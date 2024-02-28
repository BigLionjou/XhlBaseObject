//
//  UITableViewCell+XHLCell.h
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/5/14.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (XHLCategory)

- (void)setShowDefaultBottomLine:(BOOL)is leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpace;

- (void)setShowBottomLine:(BOOL)is leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpace lineColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
