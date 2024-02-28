//
//  UIApplication+XhlCategory.h
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2022/4/22.
//

#import <UIKit/UIKit.h>

typedef NSString * ApplicationOpenSDKStringKey NS_EXTENSIBLE_STRING_ENUM;


//回到放松，最开始方式
UIKIT_EXTERN ApplicationOpenSDKStringKey const _Nullable ApplicationOpenSDKStringRelax API_AVAILABLE(macos(10.0), ios(6.0));
//友盟分享
UIKIT_EXTERN ApplicationOpenSDKStringKey const _Nullable ApplicationOpenSDKStringUMShaer API_AVAILABLE(macos(10.0), ios(6.0));
//友盟登录
UIKIT_EXTERN ApplicationOpenSDKStringKey const _Nullable ApplicationOpenSDKStringUMLogin API_AVAILABLE(macos(10.0), ios(6.0));



NS_ASSUME_NONNULL_BEGIN

@interface UIApplication (XhlCategory)

//是否是友盟SDK 发起操作 (为了兼容保留)。UMShaer || UMLogin
@property (nonatomic,assign,readonly) BOOL isUMShaer;

/**
 SDK 发起跳转标识符号
 
已知
 友盟分享操作  标识符号  @“UMShaer”
 友盟登录操作  标识符号  @“UMLogin”
 
 SDK 回调必须 ApplicationOpenSDKStringKey
 
 */
@property (nonatomic,copy) NSString *state;

/**
 
 - (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{

 是否发起了恢复处理 YES后
 其他实现协议着不处理
 
 */
@property (nonatomic,assign) BOOL isRestoration;


@end

NS_ASSUME_NONNULL_END
