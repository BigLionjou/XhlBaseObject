//
//  NSUserDefaults+XHLCategory.m
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/8/12.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "NSUserDefaults+XHLCategory.h"

void xhl_setInUserDefaults(id value,NSString *key){
    [NSUserDefaults xhl_setInUserDefaultsValue:value key:key];
}

void xhl_removeInUserDefaults(NSString *key){
    [NSUserDefaults xhl_removeInUserDefaultsByKey:key];
}

id xhl_getInUserDefaults(NSString *key){
    return [NSUserDefaults xhl_getInUserDefaultsBykey:key];
}

@implementation NSUserDefaults (XHLCategory)

/**
 存值
 
 @param value 数据
 @param key key
 */
+ (void)xhl_setInUserDefaultsValue:(id)value key:(NSString *)key{
    if (value && key) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 删除key
 
 @param key key
 */
+ (void)xhl_removeInUserDefaultsByKey:(NSString *)key{
    if (key) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 根据key获取值
 
 @param key key
 */
+ (id)xhl_getInUserDefaultsBykey:(NSString *)key{
     return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}
@end
