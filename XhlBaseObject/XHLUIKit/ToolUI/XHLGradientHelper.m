//
//  XHLGradientHelper.m
//  Example
//
//  Created by whbalzac on 3/20/17.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "XHLGradientHelper.h"

#define UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFronHSB(h,s,b)               [UIColor colorWithHue:h saturation:s brightness:b alpha:1.0f]


@implementation XHLGradientHelper

#pragma mark - Linear Gradient

+ (UIImage *)xhl_getLinearGradientImage:(UIColor *)startColor and:(UIColor *)endColor directionType:(XHLGradientDirection)directionType
{
    return [self xhl_getLinearGradientImage:startColor and:endColor directionType:directionType option:CGSizeMake(kDefaultWidth, kDefaultHeight)];
}


+ (UIImage *)xhl_getLinearGradientImage:(UIColor *)startColor and:(UIColor *)endColor directionType:(XHLGradientDirection)directionType option:(CGSize)size
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)startColor.CGColor,
                             (__bridge id)endColor.CGColor];
    gradientLayer.locations = @[@(0.0f), @(1.0f)];
    
    if (directionType == XHLGradientFromLeftToRight) {
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
    }else if (directionType == XHLGradientFromTopToBottom){
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
    }else if (directionType == XHLGradientFromLeftTopToRightBottom){
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
    }else if (directionType == XHLGradientFromLeftBottomToRightTop){
        gradientLayer.startPoint = CGPointMake(0, 1);
        gradientLayer.endPoint = CGPointMake(1, 0);
    }
    
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(gradientLayer.frame.size, NO, 0);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return gradientImage;
}


#pragma mark - Radial Gradient

+ (UIImage *)xhl_getRadialGradientImage:(UIColor *)centerColor and:(UIColor *)outColor
{
    return [self xhl_getRadialGradientImage:centerColor and:outColor option:CGSizeMake(kDefaultWidth, kDefaultWidth)];
}

+ (UIImage *)xhl_getRadialGradientImage:(UIColor *)centerColor and:(UIColor *)outColor option:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat raduis = MAX(size.width / 2, size.height / 2);
    CGPathAddArc(path, NULL, size.width / 2, size.height / 2, raduis, 0, 2 * M_PI, NO);
    
    [self drawRadialGradient:gc path:path startColor:centerColor.CGColor endColor:outColor.CGColor];
    CGPathRelease(path);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

//   ChromatoAnimation
+ (void)xhl_addGradientChromatoAnimation:(UIView *)view
{
    if (view == nil) {
        return;
    }
    
    CGFloat btnHeight = view.bounds.size.height;;
    CGFloat btnWidth = view.bounds.size.width;
    
    CAGradientLayer *chromatoLayer = [CAGradientLayer layer];
    [chromatoLayer setColors:@[(__bridge id)UIColorFronHSB(0.63, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.75, 0.69, 0.88).CGColor]];
    [chromatoLayer setStartPoint:CGPointMake(0, 0)];
    [chromatoLayer setEndPoint:CGPointMake(1, 0)];
    chromatoLayer.locations = @[@(0.0f) ,@(1.0f)];
    [chromatoLayer setFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    
    CAKeyframeAnimation *chromateAnimate = [self createGradientChromatoKeyAnimation];
    
    [chromatoLayer addAnimation:chromateAnimate forKey:@"chromateAnimate"];
    
    if (chromatoLayer.superlayer == nil) {
        [view.layer insertSublayer:chromatoLayer below:view.layer.sublayers[0]];
    }
}

+ (void)xhl_addLinearGradientForLable:(UILabel *)lable start:(UIColor *)startColor and:(UIColor *)endColor
{
    UIView *parentView = lable.superview;
    if (parentView == nil || lable == nil) {
        return;
    }
    
    CAGradientLayer *chromatoLayer = [CAGradientLayer layer];
    [chromatoLayer setColors:@[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor]];
    [chromatoLayer setStartPoint:CGPointMake(0, 0)];
    [chromatoLayer setEndPoint:CGPointMake(1, 0)];
    chromatoLayer.locations = @[@(0.0f) ,@(1.0f)];
    [chromatoLayer setFrame:parentView.frame];
    
    [parentView.layer addSublayer:chromatoLayer];
    chromatoLayer.mask = lable.layer;
    chromatoLayer.frame = chromatoLayer.bounds;
}

+ (void)xhl_addGradientChromatoAnimationForLable:(UILabel *)lable{
    UIView *parentView = lable.superview;
    if (parentView == nil || lable == nil) {
        return;
    }
    
    CAGradientLayer *chromatoLayer = [CAGradientLayer layer];
    [chromatoLayer setColors:@[(__bridge id)UIColorFronHSB(0.63, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.75, 0.69, 0.88).CGColor]];
    [chromatoLayer setStartPoint:CGPointMake(0, 0)];
    [chromatoLayer setEndPoint:CGPointMake(1, 0)];
    chromatoLayer.locations = @[@(0.0f) ,@(1.0f)];
    [chromatoLayer setFrame:parentView.frame];
    
    CAKeyframeAnimation *chromateAnimate = [self createGradientChromatoKeyAnimation];
    
    [chromatoLayer addAnimation:chromateAnimate forKey:@"chromateAnimate"];
    
    [parentView.layer addSublayer:chromatoLayer];
    chromatoLayer.mask = lable.layer;
    chromatoLayer.frame = chromatoLayer.bounds;
}


#pragma mark - private method

+ (CAKeyframeAnimation *)createGradientChromatoKeyAnimation
{
    CAKeyframeAnimation *chromateAnimate = [CAKeyframeAnimation animationWithKeyPath:@"colors"];
    
    chromateAnimate.values = @[@[(__bridge id)UIColorFronHSB(0.63, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.75, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.73, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.85, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.83, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.95, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.88, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(1, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.98, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.1, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(1, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.12, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.1, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.22, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.2, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.32, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.3, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.42, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.4, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.52, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.5, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.62, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.6, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.72, 0.69, 0.88).CGColor],
                               @[(__bridge id)UIColorFronHSB(0.63, 0.69, 0.88).CGColor, (__bridge id)UIColorFronHSB(0.75, 0.69, 0.88).CGColor]];
    chromateAnimate.keyTimes = @[@0, @0.1, @0.2, @0.25, @0.35, @0.37, @0.47, @0.57, @0.67, @0.77, @0.87, @0.97, @1];
    chromateAnimate.duration = 6;
    chromateAnimate.removedOnCompletion = NO;
    chromateAnimate.repeatCount = MAXFLOAT;
    
    return chromateAnimate;
}

@end
