//
//  NSUserDefaults+XHLCategory.h
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/8/12.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
void xhl_setInUserDefaults(id value,NSString *key);
void xhl_removeInUserDefaults(NSString *key);
id xhl_getInUserDefaults(NSString *key);

@interface NSUserDefaults (XHLCategory)

/**
 存值

 @param value 数据
 @param key key
 */
+ (void)xhl_setInUserDefaultsValue:(id)value key:(NSString *)key;

/**
 删除key

 @param key key
 */
+ (void)xhl_removeInUserDefaultsByKey:(NSString *)key;

/**
 根据key获取值

 @param key key
 */
+ (id)xhl_getInUserDefaultsBykey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
