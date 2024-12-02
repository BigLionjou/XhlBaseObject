//
//  NSString+XhlString.h
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/3/18.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+XHLFontHeight.h"
#import "NSString+XHLUrl.h"


// 判断字符串是否为 NSNull nil @""
#define Xhl_StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 1 ? YES : NO )
// 防止String返回值为空为导致Crash
#define Xhl_string(str) (Xhl_StringIsEmpty(str) ? @"" : str)

// 判断字符串是否为无效字符串 NSNull nil @"" @"0"
#define Xhl_InvalidStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 || [str isEqualToString:@"0"] || [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] < 1 ? YES : NO )
//  防止String返回值为无效字符串 返回default
#define Xhl_InvalidStringDefault(str,default) (Xhl_InvalidStringIsEmpty(str) ? default : str)

NS_ASSUME_NONNULL_BEGIN


@interface NSString (XHLCategory)



#pragma mark - 判断合法性

/**
 *  判断邮箱
 *
 *  @return 是否合法
 */
- (BOOL)xhl_validateEmail;


/// 判断是否含有中文 yes 有
- (BOOL)xhl_includeChinese;

/**
 判断是否是万
 */
- (BOOL)xhl_isW;
/**
  判断字符串是否为全数字（eg:检查浏览量是否能加1，包含“万” “万+”之类的）
*/
-(BOOL)xhl_isNum;
/**
 *  验证身份证号码是否正确的方法
 *
 *  @return 返回YES或NO表示该身份证号码是否符合国家标准
 */
- (BOOL)xhl_validateCardNO;

/// 双方转换为大写比较  默认去掉空格 不需要去掉空格调用下面的方法
- (BOOL)xhl_upperCaseIsEqualToString:(NSString *)string;
/// 上面方法是否去掉空格
- (BOOL)xhl_upperCaseIsEqualToString:(NSString *)string removeWhite:(BOOL)remove;

#pragma mark - 字符串空格回车判断
/**
 * @brief 判断字符串是否只包含空格或换行符
 *
 * @return BOOL 注意:若字符串为空也会返回 True
 */
- (BOOL)xhl_isWhitespaceAndNewlines;


//获取最后一个字符
- (NSString *)last;



#pragma mark - 加密
/**
 *  md5加密
 *
 *  @return 加密后的string
 */
- (NSString *)xhl_md5;

/**
 *  sha1加密
 *
 *  @return 加密后的string
 */
- (NSString *)xhl_sha1;

#pragma mark - 编码
/**
 *  将文本转换为base64编码
 *
 *  @return base64格式的NSString
 */
- (NSString *)xhl_base64EncodedString;

/**
 *  将Base64编码还原
 *
 *  @return 文本NSString
 */
- (NSString *)xhl_base64DecodedString;
//判断string是否为base64加密
- (BOOL)xhl_isBase64Encoded;

/**
 utf8编码，已经编码过的不在编码
 
 @return utf8编码的字符串
 */
- (NSString *)xhl_stringToUTF8StringEncoding;


#pragma mark - json转换
/**
 json字符串转换成OC的数据结构
 
 @return OC的数据结构(包括NSDictionary、NSArray)
 */
- (id)xhl_jsonToObejct;


/**
 json字符串转字典
 
 @return 字典
 */
- (NSDictionary *)xhl_jsonToDictionary;

/**
 json字符串转数组
 
 @return 数组
 */
- (NSArray *)xhl_jsonToArray;

#pragma mark - 转换
/**
 *  汉字转拼音
 *
 *  @return 拼音
 */
- (NSString *)xhl_getPinyin;

/**
 *  获取字符串首字母，如果首字母非字母，则返回"~"
 *
 *  @return 首字母
 */
- (NSString *)xhl_getFirstLetter;

#pragma mark - 截取字段
/**
 截取2者之间的字符串
 
 @param startStr 开始字段
 @param endStr 结束字段
 @return 返回中间字段
 */
- (NSString *)xhl_getStrBetweenStartStr:(NSString *)startStr andEndStr:(NSString *)endStr;

/**
 截取某个字段之前的数据
 
 @param str 需要截取字段的分解符
 @return 返回截取字段
 */
- (NSString *)xhl_getBeforoStrByStr:(NSString *)str;

/**
 截取某个字段之前的数据
 
 @param str 需要截取字段的分解符
 @return 返回截取字段
 */
- (NSString *)xhl_getAfterStrByStr:(NSString *)str;




/**
 身份证加隐藏
 
 @return 身份证加码
 */
-(NSString *)xhl_idCardString;

/**
 手机号加隐藏
 
 @return 手机号加码
 */
-(NSString *)xhl_phoneString;




#pragma mark - 行间距，首航缩紧 前后空格、回车换行符
/**
 * @brief  去掉字符串前后空格、回车换行符
 *
 * @return NSString 注意：空串返回自身
 */
- (NSString *)xhl_trimmingWhiteSpaceAndNewLine;

//行间距
- (NSMutableAttributedString *)xhl_attributedStringLineSpacing:(CGFloat)lineSpacing;
//行间距，首航缩紧
- (NSMutableAttributedString *)xhl_attributedStringLineSpacing:(CGFloat)lineSpacing firstLineHeadIndent:(CGFloat)firstLineHeadIndent;





#pragma mark - 把字符串按宽度自动切割
/**
 
  把字符串按宽度自动切割
  @param labelFont 字体
  @param labelWidth 宽度
  @return NSArray: 参数数组
 */
- (NSArray *)xhl_getLinesArrayOfStringInfont:(UIFont *)labelFont
                                        width:(CGFloat)labelWidth;






#pragma mark - 正则匹配表达式 000x000
//取出000x000
- (NSString *)xhl_findHyperLinkWithString000x000;
//取出 正则匹配表达式  contain 包含第一个字符和最后一个字符
- (NSString *)xhl_findHyperLinkWithegExpStr:(NSString *)regExpStr contain:(BOOL)contain;



#pragma mark - 格式化 万

// 格式化 万+
- (NSString *)variableWan;
/**
1 文字转数字 其中含有非数字不处理返回原有数字
2 9999 + 1  处理返回 1.00 万+
@param unit 单位 万、万+、 w+ 或者你想填的
 @return NSString: 成型字符串
*/
- (NSString *)variableWan:(NSString *)unit;


//变量加1 单位万
- (NSString *)variablePlus1;
/**
 
 变量加1
 处理逻辑
 1 文字转数字 其中含有非数字不处理返回原有数字
 2 9999 + 1  处理返回 1.00 万+
 @param unit 单位 万、万+、 w+ 或者你想填的
  @return NSString: 成型字符串
 */
- (NSString *)variablePlus1:(NSString *)unit;


- (NSString *)variable:(NSString *)unit plusNumber:(CGFloat )plusNumber;











@end

NS_ASSUME_NONNULL_END
