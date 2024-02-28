//
//  XhlTimer.m
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/1/10.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "XhlTimer.h"

@interface XhlTimer ()
@property  (strong ,nonatomic) dispatch_source_t timer;
@end

@implementation XhlTimer

static NSMutableDictionary *timers_;
static dispatch_semaphore_t semaphore_;

+ (dispatch_source_t)scheduledTimerByTimeInterval:(NSTimeInterval)interval timeBegin:(void (^)(dispatch_source_t timer,NSUInteger seconds))begin timeEnd:(void (^)(void))end {
    __block int timeOut = interval;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut == 0) {
            dispatch_source_cancel(timer);
            dispatch_sync(dispatch_get_main_queue(), ^{
                end();
            });
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                begin(timer,timeOut);
            });
        }
        timeOut--;
    });
    dispatch_resume(timer);
    
    return timer;
}

+ (dispatch_source_t)scheduledTimerWithTimeInterval:(NSTimeInterval)interval timeBegin:(void (^)(NSUInteger seconds))begin timeEnd:(void (^)(void))end{
    __block int timeOut = interval;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        if (timeOut == 0) {
            dispatch_source_cancel(timer);
            dispatch_sync(dispatch_get_main_queue(), ^{
                end();
            });
        }else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                begin(timeOut);
            });
        }
        timeOut--;
    });
    dispatch_resume(timer);
    
    return timer;
}

+ (void)initialize
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        timers_ =[NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)xhl_exectTask:(void (^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async
{
   
    if ( !task || start < 0 || (interval <= 0 && repeats)) return nil;

    //队列
//    dispatch_queue_t queue = async ? dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL) : dispatch_get_main_queue();
    dispatch_queue_t queue = async ? dispatch_get_global_queue(0, 0) : dispatch_get_main_queue();

    //创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start *NSEC_PER_SEC),
                              interval * NSEC_PER_SEC,
                              0);
    
    //线程加锁
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    //定时器的唯一标识
//    NSString *name = [NSString stringWithFormat:@"%@",@(timers_.count)];
    NSString *name = [[NSUUID UUID] UUIDString];
    //存放到字典中
    timers_[name] = timer;
    //线程加锁
    dispatch_semaphore_signal(semaphore_);

    //执行回调
    dispatch_source_set_event_handler(timer, ^{
        task();
        
        if (!repeats) {
            [self xhl_cancelTask:name];
        }
    });
    
    //启动定时器
    dispatch_resume(timer);
    return name;
}

+ (NSString *)xhl_exectTask:(id)target selector:(SEL)selector start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async
{
    
    if (!target || !selector) return nil;
    return [self xhl_exectTask:^{
        if ([target respondsToSelector:selector]) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//这里是会报警告的代码
            [target performSelector:selector];
#pragma clang diagnostic pop
        }

    } start:start interval:interval repeats:repeats async:async];
}


+ (void)xhl_cancelTask:(NSString *)name
{
    if (name.length == 0) return;
    dispatch_source_t timer = timers_[name];
    
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:name];
    }
    dispatch_semaphore_signal(semaphore_);
}

@end


@interface XHLTimerPrivateTarget : NSObject

@property (nonatomic, weak)id target;
@property (nonatomic, weak)NSTimer *timer;
@property (nonatomic, assign)BOOL isRepeat;
@property (nonatomic, assign)NSUInteger repeatTimes;
@property (nonatomic, assign)NSUInteger repeatCount;
@property (nonatomic, assign)SEL selector;
@property (nonatomic, strong)id userInfo;
@property (nonatomic, copy)XHLTimerBlock block;
- (void)runTimer:(NSTimer *)timer;

@end

@implementation XHLTimerPrivateTarget

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isRepeat = NO;
        _repeatTimes = 0;
        _repeatCount = 0;
        _selector = nil;
    }
    
    return self;
}

