//
//  UIAlertController+XhlAlert.m
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/3/18.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UIAlertController+XhlCategory.h"
#import "NSString+XhlCategory.h"

/**
 alert 信息
 
 @param title 标题
 @param message 信息
 @param clikeSure 确认按钮
 */
extern void xhl_showAlert(NSString *title,NSString *message,void (^clikeSure)(void)){
    [UIAlertController xhl_alertWithTitle:title message:message completion:^{
        if (clikeSure) {
            clikeSure();
        }
    }];
}

/**
 ActionSheet
 
 @param title 标题
 @param messages 按钮数组
 @param clikeSure 点击事件
 */
extern void xhl_showActionSheet(NSString *title,NSArray <NSString *>*messages,void (^clikeSure)(NSInteger index)){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:title preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i<messages.count; i++) {
        NSString *msg = messages[i];
        [alert addAction:[UIAlertAction actionWithTitle:msg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (clikeSure) {
                clikeSure(i);
            }
        }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}
@implementation UIAlertController (XHLCategory)

+ (void)xhl_alertWithTitle:(NSString *)title
               message:(NSString *)message
            completion:(void (^)(void))completion
{
    UIAlertController*  showSecreetDefault = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ActionTrue = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nullable action) {
        completion ? completion() : NULL;
    }];
    
    [showSecreetDefault addAction:ActionTrue];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showSecreetDefault animated:YES completion:nil];
    });
}

+ (UIAlertController *)xhl_alertWithTitle:(NSString *)title
                              message:(NSString *)msg
                            sureTitle:(NSString *)sure
                          cancelTitle:(NSString *)cancel
                          sureHandler:(__nullable XhlActionHandler)sureHandler
                        cancelHandler:(__nullable XhlActionHandler)cacelHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if (!Xhl_StringIsEmpty(sure)) {
        UIAlertAction *s = [UIAlertAction actionWithTitle:sure
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      if (sureHandler) {
                                                          sureHandler(action);
                                                      }
                                                  }];
        [alert addAction:s];
    }
    
    if (!Xhl_StringIsEmpty(cancel)) {
        
        UIAlertAction *c = [UIAlertAction actionWithTitle:cancel
                                                    style:UIAlertActionStyleCancel
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      if (cacelHandler) {
                                                          cacelHandler(action);
                                                      }
                                                  }];
        
        [alert addAction:c];
    }
    
    return alert;
}

+ (UIAlertController *)xhl_alertWithTitle:(NSString *)title
                              message:(NSString *)msg
                            sureTitle:(NSString *)sure
                          sureHandler:(__nullable XhlActionHandler)sureHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    if (!Xhl_StringIsEmpty(sure)) {
        UIAlertAction *s = [UIAlertAction actionWithTitle:sure
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      if (sureHandler) {
                                                          sureHandler(action);
                                                      }
                                                  }];
        [alert addAction:s];
    }
    return alert;
}

+(UIAlertController *)xhl_alertActionSheetWithTitle:(NSString *)title
                                        message:(NSString *)msg
                                    expandArray:(NSArray <NSString *>*)expandArray
                                    cancelTitle:(NSString *)cancel
                         alertDefaultColorArray:(NSArray <UIColor *>*)defaultColorArray
                               alertCancleColor:(UIColor *)cancleColor
                                  actionHandler:(__nullable XhlActionHandler)actionHandler{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i<expandArray.count; i++) {
        UIAlertAction *b = [UIAlertAction actionWithTitle:expandArray[i]
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      if (actionHandler) {
                                                          actionHandler(action);
                                                      }
                                                  }];
        if (defaultColorArray.count == expandArray.count&&
            [defaultColorArray[i] isKindOfClass:[UIColor class]]) {
            [b setValue:defaultColorArray[i] forKey:@"_titleTextColor"];
        }
        [alertView addAction:b];
    }
    if (cancel) {
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:cancel
                                                         style:UIAlertActionStyleCancel
                                                       handler:nil];
        [cancle setValue:cancleColor forKey:@"_titleTextColor"];
        [alertView addAction:cancle];
    }
    return alertView;
}

+(UIAlertController *)xhl_alertActionSheetIndexWithTitle:(NSString *)title
                                             message:(NSString *)msg
                                         expandArray:(NSArray <NSString *>*)expandArray
                                         cancelTitle:(NSString *)cancel
                              alertDefaultColorArray:(NSArray <UIColor *>*)defaultColorArray
                                    alertCancleColor:(UIColor *)cancleColor
                                       actionHandler:(__nullable XhlActionSheetHandler)actionHandler{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i<expandArray.count; i++) {
        UIAlertAction *b = [UIAlertAction actionWithTitle:expandArray[i]
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
                                                      if (actionHandler) {
                                                          actionHandler(action,i);
                                                      }
                                                  }];
        if (defaultColorArray.count == expandArray.count&&
            [defaultColorArray[i] isKindOfClass:[UIColor class]]) {
            [b setValue:defaultColorArray[i] forKey:@"_titleTextColor"];
        }
        [alertView addAction:b];
    }
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    [cancle setValue:cancleColor forKey:@"_titleTextColor"];
    [alertView addAction:cancle];
    return alertView;
}

@end
