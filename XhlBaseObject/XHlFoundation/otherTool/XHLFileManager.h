//
//  CQFileManager.h
//  CqlivingCloud
//
//  Created by xinhualong on 16/4/22.
//  Copyright © 2016年 xinhualong. All rights reserved.
//

#import <Foundation/Foundation.h>
#define XHLMainBundle(path) \
[XHLFileManager bundleForMainWithResourcePath:path]

NS_ASSUME_NONNULL_BEGIN

@interface XHLFileManager : NSObject

/**
 *  获取document路径
 *
 *  @return document路径
 */
+ (NSString *_Nonnull)documentPath;

/**
 *  获取缓存路径
 *
 *  @return cache路径
 */
+ (NSString *_Nonnull)cachePath;

+ (NSString * _Nonnull)libraryDirPath; // 沙盒library文件夹路径
#pragma mark - NSFileManager
/**
 *  判断该路径下是否存在文件
 *
 *  @param path 沙盒路径
 *
 *  @return 是否存在
 */
+ (BOOL)fileExistsAtPath:(NSString *_Nonnull)path;

/**
 *  判断该路径下是否存在文件
 *
 *  @param path        沙盒路径
 *  @param isDirectory 是否是文件夹
 *
 *  @return 是否存在
 */
+ (BOOL)fileExistsAtPath:(NSString *)path
             isDirectory:(BOOL *)isDirectory;

/**
 *  创建文件夹
 *
 *  @param path 文件夹路径
 *
 *  @return 是否创建成功
 */
+ (BOOL)createDirectoryAtPath:(NSString *)path;

/**
 *  删除文件
 *
 *  @param path 文件路径
 *
 *  @return 是否删除成功
 */

+ (BOOL)deleteFileAtPath:(NSString *)path;

/**
 *  计算文件大小
 *
 *  @param filePath 文件路径
 *
 *  @return 文件大小
 */
+ (unsigned long long)fileSizeAtPath:(NSString *)filePath;

/**
 *  计算文件夹中所有文件的大小
 *
 *  @param folderPath 文件夹的路劲
 *
 *  @return 文件夹大小
 */
+ (unsigned long long)folderSizeAtPath:(NSString *)folderPath;

/**
 * @brief 获取 MainBundle 下资源的 Bundle，例如 [BBABundleManager bundleForMainWithResourcePath:@“BBAFeed.bundle”]
 *
 * @param path 资源路径
 * @return 资源的 Bundle
 */
+ (NSBundle *)mainBundleWithResourcePath:(NSString *)path;

/**
 * @brief 获取 BundleForClass 下资源的 Bundle，例如 [BBABundleManager bundleForClass:[self class] withResourcePath:@“Ad.bundle”]
 *
 * @param path 资源路径
 * @return 资源的 Bundle
 */
+ (NSBundle *)bundleForClass:(Class)cls withResourcePath:(NSString *)path;

// 清除缓存
+ (BOOL)removeCache;
@end

NS_ASSUME_NONNULL_END
