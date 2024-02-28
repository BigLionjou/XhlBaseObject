//
//  NSArray+Additions.m
//  CqlivingCloud
//
//  Created by XHL on 2017/4/17.
//  Copyright © 2017年 xinhualong. All rights reserved.
//

#import "NSArray+XhlCategory.h"

@implementation NSArray (XHLCategory)

//压缩图片 最大700kb
- (NSArray <UIImage *>*)xhl_compressImages{
    return [self xhl_compressImagesWithMaxFloat:700];
}

//压缩图片
- (NSArray <UIImage *>*)xhl_compressImagesWithMaxFloat:(CGFloat)maxFloat{
    NSMutableArray *sendImageArray = [NSMutableArray arrayWithCapacity:self.count];
    CGFloat imageWidth = [UIScreen mainScreen].bounds.size.width * 3;
    [self enumerateObjectsUsingBlock:^(UIImage *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            UIImage *sourceImage = (UIImage *)obj;
            obj = [self imageCompress:sourceImage ForWidth:imageWidth];
            NSData *imageData = UIImageJPEGRepresentation(obj, 1);
            CGFloat maxSize = maxFloat;  //单位kb
            if([imageData length]/1024 > maxSize){
                CGFloat biLi = maxSize / ([imageData length]/1024.0);
                CGFloat imageWidthHou = imageWidth * biLi;
                obj = [self imageCompress:sourceImage ForWidth:imageWidthHou];
                imageData = UIImageJPEGRepresentation(obj, 1);
            }
            
            UIImage * imageCompress = [UIImage imageWithData:imageData];
            [sendImageArray addObject:imageCompress];
        }
    }];
    return sendImageArray;
}

//base64编码图片
- (NSString *)xhl_backBase64ImageStr{
    
    //图片转base64编码的字符串
    __block NSString *imgs = @"";
    [self enumerateObjectsUsingBlock:^(UIImage *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIImage class]]) {
            NSData *data = UIImageJPEGRepresentation(obj, 1.0f);
            NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            if (idx == 0) {
                imgs = encodedImageStr;
            }else{
                imgs = [NSString stringWithFormat:@"%@,%@",imgs,encodedImageStr];
            }
        }

    }];
    return imgs;
}

//改变图片 尺寸  宽度为屏幕宽度 高度自适应
- (UIImage *)imageCompress:(UIImage *)image ForWidth:(CGFloat)defineWidth{
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [image drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// Log
- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"[\n"];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        for (int i = 0; i <= level; i++) { [string appendString:@"  "]; }
        if ([obj respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
            [string appendFormat:@"%@,\n", [obj descriptionWithLocale:locale indent:level + 1]];
        } else {
            [string appendFormat:@"%@,\n", obj];
        }
        
    }];
    for (int i = 0; i < level; i++) { [string appendString:@"  "]; }
    [string appendString:@"]"];
    NSRange range = [string rangeOfString:@"," options:NSBackwardsSearch];
    if (range.location != NSNotFound) { [string deleteCharactersInRange:range]; }
    return string;
}
@end
