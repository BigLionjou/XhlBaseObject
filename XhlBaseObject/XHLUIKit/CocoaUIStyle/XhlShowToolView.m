//
//  CQShowToolView.m
//  CqlivingCloud
//
//  Created by 龚魁华 on 2018/3/19.
//  Copyright © 2018年 xinhualong. All rights reserved.
//

#import "XhlShowToolView.h"

@interface XhlShowToolView ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableView;

@end
@implementation XhlShowToolView

#pragma mark -- init
+ (XhlShowToolView *)sharedInstance{
    static XhlShowToolView *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[[self class] alloc] init];

    });
    return sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.tableView];
    }
    return self;
}

-(void)showViewDataArry:(NSArray *)dataArry didSelect:(didSelectBlock)didSelect{
    self.dataArry = dataArry;
    self.didSelectIndex = didSelect;
    [self showInView:[UIApplication sharedApplication].keyWindow];
    [self.tableView reloadData];
}

#pragma mark - Configure Views
- (void)showInView:(UIView *)view{
    [view endEditing:YES];
    
    if (self.superview) {//判断视图上是否已经有了对象，防止重复点击
        return;
    }
    self.backgroundColor = [UIColor clearColor];
    self.frame = view.frame;
    self.tableView.frame = CGRectMake(0,CGRectGetHeight(self.frame), UIScreen.mainScreen.bounds.size.width, 0);
    [view addSubview:self];
    [self performSelectorOnMainThread:@selector(show) withObject:NULL waitUntilDone:false];
}

-  (void)show {
    
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        weakSelf.tableView.frame = CGRectMake(weakSelf.tableView.frame.origin.x, weakSelf.frame.size.height - (45*weakSelf.dataArry.count), weakSelf.tableView.frame.size.width, 45*weakSelf.dataArry.count);
        [weakSelf layoutIfNeeded];
    }];
    
}

/**
 *  隐藏
 */
-  (void)hide {
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.backgroundColor = [UIColor clearColor];
        weakSelf.tableView.frame = CGRectMake(0, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, 0);
        [weakSelf layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished){
            [weakSelf removeFromSuperview];
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGFloat contentViewHeight = 45*self.dataArry.count;
    CGRect contentViewRect = CGRectMake(0, UIScreen.mainScreen.bounds.size.height-contentViewHeight, UIScreen.mainScreen.bounds.size.width, contentViewHeight);
    if(!CGRectContainsPoint(contentViewRect, touchPoint)) {
        [self hide];
    }
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArry.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XhlShowToolViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XhlShowToolViewCell"];
    cell.labelTitle.text = self.dataArry[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectIndex) {
        self.didSelectIndex(indexPath.row);
    }
    [self hide];
}

#pragma mark -- lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 0)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 45;
        _tableView.scrollEnabled = false;
        _tableView.separatorInset = UIEdgeInsetsZero;
        [_tableView registerClass:[XhlShowToolViewCell class] forCellReuseIdentifier:@"XhlShowToolViewCell"];
        
    }
    return _tableView;
}
@end









@interface XhlShowToolViewCell ()

@end

@implementation XhlShowToolViewCell
-(UILabel *)labelTitle{
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, 45)];
        _labelTitle.font = [UIFont systemFontOfSize:17];
        _labelTitle.textColor = [UIColor colorWithRed:102/250.0 green:102/250.0 blue:102/250.0 alpha:1.0];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
         [self.contentView addSubview:_labelTitle];
    }
    return _labelTitle;
}
@end
