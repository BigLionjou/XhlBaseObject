//
//  XhllivingAuthorizationTools.m
//  权限判断demo
//
//  Created by 新华龙mac on 2017/11/29.
//  Copyright © 2017年 新华龙mac. All rights reserved.
//

#import "XhlAuthTools.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AddressBookUI/ABPeoplePickerNavigationController.h>
#import <AddressBook/ABPerson.h>
#import <AddressBookUI/ABPersonViewController.h>
#import <Contacts/Contacts.h>
#import <CoreTelephony/CTCellularData.h>
#import <UserNotifications/UserNotifications.h>
#import "UIAlertController+XhlCategory.h"
#import "UIView+XhlCategory.h"

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR_TEST
#else
#endif

@implementation XhlAuthTools


// 获得Info.plist数据字典
+ (NSDictionary *)getInfoDictionary {
    NSDictionary *infoDict = [NSBundle mainBundle].localizedInfoDictionary;
    if (!infoDict || !infoDict.count) {
        infoDict = [NSBundle mainBundle].infoDictionary;
    }
    if (!infoDict || !infoDict.count) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        infoDict = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return infoDict ? infoDict : @{};
}

+ (void)showAlertTip:(NSString *)name{
    
    NSDictionary *infoDict = [XhlAuthTools getInfoDictionary];
    NSString *appName = [infoDict valueForKey:@"CFBundleDisplayName"];
    if (!appName) appName = [infoDict valueForKey:@"CFBundleName"];
    NSString *tipText = [NSString stringWithFormat:@"请在iPhone的\"设置-%@-%@\"选项中，\r允许访问你的%@",appName,name,name];
    
    UIAlertController *alert = [UIAlertController  xhl_alertWithTitle:@"温馨提示"
                                                              message:tipText
                                                            sureTitle:@"确认"
                                                          cancelTitle:@"取消"
                                                          sureHandler:^(UIAlertAction * _Nonnull action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
    } cancelHandler:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIView xhl_getTopViewController] presentViewController:alert animated:YES completion:nil];
    });
    
}


#pragma mark ------------相机 -------------
+ (BOOL)canUseCameraAuthorized{
    return [XhlAuthTools canUseCamera:nil];
}

+ (BOOL)canUseCamera:(XhllOpenStatusBlock)status{
    
    //1.判断设备是否支持相机
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return NO;
    }
    //2.判断相机权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status){
        status(authStatus);
    }
    //状态 ==  3
    return authStatus == AVAuthorizationStatusAuthorized;
    
}

+ (void)showNOCanUseCameraAlertTip{
    
    [XhlAuthTools showAlertTip:@"相机"];
    
}


#pragma mark ------------相册 -------------
+ (BOOL)canUsePhotosAuthorized{
    return [XhlAuthTools canUsePhotos:nil];
}

+ (BOOL)canUsePhotos:(XhllOpenStatusBlock)status{
    
    //1.判断设备支持相册
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return NO;
    }
    //2.判断相册权限
    PHAuthorizationStatus PHstatus = [PHPhotoLibrary authorizationStatus];
    if(status){
        status(PHstatus);
    }
    //状态 ==  3
    return PHstatus == PHAuthorizationStatusAuthorized;
    
}

+ (void)showNOCanUsePhotosAlertTip{
    
    [XhlAuthTools showAlertTip:@"照片"];
    
}


#pragma mark ------------麦克风 -------------
+ (BOOL)canUseMediaTypeAudioAuthorized{
    
    return [XhlAuthTools canUseMediaTypeAudio:nil];
    
}

+ (BOOL)canUseMediaTypeAudio:(XhllOpenStatusBlock)status{
    //1.判断麦克风权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if(status){
        status(authStatus);
    }
    //状态 ==  3
    return authStatus == AVAuthorizationStatusAuthorized;
    
}
+ (void)showNOCanUseMediaAudioAlertTip{
    
    [XhlAuthTools showAlertTip:@"麦克风"];
    
}
/**
 是否能开始录像（需要请求两次权限）
 
 @param status 权限状态
 @return bool
 */
