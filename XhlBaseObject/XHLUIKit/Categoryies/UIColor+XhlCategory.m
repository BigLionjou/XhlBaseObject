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

UIColor *colorWithRgbAlpha(float red, float green, float blue, float alpha) {
    return [UIColor xhl_colorWithRgbRed:red green:green blue:blue alpha:alpha];
}

UIColor *colorWithRgb(float red, float green, float blue) {
    return [UIColor xhl_colorWithRgbRed:red green:green blue:blue];
}

@implementation UIColor (XHLCategory)

+ (UIColor *)xhl_colorWithHex:(UInt32)hex{
    return [self xhl_colorWithHexAlphaHex:hex alpha:1.0];
}

+ (UIColor *)xhl_colorWithHexAlphaHex:(UInt32)hex alpha:(float)alpha{
    CGFloat r = ((hex & 0xff0000) >> 16) / 255.f;
    CGFloat g = ((hex & 0x00ff00) >> 8) / 255.f;
    CGFloat b = (hex & 0x0000ff) / 255.f;
    return [UIColor colorWithRed:r green:g blue:b alpha:alpha];
}

+ (UIColor *)xhl_colorWithRgbRed:(float)red green:(float)green blue:(float)blue{
    return [self xhl_colorWithRgbRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)xhl_colorWithRgbRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha{
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

+ (UIColor *)xhl_randomColor {
    return [UIColor colorWithRed:(CGFloat)RAND_MAX / random()
                           green:(CGFloat)RAND_MAX / random()
                            blue:(CGFloat)RAND_MAX / random()
                           alpha:1.0f];
}

//16进制颜色值与浮点型颜色值的转换
+ (CGFloat)colorChannelFromHexString:(NSString *)hexString {
    int num[2] = {0};
    for (int i = 0 ; i < 2; i++) {
        int asc = [hexString characterAtIndex:i];
        // 数字
        if (asc >= '0' && asc <= '9') {
            num[i] = asc - '0';
        }
        // 大写字母
        else if (asc >= 'A' && asc <= 'F') {
            num[i] = asc - 'A' + 10;
        }
        // 小写字母
        else if (asc >= 'a' && asc <= 'f') {
            num[i] = asc - 'a' + 10;
        }
    }
    return (num[0] * 16 + num[1]) / 255.;
}


+ (UIColor *)xhl_RGBColorFromHexString:(NSString *)aHexStr {
    return [UIColor xhl_RGBColorFromHexString:aHexStr
                                        alpha:1.0f];
}

+ (UIColor *)xhl_RGBColorFromHexString:(NSString *)aHexStr
                                 alpha:(float)aAlpha {
    if ([aHexStr isKindOfClass:[NSString class]]
        && aHexStr.length > 6) {// #rrggbb 大小写字母及数字
        CGFloat redValue = [UIColor colorChannelFromHexString:[aHexStr substringWithRange:NSMakeRange(1, 2)]];
        CGFloat greenValue = [UIColor colorChannelFromHexString:[aHexStr substringWithRange:NSMakeRange(3, 2)]];
        CGFloat blueValue = [UIColor colorChannelFromHexString:[aHexStr substringWithRange:NSMakeRange(5, 2)]];
        UIColor *rgbColor = [UIColor colorWithRed:redValue
                                            green:greenValue
                                             blue:blueValue
                                            alpha:aAlpha];
        return rgbColor;
    }
    return [UIColor blackColor]; // 默认黑色
}

@end
