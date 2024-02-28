//
//  XHLCacheManager.m
//  BaiduBoxApp
//
//  Created by Jingxiang Zhang on 2/3/15.
//  Copyright (c) 2015 xhl. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import <UIKit/UIKit.h>
#import "XHLCacheManager.h"
#import "NSString+XhlCategory.h"
#import "NSDate+XHLCategory.h"

/// 存储位置
static NSString * const kCacheRootDirectory             = @"BaiduCaches";

/// 缓存管理文件名
static NSString * const kCacheManagementFilename        = @"CacheManagementFile.plist";

/// 缓存管理属性：缓存模式
static NSString * const kCacheManagementKeyCacheMode    = @"CacheMode";

/// 缓存管理属性：访问时间
static NSString * const kCacheManagementKeyAccessTime   = @"AccessTime";

/// 缓存默认大小上限
static NSUInteger const kCacheModeDefaultLimit          = 20 * 1000 * 1000;

/// 缓存大小上限
static NSUInteger const kCacheMode30MBLimit             = 30 * 1000 * 1000;

@implementation NSString (NSString_Extensions)

/// 返回字符串的MD5值
- (NSString *)MD5Hash
{
    const char *str = [self UTF8String];
    if (str == NULL)
    {
        str = "";
    }
    
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return hash;
}

@end

@interface XHLCacheManager ()

@property (nonatomic, strong) NSCache *memoryCache;

@end

@implementation XHLCacheManager

/// 返回单实例
+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
        [sharedInstance Initialize];
    });
    
    return sharedInstance;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// 初始化
- (void)Initialize
{
    // 初始化内存缓存
    self.memoryCache = [[NSCache alloc] init];
    
    // 进入后台时，清理缓存操作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanDisk) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    // 收到内存警告时，清理内存缓存
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanMemoryCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

/// 保存对象到缓存目录
- (BOOL)saveDataToDisk:(NSData *)data filename:(NSString *)filename cacheMode:(XHLCacheMode)cacheMode
{
    return [self saveDataToDisk:data filename:filename cacheMode:cacheMode useMemoryCache:NO];
}

/// 保存对象到缓存目录
- (BOOL)saveDataToDisk:(NSData *)data filename:(NSString *)filename cacheMode:(XHLCacheMode)cacheMode useMemoryCache:(BOOL)useMemoryCache
{
    if (data == nil || filename == nil)
    {
        return NO;
    }
    
    @try
    {
        @synchronized(self)
        {
            // 获取文件全路径
            NSString *filepath = [self fullpathByFilename:filename createDirIfNotExist:YES];
            
            // 保存对象到文件
            BOOL success = [data writeToFile:filepath atomically:YES];
            
            if (!success)
            {
                return NO;
            }
            
            // 缓存到内存
            if (useMemoryCache)
            {
                [self.memoryCache setObject:data forKey:[filename MD5Hash]];
            }
            
            // 写入缓存管理文件
            [self updateCacheMode:cacheMode accessTime:[NSDate date] filename:filename];
            
            return YES;
        }
    }
    @catch (NSException *exception)
    {
        return NO;
    }
}

/// 保存对象到缓存目录（异步操作）
- (void)saveDataToDisk:(NSData *)data filename:(NSString *)filename cacheMode:(XHLCacheMode)cacheMode callback:(XHLCacheSaveCallback)callback
{
    [self saveDataToDisk:data filename:filename cacheMode:cacheMode useMemoryCache:NO callback:callback];
}

/// 保存对象到缓存目录（异步操作）
- (void)saveDataToDisk:(NSData *)data filename:(NSString *)filename cacheMode:(XHLCacheMode)cacheMode useMemoryCache:(BOOL)useMemoryCache callback:(XHLCacheSaveCallback)callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL success = [self saveDataToDisk:data filename:filename cacheMode:cacheMode useMemoryCache:useMemoryCache];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback != nil)
            {
                callback(success);
            }
        });
    });
}

