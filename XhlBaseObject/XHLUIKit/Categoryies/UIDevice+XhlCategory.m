//
//  UIDevice+CQCategory.m
//  PodManager
//
//  Created by 龚魁华 on 2018/7/10.
//  Copyright © 2018年 mn. All rights reserved.
//

#import "UIDevice+XhlCategory.h"
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <mach/processor_info.h>

#import <sys/types.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <sys/stat.h>
#import <sys/sysctl.h>                                                        // sysctlbyname
#import <sys/socket.h>                                                         // MAC地址

#import <net/if.h>
#import <net/if.h>
#import <net/if_dl.h>

#import <arpa/inet.h>
#import <ifaddrs.h>
// 获取运营商信息时依赖这两个头文件,需要加入对库“CoreTelephony.framework”的依赖
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation UIDevice (XHLCategory)
#pragma mark - sysctlbyname utils

- (NSString *)getSysInfoByName:(const char *)aTypeSpecifier
{
    size_t size;
    sysctlbyname(aTypeSpecifier, NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname(aTypeSpecifier, answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    return results;
}

// 目前没有区分iPad和iPhone的模拟器
- (NSString *)platform
{
    NSString *platformInfo = [self getSysInfoByName:"hw.machine"];
    NSString *noUnderlinePlatFromInfo = [platformInfo stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
#if TARGET_IPHONE_SIMULATOR
    if ([self xhl_isRetina])
        return [NSString stringWithFormat:PLATFORM_FORMAT, IPHONE3, noUnderlinePlatFromInfo];
    else
        return [NSString stringWithFormat:PLATFORM_FORMAT, IPHONE1, noUnderlinePlatFromInfo];
#endif
    return noUnderlinePlatFromInfo;
}

- (UIDevicePlatform) platformType
{
    NSString *platform = [self platform];
    
    // The ever mysterious iFPGA
    if ([platform isEqualToString:@"iFPGA"])        return UIDeviceIFPGA;
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"])    return UIDevice1GiPhone;
    if ([platform isEqualToString:@"iPhone1,2"])    return UIDevice3GiPhone;
    if ([platform hasPrefix:@"iPhone2"])            return UIDevice3GSiPhone;
    if ([platform hasPrefix:@"iPhone3"])            return UIDevice4iPhone;
    if ([platform hasPrefix:@"iPhone4"])            return UIDevice4SiPhone;
    if ([platform isEqualToString:@"iPhone5,1"])    return UIDevice5iPhone;
    if ([platform isEqualToString:@"iPhone5,2"])    return UIDevice5iPhone;
    if ([platform isEqualToString:@"iPhone5,3"])    return UIDevice5CiPhone;
    if ([platform isEqualToString:@"iPhone5,4"])    return UIDevice5CiPhone;
    if ([platform hasPrefix:@"iPhone6"])            return UIDevice5SiPhone;
    if ([platform isEqualToString:@"iPhone7,1"])    return UIDevice6PLUSiPhone;
    if ([platform isEqualToString:@"iPhone7,2"])    return UIDevice6iPhone;
    if ([platform isEqualToString:@"iPhone8,1"])    return UIDevice6SiPhone;
    if ([platform isEqualToString:@"iPhone8,2"])    return UIDevice6SPLUSiPhone;
    if ([platform isEqualToString:@"iPhone8,4"])    return UIDeviceSEiPhone;
    if ([platform isEqualToString:@"iPhone9,1"])    return UIDevice7iPhone;
    if ([platform isEqualToString:@"iPhone9,2"])    return UIDevice7PLUSiPhone;
    if ([platform isEqualToString:@"iPhone9,3"])    return UIDevice7iPhone;
    if ([platform isEqualToString:@"iPhone9,4"])    return UIDevice7PLUSiPhone;
    if ([platform isEqualToString:@"iPhone10,1"])    return UIDevice8iPhone;
    if ([platform isEqualToString:@"iPhone10,4"])    return UIDevice8iPhone;
    if ([platform isEqualToString:@"iPhone10,2"])    return UIDevice8PLUSiPhone;
    if ([platform isEqualToString:@"iPhone10,5"])    return UIDevice8PLUSiPhone;
    if ([platform isEqualToString:@"iPhone10,3"])    return UIDeviceXiPhone;
    if ([platform isEqualToString:@"iPhone10,6"])    return UIDeviceXiPhone;
    if ([platform isEqualToString:@"iPhone11,2"])    return UIDeviceXSiPhone;
    if ([platform isEqualToString:@"iPhone11,4"])    return UIDeviceXSMaxiPhone;
    if ([platform isEqualToString:@"iPhone11,6"])    return UIDeviceXSMaxiPhone;
    if ([platform isEqualToString:@"iPhone11,8"])    return UIDeviceXRiPhone;
    
    // iPod
    if ([platform hasPrefix:@"iPod1"])              return UIDevice1GiPod;
    if ([platform hasPrefix:@"iPod2"])              return UIDevice2GiPod;
    if ([platform hasPrefix:@"iPod3"])              return UIDevice3GiPod;
    if ([platform hasPrefix:@"iPod4"])              return UIDevice4GiPod;
    
    // iPad
    if ([platform hasPrefix:@"iPad1"])              return UIDevice1GiPad;
    if ([platform hasPrefix:@"iPad2"])              return UIDevice2GiPad;
    if ([platform hasPrefix:@"iPad3"])              return UIDevice3GiPad;
    if ([platform hasPrefix:@"iPad4"])              return UIDevice4GiPad;
    
    // Apple TV
    if ([platform hasPrefix:@"AppleTV2"])           return UIDeviceAppleTV2;
    if ([platform hasPrefix:@"AppleTV3"])           return UIDeviceAppleTV3;
    
    if ([platform hasPrefix:@"iPhone"])             return UIDeviceUnknowniPhone;
    if ([platform hasPrefix:@"iPod"])               return UIDeviceUnknowniPod;
    if ([platform hasPrefix:@"iPad"])               return UIDeviceUnknowniPad;
    if ([platform hasPrefix:@"AppleTV"])            return UIDeviceUnknownAppleTV;
    
    // Simulator thanks Jordan Breeding
    if ([platform hasSuffix:@"86"] || [platform isEqual:@"x86_64"])
    {
        BOOL smallerScreen = [[UIScreen mainScreen] bounds].size.width < 768;
        return smallerScreen ? UIDeviceSimulatoriPhone : UIDeviceSimulatoriPad;
    }
    
    return UIDeviceUnknown;
}

- (NSString *) platformString
{
    switch ([self platformType])
    {
        case UIDevice1GiPhone: return IPHONE_1G_NAMESTRING;
        case UIDevice3GiPhone: return IPHONE_3G_NAMESTRING;
        case UIDevice3GSiPhone: return IPHONE_3GS_NAMESTRING;
        case UIDevice4iPhone: return IPHONE_4_NAMESTRING;
        case UIDevice4SiPhone: return IPHONE_4S_NAMESTRING;
        case UIDevice5iPhone: return IPHONE_5_NAMESTRING;
        case UIDevice5CiPhone: return IPHONE_5C_NAMESTRING;
        case UIDevice5SiPhone: return IPHONE_5S_NAMESTRING;
        case UIDevice6iPhone: return IPHONE_6_NAMESTRING;
        case UIDevice6PLUSiPhone: return IPHONE_6_PLUS_NAMESTRING;
        case UIDevice6SiPhone: return IPHONE_6S_NAMESTRING;
        case UIDevice6SPLUSiPhone: return IPHONE_6S_PLUS_NAMESTRING;
        case UIDeviceSEiPhone: return IPHONE_SE_NAMESTRING;
        case UIDevice7iPhone: return IPHONE_7_NAMESTRING;
        case UIDevice7PLUSiPhone: return IPHONE_7_PLUS_NAMESTRING;
        case UIDevice8iPhone: return IPHONE_8_NAMESTRING;
        case UIDevice8PLUSiPhone: return IPHONE_8_PLUS_NAMESTRING;
        case UIDeviceXiPhone: return IPHONE_X_NAMESTRING;
        case UIDeviceXSiPhone: return IPHONE_XS_NAMESTRING;
        case UIDeviceXSMaxiPhone: return IPHONE_XSMax_NAMESTRING;
        case UIDeviceXRiPhone: return IPHONE_XR_NAMESTRING;
        case UIDeviceUnknowniPhone: return IPHONE_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPod: return IPOD_1G_NAMESTRING;
        case UIDevice2GiPod: return IPOD_2G_NAMESTRING;
        case UIDevice3GiPod: return IPOD_3G_NAMESTRING;
        case UIDevice4GiPod: return IPOD_4G_NAMESTRING;
        case UIDeviceUnknowniPod: return IPOD_UNKNOWN_NAMESTRING;
            
        case UIDevice1GiPad : return IPAD_1G_NAMESTRING;
        case UIDevice2GiPad : return IPAD_2G_NAMESTRING;
        case UIDevice3GiPad : return IPAD_3G_NAMESTRING;
        case UIDevice4GiPad : return IPAD_4G_NAMESTRING;
        case UIDeviceUnknowniPad : return IPAD_UNKNOWN_NAMESTRING;
            
        case UIDeviceAppleTV2 : return APPLETV_2G_NAMESTRING;
        case UIDeviceAppleTV3 : return APPLETV_3G_NAMESTRING;
        case UIDeviceAppleTV4 : return APPLETV_4G_NAMESTRING;
        case UIDeviceUnknownAppleTV: return APPLETV_UNKNOWN_NAMESTRING;
            
        case UIDeviceSimulator: return SIMULATOR_NAMESTRING;
        case UIDeviceSimulatoriPhone: return SIMULATOR_IPHONE_NAMESTRING;
        case UIDeviceSimulatoriPad: return SIMULATOR_IPAD_NAMESTRING;
        case UIDeviceSimulatorAppleTV: return SIMULATOR_APPLETV_NAMESTRING;
            
        case UIDeviceIFPGA: return IFPGA_NAMESTRING;
            
        default: return IOS_FAMILY_UNKNOWN_DEVICE;
    }
}

- (NSString *)getDeviceInfo
{
    NSString *noUnderlineSystemVersion = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"_" withString:@"-"];
    NSString *platform = [self platform];
    if (!platform)
    {
        platform = @"";
    }
    if (!noUnderlineSystemVersion)
    {
        noUnderlineSystemVersion = @"";
    }
    return [NSString stringWithFormat:DEVICEINFO_FORMAT, platform, noUnderlineSystemVersion];
}

#pragma mark - misc

- (NSString *)getCellularProviderName
{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    return [carrier carrierName];
}

- (NSString *)getMNC
{
    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    return [carrier mobileNetworkCode];
}

- (NSString *)getMCC
{
    //    CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc] init];
    //    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    //    RELEASE_SET_NIL(netInfo);
    //    return [carrier mobileCountryCode];
    
    /*上面为原始代码，为修复bug http://newicafe.xhl.com/issue/xhlSEARCHIOS-16745/show 更改为如下代码；
     1. 该bug为系统bug，CTTelephonyNetworkInfo对象销毁后系统依然会向该对象发通知，导致crash；
     2. 将CTTelephonyNetworkInfo改为静态实例；
     参考链接：
     https://github.com/urbanairship/ios-library/issues/80
     https://stackoverflow.com/questions/38434686/coretelephony-crash-for-reason-received-a-notification-with-no-notification-nam
     https://stackoverflow.com/questions/14238586/coretelephony-crash/15510580#15510580
     */
    static CTTelephonyNetworkInfo *netInfo;
    static dispatch_once_t dispatchToken;
    if (!netInfo) {
        dispatch_once(&dispatchToken, ^{
            netInfo = [[CTTelephonyNetworkInfo alloc] init];
        });
    }
    CTCarrier *carrier = [netInfo subscriberCellularProvider];
    return [carrier mobileCountryCode];
}

- (NSString *)getMACAddress
{
    int                     mib[6];
    size_t                  len;
    char                    *buf;
    unsigned char           *ptr;
    struct if_msghdr        *ifm;
    struct sockaddr_dl      *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0)
    {
        return nil;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
    {
        return nil;
    }
    
    if ((buf = (char*)malloc(len)) == NULL)
    {
        return nil;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0)
    {
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    free(buf);
    return [outstring uppercaseString];
}


- (BOOL)xhl_isJailBreak
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/Applications/Cydia.app"])
    {
        return YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"])
    {
        return YES;
    }
    //    int res = access("/var/mobile/Library/AddressBook/AddressBook.sqlitedb", F_OK);
    //    if (res == 0)
    //        return YES;
    return NO;
    
}

- (BOOL)isSimulator {
    NSUInteger platformType = [self platformType];
    switch (platformType) {
        case UIDeviceSimulator:
        case UIDeviceSimulatoriPhone:
        case UIDeviceSimulatoriPad:
        case UIDeviceSimulatorAppleTV:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (BOOL)isIPhoneDevice {
    NSUInteger platformType = [self platformType];
    return platformType >= UIDeviceUnknowniPhone && platformType < UIDeviceUnknowniPod;
}

- (NSString *)cachedSystemVersion {
    static NSString *_system_version = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _system_version = [[UIDevice currentDevice] systemVersion];
    });
    return _system_version;
}

+ (BOOL)isUnderIphone6 {
    CGSize applicationSize = [UIScreen mainScreen].bounds.size;
    
    if (fabs(applicationSize.width - 320.f) < 0.001)
    {
        return YES;
    }
    return NO;
}

#define getDeviceMatch(name) \
static BOOL isDevice##name;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
isDevice##name = [self matchDevice:UIDevice##name##iPhone size:ScreenSizeOfDevice##name];\
});\
return isDevice##name

+ (BOOL)isIPhone4 {
    getDeviceMatch(4);
}

+ (BOOL)isIPhone5 {
    getDeviceMatch(5);
}

+ (BOOL)isIPhone6 {
    getDeviceMatch(6);
}

+ (BOOL)isIPhone6plus {
    getDeviceMatch(6PLUS);
}

+ (BOOL)needSafeArea {
    return [self _isIPhoneX] || [self isIPhoneXR] || [self isIPhoneXS] || [self isIPhoneXSMax];
}

+ (BOOL)isFringeScreen {
    return [self _isIPhoneX] || [self isIPhoneXR] || [self isIPhoneXS] || [self isIPhoneXSMax];
}

// 临时兼容业务方对iPhone X的适配
+ (BOOL)isIPhoneX {
    return [self isFringeScreen];
}

+ (BOOL)_isIPhoneX {
    getDeviceMatch(X);
}

+ (BOOL)isIPhoneXR {
    getDeviceMatch(XR);
}

+ (BOOL)isIPhoneXS {
    getDeviceMatch(XS);
}

+ (BOOL)isIPhoneXSMax {
    getDeviceMatch(XSMax);
}

+ (BOOL)matchDevice:(UIDevicePlatform)type size:(CGSize)size {
    if ([self.currentDevice platformType] == type) {
        return YES;
    } else {
        return [self checkiPhoneToFitSize:size];
    }
}

+ (BOOL)checkiPhoneToFitSize:(CGSize)toSize {
    //是否为手机
    bool isPhone = [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
    if (!isPhone) {
        return NO;
    }
    //是否匹配size
    CGSize applicationSize = [UIScreen mainScreen].bounds.size;
    if (CGSizeEqualToSize(applicationSize, toSize)) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isSupportedUIInterfaceOrientation:(UIInterfaceOrientation)orientation{
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown ||
        orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

+ (BOOL)isSupportedUIInterfaceOrientationMask:(UIInterfaceOrientationMask)orientationMask{
    if (orientationMask == UIInterfaceOrientationMaskPortrait ||
        orientationMask == UIInterfaceOrientationMaskLandscapeLeft ||
        orientationMask == UIInterfaceOrientationMaskLandscapeRight ||
        orientationMask == UIInterfaceOrientationMaskPortraitUpsideDown ||
        orientationMask == UIInterfaceOrientationMaskLandscape ||
        orientationMask == UIInterfaceOrientationMaskAll ||
        orientationMask == UIInterfaceOrientationMaskAllButUpsideDown) {
        return YES;
    }
    return NO;
}

+ (void)setOrientation:(UIInterfaceOrientation)orientation {
    SEL selector = NSSelectorFromString(@"setOrientation:");
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:selector]];
    [invocation setSelector:selector];
    [invocation setTarget:[UIDevice currentDevice]];
    int val = (int)orientation;
    [invocation setArgument:&val atIndex:2];
    [invocation invoke];
}


#pragma mark sysctl utils
- (NSUInteger) getSysInfo: (uint) typeSpecifier
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return (NSUInteger) results;
}

#pragma mark cpu information
- (NSString *) cpuType
{
    switch ([self platformType])
    {
        case UIDevice3GiPhone: return IPHONE_3G_CPUTYPE;
        case UIDevice3GSiPhone: return IPHONE_3GS_CPUTYPE;
        case UIDevice4iPhone: return IPHONE_4_CPUTYPE;
        case UIDevice4SiPhone: return IPHONE_4S_CPUTYPE;
        case UIDevice4GiPod: return IPOD_4G_CPUTYPE;
        default: return IOS_CPUTYPE_UNKNOWN;
    }
}

- (NSString *) cpuFrequency
{
    switch ([self platformType])
    {
        case UIDevice3GiPhone: return IPHONE_3G_CPUFREQUENCY;
        case UIDevice3GSiPhone: return IPHONE_3GS_CPUFREQUENCY;
        case UIDevice4iPhone: return IPHONE_4_CPUFREQUENCY;
        case UIDevice4SiPhone: return IPHONE_4S_CPUFREQUENCY;
        case UIDevice4GiPod: return IPOD_4G_CPUFREQUENCY;
        default: return IOS_CPUFREQUENCY_UNKNOWN;
    }
}

- (NSUInteger) cpuCount
{
    return [self getSysInfo:HW_NCPU];
}

- (NSArray *)cpuUsage
{
    NSMutableArray *usage = [NSMutableArray array];
    //    float usage = 0;
    processor_info_array_t _cpuInfo, _prevCPUInfo = nil;
    mach_msg_type_number_t _numCPUInfo, _numPrevCPUInfo = 0;
    unsigned _numCPUs;
    NSLock *_cpuUsageLock;
    
    int _mib[2U] = { CTL_HW, HW_NCPU };
    size_t _sizeOfNumCPUs = sizeof(_numCPUs);
    int _status = sysctl(_mib, 2U, &_numCPUs, &_sizeOfNumCPUs, NULL, 0U);
    if(_status)
        _numCPUs = 1;
    
    _cpuUsageLock = [[NSLock alloc] init];
    
    natural_t _numCPUsU = 0U;
    kern_return_t err = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO, &_numCPUsU, &_cpuInfo, &_numCPUInfo);
    if(err == KERN_SUCCESS) {
        [_cpuUsageLock lock];
        
        for(unsigned i = 0U; i < _numCPUs; ++i) {
            Float32 _inUse, _total;
            if(_prevCPUInfo) {
                _inUse = (
                          (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM])
                          + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE]   - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE])
                          );
                _total = _inUse + (_cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE] - _prevCPUInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE]);
            } else {
                _inUse = _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_USER] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_SYSTEM] + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_NICE];
                _total = _inUse + _cpuInfo[(CPU_STATE_MAX * i) + CPU_STATE_IDLE];
            }
            
            //            NSLog(@"Core : %u, Usage: %.2f%%", i, _inUse / _total * 100.f);
            float u = _inUse / _total * 100.f;
            [usage addObject:[NSNumber numberWithFloat:u]];
        }
        
        [_cpuUsageLock unlock];
        
        if(_prevCPUInfo) {
            size_t prevCpuInfoSize = sizeof(integer_t) * _numPrevCPUInfo;
            vm_deallocate(mach_task_self(), (vm_address_t)_prevCPUInfo, prevCpuInfoSize);
        }
        
        _prevCPUInfo = _cpuInfo;
        _numPrevCPUInfo = _numCPUInfo;
        
        _cpuInfo = nil;
        _numCPUInfo = 0U;
    } else {
        //        NSLog(@"Error!");
    }
    return usage;
}

