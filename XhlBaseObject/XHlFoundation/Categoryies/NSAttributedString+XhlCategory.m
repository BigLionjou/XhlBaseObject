//
//  NSAttributedString+XhlCategory.m
//  XHLMedia
//
//  Created by XHL on 2019/11/28.
//  Copyright © 2019 龚魁华. All rights reserved.
//

#import "NSAttributedString+XhlCategory.h"

@implementation NSAttributedString (XhlCategory)

- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    label.numberOfLines = 0;
    label.font = font;
    label.attributedText = self;
    [label sizeToFit];
    return CGRectGetHeight(label.frame);
}

@end
