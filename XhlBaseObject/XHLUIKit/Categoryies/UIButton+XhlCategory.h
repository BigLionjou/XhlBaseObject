//
//  UIButton+XhlCategory.h
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/7/16.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ButtonEdgeInsetsStyle) {
    ButtonEdgeInsetsStyleImageLeft,
    ButtonEdgeInsetsStyleImageRight,
    ButtonEdgeInsetsStyleImageTop,
    ButtonEdgeInsetsStyleImageBottom
};
NS_ASSUME_NONNULL_BEGIN

@interface UIButton (XHLCategory)


- (void)xhl_layoutButtonWithEdgeInsetsStyle:(ButtonEdgeInsetsStyle)style imageTitlespace:(CGFloat)space;
@end

NS_ASSUME_NONNULL_END