#pragma mark memory information
- (NSUInteger) totalMemoryBytes
{
    return [self getSysInfo:HW_PHYSMEM];
}

- (NSUInteger) freeMemoryBytes
{
    mach_port_t           host_port = mach_host_self();
    mach_msg_type_number_t   host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t               pagesize;
    vm_statistics_data_t     vm_stat;
    
    host_page_size(host_port, &pagesize);
    
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) NSLog(@"Failed to fetch vm statistics");
    
    //    natural_t   mem_used = (vm_stat.active_count + vm_stat.inactive_count + vm_stat.wire_count) * pagesize;
    NSUInteger mem_free = vm_stat.free_count * pagesize;
    //    natural_t   mem_total = mem_used + mem_free;
    
    return mem_free;
}

#pragma mark disk information
- (long long) freeDiskSpaceBytes
{
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if(statfs("/private/var", &buf) >= 0){
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

- (long long) totalDiskSpaceBytes
{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if(statfs("/private/var", &buf) >= 0){
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace;
}

#pragma mark bluetooth information
- (BOOL) bluetoothCheck
{
    switch ([self platformType])
    {
        case UIDevice3GiPhone: return YES;
        case UIDevice3GSiPhone: return YES;
        case UIDevice4iPhone: return YES;
        case UIDevice4SiPhone: return YES;
        case UIDevice5iPhone: return YES;
            
        case UIDevice3GiPod: return YES;
        case UIDevice4GiPod: return YES;
            
        case UIDevice1GiPad : return YES;
        case UIDevice2GiPad : return YES;
        case UIDevice3GiPad : return YES;
        case UIDevice4GiPad : return YES;
            
        default: return NO;
    }
}
- (NSArray *)runningProcesses
{
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    u_int miblen = 4;
    
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        size += size / 10;
        newprocess = realloc(process, size);
        if (!newprocess){
            if (process){
                free(process);
            }
            return nil;
        }
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        if (size % sizeof(struct kinfo_proc) == 0){
            size_t nprocess = size / sizeof(struct kinfo_proc);
            if (nprocess){
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (int i = (int)nprocess - 1; i >= 0; i--){
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    NSDictionary * dict = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:processID, processName, nil]
                                                                        forKeys:[NSArray arrayWithObjects:@"ProcessID", @"ProcessName", nil]];
                    [array addObject:dict];
                    
                }
                free(process);
                
                return array ;
            }
        }
    }
    
    return nil;
}

