//
//  XhlTableTestController.m
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/5/14.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "XhlTableTestController.h"
#import "XhlTableTestCell.h"
#import "XhlInitView.h"
#import "UITableViewCell+XhlCategory.h"
#import "XhlDataSource.h"

@interface XhlTableTestController ()<UITableViewDelegate>

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) NSArray *heights;

@property (strong, nonatomic) XhlDataSource *dataSource;

@end

@implementation XhlTableTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.table = newTable();
    [self.table registerClass:[XhlTableTestCell class] forCellReuseIdentifier:@"XhlTableTestCell"];
    self.table.frame = CGRectMake(0, 64, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 64);
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    self.dataSource = [[XhlDataSource alloc] initWithIdentifier:@"XhlTableTestCell" configureBlock:^(UITableViewCell *cell, NSString *model, NSIndexPath *indexpath) {
        cell.textLabel.text = model;
        [cell setShowBottomLine:true leftSpace:20 rightSpace:40 lineColor:[UIColor orangeColor]];
    }];
    self.table.dataSource = self.dataSource;
    self.heights = @[@"90.0", @"120.0", @"100.0", @"50.0", @"100.0", @"120.0", @"100.0", @"200.0"];
    [self.dataSource addDataArry:self.heights];
    [self.table reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.heights objectAtIndex:indexPath.row] floatValue];
}



@end
