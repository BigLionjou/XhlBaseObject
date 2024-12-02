//
//  UIColor+XhlCategory.h
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/7/19.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
UIColor *gray(void);
UIColor *orange(void);
UIColor *clear(void);
UIColor *white(void);
UIColor *black(void);

UIColor *grayTheme(void);
UIColor *redTheme(void);
UIColor *lightBlack22(void);
UIColor *lightBlack33(void);
UIColor *lightBlack66(void);
UIColor *lightBlack96(void);
UIColor *lightBlack99(void);
UIColor *lightBlackC0(void);
UIColor *lightBlackDD(void);
UIColor *lightBlackEE(void);
UIColor *lightBlackF9(void);

UIColor *colorWithHexAlpha(UInt32 hex, float alpha);
UIColor *colorWithHex(UInt32 hex);
UIColor *colorWithHexString(NSString *hex) ;
UIColor *colorWithRgbAlpha(float red, float green, float blue, float alpha);
UIColor *colorWithRgb(float red, float green, float blue);

@interface UIColor (XHLCategory)

//随机颜色
+ (UIColor *)xhl_randomColor;

+ (UIColor *)xhl_colorWithHex:(UInt32)hex;
+ (UIColor *)xhl_colorWithHexAlphaHex:(UInt32)hex alpha:(float)alpha;


/// 根据hex字符串获取颜色  如果格式错误 默认返回[UIColor BlackColor]
/// color: 0xrrggbb 0xaarrggbb #rrggbb #aarrggbb
+ (UIColor *)xhl_colorWithHexString:(NSString *)color;


+ (UIColor *)xhl_colorWithRgbRed:(float)red green:(float)green blue:(float)blue;
+ (UIColor *)xhl_colorWithRgbRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha;

@end

NS_ASSUME_NONNULL_END
