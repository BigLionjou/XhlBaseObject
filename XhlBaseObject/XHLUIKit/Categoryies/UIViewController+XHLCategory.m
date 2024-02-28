//
//  UIViewController+XHLCategory.m
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/8/2.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UIViewController+XHLCategory.h"

@implementation UIViewController (XHLCategory)

- (void)xhl_addSubViews{}
- (void)xhl_configerSubView{}
- (void)xhl_loadLayouts{}
- (void)xhl_getData{}

#pragma mark - controller

- (UIViewController *)xhl_ToViewControllerName:(NSString *)strClassName{
    
    Class cls = NSClassFromString(strClassName);
    
    NSArray *array = self.navigationController.viewControllers;
    
    for (UIViewController *controller in array) {
        if (([controller isKindOfClass:[cls class]])) {
            
            UIViewController *object= controller;
            
            return object;
            
        }
        
    }
    return nil;
    
}

- (void)xhl_pushToController:(NSString *)contollerName{
    UIViewController *vc = [UIViewController xhl_controllerWithName:contollerName];
    [self.navigationController pushViewController:vc animated:YES];
}

+ (UIViewController *)xhl_controllerWithName:(NSString *)name{
    if (!name) {return nil;}
    
    // 1.先读取SB
    //(1)读取缓存VC
    NSCache *cache = [self cache];
    NSString *cacheStoryboardName = [cache objectForKey:name];
    if (cacheStoryboardName) {
        UIStoryboard *userInfoSB = [UIStoryboard storyboardWithName:cacheStoryboardName bundle:[NSBundle mainBundle]];
        UIViewController *vc = [userInfoSB instantiateViewControllerWithIdentifier:name];
        vc.hidesBottomBarWhenPushed = YES;
        return vc;
    }
    
    //(2) 未缓存，遍历storyboard文件名列表，开始尝试取出实例。
    for (NSString *storyboardName in [self storyboardList]) {
        UIStoryboard *userInfoSB = [UIStoryboard storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
        if([[userInfoSB valueForKey:@"identifierToNibNameMap"] objectForKey:name]){//判断是否存在这个id的VC
            [cache setObject:storyboardName forKey:name];//当前寻找的VC存入缓存
            UIViewController *vc = [userInfoSB instantiateViewControllerWithIdentifier:name];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }
    }
    
    // 2. 不存在，则根据name创建一个
    UIViewController *vc = (UIViewController *)[[NSClassFromString(name) alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    return vc;
}

//寻找所有的storyboard
+ (nonnull NSArray*)storyboardList
{
    static NSArray *kBundleStoryboardNameList;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray *tmp = [NSMutableArray array];
        
        /**
         *  找到所有storyboard文件。
         *  @warning 会忽略带有 ~iphone(iPhone应用)或 ~ipad(ipad应用)标志的 storyboard文件名
         */
        NSArray *list = [NSBundle pathsForResourcesOfType:@"storyboardc" inDirectory:[NSBundle mainBundle].resourcePath];
        for (NSString *path in list) {
            NSString *ext = [path lastPathComponent];
            NSString *name = [ext stringByDeletingPathExtension];
            if ([name rangeOfString:@"~"].location == NSNotFound) {
                
                [tmp addObject:name];
            }
        }
        
        kBundleStoryboardNameList = [NSArray arrayWithArray:tmp];
    });
    return kBundleStoryboardNameList;
}

+ (NSCache *)cache
{
    static NSCache *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[NSCache alloc] init];
    });
    return cache;
}
@end
