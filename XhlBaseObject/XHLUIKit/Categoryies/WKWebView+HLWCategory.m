//
//  WKWebView+HLWCategory.m
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2024/10/9.
//

#import "WKWebView+HLWCategory.h"
#import <objc/runtime.h>

WKWebView *xhlBase_newWkWeb (void){
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.allowsAirPlayForMediaPlayback = YES;//是否运行airplay自动播放媒体功能
    configuration.allowsInlineMediaPlayback = YES;// 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
    configuration.selectionGranularity = WKSelectionGranularityCharacter;//解决WKWebView的内存泄露
    //    configuration.suppressesIncrementalRendering = YES;
    configuration.processPool = [[WKProcessPool alloc] init];
    
    // 该属性只支持10+系统
    if (@available(iOS 10.0, *)) {
        configuration.dataDetectorTypes = WKDataDetectorTypeNone;
        configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
    } else if(@available(iOS 9.0, *)){
        configuration.requiresUserActionForMediaPlayback = YES;//允许网页自动播放视频和自动播放音频
    }//允许网页自动播放视频和自动播放音频
    
    // 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0;
    //设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preference;
    
    //设置是否允许画中画技术 在特定设备上有效
    configuration.allowsPictureInPictureMediaPlayback = YES;
    
    //允许跨域
    [configuration.preferences setValue:@YES forKey:@"allowFileAccessFromFileURLs"];
    if (@available(iOS 10.0, *)) {
         [configuration setValue:@YES forKey:@"allowUniversalAccessFromFileURLs"];
    }
    
    NSMutableString *javascript = [NSMutableString string];
    [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
   
//    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:noneSelectScript];
    
    configuration.userContentController = userContentController;
    
    WKWebView *web = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
    web.allowsBackForwardNavigationGestures = YES;
    web.userInteractionEnabled = YES;
    web.multipleTouchEnabled = true;
    web.backgroundColor = [UIColor whiteColor];
    web.opaque = NO;
    //禁止原始web自行滚动,兼容-webkit-overflow-scrolling 网页自己有滚动
    web.scrollView.scrollEnabled = NO;
    web.scrollView.bounces = NO;
    return web;
}

static char kXhlWebconfigBottom;
static char kXhlWebconfigTop;
static char kXhlWebtoprightConfig;
static char kXhlWebRefreshHigh;
static char kXhlWebConfigShare;
static char kXhlWebLoadFinishd;
static char kXhlWebLoadStart;
static char kXhlWebGoToBackVcBlock;



@implementation WKWebView (HLWCategory)



+ (void)clearWKCache{
    if (@available(iOS 11.0, *)) {
        NSSet *websiteDataTypes = [NSSet setWithObjects:WKWebsiteDataTypeMemoryCache,WKWebsiteDataTypeDiskCache, nil];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        }];
    }

}


/**
 webView返回刷新
 */
- (void)xhl_webBackRefresh:(NSDictionary *)dic {
    if (![dic isKindOfClass:[NSDictionary class]]) {return;}
    
    NSString *callBackFun = [NSString stringWithFormat:@"%@",[dic valueForKey:@"callBackFun"]];
    NSString *par = [NSString stringWithFormat:@"%@",[dic valueForKey:@"par"]];
    NSString *type = [NSString stringWithFormat:@"%@",[dic valueForKey:@"type"]];
    if ([type isEqualToString:@"0"]) {
        //刷新指定方法
        if (callBackFun.length<1) {
            return;
        }
        NSString *refreshMethodName = [NSString stringWithFormat:@"%@('%@')",callBackFun,par];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self evaluateJavaScript:refreshMethodName completionHandler:nil];
        });
    }else if ([type isEqualToString:@"1"]){
        //刷新整个webView
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf reload];
        });
    }
}


- (void)xhl_goBack{
    //判断appReturn方法是否存在
    __weak __typeof__(self) weakSelf = self;
    [self xhl_evaluateJS:@"typeof appReturn =='function'" completionHandler:^(id result, NSError *error) {
        NSString  *dataStr = [NSString stringWithFormat:@"%@",result];
        BOOL appReturn = dataStr.boolValue;
        
        //关闭键盘
        if(!self.isFirstResponder){
            [self resignFirstResponder];
        }

        if (appReturn) {
            //需要加载完成
            [weakSelf xhl_evaluateJS:@"appReturn()"];
            return;
        }else{
            if ([weakSelf canGoBack]) {
                [weakSelf goBack];
            }else {
                [weakSelf.web_firstAvailableUIViewController.navigationController popViewControllerAnimated:true];
            }
        }
        if (self.goToBackVcBlock) {
            self.goToBackVcBlock();
        }
    }];
}

//TODO 应该由 baseObjce 提供的方法
- (UIViewController *)web_firstAvailableUIViewController {
    return (UIViewController *)[self gettopviss:self];
}

- (UIViewController *)gettopviss:(UIView *)shshs{
    return (UIViewController *)[self traverseResponderChainForUIViewController:shshs];
}

