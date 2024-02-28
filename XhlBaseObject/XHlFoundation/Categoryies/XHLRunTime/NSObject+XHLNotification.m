//
//  NSObject+XHLNotification.m
//  XHLPods
//
//  Created by xhl on 16/5/18.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "NSObject+XHLNotification.h"
#import "NSObject+XHLDealloc.h"
#import "NSObject+XHLAssociate.h"

static NSString * const kXHL3rd_extensions_NotificationInfosKey = @"kXHL3rd_extensions_NotificationInfosKey";

#pragma mark - XHLNotificationInfo
@interface XHL3rd_extensions_NotificationInfo : NSObject
@property (nonatomic, unsafe_unretained) id sender;
@property (nonatomic, copy) NSString *notificationName;
@property (nonatomic, copy) XHLNotificationBlock block;
@end

@implementation XHL3rd_extensions_NotificationInfo

- (NSUInteger)hash {
    NSString *target = [NSString stringWithFormat:@"%@_%@", [_sender description], _notificationName];
    return target.hash;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![self isKindOfClass:[object class]]) {
        return NO;
    }
    
    XHL3rd_extensions_NotificationInfo *tmpInfo = (XHL3rd_extensions_NotificationInfo *)object;
    
    NSString *myTarget = [NSString stringWithFormat:@"%@_%@", [_sender description], _notificationName];
    NSString *tmpTarget = [NSString stringWithFormat:@"%@_%@", [tmpInfo.sender description], tmpInfo.notificationName];
    
    return [myTarget isEqualToString:tmpTarget];
}

@end


#pragma mark - NSObject (XHLNotification)
@implementation NSObject (XHLNotification)

- (void)xhl_removeNotification:(NSString *)notificationName {
    @synchronized (self) {
        NSMutableSet *infos = [self ba_ntf_notificationInfos];
        
        NSMutableSet *needDeletes = [NSMutableSet new];
        [infos enumerateObjectsUsingBlock:^(XHL3rd_extensions_NotificationInfo *info, BOOL *stop) {
            if ([info.notificationName isEqualToString:notificationName]) {
                [needDeletes addObject:info];
            }
        }];
        
        if (needDeletes.count) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:notificationName object:nil];
            [infos minusSet:needDeletes];
        }
    }
}

- (void)xhl_observeNotification:(NSString *)notificationName
                         sender:(id)sender
                          block:(XHLNotificationBlock)block {
    if (!notificationName || !block) {
        return;
    }
    
    XHL3rd_extensions_NotificationInfo *info = [self ba_ntf_createNotificationInfoWithNotification:notificationName
                                               sender:sender
                                                block:block];
    @synchronized (self) {
        NSMutableSet *infos = [self ba_ntf_notificationInfos];
        if ([infos containsObject:info]) {
            return;
        }
        [infos addObject:info];
    }
    
    __unsafe_unretained id unretainedSelf = self;
    [self xhl_registerDeallocHandleWithKey:@"XHL3rd_extensions_notificationHandle" handle:^{
        [[NSNotificationCenter defaultCenter] removeObserver:unretainedSelf];
    }];
    
    if (sender != self) {
        __unsafe_unretained id unretainedSender = sender;
        [sender xhl_registerDeallocHandleWithKey:@"XHL3rd_extensions_notificationHandle" handle:^{
            [[unretainedSelf ba_ntf_notificationInfos] enumerateObjectsUsingBlock:^(XHL3rd_extensions_NotificationInfo *info, BOOL *stop) {
                if (info.sender == unretainedSender) {
                    [[NSNotificationCenter defaultCenter] removeObserver:unretainedSelf name:nil object:unretainedSender];
                    *stop = YES;
                }
            }];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ba_ntf_handleNotification:) name:notificationName object:sender];
}

#pragma mark - Private
- (void)ba_ntf_handleNotification:(NSNotification *)notification {
    NSSet *infos = [self ba_ntf_notificationInfos];
    [infos enumerateObjectsUsingBlock:^(XHL3rd_extensions_NotificationInfo *info, BOOL *stop) {
        if ([info.notificationName isEqualToString:notification.name]) {
            if (!info.sender || info.sender == notification.object) {
                info.block(notification);
                *stop = YES;
            }
        }
    }];
}

- (NSMutableSet *)ba_ntf_notificationInfos {
    NSMutableSet *infos = [self xhl_associateObjectForKey:kXHL3rd_extensions_NotificationInfosKey];
    if (!infos) {
        infos = [[NSMutableSet alloc] init];
        [self xhl_setAssociateObject:infos forKey:kXHL3rd_extensions_NotificationInfosKey];
    }
    return infos;
}

- (XHL3rd_extensions_NotificationInfo *)ba_ntf_createNotificationInfoWithNotification:(NSString *)notification
                                                            sender:(id)sender
                                                             block:(XHLNotificationBlock)block {
    XHL3rd_extensions_NotificationInfo *info = [[XHL3rd_extensions_NotificationInfo alloc] init];
    info.sender = sender;
    info.notificationName = notification;
    info.block = block;
    return info;
}

@end
