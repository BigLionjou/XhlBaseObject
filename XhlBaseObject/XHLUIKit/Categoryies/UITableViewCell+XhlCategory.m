//
//  UITableViewCell+XHLCell.m
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/5/14.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UITableViewCell+XhlCategory.h"
#import <objc/runtime.h>
#import <objc/message.h>

static NSString *key_xhlBaseObject_bottomLine = @"key_xhlBaseObject_bottomLine";
static NSString *key_xhlBaseObject_leftSpace = @"key_xhlBaseObject_leftSpace";
static NSString *key_xhlBaseObject_rightSpace = @"key_xhlBaseObject_rightSpace";
static NSString *key_xhlBaseObject_lineColor = @"key_xhlBaseObject_lineColor";
static NSString *key_xhlBaseObject_isShowBottomLine = @"key_xhlBaseObject_isShowBottomLine";

@interface UITableViewCell()

@property (nonatomic, strong) CAShapeLayer *bottomLine;

@property (nonatomic, assign) CGFloat leftSpace;

@property (nonatomic, assign) CGFloat rightSpace;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, assign) BOOL isShowBottomLine;

@end

@implementation UITableViewCell (XHLCategory)

#pragma mark - Public Method

- (void)setShowDefaultBottomLine:(BOOL)is leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpace {
    self.leftSpace = leftSpace;
    self.rightSpace = rightSpace;
    self.isShowBottomLine = is;
    self.lineColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1];
    
    [self setNeedsDisplay];
}

- (void)setShowBottomLine:(BOOL)is leftSpace:(CGFloat)leftSpace rightSpace:(CGFloat)rightSpace lineColor:(UIColor *)color {
    self.leftSpace = leftSpace;
    self.rightSpace = rightSpace;
    self.isShowBottomLine = is;
    self.lineColor = color;
    
    [self setNeedsDisplay];
}

#pragma mark - Runtime绑定属性

- (void)setBottomLine:(CAShapeLayer *)bottomLine {
    objc_setAssociatedObject(self, &key_xhlBaseObject_bottomLine, bottomLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)bottomLine {
    return objc_getAssociatedObject(self, &key_xhlBaseObject_bottomLine);
}

- (void)setLeftSpace:(CGFloat)leftSpace {
    objc_setAssociatedObject(self, &key_xhlBaseObject_leftSpace, @(leftSpace), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)leftSpace {
    NSNumber *numberValue = objc_getAssociatedObject(self, &key_xhlBaseObject_leftSpace);
    return [numberValue intValue];
}

- (void)setRightSpace:(CGFloat)rightSpace {
    objc_setAssociatedObject(self, &key_xhlBaseObject_rightSpace, @(rightSpace), OBJC_ASSOCIATION_ASSIGN);
}

- (CGFloat)rightSpace {
    NSNumber *numberValue = objc_getAssociatedObject(self, &key_xhlBaseObject_rightSpace);
    return [numberValue intValue];
}

- (void)setLineColor:(UIColor *)lineColor {
    objc_setAssociatedObject(self, &key_xhlBaseObject_lineColor, lineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)lineColor {
    return objc_getAssociatedObject(self, &key_xhlBaseObject_lineColor);
}

- (void)setIsShowBottomLine:(BOOL)isShowBottomLine {
    objc_setAssociatedObject(self, &key_xhlBaseObject_isShowBottomLine, @(isShowBottomLine), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isShowBottomLine {
    NSNumber *numberValue = objc_getAssociatedObject(self, &key_xhlBaseObject_isShowBottomLine);
    return [numberValue intValue];
}

#pragma mark - 方法交换

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        // 替换viewWillDisappear
        SEL d_originalSelector = @selector(drawRect:);
        SEL d_swizzledSelector = @selector(xhl_baseobject_drawRect:);
        
        Method d_originalMethod = class_getInstanceMethod(class, d_originalSelector);
        Method d_swizzledMethod = class_getInstanceMethod(class, d_swizzledSelector);
        
        BOOL d_didAddMethod =
        class_addMethod(class,
                        d_originalSelector,
                        method_getImplementation(d_swizzledMethod),
                        method_getTypeEncoding(d_swizzledMethod));
        
        if (d_didAddMethod) {
            class_replaceMethod(class,
                                d_swizzledSelector,
                                method_getImplementation(d_originalMethod),
                                method_getTypeEncoding(d_originalMethod));
        } else {
            method_exchangeImplementations(d_originalMethod, d_swizzledMethod);
        }
    });
}

- (void)xhl_baseobject_drawRect:(CGRect)rect {
    [self xhl_baseobject_drawRect:rect];
    
    if(![self isKindOfClass:[UITableViewCell class]]) {
        return;
    }
    
    if(self.isShowBottomLine) {
        
        self.bottomLine.hidden = NO;
        
        UIBezierPath *pathOne = [UIBezierPath bezierPath];
        pathOne.lineWidth = 0.5;
        [pathOne moveToPoint:CGPointMake(self.leftSpace, CGRectGetHeight(self.frame) - 0.5)];
        [pathOne addLineToPoint:CGPointMake(CGRectGetWidth(self.frame) - self.rightSpace, CGRectGetHeight(self.frame) - 0.5)];
        [pathOne stroke];
        
        if(!self.bottomLine) {
            self.bottomLine = [CAShapeLayer layer];
            self.bottomLine.strokeColor = self.lineColor.CGColor;
            [self.layer addSublayer:self.bottomLine];
        }
        self.bottomLine.path = pathOne.CGPath;
    } else {
        self.bottomLine.hidden = YES;
    }
}

@end
