//
//  NSArray+Additions.h
//  CqlivingCloud
//
//  Created by XHL on 2017/4/17.
//  Copyright © 2017年 xinhualong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (XHLCategory)

/**
 压缩图片
 
 最大700kb
 @return 压缩后的图片数组
 */
- (NSArray <UIImage *>*)xhl_compressImages;

/**
 压缩图片

 @param maxFloat 最大的图片大小 kb
 @return 压缩后的图片数组
 */
- (NSArray <UIImage *>*)xhl_compressImagesWithMaxFloat:(CGFloat)maxFloat;

/**
 base64 编码图片

 @return 以“,”分割的base64编码的图片字符串
 */
- (NSString *)xhl_backBase64ImageStr;

@end
