//
//  NSMutableArray+XHLCategory.h
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2022/4/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (XHLCategory)

/**
 addObject 添加 NSDictionary
 
 自动去除空对象
 */
- (void)addObjectDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
