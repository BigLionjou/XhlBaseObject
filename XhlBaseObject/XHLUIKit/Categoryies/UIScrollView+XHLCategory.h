//
//  UIScrollView+XHLCategory.h
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/11/6.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (XHLCategory)

#pragma mark - Register cell 只对tableView和collectionView有效
/**
 批量注册cell identifier为cell的名字
 
 @param cellNames cell的名字数组
 */
- (void)xhl_regiserCellNames:(NSArray<NSString *> *)cellNames;

/**
 注册单个cell identifier为cell的名字
 
 @param cellName cell的名字数组
 */
- (void)xhl_regiserSingleCellName:(NSString*)cellName;

- (void)xhl_regiserSingleCellName:(NSString *)cellName identifier:(NSString *)identifier;

//注册pod里面的xib
- (void)xhl_regiserSingleCellName:(NSString *)cellName bunleName:(NSString  *)bunleName;

- (void)xhl_regiserCellNames:(NSArray<NSString *> *)cellNames bunleName:(NSString *)bunleName;

- (void)xhl_regiserSingleCellName:(NSString *)cellName bundle:(NSBundle *)bundle;

- (void)xhl_regiserSingleCellName:(NSString *)cellName identifier:(NSString *)identifier bundle:(NSBundle *)bundle;

//预注册cell
- (void)xhl_preLoadCellWithRowCellName:(NSString *)rowCellName;

//预注册cell
- (void)xhl_preLoadCellWithRowCellName:(NSString *)rowCellName reuseIdentifier:(NSString *)reuseIdentifier;
@end

NS_ASSUME_NONNULL_END
