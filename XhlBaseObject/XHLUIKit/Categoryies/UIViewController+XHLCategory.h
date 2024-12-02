//
//  UIViewController+XHLCategory.h
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/8/2.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XhlLoadControllersProtocols <NSObject>

@optional

- (void)xhl_addSubViews;
- (void)xhl_configerSubView;
- (void)xhl_loadLayouts;
- (void)xhl_getData;

@end



@interface UIViewController (XHLCategory)<XhlLoadControllersProtocols>

#pragma mark - controller
// 检查是否有 navigationController 且当前控制器在 viewControllers 树中
- (BOOL)isPushedAsChildViewController ;

/**
 寻找子页面
 */
- (UIViewController *)xhl_ToViewControllerName:(NSString *)strClassName;
/**
 推入到子页面
 */
- (void)xhl_pushToController:(NSString *)contollerName;

/**
 创建controller 先读取storboard上的VC，如果不存在则自己创建一个VC
 
 @param name Controller的名字
 @return controller
 */
+ (UIViewController *)xhl_controllerWithName:(NSString *)name;





@end

NS_ASSUME_NONNULL_END