- (void)runTimer:(NSTimer *)timer
{
    self.repeatCount++;
    if (self.isRepeat) {
        if (self.repeatTimes != 0 && self.repeatCount >= self.repeatTimes) {
            [self.timer invalidate];
        }
    }
    
    if (self.block) {
        BOOL shouldTimer = self.block(self.timer, self.target, self.repeatTimes, self.repeatCount);
        if (!shouldTimer) {
            [self.timer invalidate];
        }
    }
    else if(self.target && self.selector && [self.target respondsToSelector:self.selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (self.userInfo) {
            [self.target performSelector:self.selector withObject:self.userInfo];
        }
        else {
            [self.target performSelector:self.selector];
        }
#pragma clang diagnostic pop
    }
    else {
        [self.timer invalidate];
    }
}

@end

@implementation NSTimer (XHLBuilder)

#pragma mark - Block定时器

+ (instancetype)xhl_timerWithTimeInterval:(NSTimeInterval)interval
                                  repeats:(BOOL)isRepeat
                                   target:(id)aTarget
                                    block:(XHLTimerBlock)block
{
    return [self xhl_timerWithTimeInterval:interval
                                   repeats:isRepeat
                               repeatTimes:0
                                    target:aTarget
                                     block:block];
}

+ (instancetype)xhl_timerWithTimeInterval:(NSTimeInterval)interval
                                  repeats:(BOOL)isRepeat
                              repeatTimes:(NSUInteger)repeatTimes
                                   target:(id)aTarget
                                    block:(XHLTimerBlock)block
{
    if (!block) {
        return nil;
    }
    
    XHLTimerPrivateTarget *privateTarget = [XHLTimerPrivateTarget new];
    privateTarget.target = aTarget;
    privateTarget.isRepeat = isRepeat;
    privateTarget.repeatTimes = isRepeat ? repeatTimes : 0;
    privateTarget.block = block;
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                             target:privateTarget
                                           selector:@selector(runTimer:)
                                           userInfo:nil
                                            repeats:isRepeat];
    privateTarget.timer = timer;
    return timer;
}

+ (instancetype)xhl_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                          repeats:(BOOL)isRepeat
                                           target:(id)aTarget
                                            block:(XHLTimerBlock)block
{
    return [self xhl_scheduleTimerWithTimeInterval:interval
                                           repeats:isRepeat
                                       repeatTimes:0
                                            target:aTarget
                                             block:block];
}

+ (instancetype)xhl_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                          repeats:(BOOL)isRepeat
                                      repeatTimes:(NSUInteger)repeatTimes
                                           target:(id)aTarget
                                            block:(XHLTimerBlock)block
{
    NSTimer *timer = [self xhl_timerWithTimeInterval:interval
                                             repeats:isRepeat
                                         repeatTimes:repeatTimes
                                              target:aTarget
                                               block:block];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    return timer;
}

#pragma mark - Selector定时器

+ (instancetype)xhl_timerWithTimeInterval:(NSTimeInterval)interval
                                  repeats:(BOOL)isRepeat
                                   target:(id)aTarget
                                 selector:(SEL)aSelector
{
    return [self xhl_timerWithTimeInterval:interval
                                   repeats:isRepeat
                               repeatTimes:0
                                    target:aTarget
                                  selector:aSelector
                                  userInfo:@""];
}

+ (instancetype)xhl_timerWithTimeInterval:(NSTimeInterval)interval
                                  repeats:(BOOL)isRepeat
                              repeatTimes:(NSUInteger)repeatTimes
                                   target:(id)aTarget
                                 selector:(SEL)aSelector
                                 userInfo:(id)userInfo
{
    if (!aTarget || !aSelector || ![aTarget respondsToSelector:aSelector]) {
        return nil;
    }
    
    XHLTimerPrivateTarget *privateTarget = [XHLTimerPrivateTarget new];
    privateTarget.target = aTarget;
    privateTarget.selector = aSelector;
    privateTarget.isRepeat = isRepeat;
    privateTarget.repeatTimes = isRepeat ? repeatTimes : 0;
    privateTarget.userInfo = userInfo;
    NSTimer *timer = [NSTimer timerWithTimeInterval:interval
                                             target:privateTarget
                                           selector:@selector(runTimer:)
                                           userInfo:nil
                                            repeats:isRepeat];
    privateTarget.timer = timer;
    return timer;
}

+ (instancetype)xhl_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                          repeats:(BOOL)isRepeat
                                           target:(id)aTarget
                                         selector:(SEL)aSelector
{
    return [self xhl_scheduleTimerWithTimeInterval:interval
                                           repeats:isRepeat
                                       repeatTimes:0
                                            target:aTarget
                                          selector:aSelector
                                          userInfo:@""];
}

+ (instancetype)xhl_scheduleTimerWithTimeInterval:(NSTimeInterval)interval
                                          repeats:(BOOL)isRepeat
                                      repeatTimes:(NSUInteger)repeatTimes
                                           target:(id)aTarget
                                         selector:(SEL)aSelector
                                         userInfo:(id)userInfo
{
    NSTimer *timer = [self xhl_timerWithTimeInterval:interval
                                             repeats:isRepeat
                                         repeatTimes:repeatTimes
                                              target:aTarget
                                            selector:aSelector
                                            userInfo:userInfo];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    return timer;
}

@end
