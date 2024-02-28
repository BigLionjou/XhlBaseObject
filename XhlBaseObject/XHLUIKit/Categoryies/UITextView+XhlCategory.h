//
//  UITextView+CQCategory.h
//  PodManager
//
//  Created by 龚魁华 on 2018/7/9.
//  Copyright © 2018年 mn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (XHLCategory)

/* 占位文字 */
@property (nonatomic, copy) IBInspectable  NSString *xhl_placeholder;

/* 占位文字颜色 */
@property (nonatomic, strong) IBInspectable UIColor *xhl_placeholderColor;

@end
