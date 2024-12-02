//
//  UIColor+XHL.m
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/7/19.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UIColor+XhlCategory.h"

UIColor *grayTheme(void) {
    return colorWithHex(0xEEEEEE);
}

UIColor *redTheme(void) {
    return colorWithHex(0xEC4B4B);
}

UIColor *lightBlack22(void) {
    return colorWithHex(0x222222);
}

UIColor *lightBlack33(void) {
    return colorWithHex(0x333333);
}

UIColor *lightBlack66(void) {
    return colorWithHex(0x666666);
}

UIColor *lightBlack96(void) {
    return colorWithHex(0x969696);
}

UIColor *lightBlack99(void) {
    return colorWithHex(0x999999);
}

UIColor *lightBlackC0(void) {
    return colorWithHex(0xC0C0C0);
}

UIColor *lightBlackDD(void) {
    return colorWithHex(0xDDDDDD);
}

UIColor *lightBlackEE(void) {
    return colorWithHex(0xEEEEEE);
}

UIColor *lightBlackF9(void) {
    return colorWithHex(0xF9F9F9);
}

UIColor *gray(void) {
    return [UIColor grayColor];
}

UIColor *white(void) {
    return [UIColor whiteColor];
}

UIColor *black(void) {
    return [UIColor blackColor];
}

UIColor *clear(void) {
    [UIFont systemFontOfSize:12 weight:12];
    return [UIColor clearColor];
}

UIColor *orange(void) {
    return [UIColor orangeColor];
}

UIColor *colorWithHexAlpha(UInt32 hex, float alpha) {
   
    return [UIColor xhl_colorWithHexAlphaHex:hex alpha:alpha];
}

UIColor *colorWithHex(UInt32 hex) {
    return [UIColor xhl_colorWithHex:hex];
}

UIColor *colorWithHexString(NSString *hex) {
    return [UIColor xhl_colorWithHexString:hex];
}


UIColor *colorWithRgbAlpha(float red, float green, float blue, float alpha) {
    return [UIColor xhl_colorWithRgbRed:red green:green blue:blue alpha:alpha];
}

UIColor *colorWithRgb(float red, float green, float blue) {
    return [UIColor xhl_colorWithRgbRed:red green:green blue:blue];
}

@implementation UIColor (XHLCategory)


+ (UIColor *)xhl_randomColor {
    return [UIColor colorWithRed:(CGFloat)RAND_MAX / random()
                           green:(CGFloat)RAND_MAX / random()
                            blue:(CGFloat)RAND_MAX / random()
                           alpha:1.0f];
}


+ (UIColor *)xhl_colorWithHex:(UInt32)hex{
    //读取透明值
    return [self xhl_colorWithHexAlphaHex:hex alpha:0];
}

+ (UIColor *)xhl_colorWithHexAlphaHex:(UInt32)hex alpha:(float)alpha{
    
    float red, green, blue, tAlpha;
    if(alpha>0){
        
        // 处理 0xRRGGBB 格式，不带透明度
        red = ((hex & 0xFF0000) >> 16) / 255.0;
        green = ((hex & 0x00FF00) >> 8) / 255.0;
        blue = (hex & 0x0000FF) / 255.0;
        return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        
    }else{
        
        //UInt32 值大于 0xFFFFFF 或者高 8 位不为 0，则说明它是 8 位的颜色值（0xRRGGBBAA）。
        if (hex > 0xFFFFFF) {
            // 处理 0xRRGGBBAA 格式，带透明度
            red = ((hex & 0xFF000000) >> 24) / 255.0;
            green = ((hex & 0x00FF0000) >> 16) / 255.0;
            blue = ((hex & 0x0000FF00) >> 8) / 255.0;
            tAlpha = (hex & 0x000000FF) / 255.0;
        } else {
            // 处理 0xRRGGBB 格式，不带透明度
            red = ((hex & 0xFF0000) >> 16) / 255.0;
            green = ((hex & 0x00FF00) >> 8) / 255.0;
            blue = (hex & 0x0000FF) / 255.0;
            tAlpha = 1.0;  // 默认不透明
        }
        // 返回生成的 UIColor 对象
        return [UIColor colorWithRed:red green:green blue:blue alpha:tAlpha];
    }
}


+ (UIColor *)xhl_colorWithHexString:(NSString *)color {
    if ([color isKindOfClass:[NSNull class]] || color == nil || [color length] < 1 || [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 6) {
        return [UIColor blackColor];
    }
    NSString *cString = [color uppercaseString];
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"]){
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1∫的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"]){
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6 && [cString length] != 8){
        return [UIColor blackColor];
    }
    
    unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:cString];
        [scanner scanHexInt:&rgbValue];

    if (cString.length == 6) {
        // 解析 RRGGBB
        return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                               green:((rgbValue & 0x00FF00) >> 8) / 255.0
                                blue:(rgbValue & 0x0000FF) / 255.0
                               alpha:1.0];
    } else if (cString.length == 8) {
        // 解析 RRGGBBAA
        return [UIColor colorWithRed:((rgbValue & 0x00FF0000) >> 16) / 255.0
                               green:((rgbValue & 0x0000FF00) >> 8) / 255.0
                                blue:(rgbValue & 0x000000FF) / 255.0
                               alpha:((rgbValue & 0xFF000000) >> 24) / 255.0];
    }else{
        return [UIColor blackColor];
    }
}



+ (UIColor *)xhl_colorWithRgbRed:(float)red green:(float)green blue:(float)blue{
    return [self xhl_colorWithRgbRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)xhl_colorWithRgbRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

@end