+ (BOOL)canUseMediaTypeToVideo:(XhllOpenStatusBlock)status{
    //0.判断是否在模拟器中运行
    if (TARGET_IPHONE_SIMULATOR) {
        if (status) status(XhlAuthStatusDevNotSupport);
        return NO;
    }
    
    AVAuthorizationStatus authStatusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    AVAuthorizationStatus authStatusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatusVideo == AVAuthorizationStatusNotDetermined&&
        authStatusAudio == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                 if (status) status(XhlAuthStatusDenied);
            }else{
                 if (status) status(XhlAuthStatusNotDetermined);
            }
        }];
       
        return YES;
    }else if (authStatusVideo == AVAuthorizationStatusRestricted&&
              authStatusAudio == AVAuthorizationStatusRestricted){
        if (status) status(XhlAuthStatusRestricted);
        return NO;
    }else if (authStatusVideo == AVAuthorizationStatusDenied||
              authStatusAudio == AVAuthorizationStatusDenied){
        if (status) status(XhlAuthStatusDenied);
        return NO;
    }else if (authStatusVideo == AVAuthorizationStatusAuthorized&&
              authStatusAudio == AVAuthorizationStatusAuthorized){
        if (status) status(XhlAuthStatusAuthorized);
        return YES;
    }
    if (status) status(XhlAuthStatusNotDetermined);
    return NO;
}



+ (BOOL)canUseLocationAuthorized{
    
    return [XhlAuthTools canUseLocation:nil];
    
}
/**
 定位权限
 
 @param status 权限状态
 @return bool
 */
+ (BOOL)canUseLocation:(XhllOpenStatusBlock)status{
    if ([CLLocationManager locationServicesEnabled]) {
        CLAuthorizationStatus authStatusLocation = [CLLocationManager authorizationStatus];
        switch (authStatusLocation) {
            case kCLAuthorizationStatusNotDetermined:
                if (status) status(XhlAuthStatusNotDetermined);
                //注意这里是 YES
                return YES;
                break;
            case kCLAuthorizationStatusRestricted:
                if (status) status(XhlAuthStatusRestricted);
                return NO;
                break;
            case kCLAuthorizationStatusDenied:
                if (status) status(XhlAuthStatusDenied);
                return NO;
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
                if (status) status(XhlAuthStatusAuthorized);
                return YES;
                break;
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                if (status) status(XhlAuthStatusAuthorized);
                return YES;
                break;
        }
    }else{
        if (status) status(XhlAuthStatusNotDetermined);
        return NO;
    }
    
}

/**
 通讯录权限
 
 @param status 权限状态
 @return bool
 */
+ (BOOL)canUseAddressBook:(XhllOpenStatusBlock)status{
    //0.判断是否在模拟器中运行
    if (TARGET_IPHONE_SIMULATOR) {
        if (status) status(XhlAuthStatusDevNotSupport);
        return NO;
    }
    CNAuthorizationStatus authorizationStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (authorizationStatus) {
        case CNAuthorizationStatusNotDetermined:
            if (status) status(XhlAuthStatusNotDetermined);
            return YES;
            break;
        case CNAuthorizationStatusRestricted:
            if (status) status(XhlAuthStatusRestricted);
            return NO;
            break;
        case CNAuthorizationStatusDenied:
            if (status) status(XhlAuthStatusDenied);
            return NO;
            break;
        case CNAuthorizationStatusAuthorized:
            if (status) status(XhlAuthStatusAuthorized);
            return YES;
            break;
    }
    
    if (status) status(XhlAuthStatusNotDetermined);
    return NO;
}

/**
 通知权限
 
 @param status 权限状态
 */
+ (void)canUseNotification:(XhllOpenStatusBlock)status
{
    if(@available(iOS 10.0, *)) {
        //IOS10以上
//        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert|UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (granted) {
//                if (status) status(XhlAuthStatusAuthorized);
//            }else{
//                if (status) status(XhlAuthStatusDenied);
//            }
//        }];
        
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if(settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                if (status) status(XhlAuthStatusNotDetermined);
            } else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                if (status) status(XhlAuthStatusAuthorized);
            } else {
                if (status) status(XhlAuthStatusDenied);
            }
        }];
    }else if (@available(iOS 8.0, *)) {
        //IOS8-IOS10
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types  == UIUserNotificationTypeNone) {
            if (status) status(XhlAuthStatusDenied);
        }else if (setting.types  == UIUserNotificationTypeBadge){
            if (status) status(XhlAuthStatusAuthorized);
        }else if (setting.types  == UIUserNotificationTypeSound){
            if (status) status(XhlAuthStatusAuthorized);
        }else if (setting.types  == UIUserNotificationTypeAlert){
            if (status) status(XhlAuthStatusAuthorized);
        }
    }else{
        //IOS3-IOS8
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (type == UIRemoteNotificationTypeNone) {
            if (status) status(XhlAuthStatusDenied);
        }else if (type == UIRemoteNotificationTypeBadge){
            if (status) status(XhlAuthStatusAuthorized);
        }else if (type == UIRemoteNotificationTypeSound){
            if (status) status(XhlAuthStatusAuthorized);
        }else if (type == UIRemoteNotificationTypeAlert){
            if (status) status(XhlAuthStatusAuthorized);
        }
#pragma clang diagnostic pop
    }
    
}

