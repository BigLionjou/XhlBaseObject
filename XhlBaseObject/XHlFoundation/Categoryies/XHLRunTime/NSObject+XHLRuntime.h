//
//  NSObject+XHLRuntime.h
//  XHLPods
//
//  Created by xhl on 16/5/17.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 运行时的基本方法，包括 xhl_respondsToSelector 和 MethodSwizzling
 * 详细介绍请看README-XHLRuntime
 */

@interface NSObject (XHLRuntime)

/**
 * @brief 当前类(而非父类)是否实现了Selector
 *
 * @param selector 方法
 * @return BOOL
 */
- (BOOL)xhl_respondsToSelector:(SEL)selector;

/**
 对 super 发送消息
 
 @param aSelector 要发送的消息
 @return 消息执行后的结果
 @link http://stackoverflow.com/questions/14635024/using-objc-msgsendsuper-to-invoke-a-class-method @/link
 */
- (nullable id)xhl_performSelectorToSuperclass:(SEL)aSelector;

/**
 对 super 发送消息
 
 @param aSelector 要发送的消息
 @param object 作为参数传过去
 @return 消息执行后的结果
 @link http://stackoverflow.com/questions/14635024/using-objc-msgsendsuper-to-invoke-a-class-method @/link
 */
- (nullable id)xhl_performSelectorToSuperclass:(SEL)aSelector withObject:(nullable id)object;

/**
 遍历某个 protocol 里的所有方法
 
 @param protocol 要遍历的 protocol，例如 \@protocol(xxx)
 @param block 遍历过程中调用的 block
 */
+ (void)xhl_enumerateProtocolMethods:(Protocol *)protocol usingBlock:(void (^)(SEL selector))block;
@end


@interface XHLRunTime : NSObject

/**
 * @brief MethodSwizzling 实例方法
 *
 * @param origCls hook的类
 * @param origSEL hook的方法
 * @param cls 替换的类
 * @param sel 替换的实例方法
 */
+ (void)replaceClass:(Class)origCls sel:(SEL)origSEL withClass:(Class)cls withSEL:(SEL)sel;

/**
 * @brief MethodSwizzling 方法
 *
 * @param origCls origCls hook的类
 * @param origSEL hook的方法
 * @param cls 替换的类
 * @param sel 替换的方法
 * @param isClassMethod YES 类方法 NO 实例方法
 */
+ (void)replaceClass:(Class)origCls sel:(SEL)origSEL withClass:(Class)cls withSEL:(SEL)sel isClassMethod:(BOOL)isClassMethod;


@end
NS_ASSUME_NONNULL_END
