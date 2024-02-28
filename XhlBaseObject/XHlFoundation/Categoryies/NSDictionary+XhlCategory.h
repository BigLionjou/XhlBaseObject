//
//  NSDictionary+XhlDictionary.h
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/1/10.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 字典指定类型取值方法
 */
BOOL xhl_dicBOOL(NSDictionary *dic, NSString *key);
int xhl_dicInt(NSDictionary *dic, NSString *key);
float xhl_dicFloat(NSDictionary *dic, NSString *key);
NSInteger xhl_dicInteger(NSDictionary *dic, NSString *key);
NSString * xhl_dicString(NSDictionary *dic, NSString *key);
NSArray * xhl_dicArray(NSDictionary *dic, NSString *key);
NSDictionary * xhl_dicDic(NSDictionary *dic, NSString *key);

/**
 字典制定key取值方法,包括一些常用的key
 */
NSString * xhl_dicString_id(NSDictionary *dic);
NSInteger xhl_dicInteger_id(NSDictionary *dic);
NSString * xhl_dicString_message(NSDictionary *dic);
NSInteger xhl_dicInteger_code(NSDictionary *dic);
NSDictionary * xhl_dicDic_data(NSDictionary *dic);
NSArray * xhl_dicArray_data(NSDictionary *dic);
@interface NSDictionary (XHLCategory)



/**
 *  字典解析获取id类型
 *
 *  @param key 字符串key
 *
 *  @return 如果有值，则返回，无，则返回一个空字典@{}
 */
- (id)xhl_dicValueforKey:(NSString *)key;

/**
 *  字典解析获取BOOL
 *
 *  @param key 字符串key
 *
 *  @return BOOL
 */
- (BOOL)xhl_dicBOOLForKey:(NSString *)key;

/**
 *  字典解析获取字符串
 *
 *  @param key 字符串key
 *
 *  @return 字符串
 */
- (NSString *)xhl_dicStringForKey:(NSString *)key;

/**
 *  字典解析获取int
 *
 *  @param key 字符串key
 *
 *  @return int
 */
- (int)xhl_dicIntForKey:(NSString *)key;

/**
 *  字典解析获取NSInteger
 *
 *  @param key NSInteger
 *
 *  @return 字符串
 */
- (NSInteger)xhl_dicIntegerForKey:(NSString *)key;

/**
 *  字典解析获取float
 *
 *  @param key 字符串key
 *
 *  @return float
 */
- (CGFloat)xhl_dicFloatForKey:(NSString *)key;

/**
 *  字典解析获取数组
 *
 *  @param key 字符串key
 *
 *  @return 数组串
 */
- (NSArray *)xhl_dicArrayForKey:(NSString *)key;

/**
 *  字典解析后分隔字符串获取数组
 *
 *  @param key       字符串key
 *  @param separator 分隔符
 *
 *  @return 分割后的数组
 */
- (NSArray *)xhl_dicArrayForKey:(NSString *)key
          separatedByString:(NSString *)separator;



/**
 //获取以逗号隔开并且剔除空字符串
 
 @param key       字符串key
 @param separator 分隔符
 
 @return 分割后的数组
 */
-(NSArray *)xhl_dicArrayContentForKey:(NSString *)key
                separatedByString:(NSString *)separator;

/**
 字典转NSdata
 */
-(NSString *)xhl_jsonString;

//json转字典
+ (NSDictionary *)xhl_dictionaryWithJsonString:(NSString *)jsonStr;
@end

NS_ASSUME_NONNULL_END
