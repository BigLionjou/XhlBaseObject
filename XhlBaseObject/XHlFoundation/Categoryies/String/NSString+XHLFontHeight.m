//
//  NSString+XHLFontHeight.m
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2024/9/9.
//

#import "NSString+XHLFontHeight.h"

@implementation NSString (XHLFontHeight)


+ (CGSize)xhl_sizeWithString:(NSString *)string Font:(UIFont *)font
{
    return [NSString  xhl_sizeWithString:string Font:font maxW:MAXFLOAT];
}
+ (CGSize)xhl_sizeWithString:(NSString *)string Font:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

#pragma mark - 计算字符串宽度、高度
//计算文字占用高度（行间距）
- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font
                      LineSpacing:(CGFloat)LineSpacing{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = LineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic;
    if(LineSpacing>0){
        dic = @{NSFontAttributeName:font,
                              NSParagraphStyleAttributeName:paraStyle,
                              NSKernAttributeName:@1.5f
                              };
    }else{
        dic = @{NSFontAttributeName:font};
    }
    
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:dic context:nil].size;
    
    CGFloat textHeight = ceil(size.height); // 向上取整，确保文本能够完全显示
    return textHeight;
}


- (CGFloat)xhl_Code_getHeightWithWidth:(CGFloat)width
                                  font:(UIFont *)font{
 
    return [self xhl_getHeightWithWidth:width font:font LineSpacing:0];
    
}

//计算内容高度
- (CGFloat)xhl_getWidthWithHFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.numberOfLines = 1;
    label.font = font;
    label.text = self;
    [label sizeToFit];
    return CGRectGetWidth(label.frame);
}
- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font{
    return [self xhl_getHeightWithWidth:width font:font lines:0];
}

- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font
                            lines:(NSInteger)lines{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    label.numberOfLines = lines;
    label.font = font;
    label.text = self;
    [label sizeToFit];
    return CGRectGetHeight(label.frame);
}



//计算富文本的高度
- (CGFloat)xhl_calculateHeightWithAttributedString:(NSMutableAttributedString *)attributedString
                                             Width:(CGFloat)width
                                              font:(UIFont *)font{
    return [self xhl_calculateHeightWithAttributedString:attributedString Width:width font:font lines:0];
}

- (CGFloat)xhl_calculateHeightWithAttributedString:(NSMutableAttributedString *)attributedString
                                             Width:(CGFloat)width
                                              font:(UIFont *)font
                                             lines:(NSInteger)lines {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    label.numberOfLines = 0;
    label.font = font;
    label.numberOfLines = lines;
    label.attributedText = attributedString;
    [label sizeToFit];
    return label.frame.size.height;
}


@end
