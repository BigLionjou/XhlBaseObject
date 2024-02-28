//
//  NSObject+XHLKVO.h
//  XHLPods
//
//  Created by xhl on 16/5/18.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * KVO 扩展
 * 详细介绍请看README-XHLRuntime
 */

#pragma mark - 项目中的KVO使用，推荐使用如下相关宏进行操作

/**
 *  注册指定TARGET的KEYPATH属性的kvo监听，该宏需结合 xhl_kvoChanged: 方法一起使用.（该KVO监听方式，会在对象释放时，自动移除KVO）
 *
 *  例如：若需要监听一个view对象的背景色的变动情况，则可以按如下方式使用：
 *
 *  [XHLObserve(view, backgroundColor) xhl_kvoChanged:^(id chanedValue) {
 *      // 处理当背景色变化时所需干的事情...
 *  }];
 *
 */
#define XHLObserve(TARGET, KEYPATH) \
[self xhl_observe:(id)(TARGET) forKeyPath:@keypath(TARGET, KEYPATH)]

/**
 *  清除指定TARGET被观察者上的所有KVO监听
 */
#define XHLObserveClean(TARGET) [self xhl_removeObserve:TARGET forKeyPath:nil];

/**
 *  移除指定TARGET被观察者上的指定KEYPATH属性的KVO监听
 */
#define XHLObserveRemove(TARGET, KEYPATH) [self xhl_removeObserve:TARGET forKeyPath:@keypath(TARGET, KEYPATH)];

#pragma mark - KVO 类别
typedef void(^XHLKVOChanedBlock)(id chanedValue);
typedef void(^XHLKVOChanedWithInfoBlock)(NSDictionary *change);


/**
 *  推荐使用上面定义的宏：XHLObserve
 */
@interface NSObject (XHLKVO)

/**
 *  @brief kvo便捷方法，通过该类别方法进行kvo监听，调用者为观察者
 *
 *  @param observedObject 被观察者
 *  @param keyPath        被观察者的属性
 *  @param chaned         被观察者的属性有改变时的回调
 *  
 *  @note 该方法会在self 或 observedObject 对象释放时，自动移除kvo监听.  !!! 推荐使用: 宏(XHLObserve) + xhl_kvoChanged方法 !!!
 */
- (void)xhl_observe:(NSObject *)observedObject forKeyPath:(NSString *)keyPath changed:(XHLKVOChanedBlock)chaned;

/**
 *  @brief 移除kvo监听
 *
 *  @param observedObject 被观察者
 *  @param keyPath        被观察者的属性 （当keyPath为nil时，将移除observedObject上的所有属性监听）
 *
 */
- (void)xhl_removeObserve:(NSObject *)observedObject forKeyPath:(NSString *)keyPath;

@end

#pragma mark - 不建议外界直接调用
@interface NSObject (XHLKVOPrivate)
/**
 *  @brief 监听被观察者的指定属性值的变化，调用者为观察者
 *
 *  @param observedObject 被观察者
 *  @param keyPath        被观察者的属性
 *
 *  @return 返回的是一个内部使用的类，该对象用于调用byq_kvoChanged该方法，进行设置被观察者的属性有改变时的回调
 *
 *  @note 不建议直接调用该方法，该方法主要用于便捷宏的使用
 */
- (id)xhl_observe:(NSObject *)observedObject forKeyPath:(NSString *)keyPath;

/**
 *  @brief 为byq_observe: forKeyPath:方法所放回的对象设置被观察者的属性有改变时的回调
 *
 *  @param changed 被观察者的属性有改变时的回调
 *
 *  @note  不建议直接调用该方法，该方法主要需要结合byq_observe: forKeyPath:方法使用
 */
- (void)xhl_kvoChanged:(XHLKVOChanedBlock)changed;



/**
 *  @brief 为byq_observe: forKeyPath:方法所放回的对象设置被观察者的属性有改变时的回调
 *
 *  @param changedInfo 被观察者的属性有改变时的回调，
 *                     会回调kvo change的相关信息 包括new 和 old值 @see NSKeyValueChangeNewKey @see NSKeyValueChangeOldKey
 *
 *  @note  不建议直接调用该方法，该方法主要需要结合byq_observe: forKeyPath:方法使用
 */
- (void)xhl_kvoChangedWithInfo:(XHLKVOChanedWithInfoBlock)changedInfo;

@end
