//
//  UIView+XhlView.m
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/3/18.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "UIView+XhlCategory.h"
#import <objc/runtime.h>
static char xhl_kActionHandlerTapBlockKey;
static char xhl_kActionHandlerTapGestureKey;
static char xhl_kActionHandlerLongPressBlockKey;
static char xhl_kActionHandlerLongPressGestureKey;

@implementation UIView (XHLCategory)
@dynamic cornerRadius;
@dynamic borderWidth;
@dynamic borderColor;
@dynamic shadowOffset;
@dynamic shadowRadius;
@dynamic shadowOpacity;
@dynamic shadowColor;

- (void)xhl_addSubViews{}
- (void)xhl_configerSubView{}
- (void)xhl_loadLayouts{}
- (void)xhl_getData{}
- (void)xhl_refreshData:(id _Nonnull)data{}


- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = (cornerRadius>0);
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}
- (UIColor *)shadowColor{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}


- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}
- (CGSize)shadowOffset{
    return self.layer.shadowOffset;
}


- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (CGFloat)shadowRadius{
    return self.layer.shadowRadius;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}
- (CGFloat)shadowOpacity{
    return self.layer.shadowOpacity;
}



-(void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)x{
    return  self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGFloat)maxY{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)maxX{
    return CGRectGetMaxX(self.frame);
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (UIViewController *)xhl_firstAvailableUIViewController {
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (BOOL )xhl_getTopVCIsAlertController {
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *vc = [self topAlertController:rootVc];
    if([vc isKindOfClass:UIAlertController.class]){
        return YES;
    }
    return NO;
}

+ (BOOL )xhl_getTopVCIsAlertController{
    UIViewController *rootVc = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIView *view = rootVc.view;
    UIViewController *vc = [view topAlertController:(UIViewController *)rootVc];
    if([vc isKindOfClass:UIAlertController.class]){
        return YES;
    }
    return NO;
}

- (UIViewController *)topAlertController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topAlertController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = (UINavigationController*)rootViewController;
        return [self topAlertController:nav.visibleViewController];
    }else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topAlertController:presentedViewController];
    }else if ([rootViewController isKindOfClass:[UIAlertController class]]) {
        return rootViewController;
    } else {
        return rootViewController;
    }
}


- (UIViewController*)xhl_getTopViewController {
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self topViewControllerWithRootViewController:rootVc];
}

+ (UIViewController *)xhl_getTopViewController{
    UIViewController *rootVc = [UIApplication sharedApplication].delegate.window.rootViewController;
    UIView *view = rootVc.view;
    return [view topViewControllerWithRootViewController:(UIViewController *)rootVc];
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nav = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:nav.visibleViewController];
    }else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }else if ([rootViewController isKindOfClass:[UIAlertController class]]) {
        return rootViewController.presentingViewController;
    } else {
        return rootViewController;
    }
}

- (id)traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

- (id)xhl_findSubViewWithSubViewClass:(Class)clazz{
    NSArray *subviews = [self subviews];
    // 如果没有子视图就直接返回
    if ([subviews count] == 0) return nil;
    for (UIView *subview in subviews) {
        if ([subview isKindOfClass:clazz]) {
            return subview;
        }
        id findeView = [subview xhl_findSubViewWithSubViewClass:clazz];
        if (findeView) {
            // 递归获取此视图的子视图
            return  findeView;
        }
    }
    return nil;
}

- (id)xhl_findsuperViewWithSuperViewClass:(Class)clazz{
    if (self == nil) {
        return nil;
    } else if (self.superview == nil) {
        return nil;
    } else if ([self.superview isKindOfClass:clazz]) {
        return self.superview;
    } else {
        return [self.superview xhl_findsuperViewWithSuperViewClass:clazz];
    }
}

- (void)xhl_addTapActionWithBlock:(xhlGestureActionBlock)block{
    self.userInteractionEnabled = true;
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &xhl_kActionHandlerTapGestureKey);
    if (!gesture){
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xhl_handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &xhl_kActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &xhl_kActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)xhl_handleActionForTapGesture:(UITapGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateRecognized){
        xhlGestureActionBlock block = objc_getAssociatedObject(self, &xhl_kActionHandlerTapBlockKey);
        if (block)
        {
            block(gesture);
        }
    }
}

