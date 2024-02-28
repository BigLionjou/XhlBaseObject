//
//  NSObject+XHLDealloc.m
//  XHLPods
//
//  Created by xhl on 16/5/18.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "NSObject+XHLDealloc.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const void *kXHL3rd_extensions_NSObject_WillDeallocHandleDicKey = &kXHL3rd_extensions_NSObject_WillDeallocHandleDicKey;

static NSMutableSet *XHL3rd_extensions_dealloc_swizzledClasses() {
    static dispatch_once_t onceToken;
    static NSMutableSet *swizzledClasses = nil;
    dispatch_once(&onceToken, ^{
        swizzledClasses = [[NSMutableSet alloc] init];
    });
    
    return swizzledClasses;
}

static void XHL3rd_extensions_swizzleDeallocIfNeeded(Class classToSwizzle) {
    @synchronized (XHL3rd_extensions_dealloc_swizzledClasses()) {
        NSString *className = NSStringFromClass(classToSwizzle);
        if ([XHL3rd_extensions_dealloc_swizzledClasses() containsObject:className]) return;
        
        SEL deallocSelector = sel_registerName("dealloc");
        
        __block void (*originalDealloc)(__unsafe_unretained id, SEL) = NULL;
        
        id newDealloc = ^(__unsafe_unretained id self) {
            
            NSDictionary *handleDic = objc_getAssociatedObject(self, kXHL3rd_extensions_NSObject_WillDeallocHandleDicKey);
            [handleDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
                void(^willDeallocHandle)(void) = obj;
                willDeallocHandle();
            }];
            
            objc_setAssociatedObject(self, kXHL3rd_extensions_NSObject_WillDeallocHandleDicKey, nil, OBJC_ASSOCIATION_ASSIGN);
            
            if (originalDealloc == NULL) {
                struct objc_super superInfo = {
                    .receiver = self,
                    .super_class = class_getSuperclass(classToSwizzle)
                };
                
                void (*msgSend)(struct objc_super *, SEL) = (__typeof__(msgSend))objc_msgSendSuper;
                msgSend(&superInfo, deallocSelector);
            } else {
                originalDealloc(self, deallocSelector);
            }
        };
        
        IMP newDeallocIMP = imp_implementationWithBlock(newDealloc);
        
        if (!class_addMethod(classToSwizzle, deallocSelector, newDeallocIMP, "v@:")) {
            // The class already contains a method implementation.
            Method deallocMethod = class_getInstanceMethod(classToSwizzle, deallocSelector);
            
            // We need to store original implementation before setting new implementation
            // in case method is called at the time of setting.
            originalDealloc = (__typeof__(originalDealloc))method_getImplementation(deallocMethod);
            
            // We need to store original implementation again, in case it just changed.
            originalDealloc = (__typeof__(originalDealloc))method_setImplementation(deallocMethod, newDeallocIMP);
        }
        
        [XHL3rd_extensions_dealloc_swizzledClasses() addObject:className];
    }
}


@implementation NSObject (XHLDealloc)

- (void)xhl_registerDeallocHandleWithKey:(NSString *)handleKey handle:(void(^)(void))willDeallocHandle {
    @synchronized(self) {
        if (!handleKey || !willDeallocHandle) {
            return;
        }
        
        NSMutableDictionary *handleDic = objc_getAssociatedObject(self, kXHL3rd_extensions_NSObject_WillDeallocHandleDicKey);
        if (!handleDic) {
            handleDic = [[NSMutableDictionary alloc] init];
            objc_setAssociatedObject(self, kXHL3rd_extensions_NSObject_WillDeallocHandleDicKey, handleDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        handleDic[handleKey] = willDeallocHandle;
        
        XHL3rd_extensions_swizzleDeallocIfNeeded([self class]);
    }
}

@end