+ (void)requestUseNotification:(XhllOpenStatusBlock)status {
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:UNAuthorizationOptionBadge|UNAuthorizationOptionSound|UNAuthorizationOptionAlert|UNAuthorizationOptionCarPlay completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            if (status) status(XhlAuthStatusAuthorized);
        }else{
            if (status) status(XhlAuthStatusDenied);
        }
    }];
}

/**
 判断联网权限（CTCellularData 只能检测蜂窝权限，不能检测WiFi权限。在ios9之前处于私有api， ios9之后公开）
 
 @param status 网络权限状态
 */
+ (void)canUseNetworkAuth:(XhllOpenStatusBlock)status{
    if(@available(iOS 9.0, *)) {
        CTCellularData *cellularData = [[CTCellularData alloc]init];
        cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
            //获取联网状态
            switch (state) {
                case kCTCellularDataRestrictedStateUnknown:
                    if (status) status(XhlAuthStatusNotDetermined);
                    NSLog(@"蜂窝网络权限未知");
                    break;
                case kCTCellularDataRestricted:
                    if (status) status(XhlAuthStatusDenied);
                    NSLog(@"蜂窝网络权限受限制");
                    break;
                case kCTCellularDataNotRestricted:
                    if (status) status(XhlAuthStatusAuthorized);
                    NSLog(@"蜂窝网络权限打开");
                    break;
                default:
                    break;
            };
        };
    }
}

/**
 当前网络连接状态（根据手机状态栏判断网络连接状态）
 
 @param status XhlOpenNetworkServiceStatusBlock状态
 */
+ (BOOL)canUseNetworkService:(XhlOpenNetworkServiceStatusBlock)status{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    switch (type) {
        case 1:
            if (status) status(XhlNetworkServiceStatus2G);
            return YES;
            break;
        case 2:
            if (status) status(XhlNetworkServiceStatus3G);
            return YES;
        case 3:
            if (status) status(XhlNetworkServiceStatus4G);
            return YES;
        case 5:
            if (status) status(XhlNetworkServiceStatusWIFI);
            return YES;
        default:
            if (status) status(XhlNetworkServiceStatusUnknown);
            return NO;
            break;
    }
}

// ----------- 等待相册权限-----------------
+ (void)judgeCanUsePhotosStatusCompletion:(void(^)(BOOL allow))completion {
    
    if (![XhlAuthTools canUsePhotos:^(XhlAuthStatus status) {
        if (status == 0) {
                /**
                 * 当某些情况下AuthorizationStatus == AuthorizationStatusNotDetermined时，无法弹出系统首次使用的授权alertView，系统应用设置里亦没有相册的设置，此时将无法使用，故作以下操作，弹出系统首次使用的授权alertView
                 */
                [XhlAuthTools CUP_requestAuthorizationWithCompletion:nil];
        }
    }]) {
        
        if ([PHPhotoLibrary authorizationStatus] == 0) {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(CUP_observeAuthrizationStatusChange:) userInfo:completion repeats:NO];
        }else{
            if(completion){
                completion(NO);
            }
        }
        
    }else{
        if(completion){
            completion(YES);
        }
    }
    
}

+ (void)CUP_requestAuthorizationWithCompletion:(void (^)(void))completion {
    void (^callCompletionBlock)(void) = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            callCompletionBlock();
        }];
    });
}

+ (void)CUP_observeAuthrizationStatusChange:(NSTimer *)timer {
    
    void (^completion)(BOOL allow) = timer.userInfo;
    [timer invalidate];
    timer = nil;
    NSLog(@"observeAuthrizationStatusChange +++");
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == 0) {
        NSTimer *timer_JX = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(CUP_observeAuthrizationStatusChange:) userInfo:completion repeats:NO];
    }
    if ([XhlAuthTools canUsePhotos:^(XhlAuthStatus status) {
        
        if (status == 0) {
                /**
                 * 当某些情况下AuthorizationStatus == AuthorizationStatusNotDetermined时，无法弹出系统首次使用的授权alertView，系统应用设置里亦没有相册的设置，此时将无法使用，故作以下操作，弹出系统首次使用的授权alertView
                 */
                [XhlAuthTools CUP_requestAuthorizationWithCompletion:nil];
        }
    }]) {
        if(completion){
            completion(YES);
        }
        NSLog(@"observeAuthrizationStatusChange ___");
        
    }else if(authStatus == PHAuthorizationStatusRestricted ||
             authStatus == PHAuthorizationStatusDenied ){
        if(completion){
            completion(NO);
        }
        NSLog(@"observeAuthrizationStatusChange _NO__");
    }
}
// ----------- 等待相机权限完成-----------------
+ (void)judgeCanUseCameraStatusCompletion:(void(^)(BOOL allow))completion {
    
    
    if (![XhlAuthTools canUseCameraAuthorized]) {
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusNotDetermined) {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(CUC_observeAuthrizationStatusChange:) userInfo:completion repeats:NO];
        }else{
            if(completion){
                completion(NO);
            }
        }
        
    }else{
        if(completion){
            completion(YES);
        }
    }

}


