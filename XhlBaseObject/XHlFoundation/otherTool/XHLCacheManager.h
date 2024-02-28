//
//  XHLCacheManager.h
//  BaiduBoxApp
//
//  Created by Jingxiang Zhang on 2/3/15.
//  Copyright (c) 2015 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^XHLCacheSaveCallback)(BOOL success);
typedef void (^XHLCacheLoadCallback)(id object);

/// 图像拉伸模式
typedef NS_ENUM(NSInteger, XHLCacheMode)
{
    /// 默认缓存，自动管理缓存，超出阈值后删除（默认值）
    XHLCacheModeDefault,
    
    /// 缓存一个周
    XHLCacheModeOneWeek,
    
    /// 缓存一个月
    XHLCacheModeOneMonth,
    
    /// 缓存30MB，超出则清空最早访问数据
    XHLCacheMode30MB,
};

@interface XHLCacheManager : NSObject

/// 返回单实例
+ (instancetype)sharedInstance;

/// 保存对象到缓存目录
- (BOOL)saveDataToDisk:(NSData *)data filename:(NSString *)filename cacheMode:(XHLCacheMode)cacheMode;

/// 保存对象到缓存目录
- (BOOL)saveDataToDisk:(NSData *)data filename:(NSString *)filename cacheMode:(XHLCacheMode)cacheMode useMemoryCache:(BOOL)useMemoryCache;

/// 保存对象到缓存目录（异步操作）
- (void)saveDataToDisk:(NSData *)data filename:(NSString *)filename cacheMode:(XHLCacheMode)cacheMode callback:(XHLCacheSaveCallback)callback;

/// 保存对象到缓存目录（异步操作）
- (void)saveDataToDisk:(NSData *)data filename:(NSString *)filename cacheMode:(XHLCacheMode)cacheMode useMemoryCache:(BOOL)useMemoryCache callback:(XHLCacheSaveCallback)callback;

/// 返回缓存目录中的指定文件
- (NSData *)dataFromDiskByFilename:(NSString *)filename;

/// 返回缓存目录中的指定文件（异步操作）
- (void)dataFromDiskByFilename:(NSString *)filename callback:(XHLCacheLoadCallback)callback;

/// 返回缓存目录中的指定文件，如果为空，则返回默认值
- (NSData *)dataFromDiskByFilename:(NSString *)filename defaultValue:(id)defaultValue;

/// 返回缓存目录中的指定文件，如果为空，则返回默认值
- (NSData *)dataFromDiskByFilename:(NSString *)filename useMemoryCache:(BOOL)useMemoryCache defaultValue:(id)defaultValue;

/// 返回缓存目录中的指定文件（异步操作），如果为空，则返回默认值
- (void)dataFromDiskByFilename:(NSString *)filename defaultValue:(id)defaultValue callback:(XHLCacheLoadCallback)callback;

/// 返回缓存目录中的指定文件（异步操作），如果为空，则返回默认值
- (void)dataFromDiskByFilename:(NSString *)filename useMemoryCache:(BOOL)useMemoryCache defaultValue:(id)defaultValue callback:(XHLCacheLoadCallback)callback;

/// 返回缓存目录中指定文件的全路径
- (NSString *)fullpathByFilename:(NSString *)filename;

/// 更新缓存模式（异步操作）
- (void)updateCacheMode:(XHLCacheMode)cacheMode filename:(NSString *)filename;

/// 缓存目录
- (NSString *)cacheDirectory:(BOOL)createIfNoteExist;

@end
