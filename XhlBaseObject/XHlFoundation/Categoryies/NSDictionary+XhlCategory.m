//
//  NSDictionary+XhlDictionary.m
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/1/10.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "NSDictionary+XhlCategory.h"

id xhl_dicResultForKey(NSDictionary *dic, NSString *key){
    if ([dic isKindOfClass:[NSDictionary class]] && key.length>0) {
        return [dic valueForKey:key];
    }else{
        return nil;
    }
}

BOOL xhl_dicBOOL(NSDictionary *dic, NSString *key){
    id result = xhl_dicResultForKey(dic, key);
    if (result && ([result isKindOfClass:[NSNumber class]]||[result isKindOfClass:[NSString class]])) {
        return [result boolValue];
    }else{
        return NO;
    }
}

float xhl_dicFloat(NSDictionary *dic, NSString *key){
    id result = xhl_dicResultForKey(dic, key);
    if (result && ([result isKindOfClass:[NSNumber class]]||[result isKindOfClass:[NSString class]])) {
        return [result floatValue];
    }else{
        return 0.0;
    }
}

int xhl_dicInt(NSDictionary *dic, NSString *key){
    id result = xhl_dicResultForKey(dic, key);
    if (result && ([result isKindOfClass:[NSNumber class]]||[result isKindOfClass:[NSString class]])) {
        return [result intValue];
    }else{
        return 0;
    }
}

NSInteger xhl_dicInteger(NSDictionary *dic, NSString *key){
    id result = xhl_dicResultForKey(dic, key);
    if (result && ([result isKindOfClass:[NSNumber class]]||[result isKindOfClass:[NSString class]])) {
        return [result integerValue];
    }else{
        return 0;
    }
}

NSString * xhl_dicString(NSDictionary *dic, NSString *key){
    id result = xhl_dicResultForKey(dic, key);
    if (result && ![result isKindOfClass:[NSNull class]]) {
        if([result isKindOfClass:NSArray.class]&&
           [result isKindOfClass:NSDictionary.class]){
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:result
                                                           options:kNilOptions
                                                             error:nil];
            NSString *str = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
            if(str.length>0){
                return str;
            }
        }
        return [NSString stringWithFormat:@"%@",result];
    }
    return @"";
}

NSArray * xhl_dicArray(NSDictionary *dic, NSString *key){
    id result = xhl_dicResultForKey(dic, key);
    if ([result isKindOfClass:[NSArray class]]) {
        return result;
    }else if ([result isKindOfClass:[NSString class]]) {
        NSString *str = result;
        NSError *err;
        id obj = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                 options:NSJSONReadingMutableContainers
                                                   error:&err];
        if([obj isKindOfClass:NSArray.class]){
            return obj;
        }
    }
    return @[];
}

NSDictionary * xhl_dicDic(NSDictionary *dic, NSString *key){
    id result = xhl_dicResultForKey(dic, key);
    if ([result isKindOfClass:[NSDictionary class]]) {
        return result;
    }else if ([result isKindOfClass:[NSString class]]) {
        NSString *str = result;
        NSError *err;
        id obj = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                 options:NSJSONReadingMutableContainers
                                                   error:&err];
        if([obj isKindOfClass:NSDictionary.class]){
            return obj;
        }
    }
    return @{};
}

/**
 字典制定key取值方法,包括一些常用的key
 */
NSString * xhl_dicString_id(NSDictionary *dic){
    return xhl_dicString(dic, @"id");
}

NSInteger xhl_dicInteger_id(NSDictionary *dic){
    return xhl_dicInteger(dic, @"id");
}

NSString * xhl_dicString_message(NSDictionary *dic){
    return xhl_dicString(dic, @"message");
}

NSInteger xhl_dicInteger_code(NSDictionary *dic){
    return xhl_dicInteger(dic, @"code");
}

NSDictionary * xhl_dicDic_data(NSDictionary *dic){
    return xhl_dicDic(dic, @"data");
}

NSArray * xhl_dicArray_data(NSDictionary *dic){
    return xhl_dicArray(dic, @"data");
}

@implementation NSDictionary (XHLCategory)

- (id)xhl_dicValueforKey : (NSString *)key
{
    id value = [self valueForKeyPath:key];
    if([value isKindOfClass:[NSNull class]] || !value)
    {
        return @{};
    }
    else
    {
        return value;
    }
}

