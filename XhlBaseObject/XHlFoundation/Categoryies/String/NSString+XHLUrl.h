//
//  NSString+XHLUrl.h
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2024/9/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQXhlWdc : NSObject

//由后至前分别为: //可以理解为每-位都是-个boolean变量。0为false 1为true
///是否展示头部
@property (nonatomic,assign) BOOL isShowTop;
///是否展示底部
@property (nonatomic,assign) BOOL isShowBottom;
///是否展示顶部返回键
@property (nonatomic,assign) BOOL isShowBackBtn;
///是否展示顶部标题
@property (nonatomic,assign) BOOL isShowTitleLael;
///是否展示右上角分享按钮
@property (nonatomic,assign) BOOL isShowMoreBtn;
///右上角分享按钮是否为单排(如果为1则只展示一排分享按钮, 没有无图反馈之类的按钮，0则按照原有逻辑展示)单排的样式参照底部分享样式
@property (nonatomic,assign) BOOL shareType;
///是否展示状态栏 （1为展示）
@property (nonatomic,assign) BOOL isShowStatusBar;
///头部状态栏文字颜色（1为黑色)
@property (nonatomic,assign) BOOL stausBarLightMode;

@end


@interface NSString (XHLUrl)

/// 解析url中XhlWd参数
- (CQXhlWdc *)analysisURLCQXhlWdc;



- (NSString *)xhl_urlEncode;


//将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)htmlEntityDecode:(NSString *)string;

//正则去除网络标签
+(NSString *)gkh_getZZwithHtmlString:(NSString *)string;

/**
 
 获取url中的参数并返回
 @return NSDictionary: 参数字典 url
 */
- (NSDictionary *)xhl_getUrlParamsComponents;
- (NSDictionary *)xhl_getUrlParams;


//华龙芯json请求
- (NSDictionary *)xhl_jsonUrlToObejct;
- (void)xhl_getJsonUrlObjctBlock:(void(^)(NSDictionary *dataDict))dataBlock;
//获取时间戳地址
- (NSString *)xhl_getTimeSuffes;

//取出jsonUrl 种的字典
- (NSDictionary *)xhl_linkUrlJsonBySep:(NSString *)sep;


//获取拼接后的阿里OSSsuffix链接
- (NSString *)xhl_getAliOSSSuffix:(NSString *)suffix;


/// 根据图片的地址 获取图片的宽高比,如果解析出来没得  则返回  16/9  1.77778
+ (CGFloat)xhl_fetchScaleWithImageUrl:(NSString *)url;
/// 根据图片的地址 获取图片的宽高比,如果解析出来没得  则返回scale
+ (CGFloat)xhl_fetchScaleWithImageUrl:(NSString *)url scale:(CGFloat)scale;


@end

NS_ASSUME_NONNULL_END
