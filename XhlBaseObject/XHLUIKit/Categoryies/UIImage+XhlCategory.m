//
//  UIImage+XHL.m
//  XhlBaseObjectDemo
//
//  Created by 龚魁华 on 2019/6/23.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UIImage+XhlCategory.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (XHLCategory)


/// 获取视频的第一秒 第10帧图片
- (UIImage *)xhl_getVidoUrlsFirstImage:(NSString *)urlstr{
    
    return [self xhl_getVidoUrlsFirstImage:urlstr timeSeconds:0 painting:10];
}
// 获取视频的某一帧图片
- (UIImage *)xhl_getVidoUrlsFirstImage:(NSString *)urlstr
                           timeSeconds:(NSInteger)timeSeconds
                              painting:(NSInteger)painting{
    
    NSURL *url = [NSURL URLWithString:urlstr];
    //根据url创建AVURLAsset
    AVURLAsset *urlAsset=[AVURLAsset assetWithURL:url];
    //根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator=[AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    /*截图
     * requestTime:缩略图创建时间
     * actualTime:缩略图实际生成的时间
     */
    NSError *error=nil;
    CMTime time=CMTimeMakeWithSeconds(timeSeconds, painting);//CMTime是表示视频时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actualTime;
    CGImageRef cgImage= [imageGenerator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if(error){
        NSLog(@"截取视频缩略图时发生错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    CMTimeShow(actualTime);
    //转化为UIImage
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    return image;
}

//改变图片 尺寸  宽度为屏幕宽度 高度自适应
- (UIImage *)xhl_imageCompressForWidth:(CGFloat)defineWidth{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [self drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//颜色转图片
+ (UIImage *)xhl_createImageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//颜色转图片
+ (UIImage *)xhl_createImageWithColor:(UIColor *)color toSize:(CGSize)size{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


- (NSString *)xhl_imagebase64Str{
    UIImage *image = self;
    if (!image) {
        return @"";
    }
    CGFloat imageWidth = [UIScreen mainScreen].bounds.size.width * 3;
    image = [self xhl_imageCompressForWidth:imageWidth];
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    NSLog(@"图片大小：%ldK", [imageData length]/1024);
    CGFloat maxSize = 700.0;  //单位kb
    if([imageData length]/1024 > maxSize)
    {
        CGFloat biLi = maxSize / ([imageData length]/1024.0);
        CGFloat imageWidthHou = imageWidth * biLi;
        image = [self xhl_imageCompressForWidth:imageWidthHou];
        imageData = UIImageJPEGRepresentation(image, 1);
        NSLog(@"目前图片大小：%ldK", [imageData length]/1024);
    }
    
    UIImage * imageCompress = [UIImage imageWithData:imageData];
    
    NSData *data = UIImageJPEGRepresentation(imageCompress, 1.0f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return encodedImageStr;
}

//旋转图片成垂直
-(UIImage *)xhl_orientationUpImage{
    UIImageOrientation imageOrientation = self.imageOrientation;
    UIImage *imageTmp;
    if(imageOrientation != UIImageOrientationUp){
        UIGraphicsBeginImageContext(self.size);
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        imageTmp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    if (imageTmp) {
        return imageTmp;
    }else{
        return self;
    }
}

/**
 根据图片判断是横屏还是竖屏

 @return 1:竖屏。2:横屏
 */

- (NSString *)xhl_judgeHorizontal{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat hight = CGImageGetHeight(self.CGImage);
    if (width>hight) {
        return @"1";
    }else{
        return @"2";
    }
}

//图片转data
-(NSData *)xhl_dataWithImageWithCompression: (CGFloat)Compression
                             andMaxSize: (CGFloat)maxSize
                          andImageWidth: (CGFloat)imageWidth{
    NSData *imageData = UIImageJPEGRepresentation(self, Compression);
    NSLog(@"转化前图片大小：%ldK", [imageData length]/1024);
    if([imageData length]/1024 > maxSize)
    {
        CGFloat biLi = maxSize / ([imageData length]/1024.0);
        CGFloat imageWidthHou = imageWidth * biLi;
        UIImage *imageTemp = [self xhl_imageCompressForWidth:imageWidthHou];
        imageData = UIImageJPEGRepresentation(imageTemp, 1);
        NSLog(@"转化后图片大小：%ldK", [imageData length]/1024);
    }
    return imageData;
}

+ (UIImage *)xhl_strechImage:(UIImage *)aOriginImage capInsets:(UIEdgeInsets)aCapInsets resizingMode:(UIImageResizingMode)aResizingMode
{
    if (aOriginImage == nil)
    {
        return nil;
    }
    
    // 仅支持两种拉伸方式（Tile & strench）
    if (aResizingMode != UIImageResizingModeTile && aResizingMode != UIImageResizingModeStretch)
    {
        aResizingMode = UIImageResizingModeStretch;
    }
    UIImage *strechedImage = nil;
    
    strechedImage = [aOriginImage resizableImageWithCapInsets:aCapInsets resizingMode:aResizingMode];
    
    return strechedImage;
}

+ (UIImage *)xhl_zoomImage:(UIImage *)aSourceImage zoomRatio:(CGFloat)aRatio
{
    if (aSourceImage == nil)
        return nil;
    
    CGSize newSize = CGSizeMake(floor(aSourceImage.size.width * aRatio), floor(aSourceImage.size.height * aRatio));
    
    // 按照目标区域进行缩放
    UIGraphicsBeginImageContext(newSize);
    [aSourceImage drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)xhl_scale:(UIImage *)image toSize:(CGSize)size
{
    if (image == nil) return nil;
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


+(UIImage *)xhl_scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (UIImage *)xhl_rotationImage:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
}


+ (UIImage *)xhl_rotateImage:(UIImage *)aImage by:(UIImageOrientation)orient
{
    CGImageRef imgRef = aImage.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    
    switch(orient)
    {
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
    }
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}

- (UIImage *)xhl_rotateImagebyRadian:(CGFloat)radian
{
    CGRect sizeRect = (CGRect) {.size = self.size};
    CGSize destinationSize = sizeRect.size;
    
    // Draw image
    UIGraphicsBeginImageContextWithOptions(destinationSize, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context)
    {
        return nil;
    }
    CGContextTranslateCTM(context, destinationSize.width / 2.0f, destinationSize.height / 2.0f);
    CGContextRotateCTM(context, radian);
    [self drawInRect:CGRectMake(-self.size.width / 2.0f, -self.size.height / 2.0f, self.size.width, self.size.height)];
    
    // Save image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //    NSLog(@"xhl_rotateImagebyRadian(%f)=%@, self.size=%@", radian, NSStringFromCGSize(newImage.size), NSStringFromCGSize(self.size));
    return newImage;
}

//将图片转成需要的颜色
+ (UIImage *)xhl_colorizeImage:(UIImage *)baseImage withColor:(UIColor *)theColor {
    UIGraphicsBeginImageContext(baseImage.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, baseImage.size.width, baseImage.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSaveGState(ctx);
    CGContextClipToMask(ctx, area, baseImage.CGImage);
    
    [theColor set];
    CGContextFillRect(ctx, area);
    
    CGContextRestoreGState(ctx);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextDrawImage(ctx, area, baseImage.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)xhl_imageNamed:(NSString *)named tintColor:(UIColor *)tintColor{
    return [UIImage xhl_imageNamed:named tintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}
+ (UIImage *)xhl_imageNamed:(NSString *)named GradientTintColor:(UIColor *)tintColor{
    return [UIImage xhl_imageNamed:named tintColor:tintColor blendMode:kCGBlendModeOverlay];
}
+ (UIImage *)xhl_imageNamed:(NSString *)named tintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode{
    
    UIImage *image = [UIImage imageNamed:named];
    [image xhl_imageWithTintColor:tintColor blendMode:blendMode];
    return image;
    
}
- (UIImage *)xhl_imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


+ (UIImage*)xhl_createGradientRectImageWithBounds:(CGRect)bounds Colors:(NSArray*)colors GradientType:(int)gradientType {
    NSMutableArray *cgcolorArr = [NSMutableArray array];
    for(UIColor *col in colors) {
        [cgcolorArr addObject:(id)col.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)cgcolorArr, NULL);
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    if (gradientType == 3) {
        startPoint = CGPointMake(0.0, bounds.size.height);
    }
    CGPoint endPoint = CGPointZero;
    switch (gradientType) {
        case 0:
            endPoint = CGPointMake(bounds.size.width, 0.0);
            break;
        case 1:
            endPoint = CGPointMake(0.0, bounds.size.width);
            break;
        case 2:
            endPoint = CGPointMake(bounds.size.width, bounds.size.height);
            break;
        case 3:
            endPoint = CGPointMake(bounds.size.width, 0.0);
            break;
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end