- (BOOL)xhl_dicBOOLForKey:(NSString *)key {
    id value = [self valueForKeyPath:key];
    if([value isKindOfClass:[NSNull class]] || !value)
    {
        return false;
    }
    else
    {
        NSString *boolStr = [NSString stringWithFormat:@"%@",value];
        if ([boolStr isEqualToString:@"0"]) {
            return false;
        }else {
            return true;
        }
    }
}

- (NSString *)xhl_dicStringForKey:(NSString *)key {
    id value = [self valueForKeyPath:key];
    if([value isKindOfClass:[NSNull class]] || !value)
    {
        return @"";
    }
    else
    {
        return [NSString stringWithFormat:@"%@",value];
    }
}

- (int)xhl_dicIntForKey:(NSString *)key {
    NSString *valueString = [self xhl_dicStringForKey:key];
    if (valueString.length) {
        return [valueString intValue];
    }else {
        return 0;
    }
}

- (NSInteger)xhl_dicIntegerForKey:(NSString *)key {
    NSString *valueString = [self xhl_dicStringForKey:key];
    if (valueString.length) {
        return [valueString integerValue];
    }else {
        return 0;
    }
}

- (CGFloat)xhl_dicFloatForKey:(NSString *)key {
    NSString *valueString = [self xhl_dicStringForKey:key];
    if (valueString.length) {
        return [valueString floatValue];
    }else {
        return 0.0;
    }
}

- (NSArray *)xhl_dicArrayForKey:(NSString *)key {
    
    id value = [self valueForKeyPath:key];
    if([value isKindOfClass:[NSNull class]] || !value)
    {
        return @[];
    }
    else
    {
        return value;
    }
}

- (NSArray *)xhl_dicArrayForKey:(NSString *)key
          separatedByString:(NSString *)separator {
    
    id value = [self valueForKeyPath:key];
    if ([value isKindOfClass:[NSNull class]] || !value)
    {
        return @[];
    } else if ([value isKindOfClass:[NSArray class]]) {
        return value;
    } else if ([value isKindOfClass:[NSString class]]) {
        NSMutableString *str = [NSMutableString stringWithString:value];
        if ([str hasPrefix:separator]) {
            [str deleteCharactersInRange:NSMakeRange(0, separator.length)];
        }
        if ([str hasSuffix:separator]) {
            [str deleteCharactersInRange:NSMakeRange(str.length - separator.length, separator.length)];
        }
        if (str.length == 0) {
            return @[];
        }
        return [str componentsSeparatedByString:separator];
    }
    return @[];
}

-(NSArray *)xhl_dicArrayContentForKey:(NSString *)key separatedByString:(NSString *)separator{
    
    NSMutableArray *arrayRetun = [[NSMutableArray alloc]init];
    id value = [self valueForKeyPath:key];
    if ([value isKindOfClass:[NSNull class]] || !value)
    {
        return @[];
    }else if ([value isKindOfClass:[NSString class]])
    {
        
        NSArray *array = [value componentsSeparatedByString:separator];
        for (int i = 0; i<array.count; i++) {
            if ([NSString stringWithFormat:@"%@",array[i]].length>0) {
                [arrayRetun addObject:array[i]];
            }
        }
    }
    
    return arrayRetun;
    
}

- (NSString *)xhl_jsonString {
    
    if (!self) {
        return @"";
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                   options:kNilOptions error:nil];
    return [[NSString alloc] initWithData:data
                                 encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)xhl_dictionaryWithJsonString:(NSString *)jsonStr
{
    if (jsonStr == nil) {
        return nil;
    }
    NSData* jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"json serialize failue");
        return nil;
    }
    return dic;
}

// Log
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"{\n"];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        for (int i = 0; i <= level; i++) { [string appendString:@"  "]; }
        [string appendFormat:@"\"%@\"", key];
        [string appendString:@" : "];
        if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
            [string appendFormat:@"%@,\n", [obj descriptionWithLocale:locale indent:level + 1]];
        } else {
            [string appendFormat:@"\"%@\",\n", obj];
        }
    }];
    for (int i = 0; i < level; i++) { [string appendString:@"  "]; }
    [string appendString:@"}"];
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) { [string deleteCharactersInRange:range]; }
    return string;
}
@end