- (void)xhl_addLongPressActionWithBlock:(xhlGestureActionBlock)block{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &xhl_kActionHandlerLongPressGestureKey);
    if (!gesture){
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(xhl_handleActionForLongPressGesture:)];
        gesture.minimumPressDuration = 0.4f;
        gesture.numberOfTouchesRequired = 1;
        gesture.cancelsTouchesInView = YES;
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &xhl_kActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &xhl_kActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)xhl_handleActionForLongPressGesture:(UITapGestureRecognizer*)gesture{
    if (gesture.state == UIGestureRecognizerStateRecognized){
        xhlGestureActionBlock block = objc_getAssociatedObject(self, &xhl_kActionHandlerLongPressBlockKey);
        if (block){
            block(gesture);
        }
    }
}

//获取table
- (UITableView *)xhl_getTableView{
    //在cell中
    UITableView *table = [self xhl_findsuperViewWithSuperViewClass:[UITableView class]];
    if (table) {
        return table;
    }
    
    //在和TableVIew同一个vc中的View
    table = [self.xhl_firstAvailableUIViewController.view xhl_findSubViewWithSubViewClass:[UITableView class]];
    if (table) {
        return table;
    }
    
    //当自己和table产生不了关系时同一个vc中的View ,不使用多级栏目
    table = [self.xhl_getTopViewController.view xhl_findSubViewWithSubViewClass:[UITableView class]];
    if (table) {
        return table;
    }
    return nil;
}

//获取CollectionView
- (UICollectionView *)xhl_getCollectionView{
    //在cell中
    UICollectionView *collection = [self xhl_findsuperViewWithSuperViewClass:[UICollectionView class]];
    if (collection) {
        return collection;
    }
    
    //在和collection同一个vc中的View
    collection = [self.xhl_firstAvailableUIViewController.view xhl_findSubViewWithSubViewClass:[UICollectionView class]];
    if (collection) {
        return collection;
    }
    
    //当自己和collection产生不了关系时同一个vc中的View ,不使用多级栏目
    collection = [self.xhl_getTopViewController.view xhl_findSubViewWithSubViewClass:[UICollectionView class]];
    if (collection) {
        return collection;
    }
    return nil;
}

//获取WkWebView
- (WKWebView *)xhl_getWkWebView{
    //在和collection同一个vc中的View
    WKWebView *web = [self.xhl_firstAvailableUIViewController.view xhl_findSubViewWithSubViewClass:[WKWebView class]];
    if (web) {
        return web;
    }
    
    //在WKWebView上的View
    web = [self xhl_findsuperViewWithSuperViewClass:[WKWebView class]];
    if (web) {
        return web;
    }
    //当自己和collection产生不了关系时同一个vc中的View ,不使用多级栏目
    web = [self.xhl_getTopViewController.view xhl_findSubViewWithSubViewClass:[WKWebView class]];
    if (web) {
        return web;
    }
    return nil;
}

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}

/**
 移除当前所有 subviews
 */
- (void)xhl_removeAllSubviews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)xhl_addSubViews:(NSArray *)views{
    for (UIView *view in views) {
        [self addSubview:view];
    }
}




+ (NSInteger)numberOfLinesForLabel:(UILabel *)label withAttributedString:(NSAttributedString *)attributedString {
    // 1. 获取 UILabel 的宽度
    CGFloat labelWidth = label.frame.size.width;
    
    // 2. 设置最大尺寸，假设高度是无穷大，宽度是 Label 的宽度
    CGSize maxSize = CGSizeMake(labelWidth, CGFLOAT_MAX);
    
    // 3. 使用 boundingRectWithSize 计算文本所占的总高度
    CGRect textRect = [attributedString boundingRectWithSize:maxSize
                                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                     context:nil];
    
    // 4. 获取每行的高度
    CGFloat lineHeight = label.font.lineHeight;
    
    // 5. 计算总行数
    NSInteger numberOfLines = ceil(textRect.size.height / lineHeight);
    
    return numberOfLines;
}

@end