/// 返回缓存目录中的指定文件
- (NSData *)dataFromDiskByFilename:(NSString *)filename
{
    return [self dataFromDiskByFilename:filename defaultValue:nil];
}

/// 返回缓存目录中的指定文件（异步操作）
- (void)dataFromDiskByFilename:(NSString *)filename callback:(XHLCacheLoadCallback)callback
{
    return [self dataFromDiskByFilename:filename defaultValue:nil callback:callback];
}

/// 返回缓存目录中的指定文件，如果为空，则返回默认值
- (NSData *)dataFromDiskByFilename:(NSString *)filename defaultValue:(id)defaultValue
{
    return [self dataFromDiskByFilename:filename useMemoryCache:NO defaultValue:defaultValue];
}

/// 返回缓存目录中的指定文件，如果为空，则返回默认值
- (NSData *)dataFromDiskByFilename:(NSString *)filename useMemoryCache:(BOOL)useMemoryCache defaultValue:(id)defaultValue
{
    @try
    {
        if (useMemoryCache)
        {
            NSData *data = [self.memoryCache objectForKey:[filename MD5Hash]];
            if (data != nil)
            {
                // 写入缓存管理文件
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self updateCacheMode:XHLCacheMode30MB accessTime:[NSDate date] filename:filename];
                });
                
                return data;
            }
        }
        
        NSString *filepath = [self fullpathByFilename:filename createDirIfNotExist:NO];
        NSData *data = [NSData dataWithContentsOfFile:filepath];
        if (data == nil)
        {
            return nil;
        }
        
        // 缓存到内存
        //        if (useMemoryCache)
        //        {
        //            [self.memoryCache setObject:data forKey:filename];
        //        }
        
        // 写入缓存管理文件
        [self updateCacheMode:XHLCacheMode30MB accessTime:[NSDate date] filename:filename];
        
        return data;
    }
    @catch (NSException *exception)
    {
        return nil;
    }
}

/// 返回缓存目录中的指定文件（异步操作），如果为空，则返回默认值
- (void)dataFromDiskByFilename:(NSString *)filename defaultValue:(id)defaultValue callback:(XHLCacheLoadCallback)callback
{
    return [self dataFromDiskByFilename:filename useMemoryCache:NO defaultValue:defaultValue callback:callback];
}

/// 返回缓存目录中的指定文件（异步操作），如果为空，则返回默认值
- (void)dataFromDiskByFilename:(NSString *)filename useMemoryCache:(BOOL)useMemoryCache defaultValue:(id)defaultValue callback:(XHLCacheLoadCallback)callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        id  result = [self dataFromDiskByFilename:filename useMemoryCache:useMemoryCache defaultValue:defaultValue];
        if (result == nil)
        {
            result = defaultValue;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback != nil)
            {
                callback(result);
            }
        });
    });
}

/// 返回缓存目录中指定文件的全路径
- (NSString *)fullpathByFilename:(NSString *)filename
{
    return [self fullpathByFilename:filename createDirIfNotExist:NO];
}

/// 返回缓存目录中指定文件的全路径
- (NSString *)fullpathByFilename:(NSString *)filename createDirIfNotExist:(BOOL)createDirIfNotExist
{
    NSString *cacheDirectory = [self cacheDirectory:createDirIfNotExist];
    NSString *fullpath = [cacheDirectory stringByAppendingPathComponent:[filename MD5Hash]];
    
    return fullpath;
}

/// 返回缓存根目录，并指定如果不存在是否创建
- (NSString *)cacheDirectory:(BOOL)createIfNoteExist
{
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths[0] stringByAppendingPathComponent:kCacheRootDirectory];
    
    @try
    {
        if (createIfNoteExist == YES)
        {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            // 文件夹如果不存在则创建
            if (![fileManager fileExistsAtPath:cacheDirectory])
            {
                BOOL success = [fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
                if (!success)
                {
                    return nil;
                }
            }
        }
    }
    @catch (NSException *exception)
    {
        return nil;
    }
    
    return cacheDirectory;
}

