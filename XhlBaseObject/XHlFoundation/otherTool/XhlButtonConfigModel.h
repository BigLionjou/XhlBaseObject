//
//  XhlButtonConfigModel.h
//  XhlWebView
//
//  Created by gongkuihua on 2022/8/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XhlButtonConfigModel : NSObject
//类型标识
@property (copy,nonatomic) NSString *type;
//选择图
@property (copy,nonatomic) NSString *selectIcon;
//默认图
@property (copy,nonatomic) NSString *icon;

/// 点击事件,可为js,也可以为链接地址json,
@property (copy,nonatomic) NSString *event;
//选中标题
@property (copy,nonatomic) NSString *selectTitle;
//默认标题
@property (copy,nonatomic) NSString *title;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
