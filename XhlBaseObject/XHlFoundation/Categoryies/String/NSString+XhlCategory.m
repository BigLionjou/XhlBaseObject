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



- (BOOL)xhl_upperCaseIsEqualToString:(NSString *)string {
    return [self xhl_upperCaseIsEqualToString:string removeWhite:YES];
}

- (BOOL)xhl_upperCaseIsEqualToString:(NSString *)string removeWhite:(BOOL)remove {
    if (Xhl_StringIsEmpty(string)) {
        return false;
    }
    if (remove) {
        return [[[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString] isEqualToString:[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString]];
    } else {
        return [[self uppercaseString] isEqualToString:[string uppercaseString]];
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


//获取最后一个字符
- (NSString *)last{
    
    if(self.length>0){
        return [self substringFromIndex:self.length - 1];
    }else{
        return @"";
    }
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










@end