/// 清除缓存（异步操作）
- (void)cleanDisk
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try
        {
            @synchronized(self)
            {
                // 读取缓存
                NSString *cacheManagementFilepath = [self fullpathForCacheManagementFile];
                NSDictionary *cacheManagementPlist = [NSDictionary dictionaryWithContentsOfFile:cacheManagementFilepath];
                
                // 枚举文件
                NSMutableDictionary *updatedCacheManagementPlist = [NSMutableDictionary dictionary];
                NSMutableDictionary *unhandledCacheFilePlist = [NSMutableDictionary dictionary];
                NSUInteger cacheMode30MBSizeTotal = 0;
                NSUInteger cacheModeDefaultSizeTotal = 0;
                
                NSString *cacheDirectory = [self cacheDirectory:NO];
                NSDirectoryEnumerator *filenameList = [[NSFileManager defaultManager] enumeratorAtPath:cacheDirectory];
                for (NSString *filename in filenameList)
                {
                    // 忽略缓存管理文件
                    if ([filename isEqualToString:kCacheManagementFilename])
                    {
                        continue;
                    }
                    
                    // 获取文件属性
                    NSDictionary *properties = [cacheManagementPlist objectForKey:filename];
                    id idCacheMode = [properties objectForKey:kCacheManagementKeyCacheMode];
                    id idAccessTime = [properties objectForKey:kCacheManagementKeyAccessTime];
                    XHLCacheMode cacheMode = XHLCacheModeDefault;
                    NSDate *accessTime = nil;
                    if (idCacheMode != nil && [idCacheMode isKindOfClass:[NSNumber class]])
                    {
                        cacheMode = [idCacheMode integerValue];
                    }
                    if (idAccessTime != nil && [idAccessTime isKindOfClass:[NSDate class]])
                    {
                        accessTime = (NSDate *)idAccessTime;
                    }
                    
                    NSString *filepath = [cacheDirectory stringByAppendingPathComponent:filename];
                    switch (cacheMode)
                    {
                        case XHLCacheModeOneWeek:
                        case XHLCacheModeOneMonth:
                        {
                            NSDate *expireTime = [NSDate dateWithDaysBeforeNow:(cacheMode == XHLCacheModeOneWeek ? 7 : 30)];
                            if ([accessTime compare:expireTime] == NSOrderedAscending)
                            {
                                // 清理缓存文件
//                                NSLog(@"删除缓存文件(XHLCacheModeOneWeek): %@", filename);
                                [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
                            }
                            else
                            {
                                // 更新缓存管理文件
                                [updatedCacheManagementPlist setObject:properties forKey:filename];
                            }
                            
                            break;
                        }
                        case XHLCacheMode30MB:
                        default:
                        {
                            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:nil];
                            unsigned long long fileSize = [fileAttributes fileSize];
                            if (cacheMode == XHLCacheMode30MB)
                            {
                                cacheMode30MBSizeTotal += fileSize;
                            }
                            else
                            {
                                cacheModeDefaultSizeTotal += fileSize;
                            }
                            
                            if (accessTime == nil)
                            {
                                accessTime = [fileAttributes fileModificationDate];
                            }
                            
                            // 存储所有未处理的文件列表备用
                            [unhandledCacheFilePlist setObject:accessTime forKey:filename];
                            
                            break;
                        }
                    }
                }
                
                // 根据访问时间排序
                NSArray *unhandledSortedCacheFiles = [unhandledCacheFilePlist keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                    return [obj1 compare:obj2];
                }];
                
                // 清理未处理过的缓存文件
                for (NSString *filename in unhandledSortedCacheFiles)
                {
                    // 获取文件属性
                    NSDictionary *properties = [cacheManagementPlist objectForKey:filename];
                    id idCacheMode = [properties objectForKey:kCacheManagementKeyCacheMode];
                    XHLCacheMode cacheMode = XHLCacheModeDefault;
                    if (idCacheMode != nil && [idCacheMode isKindOfClass:[NSNumber class]])
                    {
                        cacheMode = [idCacheMode integerValue];
                    }
                    
                    NSString *filepath = [cacheDirectory stringByAppendingPathComponent:filename];
                    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filepath error:nil];
                    unsigned long long fileSize = [fileAttributes fileSize];
                    switch (cacheMode)
                    {
                        case XHLCacheMode30MB:
                        {
                            if (cacheMode30MBSizeTotal > kCacheMode30MBLimit)
                            {
                                if ([[NSFileManager defaultManager] removeItemAtPath:filepath error:nil])
                                {
//                                    NSLog(@"删除缓存文件(XHLCacheMode30MB): %@", filename);
                                    cacheMode30MBSizeTotal -= fileSize;
                                }
                            }
                            else
                            {
                                [updatedCacheManagementPlist setObject:properties forKey:filename];
                            }
                            
                            break;
                        }
                        default:
                        {
                            if (cacheModeDefaultSizeTotal > kCacheModeDefaultLimit)
                            {
                                if ([[NSFileManager defaultManager] removeItemAtPath:filepath error:nil])
                                {
//                                    NSLog(@"删除缓存文件(XHLCacheModeDefault): %@", filename);
                                    cacheModeDefaultSizeTotal -= fileSize;
                                }
                            }
                            else
                            {
                                [updatedCacheManagementPlist setObject:properties forKey:filename];
                            }
                            
                            break;
                        }
                    }
                }
                
                // 保存修改后的缓存管理文件
                [updatedCacheManagementPlist writeToFile:cacheManagementFilepath atomically:YES];
            }
        }
        @catch (NSException *exception)
        {
        }
    });
}

