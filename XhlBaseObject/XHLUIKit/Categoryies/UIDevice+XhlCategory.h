//
//  UIDevice+CQCategory.h
//  
//
//  Created by 龚魁华 on 2018/7/10.
//  Copyright © 2018年 mn. All rights reserved.
//

#import <UIKit/UIKit.h>
#pragma mark - 宏定义

#define IFPGA_NAMESTRING                @"iFPGA"

#define IPHONE1                         @"iPhone1"
#define IPHONE3                         @"iPhone3"
#define IPAD1                           @"iPad1"
#define IPAD3                           @"iPad3"

#define PLATFORM_FORMAT                 @"%@,%@"
#define DEVICEINFO_FORMAT               @"%@_%@"

#define IPHONE_1G_NAMESTRING            @"iPhone 1G"
#define IPHONE_3G_NAMESTRING            @"iPhone 3G"
#define IPHONE_3GS_NAMESTRING           @"iPhone 3GS"
#define IPHONE_4_NAMESTRING             @"iPhone 4"
#define IPHONE_4S_NAMESTRING            @"iPhone 4S"
#define IPHONE_5_NAMESTRING             @"iPhone 5"
#define IPHONE_5C_NAMESTRING            @"iPhone 5c"
#define IPHONE_5S_NAMESTRING            @"iPhone 5s"
#define IPHONE_6_NAMESTRING             @"iPhone 6"
#define IPHONE_6_PLUS_NAMESTRING        @"iPhone 6plus"

#define IPHONE_6S_NAMESTRING            @"iPhone 6s"
#define IPHONE_6S_PLUS_NAMESTRING       @"iPhone 6s plus"
#define IPHONE_SE_NAMESTRING            @"iPhone SE"
#define IPHONE_7_NAMESTRING             @"iPhone 7"
#define IPHONE_7_PLUS_NAMESTRING        @"iPhone 7 plus"
#define IPHONE_8_NAMESTRING             @"iPhone 8"
#define IPHONE_8_PLUS_NAMESTRING        @"iPhone 8 plus"
#define IPHONE_X_NAMESTRING             @"iPhone X"
#define IPHONE_XS_NAMESTRING            @"iPhone XS"
#define IPHONE_XSMax_NAMESTRING         @"iPhone XSMax"
#define IPHONE_XR_NAMESTRING            @"iPhone XR"

#define IPHONE_UNKNOWN_NAMESTRING       @"Unknown iPhone"

#define IPOD_1G_NAMESTRING              @"iPod touch 1G"
#define IPOD_2G_NAMESTRING              @"iPod touch 2G"
#define IPOD_3G_NAMESTRING              @"iPod touch 3G"
#define IPOD_4G_NAMESTRING              @"iPod touch 4G"
#define IPOD_UNKNOWN_NAMESTRING         @"Unknown iPod"

#define IPAD_1G_NAMESTRING              @"iPad 1G"
#define IPAD_2G_NAMESTRING              @"iPad 2G"
#define IPAD_3G_NAMESTRING              @"iPad 3G"
#define IPAD_4G_NAMESTRING              @"iPad 4G"
#define IPAD_UNKNOWN_NAMESTRING         @"Unknown iPad"

#define APPLETV_2G_NAMESTRING           @"Apple TV 2G"
#define APPLETV_3G_NAMESTRING           @"Apple TV 3G"
#define APPLETV_4G_NAMESTRING           @"Apple TV 4G"
#define APPLETV_UNKNOWN_NAMESTRING      @"Unknown Apple TV"

#define IOS_FAMILY_UNKNOWN_DEVICE       @"0"

#define SIMULATOR_NAMESTRING            @"iPhone Simulator"
#define SIMULATOR_IPHONE_NAMESTRING     @"iPhone Simulator"
#define SIMULATOR_IPAD_NAMESTRING       @"iPad Simulator"
#define SIMULATOR_APPLETV_NAMESTRING    @"Apple TV Simulator" // :)

//iPhone 3G 以后各代的CPU型号和频率
#define IPHONE_3G_CPUTYPE               @"ARM11"
#define IPHONE_3G_CPUFREQUENCY          @"412MHz"
#define IPHONE_3GS_CPUTYPE              @"ARM Cortex A8"
#define IPHONE_3GS_CPUFREQUENCY         @"600MHz"
#define IPHONE_4_CPUTYPE                @"Apple A4"
#define IPHONE_4_CPUFREQUENCY           @"1GMHz"
#define IPHONE_4S_CPUTYPE               @"Apple A5 Double Core"
#define IPHONE_4S_CPUFREQUENCY          @"800MHz"

//iPod touch 4G 的CPU型号和频率
#define IPOD_4G_CPUTYPE                 @"Apple A4"
#define IPOD_4G_CPUFREQUENCY            @"800MHz"

#define IOS_CPUTYPE_UNKNOWN             @"Unknown CPU type"
#define IOS_CPUFREQUENCY_UNKNOWN        @"Unknown CPU frequency"

