//
//  NSObject+XHLDealloc.h
//  XHLPods
//
//  Created by xhl on 16/5/18.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 关联对象的 get 和 set 方法
 */

@interface NSObject (XHLDealloc)

/**
 * @brief 注册在当前对象释放之前所需处理的handle。(handleKey相同的handle将会覆盖之前的handle)
 *
 * @param handleKey 待处理handle所对应的key。相同key的handle将覆盖之前的handle
 * @param willDeallocHandle 当前对象释放之前的操作回调
 */
- (void)xhl_registerDeallocHandleWithKey:(NSString *)handleKey handle:(void(^)(void))willDeallocHandle;

@end
