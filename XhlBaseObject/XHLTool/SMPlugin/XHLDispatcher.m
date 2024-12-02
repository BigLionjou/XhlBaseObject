//
//  XHLDispatcher.m
//  XhlWebViewDemo
//
//  Created by XHL on 2019/8/15.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "XHLDispatcher.h"

@implementation XHLDispatcher

- (instancetype)initWithCallBack:(NSString *)callback
                   sourceWebView:(WKWebView *)sourceWebView
                       sourceURL:(NSURL *)sourceURL
                       parameter:(NSDictionary *)parameter{
    self = [super init];
    if (self) {
        _callback = callback;
        _sourceWebView = sourceWebView;
        _sourceURL = sourceURL;
        _parameter = parameter;
    }
    return self;
}
+ (NSString *)maskPositionJsonData:(NSDictionary *)positionDic{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:positionDic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
    
}

//数组转json字符串
+ (NSString *)maskArryToJsonData:(NSArray *)dataArry{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataArry
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return jsonString;
    
}

/**
 回传数据给js
 
 @param data 数据
 @return 执行成功
 */
- (BOOL)doCallbackData:(id)data{
    return [self doCallbackWithData:data
                  completionHandler:^(id  _Nonnull result, NSError * _Nonnull error) {
        
    }];
}

/**
 执行错误回调

 @param data 数据
 @return 执行成功
 */
- (BOOL)doFailureCallback:(NSString *)code
                  message:(NSString *)message
                otherData:(id)data{
    NSMutableDictionary *dict = @{@"code":code ? : @"-1",
                                  @"message":message ? : @""}.mutableCopy;
    if (data) {
        dict[@"data"] = data;
    }
    NSString *errmessage = [XHLDispatcher maskPositionJsonData:dict];
    if (self.replyHandler) {
        self.replyHandler(nil, errmessage);
        return true;
    }
    
    NSString *js = [NSString stringWithFormat:@"%@('%@')",@"errorCallBack",errmessage];
    [self evaluateJS:js completionHandler:^(id  _Nonnull result, NSError * _Nonnull error) {}];
    return true;
}

/**
 执行js
 
 @param data 传给js的数据
 @param completionHandler js回调
 */
- (BOOL)doCallbackWithData:(id)data
         completionHandler:(void (^)(id result,
                                     NSError * error))completionHandler{
    if (self.replyHandler) {
        self.replyHandler(data, nil);
//        return true;
    }
    
    NSString *jsData = data;
    if ([data isKindOfClass:[NSDictionary class]]) {
        jsData =  [XHLDispatcher maskPositionJsonData:data];
    }else if([data isKindOfClass:NSArray.class]){
        jsData = [XHLDispatcher maskArryToJsonData:data];
    }
    NSString *js = [NSString stringWithFormat:@"%@('%@')",self.callback,jsData];
    [self evaluateJS:js completionHandler:completionHandler];
    return YES;
}

//js执行方法
- (void)evaluateJS:(NSString *)script
 completionHandler:(void (^)(id result,
                             NSError * error))completionHandler
{
     id commandWebview = [self sourceWebView];
    if ([NSThread currentThread].isMainThread) {
        if ([commandWebview isKindOfClass:[WKWebView class]])
        {
            [commandWebview evaluateJavaScript:script
                             completionHandler:^(id _Nullable result,
                                                 NSError * _Nullable error) {
                                 if (completionHandler) {
                                     completionHandler(result, error);
                                 }
                             } ];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([commandWebview isKindOfClass:[WKWebView class]])
            {
                [commandWebview evaluateJavaScript:script
                                 completionHandler:^(id _Nullable result,
                                                     NSError * _Nullable error) {
                                     if (completionHandler) {
                                         completionHandler(result, error);
                                     }
                                 } ];
            }
        });
    }
}

@end
