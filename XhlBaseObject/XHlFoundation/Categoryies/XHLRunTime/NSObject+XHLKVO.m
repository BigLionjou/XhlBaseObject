//
//  NSObject+XHLKVO.m
//  XHLPods
//
//  Created by xhl on 16/5/18.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "NSObject+XHLKVO.h"
#import "NSObject+XHLDealloc.h"
#import "NSObject+XHLAssociate.h"

static NSString * const kXHL3rd_extensions_KVOInfoskey = @"kXHL3rd_extensions_KVOInfoskey";
static NSString * const KXHL3rd_extensions_KVOHasHookedKey = @"KXHL3rd_extensions_KVOHasHookedKey";

#pragma mark - XHLKVOInfo

@interface XHL3rd_extensions_KVOInfo : NSObject
@property (nonatomic, unsafe_unretained) NSObject *observedObject;
@property (nonatomic, unsafe_unretained) NSObject *observingObject;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, copy) XHLKVOChanedBlock chaned;
@property (nonatomic, copy) XHLKVOChanedWithInfoBlock changedWithInfo;
@property (nonatomic, readonly) BOOL valid;
@end

@implementation XHL3rd_extensions_KVOInfo

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    XHL3rd_extensions_KVOInfo *info = (__bridge XHL3rd_extensions_KVOInfo *)(context);
    if (info.chaned) {
        id changedValue = [change valueForKey:NSKeyValueChangeNewKey];
        info.chaned([changedValue isKindOfClass:[NSNull class]] ? nil : changedValue);
    }
    if (info.changedWithInfo) {
        info.changedWithInfo(change);
    }
}

- (void)eraseKVOInfo {
    self.observedObject = nil;
    self.chaned = nil;
    self.changedWithInfo = nil;
}

- (BOOL)valid {
    return self.observedObject ? YES : NO;
}

@end


#pragma mark - NSObject (XHLKVO)

@implementation NSObject (XHLKVO)

#pragma mark - Public
- (void)xhl_observe:(NSObject *)observedObject forKeyPath:(NSString *)keyPath changed:(XHLKVOChanedBlock)chaned {
    if (!observedObject) {
        return;
    }
    
    XHL3rd_extensions_KVOInfo *info = [self ba_kvo_createKVOInfoWithObserved:observedObject forKeyPath:keyPath chaned:chaned];
    [self ba_kvo_registerKVOWithInfo:info];
}

- (void)xhl_removeObserve:(NSObject *)observedObject forKeyPath:(NSString *)keyPath {
    @synchronized (observedObject) {
        NSMutableArray *infosForObservedObject = [observedObject xhl_associateObjectForKey:kXHL3rd_extensions_KVOInfoskey];
        
        NSMutableIndexSet *needRemoveIndexSet = [NSMutableIndexSet indexSet];
        [infosForObservedObject enumerateObjectsUsingBlock:^(XHL3rd_extensions_KVOInfo *info, NSUInteger idx, BOOL *stop) {
            
            if (info.observingObject == self) {
                BOOL needRemove = NO;
                if (keyPath == nil || keyPath.length == 0 || [keyPath isEqualToString:info.keyPath]) {
                    needRemove = YES;
                }
                
                if (needRemove) {
                    if (info.observedObject) {
                        [observedObject removeObserver:info forKeyPath:info.keyPath];
                        [info eraseKVOInfo];
                    }
                    [needRemoveIndexSet addIndex:idx];
                }
            }
        }];
        
        if (needRemoveIndexSet.count > 0) {
            [infosForObservedObject removeObjectsAtIndexes:needRemoveIndexSet];
        }
    }
}

#pragma mark - Private
- (XHL3rd_extensions_KVOInfo *)ba_kvo_createKVOInfoWithObserved:(NSObject *)observedObject forKeyPath:(NSString *)keyPath chaned:(XHLKVOChanedBlock)chaned {
    if (!observedObject) {
        return nil;
    }
    
    XHL3rd_extensions_KVOInfo *info = [[XHL3rd_extensions_KVOInfo alloc] init];
    info.observedObject = observedObject;
    info.keyPath = keyPath;
    info.chaned = chaned;
    info.observingObject = self;
    return info;
}

- (void)ba_kvo_registerKVOWithInfo:(XHL3rd_extensions_KVOInfo *)info {
    if (!info) {
        return;
    }
    
    // 将待监听的消息绑定到观察者上
    [self ba_kvo_bindKVOInfo:info withObject:self];
    
    // 若被观察者跟观察者不是同一个对象，则还需将待监听的消息绑定到被观察者上
    if (info.observedObject != self) {
        [self ba_kvo_bindKVOInfo:info withObject:info.observedObject];
    }
    
    // 建立被观察者与观察者之间的kvo关系
    [info.observedObject addObserver:info
                          forKeyPath:info.keyPath
                             options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld
                             context:(__bridge void *)(info)];
}