+ (void)CUC_observeAuthrizationStatusChange:(NSTimer *)timer {
    
    void (^completion)(BOOL allow) = timer.userInfo;
    [timer invalidate];
    timer = nil;
    NSLog(@"observeAuthrizationStatusChange +++");
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == 0) {
        NSTimer *timer_JX = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(CUC_observeAuthrizationStatusChange:) userInfo:completion repeats:NO];
    }
    
    if (authStatus == AVAuthorizationStatusAuthorized) {
        if(completion){
            completion(YES);
        }
        NSLog(@"observeAuthrizationStatusChange _YES__");
    }else if(authStatus == AVAuthorizationStatusRestricted ||
             authStatus == AVAuthorizationStatusDenied ){
        if(completion){
            completion(NO);
        }
        NSLog(@"observeAuthrizationStatusChange _NO__");
    }
    
}

// ----------- 等待麦克风权限完成-----------------
+ (void)judgeCanUseMediaTypeAudioStatusCompletion:(void(^)(BOOL allow))completion {
    
    if (![XhlAuthTools canUseMediaTypeAudioAuthorized]) {
        
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
        if (authStatus == AVAuthorizationStatusNotDetermined){
            //等待
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(CUA_observeAuthrizationStatusChange:) userInfo:completion repeats:NO];
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {

            }];
            
        }else{
            if(completion){
                completion(NO);
            }
        }
        
    }else{
        if(completion){
            completion(YES);
        }
    }
    
}

+ (void)CUA_observeAuthrizationStatusChange:(NSTimer *)timer {
    
    void (^completion)(BOOL allow) = timer.userInfo;
    [timer invalidate];
    timer = nil;
    NSLog(@"observeAuthrizationStatusChange +++");
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (authStatus == 0) {
        NSTimer *timer_JX = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(CUA_observeAuthrizationStatusChange:) userInfo:completion repeats:NO];
    }
    
    if (authStatus == AVAuthorizationStatusAuthorized) {
        if(completion){
            completion(YES);
        }
        NSLog(@"observeAuthrizationStatusChange _YES__");
    }else if(authStatus == AVAuthorizationStatusRestricted ||
             authStatus == AVAuthorizationStatusDenied ){
        if(completion){
            completion(NO);
        }
        NSLog(@"observeAuthrizationStatusChange _NO__");
    }
}

// ----------- 等待定位权限完成-----------------


+ (void)judgecanUseLocationStatusCompletion:(void(^)(BOOL allow))completion {
    

    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    
    if (authStatus == kCLAuthorizationStatusNotDetermined ||
        authStatus == kCLAuthorizationStatusRestricted ||
        authStatus == kCLAuthorizationStatusDenied ) {
       
        CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
        if (authStatus == kCLAuthorizationStatusNotDetermined) {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(CUL_observeAuthrizationStatusChange:) userInfo:completion repeats:NO];
        }else{
            if(completion){
                completion(NO);
            }
        }
        
    }else{
        if(completion){
            completion(YES);
        }
    }

}


+ (void)CUL_observeAuthrizationStatusChange:(NSTimer *)timer {
    
    void (^completion)(BOOL allow) = timer.userInfo;
    [timer invalidate];
    timer = nil;
    NSLog(@"observeAuthrizationStatusChange +++");
    
    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == 0) {
        NSTimer *timer_JX = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(CUL_observeAuthrizationStatusChange:) userInfo:completion repeats:NO];
    }
    
    if (authStatus  == kCLAuthorizationStatusAuthorizedAlways ||
        authStatus  == kCLAuthorizationStatusAuthorizedWhenInUse) {
        if(completion){
            completion(YES);
        }
        NSLog(@"observeAuthrizationStatusChange _YES__");
        
    }else if(authStatus == kCLAuthorizationStatusRestricted ||
           authStatus == kCLAuthorizationStatusDenied ){
        if(completion){
            completion(NO);
        }
        NSLog(@"observeAuthrizationStatusChange _NO__");
    }
}


@end

