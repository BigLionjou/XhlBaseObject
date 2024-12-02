//
//  NSURL+XHLCategory.m
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2022/5/24.
//

#import "NSURL+XHLCategory.h"
#import <objc/runtime.h>
@implementation NSURL (XHLCategory)

+ (void)load {
   // 获取URLWithString:方法的地址
   Method URLWithStringMethod = class_getClassMethod(self, @selector(URLWithString:));
   // 获取BMW_URLWithString:方法的地址
   Method BMW_URLWithStringMethod = class_getClassMethod(self, @selector(BMW_URLWithString:));
   // 交换方法地址
   method_exchangeImplementations(URLWithStringMethod, BMW_URLWithStringMethod);
   
}
+ (NSURL *)BMW_URLWithString:(NSString *)URLString {
   NSString *newURLString = [self isChinese:URLString];
   return [NSURL BMW_URLWithString:newURLString];
}
//处理特殊字符
+ (NSString *)isChinese:(NSString *)str {
   NSString *newString = str;
   //遍历字符串中的字符
   for(int i=0; i< [str length];i++){
       int a = [str characterAtIndex:i];
       //汉字的处理
       if( a > 0x4e00 && a < 0x9fff)
       {
           NSString *oldString = [str substringWithRange:NSMakeRange(i, 1)];
           NSString *string = [oldString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
           newString = [newString stringByReplacingOccurrencesOfString:oldString withString:string];
       }
     //如果需要处理其它特殊字符,在这里继续判断处理即可.
   }
    //空格处理
    if ([newString containsString:@" "]) {
        newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    }
   return newString;
}

@end
