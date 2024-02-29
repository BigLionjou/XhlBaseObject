//
//  XhlMacro.h
//  XhlBaseObjectDemo
//
//  Created by 龚魁华 on 2019/1/10.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIDevice+XhlCategory.h"
#import "UIScreen+XhlCategory.h"
#import "NSString+XhlCategory.h"

NS_ASSUME_NONNULL_BEGIN

// 字体大小适配
#define Xhl_font(size) [UIFont systemFontOfSize:size]
#define Xhl_fontWeight(size, weight) [UIFont systemFontOfSize:size weight:weight]
#define Xhl_match_font(size) [UIFont systemFontOfSize:Xhl_matching_width(size)]
#define Xhl_match_fontWeight(size, weight) [UIFont systemFontOfSize:Xhl_matching_width(size) weight:Xhl_matching_width(weight)]

#define Xhl_imageFromBundle(bundleName, imageName) [[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"] stringByAppendingPathComponent:imageName]

#define XhlUserDefaults             [NSUserDefaults standardUserDefaults]

///NSLog在release状态不执行
#ifdef __OPTIMIZE__
# define NSLog(...) {}
#else
# define NSLog(...) NSLog(__VA_ARGS__)
#endif

#pragma mark - Clang

#define ArgumentToString(macro) #macro
#define ClangWarningConcat(warning_name) ArgumentToString(clang diagnostic ignored warning_name)

/// 参数可直接传入 clang 的 warning 名，warning 列表参考：https://clang.llvm.org/docs/DiagnosticsReference.html
#define BeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(ClangWarningConcat(#warningName))
#define EndIgnoreClangWarning _Pragma("clang diagnostic pop")

#define BeginIgnorePerformSelectorLeaksWarning BeginIgnoreClangWarning(-Warc-performSelector-leaks)
#define EndIgnorePerformSelectorLeaksWarning EndIgnoreClangWarning

#define BeginIgnoreAvailabilityWarning BeginIgnoreClangWarning(-Wpartial-availability)
#define EndIgnoreAvailabilityWarning EndIgnoreClangWarning

#define BeginIgnoreDeprecatedWarning BeginIgnoreClangWarning(-Wdeprecated-declarations)
#define EndIgnoreDeprecatedWarning EndIgnoreClangWarning

#define hlw_isDark @available(iOS 13.0, *) && UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark

UIColor *khlw_generateDynamicColor(UInt32 lightHex, UInt32 darkHex);

//对所有的字赋值,方便做语音转换
NSString *khlw_setText(NSString *hex);

//对所有的图片赋值
UIImage *khlw_setImage(NSString *hex);


#define kSize_WidthCoefficient [XhlMacro xhl_fintSizeWidthCoefficient]

//----------------------------------------------------------------------
#pragma mark >>>>>>>>>>>>>>>>>>>>>>>>>>>> 字体 <<<<<<<<<<<<<<<<<<<<<<<<<<<<
//----------------------------------------------------------------------
#define kFont_RegularFont(f) [UIFont fontWithName:@"PingFangSC-Regular" size:(f)*kSize_WidthCoefficient]
#define kFont_MediumFont(f) [UIFont fontWithName:@"PingFangSC-Medium" size:(f)*kSize_WidthCoefficient]
#define kFont_SemiboldFont(f) [UIFont fontWithName:@"PingFangSC-Semibold" size:(f)*kSize_WidthCoefficient]
#define kFont_LightFont(f) [UIFont fontWithName:@"PingFangSC-Light" size:(f)*kSize_WidthCoefficient]
#define kFont_SCHeavyFont(f) [UIFont fontWithName:@"PingFang-SC-Heavy" size:(f)*kSize_WidthCoefficient]

//普通字体    苹方 标准体 17*系数
#define kFont_NormalTextFont [UIFont fontWithName:@"PingFangSC-Regular" size:17*kSize_WidthCoefficient]
//中等字体    苹方 标准体 15*系数
#define kFont_MediumTextFont [UIFont fontWithName:@"PingFangSC-Regular" size:15*kSize_WidthCoefficient]
//小号字体    苹方 标准体 13*系数
#define kFont_SmallTextFont [UIFont fontWithName:@"PingFangSC-Regular" size:13*kSize_WidthCoefficient]
//大标题      苹方 标准体 19*系数
#define kFont_BigTitleFont [UIFont fontWithName:@"PingFangSC-Regular" size:19*kSize_WidthCoefficient]
//小标题      苹方 标准体 13*系数
#define kFont_SmallTitleFont [UIFont fontWithName:@"PingFangSC-Regular" size:13*kSize_WidthCoefficient]
//正文按钮字体 苹方 中黑体 13*系数
#define kFont_ButtonTitleFont [UIFont fontWithName:@"PingFangSC-Medium" size:17*kSize_WidthCoefficient]
//底部按钮字体 苹方 粗黑体 22*系数
#define kFont_BottomButtonTitleFont [UIFont fontWithName:@"PingFangSC-Semibold" size:22*kSize_WidthCoefficient]


NSString *XhlAppBuild(void); // 获取 app build 号

NSString *XhlAppName(void); // 获取 app 的名称

NSString *XhlAppVersion(void); // 获取 app 版本号

UIWindow *XhlKeyWindow(void); // 获取主 window

void XhlSystemSetting(void); // 打开系统设置

BOOL XhlIsRegisterRemote(void); // 获取是否打开推送设置

BOOL XhlIsDark(void);//是否是暗黑模式

@interface XhlMacro : NSObject

//设置字体改变系数 1,2,3
+ (void)xhl_setFontSizeCoefficient:(CGFloat)fontsize;

+ (CGFloat)xhl_fintSizeWidthCoefficient;
@end

NS_ASSUME_NONNULL_END
