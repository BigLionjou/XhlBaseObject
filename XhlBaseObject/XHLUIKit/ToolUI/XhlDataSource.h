//
//  CQDataSource.h
//  MVCDemo
//
//  Created by 龚魁华 on 2018/12/19.
//  Copyright © 2018年 龚魁华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^cellConfigureBlock) (id cell,id model,NSIndexPath *indexpath);

@interface XhlDataSource : NSObject<UITableViewDataSource,UICollectionViewDataSource>

//自定义
- (instancetype)initWithIdentifier:(NSString *)identifier configureBlock:(cellConfigureBlock)before;


- (void)addDataArry:(NSArray *)datas;

- (id)modelsAtIndexPath:(NSIndexPath *)indexPath;
@end
