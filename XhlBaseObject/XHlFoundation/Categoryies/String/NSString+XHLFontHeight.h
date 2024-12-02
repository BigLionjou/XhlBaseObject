//
//  NSString+XHLFontHeight.h
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2024/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (XHLFontHeight)



#pragma mark - 计算字符串宽度、高度


/**
 *  计算文字占用高度（行间距）（代码计算）
 *
 *  param string    字符串
 *  param width \ maxW  最大宽度
 *  param font   字体大小
 *  param LineSpacing 行间距
 *
 *  @return 高度
 */

//（利用NSString计算）
+ (CGSize)xhl_sizeWithString:(NSString *)string Font:(UIFont *)font;
//（利用NSString计算）
+ (CGSize)xhl_sizeWithString:(NSString *)string Font:(UIFont *)font maxW:(CGFloat)maxW;
//（利用NSString计算）
- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font
                      LineSpacing:(CGFloat)LineSpacing;
//（利用NSString计算）
- (CGFloat)xhl_Code_getHeightWithWidth:(CGFloat)width
                                  font:(UIFont *)font;


/**
 *  计算文字占用高度（利用label计算）
 *
 *  param width  固定宽度
 *  param font   字体大小
 *  param lines 行数
 *  @return 高度
 */

//（利用label计算）
- (CGFloat)xhl_getWidthWithHFont:(UIFont *)font;

//（利用label计算）
- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font;

//（利用label计算）
- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font
                            lines:(NSInteger)lines;

//（计算富文本的高度（利用label计算）
- (CGFloat)xhl_calculateHeightWithAttributedString:(NSMutableAttributedString *)attributedString
                                             Width:(CGFloat)width
                                              font:(UIFont *)font;
//（计算富文本的高度（利用label计算）
- (CGFloat)xhl_calculateHeightWithAttributedString:(NSMutableAttributedString *)attributedString
                                             Width:(CGFloat)width
                                              font:(UIFont *)font
                                             lines:(NSInteger)lines;





@end

NS_ASSUME_NONNULL_END
