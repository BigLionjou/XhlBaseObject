//
//  XhlLabelImage.h
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2023/2/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface XhlLabelImage : NSObject

//大图 图片数量标签
+ (UIImage *)pictureCountImageWithText:(NSString *)text;

/// ⚠️ 纯功能 无缓存  缓存参照注释代码
/// 文字转图片标签
/// @param text 文字
/// @param textColor 文字颜色
/// @param textFontOfSize 文字Size
/// @param backGroundColor 背景颜色
/// @param cornerRadius 圆角度数
/// @param borderWidth 边线宽度
/// @param borderColor 边线颜色
/// @param edgeInsets 上下左右间距
+ (UIImage *)imageWithText:(NSString *)text
                 textColor:(UIColor * _Nullable)textColor
           textFontOfSize:(CGFloat)textFontOfSize
          backGroundColor:(UIColor * _Nullable)backGroundColor
           backGroundImage:(NSString * _Nullable)backGroundImage
             cornerRadius:(CGFloat)cornerRadius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *_Nullable)borderColor
                edgeInsets:(UIEdgeInsets)edgeInsets;

/// ⚠️ 纯功能 无缓存  缓存参照注释代码
/// 文字转图片标签
/// @param text 文字
/// @param textColor 文字颜色
/// @param textFontOfSize 文字Size
/// @param backGroundColor 背景颜色
/// @param cornerRadius 圆角度数
/// @param borderWidth 边线宽度
/// @param borderColor 边线颜色
/// @param edgeInsets 上下左右间距
+ (UIImage *)imageWithText:(NSString *)text
                      size:(CGSize)size
                 textColor:(UIColor * _Nullable)textColor
           textFontOfSize:(CGFloat)textFontOfSize
          backGroundColor:(UIColor * _Nullable)backGroundColor
           backGroundImage:(NSString * _Nullable)backGroundImage
             cornerRadius:(CGFloat)cornerRadius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *_Nullable)borderColor
                edgeInsets:(UIEdgeInsets)edgeInsets;


@end

NS_ASSUME_NONNULL_END
