//
//  UIScrollView+XHLCategory.m
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/11/6.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UIScrollView+XHLCategory.h"
#import "UIView+XhlCategory.h"
#import "NSBundle+XhlCategory.h"
#import <objc/runtime.h>

@interface UIScrollView ()

@property (strong,nonatomic) NSMutableArray *regiserIdentifierArry;

@end
@implementation UIScrollView (XHLCategory)

#pragma mark - Register cell
- (void)xhl_regiserCellNames:(NSArray<NSString *> *)cellNames{
    for (NSString *cellName in cellNames) {
        [self xhl_regiserSingleCellName:cellName];
    }
}

- (void)xhl_regiserCellNames:(NSArray<NSString *> *)cellNames bunleName:(NSString *)bunleName{
    for (NSString *cellName in cellNames) {
        [self xhl_regiserSingleCellName:cellName bunleName:bunleName];
    }
}

/**
 注册单个cell identifier为cell的名字
 
 @param cellName cell的名字数组
 */
- (void)xhl_regiserSingleCellName:(NSString *)cellName{
    [self xhl_regiserSingleCellName:cellName identifier:cellName];
}

- (void)xhl_regiserSingleCellName:(NSString *)cellName identifier:(NSString *)identifier{
     NSBundle *bundle =  [NSBundle mainBundle];
    [self xhl_regiserSingleCellName:cellName identifier:identifier bundle:bundle];
}

//注册pod里面的xib
- (void)xhl_regiserSingleCellName:(NSString *)cellName bunleName:(NSString *)bunleName{
    [self xhl_regiserSingleCellName:cellName identifier:cellName bunleName:bunleName];
}

//注册pod里面的xib
- (void)xhl_regiserSingleCellName:(NSString *)cellName identifier:(NSString *)identifier bunleName:(NSString *)bunleName{
    NSBundle *bundle = [NSBundle xhl_subBundleWithBundleName:bunleName targetClass:[self.xhl_firstAvailableUIViewController class]];
    [self xhl_regiserSingleCellName:cellName identifier:identifier bundle:bundle];
}


- (void)xhl_regiserSingleCellName:(NSString *)cellName bundle:(NSBundle *)bundle{
    [self  xhl_regiserSingleCellName:cellName identifier:cellName bundle:bundle];
}

- (void)xhl_regiserSingleCellName:(NSString *)cellName identifier:(NSString *)identifier bundle:(NSBundle *)bundle{
    if ([self.regiserIdentifierArry containsObject:identifier]) {
        return;
    }
    NSString *localPath = [bundle pathForResource:cellName ofType:@"nib"];
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *table = (UITableView *)self;
        
        if (localPath) {
            UINib *nib = [UINib nibWithNibName:cellName bundle:bundle];
            [table registerNib:nib forCellReuseIdentifier:identifier];
            
        }else{
            Class class = NSClassFromString(cellName);
            if (class) {
                [table registerClass:class forCellReuseIdentifier:identifier];
            }
        }
        
    }else if([self isKindOfClass:[UICollectionView class]]){
        UICollectionView *collection = (UICollectionView *)self;
        if (localPath) {
            UINib *nib = [UINib nibWithNibName:cellName bundle:bundle];
            [collection registerNib:nib forCellWithReuseIdentifier:identifier];
        }else{
            Class class = NSClassFromString(cellName);
            if (class) {
                [collection registerClass:class forCellWithReuseIdentifier:identifier];
            }
        }
    }
    [self.regiserIdentifierArry addObject:identifier];
}


//预注册cell
- (void)xhl_preLoadCellWithRowCellName:(NSString *)rowCellName{
    [self xhl_preLoadCellWithRowCellName:rowCellName reuseIdentifier:rowCellName];
}

//预注册cell
- (void)xhl_preLoadCellWithRowCellName:(NSString *)rowCellName reuseIdentifier:(NSString *)reuseIdentifier{
    if ([self.regiserIdentifierArry containsObject:reuseIdentifier]) {
        return;
    }
    [self xhl_regiserSingleCellName:rowCellName identifier:reuseIdentifier];
}

- (NSMutableArray *)regiserIdentifierArry{
    NSMutableArray *arry = objc_getAssociatedObject(self, _cmd);
    if (!arry) {
        arry = NSMutableArray.array;
        objc_setAssociatedObject(self, @selector(regiserIdentifierArry), arry, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return arry;
}

- (void)setRegiserIdentifierArry:(NSMutableArray *)regiserIdentifierArry{
    objc_setAssociatedObject(self, @selector(regiserIdentifierArry), regiserIdentifierArry, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

