//
//  UUID.h
//  UUID
//
//  Created by XHL on 16/12/29.
//  Copyright © 2016年 XHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUID : NSObject

/**
 获取设备uuid，自动保存到KeyChain
 获取唯一标识符,升级系统时候会变
 @return 设备uuid
 */
+(NSString *)getUUID;

//NSString *phoneCode = [UUID getUUID];
//NSString *registrationID = [JPUSHService registrationID];

@end
