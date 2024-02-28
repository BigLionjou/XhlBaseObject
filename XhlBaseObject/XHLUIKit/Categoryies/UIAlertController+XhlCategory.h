//
//  UIAlertController+XhlAlert.h
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/3/18.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XhlActionHandler)(UIAlertAction *action);
typedef void(^XhlActionSheetHandler)(UIAlertAction *action,NSInteger selectIndex);

/**
 alert 信息
 
 @param title 标题
 @param message 信息
 @param clikeSure 确认按钮
 */
extern void xhl_showAlert(NSString *title,NSString *message,void (^clikeSure)(void));

/**
 ActionSheet
 
 @param title 标题
 @param messages 按钮数组
 @param clikeSure 点击事件
 */
extern void xhl_showActionSheet(NSString *title,NSArray <NSString *>*messages,void (^clikeSure)(NSInteger index));

@interface UIAlertController (XHLCategory)

+ (void)xhl_alertWithTitle:(NSString *)title
               message:(NSString *)message
            completion:(void (^)(void))completion;

/**
 UIAlertControllerStyleAlert
 
 @param title 标题
 @param msg 详情
 @param sure 确定标题
 @param cancel 取消标题
 @param sureHandler 确定回调
 @param cacelHandler 取消回调
 @return UIAlertController(类型为UIAlertControllerStyleAlert)
 */
+ (UIAlertController *)xhl_alertWithTitle:(NSString *)title
                              message:(NSString *)msg
                            sureTitle:(NSString *)sure
                          cancelTitle:(NSString *)cancel
                          sureHandler:(__nullable XhlActionHandler)sureHandler
                        cancelHandler:(__nullable XhlActionHandler)cacelHandler;

/**
 UIAlertControllerStyleAlert
 
 @param title 标题
 @param msg 详情
 @param sure 确定标题
 @param sureHandler 确定回调
 @return UIAlertController(类型为UIAlertControllerStyleAlert)
 */
+ (UIAlertController *)xhl_alertWithTitle:(NSString *)title
                              message:(NSString *)msg
                            sureTitle:(NSString *)sure
                          sureHandler:(__nullable XhlActionHandler)sureHandler;


/**
 UIAlertControllerStyleActionSheet
 
 @param title 标题
 @param msg 详情
 @param expandArray 选择按钮
 @param cancel 取消按钮
 @param defaultColorArray defaultColorArray
 @param cancleColor 取消按钮颜色
 @param actionHandler 返回点击ActionHandler
 @return UIAlertController
 */
+(UIAlertController *)xhl_alertActionSheetWithTitle:(NSString *)title
                                        message:(NSString *)msg
                                    expandArray:(NSArray <NSString *>*)expandArray
                                    cancelTitle:(NSString *)cancel
                         alertDefaultColorArray:(NSArray <UIColor *>*)defaultColorArray
                               alertCancleColor:(UIColor *)cancleColor
                                  actionHandler:(__nullable XhlActionHandler)actionHandler;
/**
 UIAlertControllerStyleActionSheet
 
 @param title 标题
 @param msg 详情
 @param expandArray 选择按钮
 @param cancel 取消按钮
 @param defaultColorArray defaultColorArray
 @param cancleColor 取消按钮颜色
 @param actionHandler 返回点击ActionHandler
 @return UIAlertController
 */
+(UIAlertController *)xhl_alertActionSheetIndexWithTitle:(NSString *)title
                                             message:(NSString *)msg
                                         expandArray:(NSArray <NSString *>*)expandArray
                                         cancelTitle:(NSString *)cancel
                              alertDefaultColorArray:(NSArray <UIColor *>*)defaultColorArray
                                    alertCancleColor:(UIColor *)cancleColor
                                       actionHandler:(__nullable XhlActionSheetHandler)actionHandler;


@end

NS_ASSUME_NONNULL_END
