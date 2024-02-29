//
//  XHLDatePicker.h
//  XHLPods
//
//  Created by macmini on 2017/12/30.
//  Copyright © 2017年 xhl. All rights reserved.
//

// 用法1:
//	[XHLDatePicker showDatePickerWithMode:@"date"
//								    value:@"2017-01-01"
//								 	start:@"2016-2-01"
//								   	  end:@"2018-6-5"
//								   fields:@"month"
//							   bindChange:^(NSString *value) {
//									NSLog(@"%@",value);
//							}
//                             bindCancel:nil
//							     disabled:NO];

// 用法2:
//	[XHLDatePicker showDatePickerWithMode:@"time"
//									value:@"10:00"
//									start:@"8:10"
//									  end:@"23:33"
//								   fields:nil
//							   bindChange:^(NSString *value) {
//									NSLog(@"%@",value);
//								}
//                             bindCancel:nil
//								 disabled:NO];

#import <UIKit/UIKit.h>
/// 时间和日期选择器
@interface XHLDatePicker : UIView

+ (void)showDatePickerWithMode:(NSString *)mode
						 value:(NSString *)value
						 start:(NSString *)start
						   end:(NSString *)end
						fields:(NSString *)fields
					bindChange:(void (^)(NSString *value))eventHandle
                    bindCancel:(void (^)(void))cancelBlock
					  disabled:(BOOL)disabled;

+ (void)showDatePickerWithMode:(NSString *)mode
                         value:(NSString *)value
                         start:(NSString *)start
                           end:(NSString *)end
                        fields:(NSString *)fields
                    bindChange:(void (^)(NSString *value))eventHandle
                    bindCancel:(void (^)(void))cancelBlock
                      disabled:(BOOL)disabled
                      onWindow:(UIWindow *)window;


/**
 选择时间,年月日时分
 
 @param value 选中值
 @param eventHandle 选中
 @param cancelBlock 取消
 */
+ (void)showDatePickerWithvalue:(NSDate *)value
                     bindChange:(void (^)(NSDate *value))eventHandle
                     bindCancel:(void (^)(void))cancelBlock;

/**
 选择时间,年月日时分
 
 @param value 选中值
 @param eventHandle 选中
 @param cancelBlock 取消
 */
+ (void)showDatePickerWithvalue:(NSDate *)value
                          start:(NSDate *)start
                            end:(NSDate *)end
                     bindChange:(void (^)(NSDate *value))eventHandle
                     bindCancel:(void (^)(void))cancelBlock;

@end
