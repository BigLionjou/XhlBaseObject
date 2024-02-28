//
//  CQFileManager.m
//  CqlivingCloud
//
//  Created by xinhualong on 16/4/22.
//  Copyright © 2016年 xinhualong. All rights reserved.
//

#import "XHLFileManager.h"

@implementation XHLFileManager


+ (NSString *)documentPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString *)cachePath {
    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
}

+ (NSString * _Nonnull)libraryDirPath
{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

#pragma mark - NSFileManager
+ (BOOL)fileExistsAtPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

+ (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path isDirectory:isDirectory];
}

+ (BOOL)createDirectoryAtPath:(NSString *)path {
    
    BOOL isDir = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        NSError *error;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            return NO;
        }else {
            return YES;
        }
    }
    return YES;
}

+ (BOOL)deleteFileAtPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:path error:nil];
}

+ (unsigned long long)fileSizeAtPath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:filePath];
    if (isExist) {
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        return fileSize;
    }else {
        return 0;
    }
}

//计算文件夹中所有文件的大小
+ (unsigned long long)folderSizeAtPath:(NSString *)folderPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:folderPath];
    if (isExist) {
        
        NSEnumerator *childFileEnumerator = [[fileManager subpathsAtPath:folderPath] objectEnumerator];
        unsigned long long folderSize = 0;
        NSString *fileName = @"";
        while (fileName = [childFileEnumerator nextObject]) {
            NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize;
    }else {
        return 0;
    }
}

+ (NSBundle *)mainBundleWithResourcePath:(NSString *)path {
    NSString *bundlePath = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:path];
    return [NSBundle bundleWithPath:bundlePath];
}

+ (NSBundle *)bundleForClass:(Class)cls withResourcePath:(NSString *)path {
    NSBundle *bundle;
    if (cls == NULL) {
        bundle = [NSBundle mainBundle];
    } else {
        bundle = [NSBundle bundleForClass:[self class]];
    }
    NSString *bundlePath = [bundle.resourcePath stringByAppendingPathComponent:path];
    return [NSBundle bundleWithPath:bundlePath];
}

// 清除缓存
+ (BOOL)removeCache{
    
    // 1.拿到cachePath路径的下一级目录的子文件夹
    // contentsOfDirectoryAtPath:error:递归
    // subpathsAtPath:不递归
    
    NSArray *subpathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cachePath] error:nil];
    
    // 2.如果数组为空，说明没有缓存或者用户已经清理过，此时直接return
    if (subpathArray.count == 0) {
        return YES;
    }
    
    NSError *error = nil;
    NSString *filePath = nil;
    BOOL flag = NO;
    for (NSString *subpath in subpathArray) {
        filePath = [[self cachePath] stringByAppendingPathComponent:subpath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self cachePath]]) {
            // 删除子文件夹
            BOOL isRemoveSuccessed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (isRemoveSuccessed) { // 删除成功
                flag = YES;
            }
        }
    }
    return flag;
}
@end
