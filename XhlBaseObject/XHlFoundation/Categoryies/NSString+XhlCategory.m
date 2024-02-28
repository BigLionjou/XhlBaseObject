//
//  NSString+XhlString.m
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/3/18.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "NSString+XhlCategory.h"
#import <CommonCrypto/CommonDigest.h>
#import <CoreText/CoreText.h>
#import "NSDictionary+XhlCategory.h"

@implementation CQXhlWdc

@end

@implementation NSString (XHLCategory)


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
#pragma mark - 加密
- (NSString *)xhl_md5 {
    
    if (self == nil || self.length == 0) {
        return @"";
    }
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr,(CC_LONG)strlen(cStr),result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
- (NSString *)xhl_sha1 {
    
    const char *cstr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    CC_SHA256(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

#pragma mark - 编码
//编码base64
- (NSString *)xhl_base64EncodedString {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

//解码base64
- (NSString *)xhl_base64DecodedString {
    if ([self xhl_isBase64Encoded]) {
        NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] ?: self;
    }
    return self;
}
//判断string是否为base64加密
- (BOOL)xhl_isBase64Encoded{
    NSString *base64Pattern = @"^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$";
    NSPredicate *base64Test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", base64Pattern];
    return [base64Test evaluateWithObject:self];
}


- (NSString *)xhl_stringToUTF8StringEncoding{
    if (self.xhl_includeChinese) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return (NSString *)
        CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  (CFStringRef)self,
                                                                  (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                  NULL,
                                                                  kCFStringEncodingUTF8));
#pragma clang diagnostic pop
    }
    return self;
}

- (BOOL)xhl_includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

#pragma mark - json转换
// json字符串转换成OC的数据结构
- (id)xhl_jsonToObejct {
    if (!self) {return nil;}
    NSError *error = nil;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    }
    //解析错误
    return nil;
}

//json字符串转字典
- (NSDictionary *)xhl_jsonToDictionary {
    
    if (self == nil) {return nil;}
    NSError *err;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {return nil;}
    return dic;
}


//json字符串转数组
- (NSArray *)xhl_jsonToArray {
    if (self == nil) {return nil;}
    NSError *err;
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:jsonData
                                                   options:NSJSONReadingMutableContainers
                                                     error:&err];
    if(err) {return nil;}
    return arr;
}

#pragma mark - 转换
// 汉字转拼音
- (NSString *)xhl_getPinyin {
    
    NSString *pinyin;
    if ([self length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:self];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            
        }
        pinyin = ms;
    }
    return pinyin;
}

// 获取字符串首字母，如果首字母非字母，则返回"~"
- (NSString *)xhl_getFirstLetter {
    
    if (self.length) {
        NSString *regex = @"^[a-zA-Z]*$";
        NSString *firstLetter = [self substringToIndex:1];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        
        if ([predicate evaluateWithObject:firstLetter]) {
            return [firstLetter uppercaseString];
        }
        return @"~";
    }
    return @"~";
}

// 截取2者之间的字符串
- (NSString *)xhl_getStrBetweenStartStr:(NSString *)startStr andEndStr:(NSString *)endStr{
    NSRange startRange = [self rangeOfString:startStr];
    NSRange endRange = [self rangeOfString:endStr];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    NSString *result = [self substringWithRange:range];
    return result;
}

/**
 截取某个字段之前的数据
 
 @param str 需要截取字段的分解符
 @return 返回截取字段
 */
- (NSString *)xhl_getBeforoStrByStr:(NSString *)str{
    NSRange rang = [self rangeOfString:str];//匹配得到的下标
    NSString *result  = [self substringToIndex:rang.location];//截取字符串获取url
    return result;
}

/**
 截取某个字段之前的数据
 
 @param str 需要截取字段的分解符
 @return 返回截取字段
 */
- (NSString *)xhl_getAfterStrByStr:(NSString *)str{
    NSRange rang = [self rangeOfString:str];//匹配得到的下标
    NSString *result  = [self substringFromIndex:rang.location+rang.length];//截取字符串获取url
    return result;
}

#pragma mark - 判断合

//判断邮箱
- (BOOL)xhl_validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 判断是否是万
 */
- (BOOL)xhl_isW{
    if ([self containsString:@"w"]||
        [self containsString:@"W"]||
        [self containsString:@"万"]) {
        return YES;
    }
    return NO;
}

//验证身份证号码是否正确的方法
- (BOOL)xhl_validateCardNO {
    
    if (self.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:self]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - 计算字符串宽度、高度
//计算文字占用高度（行间距）
- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font
                      LineSpacing:(CGFloat)LineSpacing{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = LineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:dic context:nil].size;
    return size.height;
}

//计算内容高度
- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font{
    return [self xhl_getHeightWithWidth:width font:font lines:0];
}

- (CGFloat)xhl_getHeightWithWidth:(CGFloat)width
                             font:(UIFont *)font
                            lines:(NSInteger)lines{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    label.numberOfLines = lines;
    label.font = font;
    label.text = self;
    [label sizeToFit];
    return CGRectGetHeight(label.frame);
}

- (CGFloat)xhl_getWidthWithHFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.numberOfLines = 1;
    label.font = font;
    label.text = self;
    [label sizeToFit];
    return CGRectGetWidth(label.frame);
}

-(NSString *)xhl_idCardString{
    NSString *tel = [self stringByReplacingCharactersInRange:NSMakeRange(3, 13) withString:@"*************"];
    return tel;
}

