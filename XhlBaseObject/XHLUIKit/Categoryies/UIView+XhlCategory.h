//
//  UIView+XhlView.h
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/3/18.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@protocol XhlLoadViewsProtocols <NSObject>

@optional

- (void)xhl_addSubViews;
- (void)xhl_configerSubView;
- (void)xhl_loadLayouts;
- (void)xhl_getData;
- (void)xhl_refreshData:(id _Nonnull )data;

@end


typedef void (^xhlGestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (XHLCategory)<XhlLoadViewsProtocols>

@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
@property (strong, nonatomic) IBInspectable UIColor *borderColor;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign, readonly) CGFloat maxX;
@property (nonatomic, assign, readonly) CGFloat maxY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGFloat  height;
@property (nonatomic, assign) CGFloat  width;
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat bottom;

/**
 返回当前页面的 ViewController

 @return ViewController对象
 */
- (UIViewController *)xhl_firstAvailableUIViewController;
//判断顶层vc是否是AlertController
- (BOOL )xhl_getTopVCIsAlertController;
//判断顶层vc是否是AlertController
+ (BOOL )xhl_getTopVCIsAlertController;

//获取顶部vc,不适用pageVC
- (UIViewController*)xhl_getTopViewController;

+ (UIViewController *)xhl_getTopViewController;

//获取子视图
- (id)xhl_findSubViewWithSubViewClass:(Class)clazz;

//获取父视图
- (id)xhl_findsuperViewWithSuperViewClass:(Class)clazz;

/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)xhl_addTapActionWithBlock:(xhlGestureActionBlock)block;

/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)xhl_addLongPressActionWithBlock:(xhlGestureActionBlock)block;

/**
 获取table
 
 @return UITableView
 */
- (UITableView *)xhl_getTableView;

/**
 获取CollectionView
 
 @return CollectionView
 */
- (UICollectionView *)xhl_getCollectionView;

/**
 获取WkWebView
 
 @return WkWebView
 */
- (WKWebView *)xhl_getWkWebView;

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen;

/**
 移除当前所有 subviews
 */
- (void)xhl_removeAllSubviews;

- (void)xhl_addSubViews:(NSArray *)views;
@end

NS_ASSUME_NONNULL_END
