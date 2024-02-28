//
//  UIResponder+CQCategory.m
//  PodManager
//
//  Created by 龚魁华 on 2018/7/12.
//  Copyright © 2018年 mn. All rights reserved.
//

#import "UIResponder+XHLCategory.h"

@implementation UIResponder (XHLCategory)
- (void)xhl_routerEventWithName:(NSString *)eventName userInfo:(id)userInfo
{
    //父类可以直接实现相应的eventname方法接受操作
    NSString *selector;
    if (userInfo) {
        selector = [NSString stringWithFormat:@"%@:",eventName];
        if ([[self nextResponder] respondsToSelector:NSSelectorFromString(selector)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [[self nextResponder] performSelector:NSSelectorFromString(selector) withObject:userInfo];
#pragma clang diagnostic pop
            return;
        }
    }else{
        selector = eventName;
        if ([[self nextResponder] respondsToSelector:NSSelectorFromString(selector)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [[self nextResponder] performSelector:NSSelectorFromString(selector) withObject:userInfo];
#pragma clang diagnostic pop
            return;
        }
    }
    [[self nextResponder] xhl_routerEventWithName:eventName userInfo:userInfo];
}

- (void)xhl_routerEventWithName:(NSString *)eventName userInfo:(id)userInfo complete:(void (^)(id))complete {
    [[self nextResponder] xhl_routerEventWithName:eventName userInfo:userInfo complete:complete];
}
@end
