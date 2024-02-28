//
//  UIViewController+RequestPar.h
//  HlwNewsModule
//
//  Created by xiaoshiheng on 2022/6/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//web类型
typedef NS_ENUM(NSInteger, XhlViewType){
    XhlViewType_default,     //默认二、三级栏目 （无导航栏，头部、底部和父view对齐）
    XhlViewType_pushVC,      //Push推入栏目  (有导航栏 无Tabar)
    XhlViewType_tabarChild   //一级栏目 （有导航栏 有Tabar）
};

@interface UIViewController (RequestPar)


//vc 类型
@property (nonatomic, assign) XhlViewType xhlViewType;
///栏目templetCode
@property (copy, nonatomic) NSString *templetCode;
// 需要push跳转
@property (assign, nonatomic) BOOL isPushAf;

/// 请求参数
@property (strong,nonatomic) NSDictionary <NSString *,id>*requestPar;

/// 非请求参数通用传递
@property (strong,nonatomic) NSDictionary <NSString *,id>*parameterPar;

@end



NS_ASSUME_NONNULL_END
