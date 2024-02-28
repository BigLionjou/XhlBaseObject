//
//  NSMutableArray+XHLCategory.m
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2022/4/18.
//

#import "NSMutableArray+XHLCategory.h"

@implementation NSMutableArray (XHLCategory)


/**
 addObject 添加 NSDictionary
 
 自动去除空对象
 */
- (void)addObjectDictionary:(NSDictionary *)dict
{
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc] init];
    for (NSString *keyStr in dict.allKeys) {
        if ([[dict objectForKey:keyStr] isEqual:[NSNull null]]) {
            [mutableDic setObject:@"" forKey:keyStr];
        }
        else {
            [mutableDic setObject:[dict objectForKey:keyStr] forKey:keyStr];
        }
    }
    [self addObject:mutableDic];
}

@end
