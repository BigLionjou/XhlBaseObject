//
//  CQShowToolView.h
//  CqlivingCloud
//
//  Created by 龚魁华 on 2018/3/19.
//  Copyright © 2018年 xinhualong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^didSelectBlock)(NSInteger index);

@interface XhlShowToolView : UIView
@property (strong,nonatomic) NSArray *dataArry;
@property (copy,nonatomic) didSelectBlock didSelectIndex;

+ (XhlShowToolView *)sharedInstance;

/**
 展示数据

 @param dataArry 数据
 @param didSelect 点击事件
 */
-(void)showViewDataArry:(NSArray *)dataArry didSelect:(didSelectBlock)didSelect;

@end











@interface XhlShowToolViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *labelTitle;

@end
