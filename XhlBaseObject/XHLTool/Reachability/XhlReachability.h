//
//  XhlReachability.h
//  Pods
//
//  Created by xiaoshiheng on 2024/10/10.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

NS_ASSUME_NONNULL_BEGIN


#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

extern NSString *const kXhlReachabilityChangedNotification;

typedef NS_ENUM(NSInteger, XhlNetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    XhlNotReachable = 0,
    XhlReachableViaWiFi = 2,
    XhlReachableViaWWAN = 1
};

@class XhlReachability;

typedef void (^XhlNetworkReachable)(XhlReachability * reachability);
typedef void (^XhlNetworkUnreachable)(XhlReachability * reachability);


@interface XhlReachability : NSObject

@property (nonatomic, copy) XhlNetworkReachable    reachableBlock;
@property (nonatomic, copy) XhlNetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;

//互联网连接域名的可达性
+(XhlReachability*)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(XhlReachability*)reachabilityWithHostName:(NSString*)hostname;
//互联网连接的可达性
+(XhlReachability*)reachabilityForInternetConnection;

//带地址的可达性
+(XhlReachability*)reachabilityWithAddress:(void *)hostAddress;
//本地WiFi的可达性
+(XhlReachability*)reachabilityForLocalWiFi;

-(XhlReachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;


-(BOOL)isReachable;
//提供 同步 isReachable方法
+ (BOOL)networkEnable;

-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;
//同步方法提供
+ (BOOL)isReachableViaWiFi;

//WWAN可能可用，但在建立连接之前不会活动。
//WiFi可能需要连接VPN点播
-(BOOL)isConnectionRequired; // Identical DDG variant.
-(BOOL)connectionRequired; // Apple's routine.
//动态、按需连接？
-(BOOL)isConnectionOnDemand;
//是否需要用户干预？
-(BOOL)isInterventionRequired;

-(XhlNetworkStatus)currentReachabilityStatus;
//同步方法提供
+ (NSString *)networkTypeName;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;



@end

NS_ASSUME_NONNULL_END
