//
//  NSString+XHLUrl.m
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2024/9/9.
//

#import "NSString+XHLUrl.h"
#include "NSString+XhlCategory.h"
#import "NSDictionary+XhlCategory.h"


@implementation NSString (XHLUrl)

/// 解析url中XhlWd参数
- (CQXhlWdc *)analysisURLCQXhlWdc{

    NSDictionary *dic = [self xhl_getUrlParams];
    NSString *valueString = [dic xhl_dicStringForKey:@"cqxhlwdc"];
    if(Xhl_StringIsEmpty(valueString)){
        return nil;
    }
    NSString *p1 = valueString;
    const char *p = [p1 cStringUsingEncoding:NSASCIIStringEncoding];
    char *str;
    long cqxhlwdc = strtol(p, &str, 16);
    CQXhlWdc *wdc = [[CQXhlWdc alloc]init];
    //由后至前分别为: //可以理解为每-位都是-个boolean变量。0为false 1为true
    //是否展示头部
    wdc.isShowTop = cqxhlwdc&1;
    //是否展示底部
    wdc.isShowBottom = cqxhlwdc&1<<1;
    //是否展示顶部返回键
    wdc.isShowBackBtn = cqxhlwdc&1<<2;
    //是否展示顶部标题
    wdc.isShowTitleLael = cqxhlwdc&1<<3;
    //是否展示右上角分享按钮
    wdc.isShowMoreBtn = cqxhlwdc&1<<4;
    //右上角分享按钮是否为单排(如果为1则只展示一排分享按钮, 没有无图反馈之类的按钮，0则按照原有逻辑展示)单排的样式参照底部分享样式
    wdc.shareType = cqxhlwdc&1<<5;
    //是否展示状态栏
    wdc.isShowStatusBar = cqxhlwdc&1<<6;
    //头部状态栏文字颜色
    wdc.stausBarLightMode = cqxhlwdc&1<<7;

    return wdc;
}


- (NSString *)xhl_urlEncode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

//正则去除网络标签
+(NSString *)gkh_getZZwithHtmlString:(NSString *)string{
    NSRegularExpression *regularExpretion=[NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n|&nbsp"
                                                                                    options:0
                                                                                      error:nil];
    string=[regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    return string;
}

//将 &lt 等类似的字符转化为HTML中的“<”等
+ (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"

    return string;
}



/**
 
 获取url中的参数并返回
 @return NSDictionary: 参数字典 url
 */
- (NSDictionary *)xhl_getUrlParamsComponents{
    
    //在url中把 参数取出来
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:self];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
    [components.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSURLQueryItem *item = (NSURLQueryItem *)obj;
            NSString *paramsName = item.name;
            NSString *paramsValue = item.value;
            [tempDic setValue:paramsValue forKey:paramsName];
    }];
    
    return tempDic;
    
}