- (id )traverseResponderChainForUIViewController:(UIView *)bounss{
    id nextResponder =  [bounss nextResponder ];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [self traverseResponderChainForUIViewController:nextResponder];
    } else {
        return nil;
    }
}

//js执行方法
- (void)xhl_evaluateJS:(NSString *)script{
    [self xhl_evaluateJS:script completionHandler:^(id  _Nonnull result, NSError * _Nonnull error) {}];
}
- (void)xhl_evaluateJS:(NSString *)script
     completionHandler:(void (^)(id result,
                                 NSError * error))completionHandler
{
    if ([NSThread currentThread].isMainThread) {
        [self evaluateJavaScript:script
               completionHandler:^(id _Nullable result,
                                   NSError * _Nullable error) {
                   if ([result isKindOfClass:[NSNull class]]||!result) {
                       result = @"";
                   }
                   if (completionHandler) {
                       completionHandler(result, error);
                   }
               } ];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self evaluateJavaScript:script
                   completionHandler:^(id _Nullable result,
                                       NSError * _Nullable error) {
                       if ([result isKindOfClass:[NSNull class]]) {
                           result = @"";
                       }
                       if (completionHandler) {
                           completionHandler(result, error);
                       }
                   } ];
        });
    }
}


#pragma mark - runtim set get
- (void)setIsOneWebloadFinish:(BOOL)isOneWebloadFinish{
    objc_setAssociatedObject(self, @selector(isOneWebloadFinish), @(isOneWebloadFinish), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(BOOL)isOneWebloadFinish{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setConfigTop:(void (^)(NSDictionary * _Nonnull))configTop{
    objc_setAssociatedObject(self, &kXhlWebconfigTop, configTop, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSDictionary * _Nonnull))configTop{
    return  objc_getAssociatedObject(self,  &kXhlWebconfigTop);
}

- (void)setToprightConfig:(void (^)(NSDictionary * _Nonnull))toprightConfig{
    objc_setAssociatedObject(self, &kXhlWebtoprightConfig, toprightConfig, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSDictionary * _Nonnull))toprightConfig{
    return objc_getAssociatedObject(self, &kXhlWebtoprightConfig);
}

- (void)setConfigBottom:(void (^)(NSDictionary * _Nonnull))configBottom{
    objc_setAssociatedObject(self, &kXhlWebconfigBottom, configBottom, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSDictionary * _Nonnull))configBottom{
    return  objc_getAssociatedObject(self, &kXhlWebconfigBottom);
}

- (void)setRefreshWebviewHeight:(void (^)(CGFloat))refreshWebviewHeight{
    objc_setAssociatedObject(self, &kXhlWebRefreshHigh, refreshWebviewHeight, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(CGFloat))refreshWebviewHeight{
    return  objc_getAssociatedObject(self, &kXhlWebRefreshHigh);
}
- (void)setConfigShare:(void (^)(NSDictionary * _Nonnull))configShare{
    objc_setAssociatedObject(self, &kXhlWebConfigShare, configShare, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(NSDictionary * _Nonnull))configShare{
    return  objc_getAssociatedObject(self, &kXhlWebConfigShare);
}

- (void)setCallBack:(void (^)(NSDictionary * _Nonnull))CallBack{
    objc_setAssociatedObject(self, @selector(CallBack), CallBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(NSDictionary * _Nonnull))CallBack{
    return  objc_getAssociatedObject(self, _cmd);
}

- (void)setWebloadFinish:(void (^)(WKWebView *webView))webloadFinish{
    objc_setAssociatedObject(self, &kXhlWebLoadFinishd, webloadFinish, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(WKWebView *webView))webloadFinish{
    return  objc_getAssociatedObject(self, &kXhlWebLoadFinishd);
}

- (void)setWebloadStart:(void (^)(WKWebView * _Nonnull))webloadStart{
    objc_setAssociatedObject(self, &kXhlWebLoadStart, webloadStart, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(WKWebView * _Nonnull))webloadStart{
    return  objc_getAssociatedObject(self, &kXhlWebLoadStart);
}

- (void)setXhl_customImplementationJS:(BOOL (^)(NSString * _Nonnull, NSDictionary * _Nonnull, id _Nonnull))xhl_customImplementationJS{
    objc_setAssociatedObject(self, @selector(xhl_customImplementationJS), xhl_customImplementationJS, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL (^)(NSString * _Nonnull, NSDictionary * _Nonnull, id _Nonnull))xhl_customImplementationJS{
    return  objc_getAssociatedObject(self, @selector(xhl_customImplementationJS));
}

- (void (^)(void))goToBackVcBlock{
    return  objc_getAssociatedObject(self, &kXhlWebGoToBackVcBlock);
}
- (void)setGoToBackVcBlock:(void (^)(void))goToBackVcBlock{
    objc_setAssociatedObject(self, &kXhlWebGoToBackVcBlock, goToBackVcBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
