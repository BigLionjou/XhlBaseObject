//
//  CQDataSource.m
//  MVCDemo
//
//  Created by 龚魁华 on 2018/12/19.
//  Copyright © 2018年 龚魁华. All rights reserved.
//

#import "XhlDataSource.h"

@interface XhlDataSource ()

@property (strong, nonatomic) NSMutableArray *dataArry;

@property (copy, nonatomic)  NSString *cellIdentifier;

@property (copy,nonatomic) cellConfigureBlock cellConfigureBefore;
@end

@implementation XhlDataSource
- (instancetype)initWithIdentifier:(NSString *)identifier configureBlock:(cellConfigureBlock)before{
    if (self = [super init]) {
        self.cellIdentifier = identifier;
        self.cellConfigureBefore = [before copy];
    }
    return self;
}

- (void)addDataArry:(NSArray *)datas{
    if (!datas)  return;
    
    if (self.dataArry.count>0) {
        [self.dataArry removeAllObjects];
    }
    
    [self.dataArry addObjectsFromArray:datas];
    
}

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath{
    return self.dataArry.count > indexPath.row ? self.dataArry[indexPath.row] : nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return !self.dataArry ? 0 : self.dataArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[[NSClassFromString(self.cellIdentifier) class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.cellIdentifier];
    }
    id model = [self modelsAtIndexPath:indexPath];
    if (self.cellConfigureBefore) {
        self.cellConfigureBefore(cell, model, indexPath);
    }
    return cell;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return !self.dataArry ? 0 : self.dataArry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id model = [self modelsAtIndexPath:indexPath];
    if (self.cellConfigureBefore) {
        self.cellConfigureBefore(cell, model, indexPath);
    }
    return cell;
}

#pragma mark - lazy
- (NSMutableArray *)dataArry{
    if (!_dataArry) {
        _dataArry = [NSMutableArray array];
    }
    return _dataArry;
}
@end
