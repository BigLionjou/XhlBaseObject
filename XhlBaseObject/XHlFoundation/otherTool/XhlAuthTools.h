//
//  XhlAuthTools.h
//  权限判断demo
//
//  Created by 新华龙mac on 2017/11/29.
//  Copyright © 2017年 新华龙mac. All rights reserved.
//  权限判断

#import <Foundation/Foundation.h>

//普通权限状态
typedef NS_ENUM(NSUInteger, XhlAuthStatus) {
    XhlAuthStatusNotDetermined = 0, // 默认还没做出选择
    XhlAuthStatusRestricted,        // 客户端没有被授权访问媒体类型的硬件。用户不能改变客户端的状态，可能是因为有一些活动限制，比如父母控制的存在。
    XhlAuthStatusDenied,            // 用户已经明确否认了应用程序对应权限访问,用户拒绝
    XhlAuthStatusAuthorized,        // 用户已经授权应用程序对应权限访问
    XhlAuthStatusDevNotSupport      // 当前设备不支持开启此权限设备
};

//网络联网状态
typedef NS_ENUM(NSUInteger, XhlNetworkServiceStatus) {
    XhlNetworkServiceStatus2G = 0, // 2G网络
    XhlNetworkServiceStatus3G,     // 3G网络
    XhlNetworkServiceStatus4G,     // 4G网络
    XhlNetworkServiceStatusWIFI,   // wifi网络
    XhlNetworkServiceStatusUnknown,// 未知网络
    XhlNetworkServiceStatusGPRS,   // GPRS网络(不能判断到底是2.3.4G网络)
};

typedef void (^XhllOpenStatusBlock)(XhlAuthStatus status);
typedef void (^XhlOpenNetworkServiceStatusBlock)(XhlNetworkServiceStatus status);


@interface XhlAuthTools : NSObject

/**
 是否拥有相机权限
 @return bool
 */
+ (BOOL)canUseCameraAuthorized;

/**
 相机权限
 
 @param status 权限状态
 @return bool
 */
+ (BOOL)canUseCamera:(XhllOpenStatusBlock)status;


/**
 等待相机权限完成
 
 @param completion allow 权限状态
 */
+ (void)judgeCanUseCameraStatusCompletion:(void(^)(BOOL allow))completion ;

/**
 无相机权限弹窗
 */
+ (void)showNOCanUseCameraAlertTip;


/**
 是否拥有相册权限
 @return bool
 */
+ (BOOL)canUsePhotosAuthorized;

/**
 相机权限
 
 @param status 权限状态
 @return bool
 */
+ (BOOL)canUsePhotos:(XhllOpenStatusBlock)status;

/**
 等待相册权限完成
 
 @param completion allow 权限状态
 */
+ (void)judgeCanUsePhotosStatusCompletion:(void(^)(BOOL allow))completion ;

/**
 无相册权限弹窗
 */
+ (void)showNOCanUsePhotosAlertTip;

/**
 是否拥有麦克风权限
 @return bool
 */
+ (BOOL)canUseMediaTypeAudioAuthorized;

/**
 麦克风权限
 
 @param status 权限状态
 @return bool
 */
+ (BOOL)canUseMediaTypeAudio:(XhllOpenStatusBlock)status;

/**
 等待麦克风权限完成
 
 @param completion allow 权限状态
 */
+ (void)judgeCanUseMediaTypeAudioStatusCompletion:(void(^)(BOOL allow))completion ;

/**
 麦克风权限弹窗
 */
+ (void)showNOCanUseMediaAudioAlertTip;


/**
 是否能开始录像
 
 @param status 权限状态
 @return bool
 */
+ (BOOL)canUseMediaTypeToVideo:(XhllOpenStatusBlock)status;


/**
 是否拥有定位权限
 @return bool
 */
+ (BOOL)canUseLocationAuthorized;
/**
 定位权限
 
 @param status 权限状态
 @return bool
 */
+ (BOOL)canUseLocation:(XhllOpenStatusBlock)status;

/**
 等待定位权限完成
 
 @param completion allow 权限状态
 */
+ (void)judgecanUseLocationStatusCompletion:(void(^)(BOOL allow))completion ;

/**
 通讯录权限
 
 @param status 权限状态
 @return bool
 */
+ (BOOL)canUseAddressBook:(XhllOpenStatusBlock)status;

/**
 是否打开通知权限
 
 @param status 权限状态
 */
+ (void)canUseNotification:(XhllOpenStatusBlock)status;
/// 请求推送权限
+ (void)requestUseNotification:(XhllOpenStatusBlock)status;

/**
 判断联网权限（CTCellularData 只能检测蜂窝权限，不能检测WiFi权限。在ios10之前处于私有api， 10之后公开）
 
 @param status 网络权限状态
 */
+ (void)canUseNetworkAuth:(XhllOpenStatusBlock)status;

/**
 当前网络连接状态（推荐使用AFNetWorking判断，部分代码在.m拓展）
 
 @param status XhlOpenNetworkServiceStatusBlock状态
 @return bool
 */
+ (BOOL)canUseNetworkService:(XhlOpenNetworkServiceStatusBlock)status;


@end

