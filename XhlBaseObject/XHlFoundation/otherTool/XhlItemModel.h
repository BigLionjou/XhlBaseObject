//
//  XhlItemModel.h
//  XhlBaseObjectDemo
//  做表单提交的模型
//  Created by 龚魁华 on 2019/6/13.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XhlItemModel : NSObject
#pragma mark - common
/**
 用于注册, reuseIdentifier为cellName
 */
@property (nonatomic,copy) NSString *cellName;//cell名字

//是否显示下一步按钮
@property (nonatomic, assign) BOOL isShowAccessoryView;
//头部高度
@property (nonatomic, assign) CGSize headerSize;

//头部高度
@property (nonatomic, assign) CGFloat headerHight;

//头部背景颜色
@property (nonatomic, strong) UIColor *headerColor;

//底部高度
@property (nonatomic, assign) CGFloat footHight;

//底部背景颜色
@property (nonatomic, strong) UIColor *footColor;

/**
 数据,可以为字典,数组,字符串,模型,需要自己对应做解析
 */
@property (nonatomic,strong) id data;

/**
 data 里面的主键
 */
@property (nonatomic, copy) NSString *primaryKey;

#pragma mark collectView
@property (nonatomic,assign) CGSize sizeForItem;//每个大小
@property (nonatomic,assign) CGSize  footViewSize;//底部大小

@property (nonatomic,assign) UIEdgeInsets  insetForSection;//每行上学左右的间距

@property (nonatomic,assign) CGFloat  minimumLineSpacing;//每行的高度
@property (nonatomic,assign) CGFloat  minimumInteritemSpacing;//每个之间的宽度

#pragma mark - tableView
/**
 cell的高度, 当automaticDimension为YES时不生效
 */
@property (nonatomic,assign) CGFloat  cellHeight;
/**
 使用系统默认的高度预估  默认0  大于0时将tableView的estimatedRowHeight设为该值,并在返回高度的时候返回UITableViewAutomaticDimension
 */
@property (nonatomic, assign) CGFloat estimatedRowHeight;


#pragma mark - textView
//cell 上有输入框控件,
@property (nonatomic,copy) NSString  *placeholder;

@property (nonatomic, assign) BOOL hiddenSeparator;

@property (nonatomic,strong) NSIndexPath *indexPath;

//是否是最后一个
@property (nonatomic,assign) BOOL isLast;
//禁止重用
@property (nonatomic,assign) BOOL disableReuse;
@end

NS_ASSUME_NONNULL_END
