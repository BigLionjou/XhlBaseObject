//
//  NSObject+XHLRuntime.m
//  XHLPods
//
//  Created by xhl on 16/5/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "NSObject+XHLRuntime.h"
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>


static volatile OSSpinLock lock = OS_SPINLOCK_INIT;

@implementation NSObject (XHLRuntime)

- (BOOL)xhl_respondsToSelector:(SEL)selector//当前类(而非父类)是否实现了Selector
{
    unsigned int outCount = 0;
    BOOL response = NO;
    Method *mothodList = class_copyMethodList([self class], &outCount);
    for (int i = 0; i < outCount; i ++)
    {
        if (method_getName(mothodList[i]) == selector)
        {
            response = YES;
            break;
        }
    }
    
    free(mothodList);
    
    return response;
}

- (id)xhl_performSelectorToSuperclass:(SEL)aSelector {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector);
}

- (id)xhl_performSelectorToSuperclass:(SEL)aSelector withObject:(id)object {
    struct objc_super mySuper;
    mySuper.receiver = self;
    mySuper.super_class = class_getSuperclass(object_getClass(self));
    
    id (*objc_superAllocTyped)(struct objc_super *, SEL, ...) = (void *)&objc_msgSendSuper;
    return (*objc_superAllocTyped)(&mySuper, aSelector, object);
}

+ (void)xhl_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL))block {
    if (!block) return;
    
    unsigned int methodCount = 0;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, NO, YES, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methods[i];
        if (block) {
            block(methodDescription.name);
        }
    }
    free(methods);
}
@end

@implementation XHLRunTime

+ (void)replaceClass:(Class)origCls sel:(SEL)origSEL withClass:(Class)cls withSEL:(SEL)sel {
    [self replaceClass:origCls sel:origSEL withClass:cls withSEL:sel isClassMethod:NO];
}

+ (void)replaceClass:(Class)origCls sel:(SEL)origSEL withClass:(Class)cls withSEL:(SEL)sel isClassMethod:(BOOL)isClassMethod {
    if ((origCls == NULL) || (origSEL == NULL) || (cls == NULL) || (sel == NULL)) {
        return;
    }
    
    OSSpinLockLock(&lock);
    
    do {
        Method origMethod;
        Method method;
        if (isClassMethod) {
            // 类方法需要使用 object_getClass(obj) 返回类对象中的isa指针，即指向元类对象的指针
            origCls = object_getClass(origCls);
            cls = object_getClass(cls);
            origMethod = class_getClassMethod(origCls, origSEL);
            method = class_getClassMethod(cls, sel);
        } else {
            origMethod = class_getInstanceMethod(origCls, origSEL);
            method = class_getInstanceMethod(cls, sel);
        }
        if ((origMethod == NULL) || (method == NULL)) break;
        BOOL didAddMethod = class_addMethod(origCls, sel, method_getImplementation(method), method_getTypeEncoding(origMethod));
        if (!didAddMethod) {
            // 说明 origCls 存在与 sel 同名的方法，那么选择替换掉方法
            class_replaceMethod(origCls, sel, method_getImplementation(method), method_getTypeEncoding(origMethod));
            // 若方法名相同，替换掉方法后 break
            if (sel == origSEL) break;
        }
        Method exchangeMethod;
        if (isClassMethod) {
            exchangeMethod = class_getClassMethod(origCls, sel);
        } else {
            exchangeMethod = class_getInstanceMethod(origCls, sel);
        }
        method_exchangeImplementations(origMethod, exchangeMethod);
    } while(0);
    
    OSSpinLockUnlock(&lock);
}

@end
