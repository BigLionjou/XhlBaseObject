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

///获取安全区域的 Nav 顶部高度
#define XhlStatusBarHeight (XhlIPHONE_X ?  XhlIPHONE_KeyWindowSafeAreaInsets.top : 20)
#define XhlSafeAreaNaviTopY XhlStatusBarHeight
//导航栏高度
#define XhlNavtionHeight 44
// 导航栏高度 加 安全高度
#define XhlSafeAreaTopHeight (XhlStatusBarHeight + XhlNavtionHeight)


///横条
#define XhlSafeAreaBottomY (XhlIPHONE_X ? 17 : 0)
/// 获取安全区域的 TabBar 底部高度
#define XhlSafeAreaTabBottomY (XhlIPHONE_X ? XhlIPHONE_KeyWindowSafeAreaInsets.bottom : 0)
//标签栏高度
#define XhlTabBottomHeight 49
// 标签栏高度 + 安全高度
#define XhlSafeAreaBottomHeight (XhlSafeAreaTabBottomY + XhlTabBottomHeight)





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
