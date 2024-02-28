//
//  UIScreen+XhlCategory.h
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/8/1.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIDevice+XhlCategory.h"

#define Xhl_ScreenBound [UIScreen xhl_getApplicationSize]
#define xhl_SCREEN_SCALE ([UIScreen mainScreen].scale)

/// 获取当前屏幕的宽度
#define Xhl_ScreenWidth    [UIScreen xhl_getScreenWidth]
/// 获取当前屏幕的高度
#define Xhl_ScreenHeight   [UIScreen xhl_getScreenHeight]


// 标签栏高度
#define XhlSafeAreaBottomHeight (XhlIPHONE_X ? (49 + 34) : 49)

/// 状态栏高度(来电等情况下，状态栏高度会发生变化，所以应该实时计算) iphone x 系列从刘海平开始算起
//#define XhlStatusBarHeight ([UIApplication sharedApplication].statusBarHidden ? 0 : ([[UIApplication sharedApplication] statusBarFrame].size.height)) 有bug

#define XhlStatusBarHeight (XhlIPHONE_X ? 44 : 20)

//导航栏高度
#define XhlNavtionHeight 44

// 导航栏高度加状态栏
//#define XhlSafeAreaTopHeight (XhlIPHONE_X ? 88 : 64)
#define XhlSafeAreaTopHeight (XhlStatusBarHeight + XhlNavtionHeight)

// 定义导航栏开始布局的高度，纵坐标的 Y，非 IphoneX 是基于 20 状态栏 的高度布局，而IphoneX是基于 44 的高度开始布局
//#define XhlSafeAreaNaviTopY (XhlIPHONE_X ? 44 : 20)
#define XhlSafeAreaNaviTopY XhlStatusBarHeight

#define XhlSafeAreaTabBottomY (XhlIPHONE_X ? 34 : 0)
#define XhlSafeAreaBottomY (XhlIPHONE_X ? 17 : 0)

// 屏幕比例适配，以 375px为基
#define Xhl_matching_scale (Xhl_ScreenWidth / 375.0)

// 屏幕比例适配，以 375px为基
#define Xhl_matching_scale (Xhl_ScreenWidth / 375.0)
// 宽度比例适配
#define Xhl_matching_width(width) ((width) * Xhl_matching_scale)
NS_ASSUME_NONNULL_BEGIN

@interface UIScreen (XHLCategory)
+ (CGSize)xhl_getApplicationSize;
+ (CGFloat)xhl_getScreenWidth;
+ (CGFloat)xhl_getScreenHeight;

@end

NS_ASSUME_NONNULL_END
