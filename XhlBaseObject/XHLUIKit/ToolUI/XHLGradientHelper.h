//
//  XHLGradientHelper.h
//  Example
//  设置渐变色
//  Created by whbalzac on 3/20/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kDefaultWidth 200
#define kDefaultHeight 200

typedef NS_ENUM(NSInteger, XHLGradientDirection) {
    XHLGradientFromLeftToRight,                 //AC - BD 从左到右
    XHLGradientFromTopToBottom,              //AB - CD 从上到下
    XHLGradientFromLeftTopToRightBottom,    //A - D 从左上脚到右下角
    XHLGradientFromLeftBottomToRightTop,      //C - B 从左下角到右上角
};
//      A         B
//       _________
//      |         |
//      |         |
//       ---------
//      C         D

@interface XHLGradientHelper : NSObject

//   Linear Gradient

/**
 设置一个渐变颜色,返回一个图片 默认是200*200的大小

 @param startColor 开始颜色
 @param endColor 结束颜色
 @param directionType 方向
 @return 一个图片
 */
+ (UIImage *)xhl_getLinearGradientImage:(UIColor *)startColor and:(UIColor *)endColor directionType:(XHLGradientDirection)directionType;

/**
 设置一个渐变颜色,返回一个图片
 
 @param startColor 开始颜色
 @param endColor 结束颜色
 @param directionType 方向
 @param size 设置大小
 @return 一个图片
 */
+ (UIImage *)xhl_getLinearGradientImage:(UIColor *)startColor and:(UIColor *)endColor directionType:(XHLGradientDirection)directionType option:(CGSize)size;

//    Radial Gradient

/**
 返回一张圆图,从中心往两边渐变 默认200*200

 @param centerColor 中心颜色
 @param outColor 外边颜色
 @return 返回一个图片
 */
+ (UIImage *)xhl_getRadialGradientImage:(UIColor *)centerColor and:(UIColor *)outColor;/* raduis = kDefaultWidth / 2 */

/**
 返回一张圆图,从中心往两边渐变 默认200*200
 
 @param centerColor 中心颜色
 @param outColor 外边颜色
 @param size 设置大小
 @return 返回一个图片
 */
+ (UIImage *)xhl_getRadialGradientImage:(UIColor *)centerColor and:(UIColor *)outColor option:(CGSize)size;

//   ChromatoAnimation

/**
 设置一个自动变化颜色的颜色变换

 @param view 设置的view
 */
+ (void)xhl_addGradientChromatoAnimation:(UIView *)view;

//   LableText LinearGradient and ChromatoAnimation

/**
 lable渐变字体渐变 不需要调用 请先添加后使用

 @param lable lable
 @param startColor 开始颜色
 @param endColor 结束颜色
 
 // lable 使用方法
 UILabel* lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 300, 375, 50)];
 lable1.textAlignment = NSTextAlignmentCenter;
 lable1.text = @"交流故事，沟通想法";
 lable1.font = [UIFont systemFontOfSize:28];
 [self.view addSubview:lable1];
 [WHGradientHelper addLinearGradientForLable:lable1 start:[UIColor blueColor] and:[UIColor greenColor]];
 */
+ (void)xhl_addLinearGradientForLable:(UILabel *)lable start:(UIColor *)startColor and:(UIColor *)endColor;

/**
 设置颜色变换 请先添加后使用

 @param lable 标签
 
 UILabel* lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 440, 375, 50)];
 lable2.textAlignment = NSTextAlignmentCenter;
 lable2.text = @"交流故事，沟通想法";
 lable2.font = [UIFont systemFontOfSize:28];
 [self.view addSubview:lable2];
 */
+ (void)xhl_addGradientChromatoAnimationForLable:(UILabel *)lable;

@end
