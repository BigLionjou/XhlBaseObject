//
//  UIScreen+XHL.m
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/8/1.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UIScreen+XhlCategory.h"

@implementation UIScreen (XHLCategory)

+ (CGSize)xhl_getApplicationSize
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    if (h < w) {
        size = CGSizeMake(h, w);
    }
    
    return size;
}

+ (CGFloat)xhl_getScreenWidth
{
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)xhl_getScreenHeight
{
    return [[UIScreen mainScreen] bounds].size.height;
}

@end