- (NSDictionary *)xhl_getUrlParams{
    NSString *urlString = self;
    if(urlString.length==0) {
        NSLog(@"链接为空！");
        return @{};
    }
    //先截取问号
    NSArray *allElements = [urlString componentsSeparatedByString:@"?"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];//待set的参数字典
    if(allElements.count==2) {
        //有参数或者?后面为空
        //        NSString *myUrlString = allElements[0];
        NSString *paramsString = allElements[1];
        //获取参数对
        NSArray *paramsArray = [paramsString componentsSeparatedByString:@"&"];
        if(paramsArray.count>=2) {
            for(NSInteger i =0; i < paramsArray.count; i++) {
                NSString *singleParamString = paramsArray[i];
                NSArray *singleParamSet = [singleParamString componentsSeparatedByString:@"="];
                if(singleParamSet.count==2) {
                    NSString*key = singleParamSet[0];
                    NSString*value = singleParamSet[1];
                    if(key.length>0|| value.length>0) {
                        [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
                    }
                }
            }
        }else if(paramsArray.count==1) {
            //无 &。url只有?后一个参数
            NSString *singleParamString = paramsArray[0];
            NSArray *singleParamSet = [singleParamString componentsSeparatedByString:@"="];
            if(singleParamSet.count==2) {
                NSString *key = singleParamSet[0];
                NSString *value = singleParamSet[1];
                if(key.length>0|| value.length>0) {
                    [params setObject:value.length>0?value:@""forKey:key.length>0?key:@""];
                }
            }else{
                //问号后面啥也没有 xxxx?  无需处理
            }
        }
        //整合url及参数
        return params;
    }else if(allElements.count>2) {
        NSLog(@"链接不合法！链接包含多个\"?\"");
        return @{};
    }else{
        NSLog(@"链接不包含参数！");
        return @{};
    }
}



- (NSDictionary *)xhl_jsonUrlToObejct{
    if ([self containsString:@".json"]) {
        NSError *error = nil;
        NSString *jsonUrl = self;
        if (![jsonUrl containsString:@"time"]) {
            jsonUrl = jsonUrl.xhl_getTimeSuffes;
        }
        NSURL *url = [NSURL URLWithString:jsonUrl];
        NSURLResponse* urlResponse;
        NSMutableURLRequest* urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:2];
        NSData* d = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
        
        BOOL isLossy = YES;
        NSString *str = [[NSString alloc] initWithData:d encoding: NSUTF8StringEncoding];
        return str.dellResponseData;
    }
    return @{};
}

- (void)xhl_getJsonUrlObjctBlock:(void(^)(NSDictionary *dataDict))dataBlock{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dict = self.xhl_jsonUrlToObejct;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dataBlock) {
                dataBlock(dict);
            }
        });
    });
}

