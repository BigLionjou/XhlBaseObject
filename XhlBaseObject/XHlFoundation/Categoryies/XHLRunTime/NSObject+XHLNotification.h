//
//  NSObject+XHLNotification.h
//  XHLPods
//
//  Created by xhl on 16/5/18.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 消息监听 扩展
 * 详细介绍请看README-XHLRuntime
 */

/**
 @block
 @brief  消息监听的 block
 @param  notification  传递的参数（NSNotification）
 */
typedef void(^XHLNotificationBlock)(NSNotification *notification);

@interface NSObject (XHLNotification)

/**
 *  @brief 为当前对象注册一个消息监听
 *
 *  @param notificationName 待监听的消息
 *  @param sender           消息发送者
 *  @param block            监听到消息的回调
 *
 *  @note 通过该方式注册的消息监听，会自动在 "当前对象" 或 "消息发送者" 释放之前，移除该消息监听
 */
- (void)xhl_observeNotification:(NSString *)notificationName
                         sender:(id)sender
                          block:(XHLNotificationBlock)block;

/**
 *  @brief 手动移除指定的消息监听
 *
 *  @param notificationName 监听的消息
 */
- (void)xhl_removeNotification:(NSString *)notificationName;

@end