// 系统版本
#define XHL_AVAILABLE(v)   @available(iOS v, *)
#define xhl_ios_system ([[[UIDevice currentDevice] systemVersion] floatValue])

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] cachedSystemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_EQUAL_TO(v)  ([[[UIDevice currentDevice] cachedSystemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_LOWWER_THAN(v)  ([[[UIDevice currentDevice] cachedSystemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability"

/// 获取 KeyWindow 的安全区域
#define XhlIPHONE_KeyWindowSafeAreaInsets \
({ \
    UIEdgeInsets safeInsets = UIEdgeInsetsZero; \
    if (@available(iOS 11.0, *)) { \
        UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow; \
        if (!keyWindow && @available(iOS 13.0, *)) { \
            for (UIWindowScene *scene in UIApplication.sharedApplication.connectedScenes) { \
                if ([scene isKindOfClass:[UIWindowScene class]]) { \
                    keyWindow = ((UIWindowScene *)scene).windows.firstObject; \
                    break; \
                } \
            } \
        } \
        safeInsets = keyWindow.safeAreaInsets; \
    } \
    safeInsets; \
})

#pragma clang diagnostic pop

/// 刘海屏检测宏
#define XhlIPHONE_X (XhlIPHONE_KeyWindowSafeAreaInsets.top > 20.0)

// 设备屏幕尺寸
#define ScreenSizeOfDevice4     CGSizeMake(320, 480)
#define ScreenSizeOfDevice4S    ScreenSizeOfDevice4

#define ScreenSizeOfDevice5     CGSizeMake(320, 568)
#define ScreenSizeOfDevice5S    ScreenSizeOfDevice5
#define ScreenSizeOfDevice5C    ScreenSizeOfDevice5
#define ScreenSizeOfDeviceSE    ScreenSizeOfDevice5

#define ScreenSizeOfDevice6     CGSizeMake(375, 667)
#define ScreenSizeOfDevice6S    ScreenSizeOfDevice6
#define ScreenSizeOfDevice7     ScreenSizeOfDevice6
#define ScreenSizeOfDevice8     ScreenSizeOfDevice6

#define ScreenSizeOfDevice6PLUS  CGSizeMake(414, 736)
#define ScreenSizeOfDevice6SPLUS ScreenSizeOfDevice6PLUS
#define ScreenSizeOfDevice7PLUS  ScreenSizeOfDevice6PLUS
#define ScreenSizeOfDevice8PLUS  ScreenSizeOfDevice6PLUS

#define ScreenSizeOfDeviceX     CGSizeMake(375, 812)
#define ScreenSizeOfDeviceXS    ScreenSizeOfDeviceX

#define ScreenSizeOfDeviceXR    CGSizeMake(414, 896)
#define ScreenSizeOfDeviceXSMax ScreenSizeOfDeviceXR



#pragma mark - 枚举值
// 第一位区别设备 0: 模拟器  1: iPhone  2: Pod  3: Pad  4: TV
// 第二三位区别系列     iPhone6 / iPhone7
// 第四位区别升级版本   iPhone6 / iPhone6s

typedef enum {
    UIDeviceUnknown,
    
    UIDeviceSimulator           = 0000,
    UIDeviceSimulatoriPhone     = 0001,
    UIDeviceSimulatoriPad       = 0003,
    UIDeviceSimulatorAppleTV    = 0004,
    
    UIDevice1GiPhone            = 1010,
    UIDevice3GiPhone            = 1030,
    UIDevice3GSiPhone           = 1031,
    UIDevice4iPhone             = 1040,
    UIDevice4SiPhone            = 1041,
    UIDevice5iPhone             = 1050,
    UIDevice5CiPhone            = 1051,
    UIDevice5SiPhone            = 1052,
    UIDevice6iPhone             = 1060,
    UIDevice6PLUSiPhone         = 1061,
    UIDevice6SiPhone            = 1062,
    UIDevice6SPLUSiPhone        = 1063,
    UIDeviceSEiPhone            = 1064,
    UIDevice7iPhone             = 1070,
    UIDevice7PLUSiPhone         = 1071,
    UIDevice8iPhone             = 1080,
    UIDevice8PLUSiPhone         = 1081,
    UIDeviceXiPhone             = 1100,
    UIDeviceXRiPhone            = 1101,
    UIDeviceXSiPhone            = 1102,
    UIDeviceXSMaxiPhone         = 1103,
    
    UIDevice1GiPod              = 2010,
    UIDevice2GiPod              = 2020,
    UIDevice3GiPod              = 2030,
    UIDevice4GiPod              = 2040,
    
    UIDevice1GiPad              = 3010,
    UIDevice2GiPad              = 3020,
    UIDevice3GiPad              = 3030,
    UIDevice4GiPad              = 3040,
    
    UIDeviceAppleTV2            = 4020,
    UIDeviceAppleTV3            = 4030,
    UIDeviceAppleTV4            = 4040,
    
    UIDeviceUnknowniPhone       = 1000,
    UIDeviceUnknowniPod         = 2000,
    UIDeviceUnknowniPad         = 3000,
    UIDeviceUnknownAppleTV      = 4000,
    UIDeviceIFPGA               = 9999,
    
} UIDevicePlatform;

typedef enum {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
    
} UIDeviceFamily;

typedef NS_ENUM(NSUInteger, XHLlDeviceResolution) {
    XHLlDeviceResolution_Unknown            = 0,
    XHLlDeviceResolution_iPhoneStandard    = 1,    // iPhone 1,3,3GS 标准    (320x480px)
    XHLlDeviceResolution_iPhoneRetina35    = 2,    // iPhone 4,4S 高清 3.5"    (640x960px)
    XHLlDeviceResolution_iPhoneRetina4    = 3,    // iPhone 5 高清 4"        (640x1136px)
    XHLlDeviceResolution_iPadStandard    = 4,    // iPad 1,2 标准        (1024x768px)
    XHLlDeviceResolution_iPadRetina        = 5,    // iPad 3 高清            (2048x1536px)
    XHLlDeviceResolution_iPhoneRetina47  = 6,    // iPhone 6 高清 4.7" (750x1334px)
    XHLlDeviceResolution_iPhoneRetina55  = 7     // iPhone 6 Plus 高清 5.5" (1242x2208px @3x)
};

@interface UIDevice (XHLCategory)

- (NSString *)getSysInfoByName:(const char *)aTypeSpecifier; // 平台信息
- (NSString *)getDeviceInfo;                // 没有经过ULREncode的原始信息
- (NSString *)getCellularProviderName;      // 获取运营商信息
- (NSString *)getMNC;                       // 获取移动网络码
- (NSString *)getMCC;                       // 获取国家码
- (NSString *)getMACAddress;                // 获取MAC地址
- (NSString *)cachedSystemVersion;          // 获取系统版本，并缓存

- (BOOL)xhl_isJailBreak;            // 判断是否越狱
- (BOOL)isSimulator;                // 判断是否是模拟器
- (BOOL)isIPhoneDevice;             // 判断是否是iPhone真机

- (NSString *) platform;
- (UIDevicePlatform) platformType;
- (NSString *) platformString;

#pragma mark - 机型判断
+ (BOOL)isIPhone5;
+ (BOOL)isIPhone6;
+ (BOOL)isIPhone6plus;
+ (BOOL)isUnderIphone6;
+ (BOOL)isIPhone4;

+ (BOOL)needSafeArea;
+ (BOOL)isFringeScreen; //刘海屏
+ (BOOL)isIPhoneX;
+ (BOOL)isIPhoneXR;
+ (BOOL)isIPhoneXS;
+ (BOOL)isIPhoneXSMax;
+ (BOOL)isSupportedUIInterfaceOrientation:(UIInterfaceOrientation)orientation;
+ (BOOL)isSupportedUIInterfaceOrientationMask:(UIInterfaceOrientationMask)orientationMask;
+ (void)setOrientation:(UIInterfaceOrientation)orientation;


- (NSString *) cpuType;             //cpu型号
- (NSString *) cpuFrequency;        //cpu频率
- (NSUInteger) cpuCount;            //cpu核数
- (NSArray *) cpuUsage;                 //cpu利用率

- (NSUInteger) totalMemoryBytes;    //获取手机内存总量,返回的是字节数
- (NSUInteger) freeMemoryBytes;     //获取手机可用内存,返回的是字节数

- (long long) freeDiskSpaceBytes;   //获取手机硬盘空闲空间,返回的是字节数
- (long long) totalDiskSpaceBytes;  //获取手机硬盘总空间,返回的是字节数


- (BOOL) bluetoothCheck;            //是否支持蓝牙
- (NSArray *)runningProcesses;
- (float)cpu_usage;                 //另一种计算cpu使用率的函数

- (float)report_memory;              //当前进程的内存信息
- (NSArray *)getDataCounters;       //wifi流量信息

- (float) getBattery;

/**
 *  Determine whether the current device is an iPad.
 *
 *  @return YES if the current device is an iPad; NO if not
 */
- (BOOL) DeviceIsiPad;

/**
 *  Determine whether the device orientation is currently landscape.
 *
 *  @return YES if the device is currently oriented in landscape; NO if portrait
 */
- (BOOL) DeviceIsLandscape;

/**
 *     @brief    设备当前分辨率(枚举)
 */
- (XHLlDeviceResolution)xhl_resolution;

/**
 *     @brief    设备当前分辨率(Size)
 */
- (CGSize)xhl_resolutionSize;

/**
 *     @brief   屏幕是否为retina屏幕
 *  @return  BOOL
 */
- (BOOL)xhl_isRetina;


/**
 *     @brief    屏幕是否为retina屏幕
 *      @return  BOOL
 */
+ (NSString*)xhl_NSStringFromResolution:(XHLlDeviceResolution) resolution;
@end
