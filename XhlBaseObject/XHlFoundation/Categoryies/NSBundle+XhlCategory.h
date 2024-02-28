//
//  NSBundle+XhlCategory.h
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/12/10.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (XhlCategory)

/**
 获取文件所在name，默认情况下podName和bundlename相同，传一个即可
 
 @param bundleName bundle名字，就是在resource_bundles里面的名字
 @param podName pod的名字
 @return bundle
 */
+ (NSBundle *)xhl_bundleWithBundleName:(NSString *)bundleName podName:(NSString *)podName;

+ (instancetype)xhl_subBundleWithBundleName:(NSString *)bundleName targetClass:(Class)targetClass;
@end

NS_ASSUME_NONNULL_END
