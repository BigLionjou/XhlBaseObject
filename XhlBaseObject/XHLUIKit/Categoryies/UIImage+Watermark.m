//
//  UIImage+Watermark.m
//  mn_tools
//
//  Created by xhl on 2021/8/5.
//

#import "UIImage+Watermark.h"
#import "NSDictionary+XhlCategory.h"

@implementation UIImage (Watermark)

- (UIImage *)syncImageWithUrl:(NSString *)url{
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [UIImage imageWithData:data];
    return image;
}
- (UIImage *)addWatermarkWithWatermarkInfo:(NSDictionary *)watermarkInfo {
    
    NSString *imageUrl = [watermarkInfo xhl_dicStringForKey:@"imageUrl"];
    NSInteger markPosition = [watermarkInfo xhl_dicIntegerForKey:@"markPosition"];
    NSInteger insetBottom = [watermarkInfo xhl_dicIntegerForKey:@"insetBottom"];
    NSInteger insetLeft = [watermarkInfo xhl_dicIntegerForKey:@"insetLeft"];
    NSInteger insetRight = [watermarkInfo xhl_dicIntegerForKey:@"insetRight"];
    NSInteger insetTop = [watermarkInfo xhl_dicIntegerForKey:@"insetTop"];
    CGFloat scale = [watermarkInfo xhl_dicFloatForKey:@"scale"];
    CGFloat opacity = [watermarkInfo xhl_dicFloatForKey:@"opacity"];
    
    UIImage *waterImage = [self syncImageWithUrl:imageUrl];
    waterImage = [self imageByApplyingAlpha:opacity image:waterImage];
    
    UIGraphicsBeginImageContext(self.size);
    
    // 原始图片渲染
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    if (scale >1 || scale <= 0) {
        scale = 1;
    }
    CGFloat waterX = 0;
    CGFloat waterY = 0;
    CGFloat waterW = self.size.width *scale;
    CGFloat waterH = waterImage.size.height * waterW/waterImage.size.width;
    
    switch (markPosition) {
        case WaterImageLocationCenter:
            waterX = self.size.width/2 - waterW/2;
            waterY = self.size.height/2 - waterH/2;
            break;
        case WaterImageLocationTopLeft:
            waterX = 0 + insetLeft;
            waterY = 0 + insetTop;
            break;
        case WaterImageLocationTopRight:
            waterX = self.size.width - waterW - insetRight;
            waterY = 0 + insetTop;
            break;
        case WaterImageLocationBottomLeft:
            waterX = 0 + insetLeft;
            waterY = self.size.height - waterH - insetBottom;
            break;
        case WaterImageLocationBottomRight:
            waterX = self.size.width - waterW - insetLeft;
            waterY = self.size.height - waterH - insetBottom;
            break;
        case WaterImageLocationTop:
            waterX = self.size.width/2 - waterW/2;
            waterY = 0 + insetTop;
            break;
        case WaterImageLocationLeft:
            waterX = 0 + insetLeft;
            waterY = self.size.height/2 - waterH/2;
            break;
        case WaterImageLocationRight:
            waterX = self.size.width - waterW - insetRight;
            waterY = self.size.height/2 - waterH/2;
            break;
        case WaterImageLocationBottom:
            waterX = self.size.width/2 - waterW/2;
            waterY = self.size.height - waterH - insetBottom;
            break;
        default:
            break;
    }
    CGRect waterRect = CGRectMake(waterX, waterY, waterW, waterH);
    [waterImage drawInRect:waterRect];
    UIGraphicsEndPDFContext();
    UIImage * imageNew = UIGraphicsGetImageFromCurrentImageContext();
    return imageNew;
}
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