- (void)ba_kvo_bindKVOInfo:(XHL3rd_extensions_KVOInfo *)info withObject:(NSObject *)targetObject {
    if (!info || !targetObject) {
        return;
    }
    
    // 将当前注册的kvo信息存放到指定对象的kvo信息列表中
    @synchronized (targetObject) {
        NSMutableArray *infos = [targetObject xhl_associateObjectForKey:kXHL3rd_extensions_KVOInfoskey];
        if (!infos) {
            infos = [[NSMutableArray alloc] init];
            [targetObject xhl_setAssociateObject:infos forKey:kXHL3rd_extensions_KVOInfoskey];
        }
        [infos addObject:info];
        
        // 移除KVO链的另一端对象(可能是监听者，也可能是被监听者)在移除KVO时所残留的信息
        NSMutableIndexSet *deposedIndexSet = [NSMutableIndexSet new];
        [infos enumerateObjectsUsingBlock:^(XHL3rd_extensions_KVOInfo *deposedInfo, NSUInteger idx, BOOL *stop) {
            if (!deposedInfo.valid) {
                [deposedIndexSet addIndex:idx];
            }
        }];
        if (deposedIndexSet.count > 0) {
            [infos removeObjectsAtIndexes:deposedIndexSet];
        }
    }
    
    // 在当前对象释放之前，需先解除与其相关联的所有kvo
    [self ba_kvo_registerDeallocHandleForObject:targetObject];
}

- (void)ba_kvo_registerDeallocHandleForObject:(NSObject *)targetObject {
    __unsafe_unretained NSObject *registeredObject = targetObject;
    [registeredObject xhl_registerDeallocHandleWithKey:@"XHL3rd_extensions_dealloc_kvoHandle" handle:^{
        NSArray *infos = [registeredObject xhl_associateObjectForKey:kXHL3rd_extensions_KVOInfoskey];
        [infos enumerateObjectsUsingBlock:^(XHL3rd_extensions_KVOInfo *info, NSUInteger idx, BOOL *stop) {
            /**
             *  KVO自动移除时机为：KVO链上2端的对象，即：observedObject、observingObject，任一个对象释放时，进行移除操作
             *  具体移除操作为：
             *  1. 遍历当前即将释放对象所注册 或 被注册的KVO列表，从该列表中将对应的KVO逐个移除
             *  2. 同一个KVO只能移除一次，因此，在移除某个KVO时，需将KVO链中的另一个对象（可能是监听者，也可能是被监听者）的KVO列表中将当前KVOInfo移除，为了更好地处理多线程问题，此处仅将该KVOInfo中的信息擦除，具体的移除操作放到注册监听时进行
             */
            
            // 需对Info加锁处理，以防止info所对应的KVO链上的observedObject、observingObject同时释放的情况
            @synchronized (info) {
                if (info.observedObject) {
                    // 移除kvo
                    [info.observedObject removeObserver:info forKeyPath:info.keyPath];
                    // 擦除KVO相关信息
                    [info eraseKVOInfo];
                }
            }
        }];
    }];
}

@end


@implementation NSObject (XHLKVOPrivate)

- (id)xhl_observe:(NSObject *)observedObject forKeyPath:(NSString *)keyPath {
    if (!observedObject) {
        return nil;
    }
    
    XHL3rd_extensions_KVOInfo *info = [self ba_kvo_createKVOInfoWithObserved:observedObject forKeyPath:keyPath chaned:nil];
    [self ba_kvo_registerKVOWithInfo:info];
    return info;
}

- (void)xhl_kvoChanged:(XHLKVOChanedBlock)changed {
    if ([self isKindOfClass:[XHL3rd_extensions_KVOInfo class]]) {
        XHL3rd_extensions_KVOInfo *info = (XHL3rd_extensions_KVOInfo *)self;
        info.chaned = changed;
    }
}

- (void)xhl_kvoChangedWithInfo:(XHLKVOChanedWithInfoBlock)changedInfo {
    if ([self isKindOfClass:[XHL3rd_extensions_KVOInfo class]]) {
        XHL3rd_extensions_KVOInfo *info = (XHL3rd_extensions_KVOInfo *)self;
        info.changedWithInfo = changedInfo;
    }
}

@end
