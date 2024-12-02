//
//  WKWebView+HLWCategory.h
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2024/10/9.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

WKWebView *xhlBase_newWkWeb (void);

@interface WKWebView (HLWCategory)

//配置头部
@property (nonatomic, copy) void (^configTop)(NSDictionary *dict);
//配置底部
@property (nonatomic, copy) void (^configBottom)(NSDictionary *dict);
//配置顶部右上角按钮
@property (nonatomic, copy) void (^toprightConfig)(NSDictionary *dict);
//配置分享
@property (nonatomic, copy) void (^configShare)(NSDictionary *dict);
//网页加载第一次是否完成
@property (nonatomic, assign) BOOL isOneWebloadFinish;
//网页开始加载
@property (nonatomic, copy) void (^webloadStart)(WKWebView *webView);
//网页加载完成
@property (nonatomic, copy) void (^webloadFinish)(WKWebView *webView);
// 回调
@property (nonatomic, copy) void (^CallBack)(NSDictionary *dict);

//拦截js实现,这里返回true后,不在走默认分发
@property (nonatomic,copy) BOOL (^xhl_customImplementationJS)(NSString *jsfunName,NSDictionary *parameter,id dataModel);


//刷新web的高度
@property (nonatomic, copy) void (^refreshWebviewHeight)(CGFloat webHight);

//返回Vc的通知
@property (nonatomic, copy) void (^goToBackVcBlock)(void);
#pragma mark - ****** 类方法 *******

/** 清除缓存 */
+ (void)clearWKCache;

//刷新上个页面
- (void)xhl_webBackRefresh:(NSDictionary *)dic;

//返回上个页面
- (void)xhl_goBack;

//js执行方法
- (void)xhl_evaluateJS:(NSString *)script
     completionHandler:(void (^)(id result,
                                 NSError * error))completionHandler;
- (void)xhl_evaluateJS:(NSString *)script;


@end

NS_ASSUME_NONNULL_END