- (float)cpu_usage
{
    kern_return_t            kr = { 0 };
    task_info_data_t        tinfo = { 0 };
    mach_msg_type_number_t    task_info_count = TASK_INFO_MAX;
    
    kr = task_info( mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    task_basic_info_t        basic_info = { 0 };
    thread_array_t            thread_list = { 0 };
    mach_msg_type_number_t    thread_count = { 0 };
    
    thread_info_data_t        thinfo = { 0 };
    thread_basic_info_t        basic_info_th = { 0 };
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads( mach_task_self(), &thread_list, &thread_count );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    long    tot_sec = 0;
    long    tot_usec = 0;
    float    tot_cpu = 0;
    
    for ( int i = 0; i < thread_count; i++ )
    {
        mach_msg_type_number_t thread_info_count = THREAD_INFO_MAX;
        
        kr = thread_info( thread_list[i], THREAD_BASIC_INFO, (thread_info_t)thinfo, &thread_info_count );
        if ( KERN_SUCCESS != kr )
            return 0.0f;
        
        basic_info_th = (thread_basic_info_t)thinfo;
        if ( 0 == (basic_info_th->flags & TH_FLAGS_IDLE) )
        {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE;
        }
    }
    
    kr = vm_deallocate( mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t) );
    if ( KERN_SUCCESS != kr )
        return 0.0f;
    
    return tot_cpu;
}

