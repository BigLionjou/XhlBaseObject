//
//  NSData+XHL.m
//  XhlBaseObjectDemo
//
//  Created by XHL on 2019/8/2.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "NSData+XhlCategory.h"
#import <zlib.h>

#define WindowBits 15
#define GZIP_ENCODING 16
#define ENABLE_ZLIB_GZIP 32

@implementation NSData (XHLCategory)
- (NSData *)xhl_compressGZip {
    return [self xhl_compressGZipWithCompressionLevel:Z_DEFAULT_COMPRESSION estimatedOutputLength:self.length / 2];
}

- (NSData *)xhl_bestCompressGZip {
    return [self xhl_compressGZipWithCompressionLevel:Z_BEST_COMPRESSION estimatedOutputLength:self.length / 2];
}

- (NSData *)xhl_compressGZipWithCompressionLevel:(int)level estimatedOutputLength:(NSUInteger)outputLength {
    if ((0 == self.length) || [self xhl_isCompressedGZipData]) return self;
    // 初始化 stream
    z_stream stream;
    bzero(&stream, sizeof(z_stream));
    stream.avail_in = (uInt)self.length;
    stream.next_in = (unsigned char*)self.bytes;
    // 设置每次扩容的长度为 Data 长度的 1/2
    NSUInteger chunkSize = self.length / 2;
    if (deflateInit2(&stream, level, Z_DEFLATED, WindowBits + GZIP_ENCODING, MAX_MEM_LEVEL, Z_DEFAULT_STRATEGY) == Z_OK) {
        NSMutableData *output = [NSMutableData dataWithLength:outputLength];
        int retCode = Z_OK;
        while (retCode == Z_OK) {
            // 扩容
            if (stream.total_out >= output.length) output.length += chunkSize;
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            retCode = deflate(&stream, Z_FINISH);
        }
        if (deflateEnd(&stream) == Z_OK) {
            // 调整 output 长度
            output.length = stream.total_out;
            return [NSData dataWithData:output];
        }
    }
    return nil;
}

- (NSData *)xhl_decompressGZip {
    return [self xhl_decompressGZipWithEstimatedOutputLength:self.length * 2];
}

- (NSData *)xhl_decompressGZipWithEstimatedOutputLength:(NSUInteger)outputLength {
    if ((0 == self.length) || ![self xhl_isCompressedGZipData]) return self;
    // 初始化 stream
    z_stream stream;
    bzero(&stream, sizeof(z_stream));
    stream.avail_in = (uInt)self.length;
    stream.next_in = (unsigned char*)self.bytes;
    // 设置每次扩容的长度为 Data 长度的 1/2
    NSUInteger chunkSize = self.length / 2;
    if (inflateInit2(&stream, WindowBits + ENABLE_ZLIB_GZIP) == Z_OK) {
        NSMutableData *output = [NSMutableData dataWithCapacity:outputLength];
        int retCode = Z_OK;
        while (retCode == Z_OK) {
            // 扩容
            if (stream.total_out >= output.length) output.length += chunkSize;
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            retCode = inflate(&stream, Z_SYNC_FLUSH);
        }
        if (inflateEnd(&stream) == Z_OK) {
            // 调整 output 长度
            output.length = stream.total_out;
            return [NSData dataWithData:output];
        }
    }
    return nil;
}

- (BOOL)xhl_isCompressedGZipData {
    const UInt8 *bytes = (const UInt8 *)self.bytes;
    return (self.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}
@end
