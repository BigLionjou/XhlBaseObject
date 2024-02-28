//
//  Xcode14Fixer.m
//  CqlivingCloud
//
//  Created by xiaoshiheng on 2023/4/27.
//  Copyright © 2023 xinhualong. All rights reserved.
//

#import "Xcode14Fixer.h"
#import <objc/runtime.h>

@implementation Xcode14Fixer

+ (void)load
{
    Class cls = NSClassFromString(@"_UINavigationBarContentViewLayout");
    SEL selector = @selector(valueForUndefinedKey:);
    Method impMethod = class_getInstanceMethod([self class], selector);

    if (impMethod) {
        class_addMethod(cls, selector, method_getImplementation(impMethod), method_getTypeEncoding(impMethod));
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}


@end