//计算当前内存
-(float )report_memory
{
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS )
    {
        printf("Memory vm : %zd\n",info.virtual_size);
        printf("Memory in use (in bytes): %zd b\n", info.resident_size);
        printf("Memory in use (in k-bytes): %f k\n", info.resident_size / 1024.0);
        printf("Memory in use (in m-bytes): %f m\n", info.resident_size / (1024.0 * 1024.0));
        return info.resident_size / (1024.0);
    }
    else
    {
        printf("Error with task_info(): %s\n", mach_error_string(kerr));
        return 0.0;
    }
}

- (NSArray *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    int WiFiSent = 0;
    int WiFiReceived = 0;
    
    int WWANSent = 0;
    int WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            //            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    //                    NSLog(@"WiFiSent %d ==%d",WiFiSent,networkStatisc->ifi_obytes);
                    //                    NSLog(@"WiFiReceived %d ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    //                    NSLog(@"WWANSent %d ==%d",WWANSent,networkStatisc->ifi_obytes);
                    //                    NSLog(@"WWANReceived %d ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return [NSArray arrayWithObjects:[NSNumber numberWithFloat:(WiFiSent+WiFiReceived)/(1024.0)],
            [NSNumber numberWithFloat:WiFiSent/(1024.0)],
            [NSNumber numberWithFloat:WiFiReceived/(1024.0)],
            [NSNumber numberWithInt:WWANSent],
            [NSNumber numberWithInt:WWANReceived], nil];
}


