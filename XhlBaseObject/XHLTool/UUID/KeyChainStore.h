//
//  KeyChainStore.h
//  UUID
//
//  Created by XHL on 16/12/29.
//  Copyright © 2016年 XHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;
@end
