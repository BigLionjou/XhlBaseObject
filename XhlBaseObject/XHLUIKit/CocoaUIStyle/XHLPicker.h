//
//  XHLPicker.h
//  XHLPods-XHLUIKit
//
//  Created by xhl on 2018/3/8.
//  Copyright © 2018年 xhl. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XHLPicker;

/**
 *  @brief value改变回调函数
 *
 *  @param picker 发送者
 *  @param value 选择数据，如@[@1, @0, @2]
 */
typedef void (^XHLPickerValueBlock)(XHLPicker *picker, NSArray<NSNumber *> *value);

/**
 *  @brief 某一列改变回调函数
 *
 *  @param picker 发送者
 *  @param column 表示改变了第几列（下标从0开始）
 *  @param value 示变更值的下标
 */
typedef void (^XHLPickerColumnBlock)(XHLPicker *picker, NSInteger column, NSInteger value);

/**
 *  @brief 取消的回调
 */
typedef void (^XHLPickerCancelBlock)(void);

@interface XHLPicker : UIView

@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

// picker元数据
@property (nonatomic, readonly) NSArray *range;

// picker选择数据
@property (nonatomic, readonly) NSArray<NSNumber *> *value;

/**
 *  调起从底部弹起的滚动选择器
 *
 *  @param range 二维数组，长度表示多少列，数组的每项表示每列的数据，如[["a","b"], ["c","d"]]
 *  @param value value 每一项的值表示选择了 range 对应项中的第几个（下标从 0 开始）如[0, 1]
 *  @param valueChange value改变时触发change事件
 *  @param columnChange 某一列的值改变时触发 columnchange 事件，event.detail = {column: column, value: value}，column 的值表示改变了第几列（下标从0开始），value 的值表示变更值的下标
 *  @param cancel 取消选择时触发
 */
+ (instancetype)showPickerWithRange:(NSArray *)range
                              value:(NSArray<NSNumber *> *)value
                    bindValueChange:(XHLPickerValueBlock)valueChange
                   bindColumnChange:(XHLPickerColumnBlock)columnChange
                         bindCancel:(XHLPickerCancelBlock)cancel;
- (instancetype)initWithRange:(NSArray *)range
                        value:(NSArray<NSNumber *> *)value
              bindValueChange:(XHLPickerValueBlock)valueChange
             bindColumnChange:(XHLPickerColumnBlock)columnChange
                   bindCancel:(XHLPickerCancelBlock)cancel;

/**
 *  显示picker
 */
- (void)show;

/**
 *  更新rang信息
 *
 *  @param range 同showPickerWithRange的range
 *  @param value value 每一项的值表示选择了 range 对应项中的第几个（下标从 0 开始）
 */
- (void)updatePickerRange:(NSArray *)range
                    value:(NSArray<NSNumber *> *)value;

/**
 *  更新rang信息
 *
 *  @param columns 更新列的数据
 *  @param index 更新第几列
 *  @param row 选择第几行
 */
- (void)updatePickerColumns:(NSArray *)columns
                columnIndex:(NSInteger)index
                        row:(NSInteger)row;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
@end

NS_ASSUME_NONNULL_END