/// 清理内存缓存
- (void)cleanMemoryCache
{
    [self.memoryCache removeAllObjects];
}

/// 更新缓存模式（异步操作）
- (void)updateCacheMode:(XHLCacheMode)cacheMode filename:(NSString *)filename
{
    return [self updateCacheMode:cacheMode accessTime:nil filename:filename];
}

/// 更新缓存模式和访问时间（异步操作）
- (void)updateCacheMode:(XHLCacheMode)cacheMode accessTime:(NSDate *)accessTime filename:(NSString *)filename
{
    if (cacheMode == XHLCacheModeDefault)
    {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @try
        {
            @synchronized(self)
            {
                // 读取缓存
                NSString *filenameHash = [filename MD5Hash];
                NSString *cacheManagementFilepath = [self fullpathForCacheManagementFile];
                NSMutableDictionary *cacheManagementPlist = [NSMutableDictionary dictionaryWithContentsOfFile:cacheManagementFilepath];
                if (cacheManagementPlist == nil)
                {
                    cacheManagementPlist = [NSMutableDictionary dictionary];
                }
                
                // 如果无此记录，则创建
                NSMutableDictionary *properties = [cacheManagementPlist objectForKey:filenameHash];
                if (properties == nil)
                {
                    properties = [NSMutableDictionary dictionary];
                }
                
                if (accessTime != nil)
                {
                    [properties setObject:[NSDate date] forKey:kCacheManagementKeyAccessTime];
                }
                
                [cacheManagementPlist setObject:properties forKey:filenameHash];
                
                // 存储文件
                [cacheManagementPlist writeToFile:cacheManagementFilepath atomically:YES];
            }
        }
        @catch (NSException *exception)
        {
        }
    });
}

/// 获取缓存管理文件的全路径
- (NSString *)fullpathForCacheManagementFile
{
    NSString *cacheDirectory = [self cacheDirectory:YES];
    NSString *filepath = [cacheDirectory stringByAppendingPathComponent:kCacheManagementFilename];
    
    return filepath;
}

@end
