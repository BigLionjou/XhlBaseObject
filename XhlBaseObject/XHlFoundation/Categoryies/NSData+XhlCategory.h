//
//  NSData+XhlCategory.h
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/8/2.
//  Copyright © 2019 rogue. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (XHLCategory)
/**
 * @brief 默认的 GZip 压缩, level 为 Z_DEFAULT_COMPRESSION, 速度快
 *
 * @return GZip 压缩后的 NSData
 */
- (NSData *)xhl_compressGZip;

/**
 * @brief 性能最好的 GZip 压缩, level 为 Z_BEST_COMPRESSION, 速度慢
 *
 * @return GZip 压缩后的 NSData
 */
- (NSData *)xhl_bestCompressGZip;

/**
 * @brief GZip 压缩
 *
 * @param level 压缩 level 推荐 Z_DEFAULT_COMPRESSION 或 Z_BEST_COMPRESSION (分别代表 -1 和 9，注意不要用 0)
 * @param outputLength 估计的 output 长度， 如果最后长度与实际 output 不符合，会进行动态调整
 * @return GZip 压缩后的 NSData
 *
 * @note 建议使用上面压缩方法，其 outputLength = self.length / 2
 */
- (NSData *)xhl_compressGZipWithCompressionLevel:(int)level estimatedOutputLength:(NSUInteger)outputLength;

/**
 * @brief GZip 解压
 *
 * @return GZip 解压后的 NSData
 */
- (NSData *)xhl_decompressGZip;

/**
 * @brief GZip 解压
 *
 * @param outputLength outputLength 估计的 output 长度， 如果最后长度与实际 output 不符合，会进行动态调整
 * @return GZip 解压后的 NSData
 *
 * @note 建议调用上面解压方法，其 outputLength = self.length * 2
 */
- (NSData *)xhl_decompressGZipWithEstimatedOutputLength:(NSUInteger)outputLength;

/**
 * @brief 判断是否是 GZip 压缩后的 NSData
 *
 * @return YES on success
 */
- (BOOL)xhl_isCompressedGZipData;
@end

NS_ASSUME_NONNULL_END