//处理相应数据
- (NSDictionary *)dellResponseData{
    NSDictionary *dict = @{@"data":@""};
    NSString *result = self;
    if ([result containsString:@"%22"]) {
        result = [result stringByReplacingOccurrencesOfString:@"%22" withString:@"\\\""];
    }
    id jsonData = result.xhl_jsonToObejct;
    if (!jsonData) {
        if ([result containsString:@"\r"]) {
            result = [result stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        }
        if ([result containsString:@"\n"]) {
            result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
        if ([result containsString:@"\t"]) {
            result = [result stringByReplacingOccurrencesOfString:@"\t" withString:@""];
        }
        jsonData = result.xhl_jsonToObejct;
    }
   
    if ([jsonData isKindOfClass:[NSString class]]) {
        dict = @{@"data":jsonData};
    }else  if ([jsonData isKindOfClass:[NSArray class]]) {
        dict = @{@"data":jsonData};
    }else  if ([jsonData isKindOfClass:[NSDictionary class]]) {
        dict = jsonData;
    }else{
        dict = @{@"data":result};
    }
    return dict;
}



//获取时间戳地址
- (NSString *)xhl_getTimeSuffes{
    NSString *string = [NSString stringWithFormat:@"%@?time=%@",self,self.getTiemStr];
    if ([self containsString:@"?"]) {
        string = [NSString stringWithFormat:@"%@&time=%@",self,self.getTiemStr];
    }
    return string;
}

- (NSString *)getTiemStr{
     NSString *str = [NSUserDefaults.standardUserDefaults stringForKey:@"xhlkgetTiemStr"];
    if (!Xhl_StringIsEmpty(str)) {
        NSString *timeIntervalSince1970 = @(NSDate.date.timeIntervalSince1970).stringValue;
        //30s 后刷新缓存
        if (timeIntervalSince1970.floatValue-str.floatValue>30) {
            [NSUserDefaults.standardUserDefaults setObject:timeIntervalSince1970 forKey:@"xhlkgetTiemStr"];
        }
    }else{
        NSString *timeIntervalSince1970 = @(NSDate.date.timeIntervalSince1970).stringValue;
        [NSUserDefaults.standardUserDefaults setObject:timeIntervalSince1970 forKey:@"xhlkgetTiemStr"];
        str = timeIntervalSince1970;
    }
    return str;
}

- (NSDictionary *)xhl_linkUrlJsonBySep:(NSString *)sep{
    NSString *str = self;
    NSString *firstUrl = [str componentsSeparatedByString:@"?"].firstObject;
    firstUrl = [NSString stringWithFormat:@"%@?",firstUrl];
    str = [str stringByReplacingOccurrencesOfString:firstUrl withString:@""];
    NSMutableDictionary *dict = NSMutableDictionary.dictionary;
    for (NSString *temp in [str componentsSeparatedByString:sep]) {
        NSString *key = [temp componentsSeparatedByString:@"="].firstObject;
        NSString *tempKey = [NSString stringWithFormat:@"%@=",key];
        NSString *value = [temp stringByReplacingOccurrencesOfString:tempKey withString:@""];
        dict[key] = value;
    }
    return dict;
}


//获取拼接后的listSuffix链接
- (NSString *)xhl_getAliOSSSuffix:(NSString *)suffix{
    
    NSString *picStr = self;
    if(Xhl_StringIsEmpty(suffix)){
        return picStr;
    }
    //是否 有000x000 格式后缀
    NSString * tempStr = [picStr xhl_findHyperLinkWithString000x000];
    //已是阿里云地址
    BOOL oss = [picStr containsString:@"?x-oss-process"];
    //是否 ios 阿里云上传
    BOOL iosAiYunC = [picStr containsString:@"xhl_AiYunC"];
    
    
    //无后缀
    if(Xhl_StringIsEmpty(tempStr)){
        //
        if(!oss){
            //不是阿里云地址
            picStr = [picStr stringByAppendingString:suffix];
        }else{
            //已是阿里云地址
        }
    }else{
        
        
        if(iosAiYunC){
            //不用去除 格式000x000
            if(!oss){
                //不是阿里云地址
                picStr = [picStr stringByAppendingString:suffix];
            }else{
                //已是阿里云地址
            }
            
        }else{
            
            //出去格式000x000
            picStr = [picStr stringByReplacingOccurrencesOfString:tempStr withString:@"."];
            if(!oss){
                //不是阿里云地址
                picStr = [picStr stringByAppendingString:suffix];
            }else{
                //已是阿里云地址
            }
        }
        
    }
    return picStr;
    
}



/// 根据图片的地址 获取图片的宽高比,如果解析出来没得  则返回  16/9  1.77778
+ (CGFloat)xhl_fetchScaleWithImageUrl:(NSString *)url {
    return [self xhl_fetchScaleWithImageUrl:url scale:1.77778];
}
/// 根据图片的地址 获取图片的宽高比,如果解析出来没得  则返回scale
+ (CGFloat)xhl_fetchScaleWithImageUrl:(NSString *)url scale:(CGFloat)scale {
    if (Xhl_StringIsEmpty(url)) {
        return scale;
    }
    NSDictionary *dict = [url xhl_getUrlParams];
    if ([dict.allKeys containsObject:@"wh"]) { // 在参数中查找
        NSString *v = [dict xhl_dicStringForKey:@"wh"];
        NSArray *array = [v componentsSeparatedByString:@"x"];
        CGFloat w = [array.firstObject floatValue];
        CGFloat h = [array.lastObject floatValue];
        return w / h;
    } else { // 在连接上匹配
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"_wh(\\d+x\\d+)" options:0 error:&error];

        if (error == nil) {
            NSRange range = NSMakeRange(0, [url length]);
            NSTextCheckingResult *match = [regex firstMatchInString:url options:0 range:range];

            if (match) {
                NSRange parameterRange = [match rangeAtIndex:1];
                NSString *parameter = [url substringWithRange:parameterRange];
                NSArray *array = [parameter componentsSeparatedByString:@"x"];
                CGFloat w = [array.firstObject floatValue];
                CGFloat h = [array.lastObject floatValue];
                return w / h;
            } else {
                NSLog(@"未找到匹配的参数");
            }
        } else {
            NSLog(@"正则表达式错误: %@", [error localizedDescription]);
        }
    }
    
    return scale;
}



@end