-(float) getBattery{
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    UIDevice *myDevice = [UIDevice currentDevice];
    
    [myDevice setBatteryMonitoringEnabled:YES];
    double batLeft = (float)[myDevice batteryLevel];
    return batLeft;
    
}

- (BOOL) DeviceIsiPad {
    return [self userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

- (BOOL) DeviceIsLandscape {
    return UIDeviceOrientationIsLandscape((UIDeviceOrientation)[[UIApplication sharedApplication] statusBarOrientation]);
}

+ (NSString*)xhl_NSStringFromResolution:(XHLlDeviceResolution) resolution
{
    switch (resolution) {
        case XHLlDeviceResolution_iPhoneStandard:
            return @"iPhone Standard";
            break;
        case XHLlDeviceResolution_iPhoneRetina35:
            return @"iPhone Retina 3.5\"";
            break;
        case XHLlDeviceResolution_iPhoneRetina4:
            return @"iPhone Retina 4\"";
            break;
        case XHLlDeviceResolution_iPadStandard:
            return @"iPad Standard";
            break;
        case XHLlDeviceResolution_iPadRetina:
            return @"iPad Retina";
            break;
        case XHLlDeviceResolution_iPhoneRetina47:
            return @"iPhone Retina 4.7\"";
            break;
        case XHLlDeviceResolution_iPhoneRetina55:
            return @"iPhone Retina 5.5\"";
            break;
        case XHLlDeviceResolution_Unknown:
        default:
            return @"Unknown";
            break;
    }
}

- (XHLlDeviceResolution)xhl_resolution
{
    XHLlDeviceResolution resolution = XHLlDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        if (scale == 3.0f && pixelHeight == 2208.0f)
        {
            resolution = XHLlDeviceResolution_iPhoneRetina55;
        }
        else if (scale == 2.0f)
        {
            if (pixelHeight == 960.0f)
            {
                resolution = XHLlDeviceResolution_iPhoneRetina35;
            }
            else if (pixelHeight == 1136.0f)
            {
                resolution = XHLlDeviceResolution_iPhoneRetina4;
            }
            else if (pixelHeight == 1334.0f)
            {
                resolution = XHLlDeviceResolution_iPhoneRetina47;
            }
        }
        else if (scale == 1.0f && pixelHeight == 480.0f)
        {
            resolution = XHLlDeviceResolution_iPhoneStandard;
        }
    }
    else
    {
        if (scale == 2.0f && pixelHeight == 2048.0f)
        {
            resolution = XHLlDeviceResolution_iPadRetina;
            
        }
        else if (scale == 1.0f && pixelHeight == 1024.0f)
        {
            resolution = XHLlDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
}

- (CGSize)xhl_resolutionSize
{
    CGSize resolusionSize = CGSizeZero;
    XHLlDeviceResolution resolution = [[UIDevice currentDevice] xhl_resolution];
    switch (resolution) {
        case XHLlDeviceResolution_iPhoneStandard:
            resolusionSize = CGSizeMake(320, 480);
            break;
        case XHLlDeviceResolution_iPhoneRetina35:
            resolusionSize = CGSizeMake(640, 960);
            break;
        case XHLlDeviceResolution_iPhoneRetina4:
            resolusionSize = CGSizeMake(640, 1136);
            break;
        case XHLlDeviceResolution_iPadStandard:
            resolusionSize = CGSizeMake(1024, 768);
            break;
        case XHLlDeviceResolution_iPadRetina:
            resolusionSize = CGSizeMake(2048, 1536);
            break;
        case XHLlDeviceResolution_iPhoneRetina47:
            resolusionSize = CGSizeMake(750, 1334);
            break;
        case XHLlDeviceResolution_iPhoneRetina55:
            resolusionSize = CGSizeMake(1242, 2208);
            break;
        default:
            break;
    }
    
    return resolusionSize;
}


- (BOOL)xhl_isRetina
{
    BOOL isRetina = NO;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    if (scale > 1.0) {
        isRetina = YES;
    }
    return isRetina;
}
@end
