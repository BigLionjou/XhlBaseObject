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


//安全取值
- (id)xhl_arrayObjectAtIndex:(NSUInteger)index ;


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


/**
 * 将数组拆分成多个子数组，每个子数组包含`chunkSize`个元素。
 * 如果不能平均分配，则最后一个子数组的元素数量可能少于`chunkSize`。
 *
 * @param chunkSize 每个子数组应包含的元素数量。
 * @return 包含所有子数组的数组。
 */
- (NSArray<NSArray *> *)xhl_chunkedArrayWithSize:(NSUInteger)chunkSize;

@end
