//
//  XhlTimer.h
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/1/10.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @block
 @brief  定时器触发回调闭包
 @param  timer        定时器对象
 @param  target       目标对象（使用该对象可避免循环引用）
 @param  repeatTimes  设置的定时器触发总次数
 @param  repeatCount  定时器当前触发的次数
 @result 返回YES，继续定时器逻辑；NO，立即停止定时器
 */
typedef BOOL (^XHLTimerBlock)(NSTimer * _Nullable timer, id _Nullable target, NSUInteger repeatTimes, NSUInteger repeatCount);

NS_ASSUME_NONNULL_BEGIN

@interface XhlTimer : NSObject

+ (dispatch_source_t)scheduledTimerByTimeInterval:(NSTimeInterval)interval timeBegin:(void (^)(dispatch_source_t timer,NSUInteger seconds))begin timeEnd:(void (^)(void))end;

+ (dispatch_source_t)scheduledTimerWithTimeInterval:(NSTimeInterval)interval timeBegin:(void (^)(NSUInteger seconds))begin timeEnd:(void (^)(void))end;

/// GCD定时器
/// @param task 执行任务block
/// @param start 开始时间
/// @param interval 间隔时间
/// @param repeats YES：重复   NO：不重复
/// @param async 是不是主线程执行
+ (NSString *)xhl_exectTask:(void (^)(void))task
            start:(NSTimeInterval)start
         interval:(NSTimeInterval)interval
          repeats:(BOOL)repeats
            async:(BOOL)async;


+ (NSString *)xhl_exectTask:(id)target
               selector:(SEL)selector
            start:(NSTimeInterval)start
         interval:(NSTimeInterval)interval
          repeats:(BOOL)repeats
            async:(BOOL)async;

///  取消任务
/// @param name 创建任务时返回的name
+ (void)xhl_cancelTask:(NSString *)name;
@end

@interface NSTimer (XHLBuilder)

#pragma mark - Block定时器

/*!
 @method
 @brief  创建一个NSTimer对象
 @param  interval     定时器触发时间间隔
 @param  isRepeat     是否重复触发定时
 @param  aTarget      目标对象，该对象会在block回调中回传，使用该对象可避免循环引用
 @param  block        回调函数
 @result NSTimer对象
 */
+ (instancetype)xhl_timerWithTimeInterval:(NSTimeInterval)interval
                                  repeats:(BOOL)isRepeat
                                   target:(id)aTarget
                                    block:(XHLTimerBlock)block;

/*!
 @method
 @brief  创建一个NSTimer对象
 @param  interval     定时器触发时间间隔
 @param  isRepeat     是否重复触发定时
 @patam  repeatTimes  定时器触发次数，设置为0表示不限制触发次数(该参数仅在isRepeat=YES下生效)
 @param  aTarget      目标对象，该对象会在block回调中回传，使用该对象可避免循环引用
 @param  block        回调函数
 @result NSTimer对象
 */
+ (instancetype)xhl_timerWithTimeInterval:(NSTimeInterval)interval
                                  repeats:(BOOL)isRepeat
                              repeatTimes:(NSUInteger)repeatTimes
                                   target:(id)aTarget
                                    block:(XHLTimerBlock)block;

/*!
 @method
 @brief  创建一个NSTimer对象，并开启定时器
 @param  interval     定时器触发时间间隔
 @param  isRepeat     是否重复触发定时
 @param  aTarget      目标对象，该对象会在block回调中回传，使用该对象可避免循环引用
 @param  block        回调函数
 @result NSTimer对象
 */
+ (instancetype)xhl_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                          repeats:(BOOL)isRepeat
                                           target:(id)aTarget
                                            block:(XHLTimerBlock)block;

/*!
 @method
 @brief  创建一个NSTimer对象，并开启定时器
 @param  interval     定时器触发时间间隔
 @param  isRepeat     是否重复触发定时
 @patam  repeatTimes  定时器触发次数，设置为0表示不限制触发次数(该参数仅在isRepeat=YES下生效)
 @param  aTarget      目标对象，该对象会在block回调中回传，使用该对象可避免循环引用
 @param  block        回调函数
 @result NSTimer对象
 */
+ (instancetype)xhl_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                          repeats:(BOOL)isRepeat
                                      repeatTimes:(NSUInteger)repeatTimes
                                           target:(id)aTarget
                                            block:(XHLTimerBlock)block;

#pragma mark - Selector定时器

/*!
 @method
 @brief  创建一个NSTimer对象
 @param  interval     定时器触发时间间隔
 @param  isRepeat     是否重复触发定时
 @param  aTarget      目标对象，该对象会在block回调中回传，使用该对象可避免循环引用
 @param  aSelector    目标对象的调用方法
 @result NSTimer对象
 */
+ (instancetype)xhl_timerWithTimeInterval:(NSTimeInterval)interval
                                  repeats:(BOOL)isRepeat
                                   target:(id)aTarget
                                 selector:(SEL)aSelector;

/*!
 @method
 @brief  创建一个NSTimer对象
 @param  interval     定时器触发时间间隔
 @param  isRepeat     是否重复触发定时
 @patam  repeatTimes  定时器触发次数，设置为0表示不限制触发次数(该参数仅在isRepeat=YES下生效)
 @param  aTarget      目标对象，该对象会在block回调中回传，使用该对象可避免循环引用
 @param  aSelector    目标对象的调用方法
 @param  userInfo     调用目标方法的回传参数
 @result NSTimer对象
 */
+ (instancetype)xhl_timerWithTimeInterval:(NSTimeInterval)interval
                                  repeats:(BOOL)isRepeat
                              repeatTimes:(NSUInteger)repeatTimes
                                   target:(id)aTarget
                                 selector:(SEL)aSelector
                                 userInfo:(id)userInfo;

/*!
 @method
 @brief  创建一个NSTimer对象，并开启定时器
 @param  interval     定时器触发时间间隔
 @param  isRepeat     是否重复触发定时
 @param  aTarget      目标对象，该对象会在block回调中回传，使用该对象可避免循环引用
 @param  aSelector    目标对象的调用方法
 @result NSTimer对象
 */
+ (instancetype)xhl_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                          repeats:(BOOL)isRepeat
                                           target:(id)aTarget
                                         selector:(SEL)aSelector;

/*!
 @method
 @brief  创建一个NSTimer对象，并开启定时器
 @param  interval     定时器触发时间间隔
 @param  isRepeat     是否重复触发定时
 @patam  repeatTimes  定时器触发次数，设置为0表示不限制触发次数(该参数仅在isRepeat=YES下生效)
 @param  aTarget      目标对象，该对象会在block回调中回传，使用该对象可避免循环引用
 @param  aSelector    目标对象的调用方法
 @param  userInfo     调用目标方法的回传参数
 @result NSTimer对象
 */
+ (instancetype)xhl_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                          repeats:(BOOL)isRepeat
                                      repeatTimes:(NSUInteger)repeatTimes
                                           target:(id)aTarget
                                         selector:(SEL)aSelector
                                         userInfo:(id)userInfo;


@end
NS_ASSUME_NONNULL_END
