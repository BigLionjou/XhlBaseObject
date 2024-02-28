//
//  XhlLabelImage.m
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2023/2/8.
//

#import "XhlLabelImage.h"
#import "XhlBaseObject.h"
#import "UIColor+XhlCategory.h"

@implementation XhlLabelImage

+ (UIImage *)pictureCountImageWithText:(NSString *)text{
 
    //初始化并绘制UI
    UIImage *view = [self graphicsWithSize:CGSizeMake(0, 18)
                                  text:text
                            textColor:[UIColor whiteColor]
                       textFontOfSize:12
                      backGroundColor:[UIColor xhl_colorWithHexAlphaHex:0x000000 alpha:0.5]
                           backGroundImage:nil
                         cornerRadius:9
                          borderWidth:0
                          borderColor:nil
                           edgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    
    return  view;
    
}

+ (UIImage *)imageWithText:(NSString *)text
                 textColor:(UIColor * _Nullable)textColor
           textFontOfSize:(CGFloat)textFontOfSize
          backGroundColor:(UIColor * _Nullable)backGroundColor
           backGroundImage:(NSString * _Nullable)backGroundImage
             cornerRadius:(CGFloat)cornerRadius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *_Nullable)borderColor
                edgeInsets:(UIEdgeInsets)edgeInsets
{
    
   
    
    //初始化并绘制UI
    UIImage *view = [self imageWithText:text size:CGSizeZero textColor:textColor textFontOfSize:textFontOfSize backGroundColor:backGroundColor backGroundImage:backGroundImage cornerRadius:cornerRadius borderWidth:borderWidth borderColor:borderColor edgeInsets:edgeInsets];
    
   
    return  view;
}

+ (UIImage *)imageWithText:(NSString *)text
                      size:(CGSize)size
                 textColor:(UIColor * _Nullable)textColor
           textFontOfSize:(CGFloat)textFontOfSize
          backGroundColor:(UIColor * _Nullable)backGroundColor
           backGroundImage:(NSString * _Nullable)backGroundImage
             cornerRadius:(CGFloat)cornerRadius
              borderWidth:(CGFloat)borderWidth
              borderColor:(UIColor *_Nullable)borderColor
                edgeInsets:(UIEdgeInsets)edgeInsets {
    //初始化并绘制UI
    UIImage *view = [self graphicsWithSize:size
                                  text:text
                            textColor:textColor
                       textFontOfSize:textFontOfSize
                      backGroundColor:backGroundColor
                           backGroundImage:backGroundImage
                         cornerRadius:cornerRadius
                          borderWidth:borderWidth
                          borderColor:borderColor
                           edgeInsets:edgeInsets];
    
   
    return  view;
}

+ (UIImage *)graphicsWithSize:(CGSize)size
                     text:(NSString *)text
               textColor:(UIColor *)textColor
          textFontOfSize:(CGFloat)textFontOfSize
         backGroundColor:(UIColor *)backGroundColor
              backGroundImage:(NSString * _Nullable)backGroundImage
            cornerRadius:(CGFloat)cornerRadius
             borderWidth:(CGFloat)borderWidth
             borderColor:(UIColor *)borderColor
              edgeInsets:(UIEdgeInsets)edgeInsets
                   
{

    //将全部值 组合为 key 生成完的image 会通过SDWebImage 保存下来
//    NSString *key = [[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",NSStringFromCGSize(size),text,textColor.sd_hexString,@(textFontOfSize),backGroundColor.sd_hexString,@(cornerRadius),@(borderWidth),borderColor.sd_hexString,NSStringFromUIEdgeInsets(edgeInsets)] xhl_md5];
//    NSLog(@"HwszLabelImage key = %@",key);
//    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
//    if(image){
//        UIImage *tempiamge = [UIImage imageWithData:image.sd_imageData scale:[UIScreen mainScreen].scale];
//        NSLog(@"HwszLabelImage Cache %@ scale %@",NSStringFromCGSize(tempiamge.size),@(tempiamge.scale));
//        return tempiamge;
//    }else{
        //初始化并绘制UI
        UIView *view = [self initWithSize:size
                                      text:text
                                textColor:textColor
                           textFontOfSize:textFontOfSize
                          backGroundColor:backGroundColor
                          backGroundImage:backGroundImage
                             cornerRadius:cornerRadius
                              borderWidth:borderWidth
                              borderColor:borderColor
                               edgeInsets:edgeInsets];
        
        UIImage *drowimage = [self graphicsBeginImageContextWithView:view];
        NSLog(@"HwszLabelImage drowimage %@ scale %@",NSStringFromCGSize(drowimage.size),@(drowimage.scale));
//        [[SDImageCache sharedImageCache] storeImage:drowimage forKey:key completion:nil];
        return drowimage;
//    }
    
    
}