-(NSString *)xhl_phoneString{
    NSString *tel = [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return tel;
}



#pragma mark - 字符串空格回车判断
- (BOOL)xhl_isWhitespaceAndNewlines {
    if (0 == self.length) return YES;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

- (NSString *)xhl_trimmingWhiteSpaceAndNewLine {
    if (0 == self.length) return self;
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:whitespace];
}

//行间距
- (NSMutableAttributedString *)xhl_attributedStringLineSpacing:(CGFloat)lineSpacing{
    return [self xhl_attributedStringLineSpacing:lineSpacing firstLineHeadIndent:0];
}
//行间距，首航缩紧
- (NSMutableAttributedString *)xhl_attributedStringLineSpacing:(CGFloat)lineSpacing firstLineHeadIndent:(CGFloat)firstLineHeadIndent{
    
    NSMutableAttributedString *mutStr = [[NSMutableAttributedString alloc]initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = firstLineHeadIndent;//行首缩进2个字体
    [paragraphStyle setLineSpacing:lineSpacing];
    [mutStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return mutStr;
}
//计算富文本的高度
- (CGFloat)xhl_calculateHeightWithAttributedString:(NSMutableAttributedString *)attributedString
                                             Width:(CGFloat)width
                                              font:(UIFont *)font{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 0)];
    label.numberOfLines = 0;
    label.font = font;
    label.attributedText = attributedString;
    [label sizeToFit];
    return label.frame.size.height;
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

-(BOOL)xhl_isNum{
    if(self.length == 0) {
        return NO;
    }
   NSString *str = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(str.length > 0) {
        return NO;
    }
    return YES;
}


- (NSArray *)xhl_getLinesArrayOfStringInfont:(UIFont *)labelFont
                                       width:(CGFloat)labelWidth{
    
    NSString *text = self;
    UIFont *font = labelFont;
    CGFloat rectWidth = labelWidth-1; //最大宽度往后减1 让计算出的每行字符串不是溢出的
    
    CTFontRef myFont = CTFontCreateWithName(( CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge  id)myFont range:NSMakeRange(0, attStr.length)];
    CFRelease(myFont);
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(( CFAttributedStringRef)attStr);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rectWidth,100000));
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    NSArray *lines = ( NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    for (id line in lines) {
        CTLineRef lineRef = (__bridge  CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithFloat:0.0]));
        CFAttributedStringSetAttribute((CFMutableAttributedStringRef)attStr, lineRange, kCTKernAttributeName, (CFTypeRef)([NSNumber numberWithInt:0.0]));
        //NSLog(@"''''''''''''''''''%@",lineString);
        [linesArray addObject:lineString];
    }
    
    CGPathRelease(path);
    CFRelease( frame );
    CFRelease(frameSetter);
    return (NSArray *)linesArray;
}

- (NSString *)variableWan{
    return [self variable:@"万+" plusNumber:0];
}
- (NSString *)variableWan:(NSString *)unit{
    
    return [self variable:unit plusNumber:0];
    
}
//变量加1 单位万
- (NSString *)variablePlus1{
    
    return [self variable:@"万+" plusNumber:1];
}

- (NSString *)variablePlus1:(NSString *)unit{
    
    return [self variable:unit plusNumber:1];
    
}

- (NSString *)variable:(NSString *)unit plusNumber:(CGFloat )plusNumber{
    
    
    NSString *tempstr = self;
    if([tempstr hasPrefix:@"+"] || [tempstr hasPrefix:@"-"]){
        //除去 — + 值
        tempstr = [tempstr substringFromIndex:1];
    }
    if([tempstr xhl_isNum])
    {
        //取用 原数字
        CGFloat tempnumber = [self floatValue];
        tempnumber = tempnumber + plusNumber;
        if(tempnumber > 9999){
            
            CGFloat a = tempnumber / 10000;
            NSString *tempnumberstr = [NSString stringWithFormat:@"%.1lf%@",a,unit];
            //去掉.0
            tempnumberstr = [tempnumberstr stringByReplacingOccurrencesOfString:@".0" withString:@""];
            
            return tempnumberstr;
            
        }
    
        return [NSString stringWithFormat:@"%@",@(tempnumber)];
    }

    return self;
    
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

- (NSString *)xhl_findHyperLinkWithString000x000{
    return [self xhl_findHyperLinkWithegExpStr:@"_\\d*x\\d*\\." contain:NO];
}
- (NSString *)xhl_findHyperLinkWithegExpStr:(NSString *)regExpStr contain:(BOOL)contain{
    NSString *rawString = self;
    if (rawString.length <= 0) {
        return @"";
    }
    NSError *error;
    NSRegularExpression *orderNumRegExp;
    
    NSString *orderNumRegExpStr = regExpStr; //正则匹配表达式
    if (orderNumRegExpStr.length <= 0) {
        return @"";
    }
    orderNumRegExp = [NSRegularExpression regularExpressionWithPattern:orderNumRegExpStr options:0 error:&error];
    if (!error) {
        
        NSTextCheckingResult *matchResult = [orderNumRegExp firstMatchInString:rawString options:0 range:NSMakeRange(0, rawString.length)];
        
        if (matchResult) {
            if(contain){
                if(matchResult.range.length >= 3){
                    NSString* matchedString = [rawString substringWithRange:NSMakeRange(matchResult.range.location + 1,matchResult.range.length - 2)];
                    return matchedString;
                }else{
                    return @"";
                }
            }else{
                NSString* matchedString = [rawString substringWithRange:matchResult.range];
                return matchedString;
            }
        }
    }
    return @"";
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
        //出去格式000x000
        picStr = [picStr stringByReplacingOccurrencesOfString:tempStr withString:@"."];
        if(!oss){
            //不是阿里云地址
            picStr = [picStr stringByAppendingString:suffix];
        }else{
            //已是阿里云地址
        }
    }
    return picStr;
    
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

@end
