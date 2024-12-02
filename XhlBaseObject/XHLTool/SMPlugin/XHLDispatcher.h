//
//  XHLDispatcher.h
//  XhlWebViewDemo
//
//  Created by XHL on 2019/8/15.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "WKWebView+HLWCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHLDispatcher : NSObject
// Web JS 回调
@property (nonatomic, copy,readonly) NSString *callback;
@property (nonatomic, weak,readonly)   WKWebView *sourceWebView;
@property (nonatomic, copy,readonly)   NSURL *sourceURL;     // 调起来源URL
@property (nonatomic, strong,readonly) NSDictionary *parameter;//js参数

@property(nonatomic, copy) void (^replyHandler)(id reply, NSString *errorMessage);

/**
 初始化,该方法只在路由转发中使用

 */
- (instancetype)initWithCallBack:(NSString *)callback
                   sourceWebView:(WKWebView *)sourceWebView
                       sourceURL:(NSURL *)sourceURL
                       parameter:(NSDictionary *)parameter;

/**
执行回调

@param positionDic  回调数据
@return 执行的js字符串成功
*/
+ (NSString *)maskPositionJsonData:(NSDictionary *)positionDic;

//数组转json字符串
+ (NSString *)maskArryToJsonData:(NSArray *)dataArry;

/**
 执行回调

 @param data 数据
 @return 执行成功
 */
- (BOOL)doCallbackData:(id)data;


/**
 执行错误回调

 @param data 数据
 @return 执行成功
 */
- (BOOL)doFailureCallback:(NSString *)code
                  message:(NSString *)message
                otherData:(id)data;

/**
 执行回调

 @param data 传给js的数据
 @param completionHandler js回调
 */
- (BOOL)doCallbackWithData:(id)data
           completionHandler:(void (^)(id result,
                                       NSError * error))completionHandler;



/**
 执行js方法

 @param script js
 @param completionHandler 回调
 */
- (void)evaluateJS:(NSString *)script
 completionHandler:(void (^)(id result,
                             NSError * error))completionHandler;
@end

NS_ASSUME_NONNULL_END