+ (UIImage *)graphicsBeginImageContextWithView:(UIView *)view{
    // 0.0  自动使用 [UIScreen mainScreen].scale
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
}


//有size.w 传入左右偏移会失效 会使用中心点 但总w会加上左右偏移量
//有size.h 传入上下偏移会失效 会使用中心点  但总h会加上上下偏移量
+ (UIView *)initWithSize:(CGSize)size
                     text:(NSString *)text
               textColor:(UIColor *)textColor
          textFontOfSize:(CGFloat)textFontOfSize
         backGroundColor:(UIColor *)backGroundColor
         backGroundImage:(NSString * _Nullable)backGroundImage
            cornerRadius:(CGFloat)cornerRadius
             borderWidth:(CGFloat)borderWidth
             borderColor:(UIColor *)borderColor
              edgeInsets:(UIEdgeInsets)edgeInsets
                   
{
 
    UIView *backView = [[UIView alloc] init];
    UIImageView *bgImageView = [[UIImageView alloc] init];
    if (!Xhl_StringIsEmpty(backGroundImage)) {
        bgImageView.image = [UIImage imageNamed:backGroundImage];
    }
    if(backGroundColor){
        backView.backgroundColor = backGroundColor;
    }else{
        backView.backgroundColor = [UIColor clearColor];
    }
    if(cornerRadius>0){
        backView.layer.masksToBounds = true;
        backView.layer.cornerRadius = cornerRadius;
    }
    if(borderWidth>0){
        backView.layer.borderWidth = borderWidth;
        if(borderColor){
            backView.layer.borderColor =  borderColor.CGColor;
        }
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.textAlignment = NSTextAlignmentCenter;
    if(textColor){
        label.textColor = textColor;
    }
    if(textFontOfSize>0){
        label.font = [UIFont systemFontOfSize:textFontOfSize];
    }else{
        label.font = [UIFont systemFontOfSize:16];
    }
    [label sizeToFit];
    
    
    if(UIEdgeInsetsEqualToEdgeInsets(edgeInsets, UIEdgeInsetsZero)){
        
        if(CGSizeEqualToSize(size, CGSizeZero)){
            [backView setBounds:CGRectMake(0, 0, CGRectGetWidth(label.bounds), CGRectGetHeight(label.bounds))];
        }else{
            CGFloat wtemp =  CGRectGetWidth(label.bounds);
            CGFloat htemp =  CGRectGetHeight(label.bounds);
            if(size.width>0){
                wtemp = size.width;
            }
            if(size.height>0){
                htemp = size.height;
            }
            [backView setBounds:CGRectMake(0, 0, wtemp, htemp)];
        }
    }else{
        if(CGSizeEqualToSize(size, CGSizeZero)){
            CGPoint labelpoint = label.center;
            [label setCenter:CGPointMake(labelpoint.x+edgeInsets.left, labelpoint.y+edgeInsets.top)];
            [backView setBounds:CGRectMake(0, 0, CGRectGetWidth(label.bounds)+edgeInsets.left+edgeInsets.right, CGRectGetHeight(label.bounds)+edgeInsets.top+edgeInsets.bottom)];
        }else{
            
            CGFloat wtemp =  CGRectGetWidth(label.bounds)+edgeInsets.left+edgeInsets.right;
            CGFloat htemp =  CGRectGetHeight(label.bounds)+edgeInsets.top+edgeInsets.bottom;
            CGPoint labelpoint = label.center;
            CGFloat labelx = labelpoint.x+edgeInsets.left;
            CGFloat labely = labelpoint.y+edgeInsets.top;
            if(size.width>0){
                wtemp = size.width;
                labelx = wtemp/2.0;
            }
            if(size.height>0){
                htemp = size.height;
                labely = htemp/2.0;
            }
            [backView setBounds:CGRectMake(0, 0, wtemp, htemp)];
            [label setCenter:CGPointMake(labelx, labely)];
        }
        
    }
    bgImageView.frame = backView.bounds;
    [backView addSubview:bgImageView];
    [backView addSubview:label];
    
    return backView;
}

@end
