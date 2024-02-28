//
//  UIImage+XhlCategory.h
//  XhlBaseObjectDemo
//
//  Created by 龚魁华 on 2019/6/23.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (XHLCategory)


/**
 获取视频的第一秒 第10帧图片
 
 @return 返回第一秒 第10帧图片
 */
- (UIImage *)xhl_getVidoUrlsFirstImage:(NSString *)urlstr;
/**
 获取视频的第一针图片
 
 @param urlstr 连接
 @param timeSeconds 第几秒
 @param painting 第几帧
 @return 返回第一针图片
 */
- (UIImage *)xhl_getVidoUrlsFirstImage:(NSString *)urlstr
                           timeSeconds:(NSInteger)timeSeconds
                              painting:(NSInteger)painting;


//改变图片 尺寸  宽度为屏幕宽度 高度自适应
- (UIImage *)xhl_imageCompressForWidth:(CGFloat)defineWidth;

/**
 颜色转图片

 @param color 颜色
 */
+ (UIImage *)xhl_createImageWithColor:(UIColor *)color;
+ (UIImage *)xhl_createImageWithColor:(UIColor *)color toSize:(CGSize)size;

/**
 图片转base64

 @return base64
 */
- (NSString *)xhl_imagebase64Str;

//旋转图片成垂直
- (UIImage *)xhl_orientationUpImage;

/**
 根据图片判断是横屏还是竖屏
  当前图片
 @return 0:屏幕。1:横屏
 */
- (NSString *)xhl_judgeHorizontal;
/**
 图片转化成data
 
 @param Compression 图片的Compression（0-1）
 @param maxSize 图片最大的内存（KB）
 @param imageWidth 图片的大小
 @return NSData
 */
-(NSData *)xhl_dataWithImageWithCompression: (CGFloat)Compression
                             andMaxSize: (CGFloat)maxSize
                          andImageWidth: (CGFloat)imageWidth;

#pragma mark - 图片缩放
// 拉伸图片(区域拉伸)
+ (UIImage *)xhl_strechImage:(UIImage *)aOriginImage capInsets:(UIEdgeInsets)aCapInsets resizingMode:(UIImageResizingMode)aResizingMode;

/**
 将图片等比例缩放
 
 @param aSourceImage 原始图片
 @param aRatio 缩放比例
 @return 缩放后图片
 */
+ (UIImage *)xhl_zoomImage:(UIImage *)aSourceImage zoomRatio:(CGFloat)aRatio;

/**
 将图片缩放至指定大小
 
 @param image 原始图片
 @param size 缩放后图片大小
 @return 缩放后图片
 */
+ (UIImage *)xhl_scale:(UIImage *)image toSize:(CGSize)size;


+ (UIImage *)xhl_scaleImage:(UIImage *)image toScale:(float)scaleSize;

#pragma mark - 图片旋转
+ (UIImage *)xhl_rotationImage:(UIImage *)image rotation:(UIImageOrientation)orientation;
+ (UIImage *)xhl_rotateImage:(UIImage *)aImage by:(UIImageOrientation)orient;
- (UIImage *)xhl_rotateImagebyRadian:(CGFloat)radian;


//将图片转成需要的颜色
+ (UIImage *)xhl_colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor;
///改变图片目标颜色
+ (UIImage *)xhl_imageNamed:(NSString *)named tintColor:(UIColor *)tintColor;
///改变图片背景颜色
+ (UIImage *)xhl_imageNamed:(NSString *)named GradientTintColor:(UIColor *)tintColor;
///改变图片目标颜色
+ (UIImage *)xhl_imageNamed:(NSString *)named tintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;
///改变图片 上色功能
- (UIImage *)xhl_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;



/**
*  绘制渐变色的矩形UIImage
*
*  @param bounds       UIImage的bounds
*  @param colors       渐变色数组，可以设置两种颜色
*  @param gradientType 渐变的方式：0:水平渐变   1:竖直渐变   2:向下对角线渐变   3:向上对角线渐变
*
*  @return 渐变色的UIImage
*/
+ (UIImage*)xhl_createGradientRectImageWithBounds:(CGRect)bounds Colors:(NSArray*)colors GradientType:(int)gradientType ;

@end

NS_ASSUME_NONNULL_END
