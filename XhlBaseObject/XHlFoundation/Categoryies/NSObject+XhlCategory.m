//
//  NSObject+XhlCategory.m
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/12/10.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "NSObject+XhlCategory.h"
#import <objc/runtime.h>

@implementation NSObject (XhlCategory)

- (void)setXhl_userDict:(NSMutableDictionary *)xhl_userDict {
    objc_setAssociatedObject(self, @selector(xhl_userDict), xhl_userDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)xhl_userDict {
    NSMutableDictionary *dict = objc_getAssociatedObject(self, _cmd);
    if(!dict){
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, @selector(xhl_userDict), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return dict;
}

@end
