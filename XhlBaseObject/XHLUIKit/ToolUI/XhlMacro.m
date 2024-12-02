//
//  XhlMacro.m
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/1/10.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "XhlMacro.h"
#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>
#import "UIColor+XhlCategory.h"
NSString *XhlAppBuild(void) {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

NSString *XhlAppName(void) {
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleDisplayName"];
}

NSString *XhlAppVersion(void) {
    return [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"];
}

UIWindow *XhlKeyWindow(void) {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    return window;
}

void XhlSystemSetting(void) {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

BOOL XhlIsRegisterRemote(void) {
    BOOL isRemoteNotify = false;
    if (xhl_ios_system >= 8.0) {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
            isRemoteNotify = true;
        }
    }
    return isRemoteNotify;
}

BOOL XhlIsDark(void){
    if (@available(iOS 12.0, *)) {
        BOOL isDark = (UIApplication.sharedApplication.keyWindow.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark);
        return isDark;
    } else {
        // Fallback on earlier versions
    }
    return false;
}

NSString *khlw_setText(NSString *hex){
    NSString *str = NSLocalizedString(hex, nil);
    return str;
}

//对所有的图片赋值
UIImage *khlw_setImage(NSString *hex){
    return [UIImage imageNamed:khlw_setText(hex)];
}

UIColor *khlw_generateDynamicColor(UInt32 lightHex, UInt32 darkHex){
    if (@available(iOS 13.0, *)) {
        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
                return colorWithHex(lightHex);
            }else {
                return colorWithHex(darkHex);
            }
        }];
        return dyColor;
    }else{
        return colorWithHex(lightHex);
    }
}


@implementation XhlMacro

#define k_xhl_setFontSizeCoefficientkey @"xhl_setFontSizeCoefficient"
//设置字体改变系数 1,2,3
+ (void)xhl_setFontSizeCoefficient:(CGFloat)fontsize{
    [NSUserDefaults.standardUserDefaults setObject:@(fontsize) forKey:k_xhl_setFontSizeCoefficientkey];
    [NSUserDefaults.standardUserDefaults synchronize];
}

+ (CGFloat)xhl_fintSizeWidthCoefficient{
    NSUserDefaults *defaults = NSUserDefaults.standardUserDefaults;
    //大屏放大的系数 （以4.7寸作为标准 375 * 667）
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight= screenSize.height;
    
    //横屏状态下
    if(screenWidth > screenHeight){
        screenWidth = screenHeight;
    }
    
    CGFloat fintSizeWidthCoefficient = (screenWidth / 375.0);
    
    if ([defaults objectForKey:k_xhl_setFontSizeCoefficientkey]) {
        NSNumber *number = [defaults objectForKey:k_xhl_setFontSizeCoefficientkey];
        float fontsizeCoefficient = number.floatValue;
        if (fontsizeCoefficient>0) {
            fintSizeWidthCoefficient = fintSizeWidthCoefficient*fontsizeCoefficient;
        }
    }
    return fintSizeWidthCoefficient;
}
@end
