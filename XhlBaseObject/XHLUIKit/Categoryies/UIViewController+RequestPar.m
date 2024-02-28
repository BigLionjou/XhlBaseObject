//
//  UIViewController+RequestPar.m
//  HlwNewsModule
//
//  Created by xiaoshiheng on 2022/6/7.
//

#import "UIViewController+RequestPar.h"
#import <objc/runtime.h>

@implementation UIViewController (RequestPar)



- (XhlViewType)xhlViewType{
    NSNumber *xhlViewType = objc_getAssociatedObject(self, _cmd);
    return xhlViewType.integerValue;
}
- (void)setXhlViewType:(XhlViewType)xhlViewType{
    objc_setAssociatedObject(self, @selector(xhlViewType), @(xhlViewType), OBJC_ASSOCIATION_ASSIGN);
}

- (NSDictionary<NSString *,id> *)requestPar{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setRequestPar:(NSDictionary<NSString *,id> *)requestPar{
    objc_setAssociatedObject(self, @selector(requestPar), requestPar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary<NSString *,id> *)parameterPar{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setParameterPar:(NSDictionary<NSString *,id> *)parameterPar{
    objc_setAssociatedObject(self, @selector(parameterPar), parameterPar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)templetCode{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setTempletCode:(NSString *)templetCode{
    
    objc_setAssociatedObject(self, @selector(templetCode), templetCode, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)setIsPushAf:(BOOL)isPushAf{
    objc_setAssociatedObject(self, @selector(isPushAf), @(isPushAf), OBJC_ASSOCIATION_ASSIGN);
}
- (BOOL)isPushAf{
    NSNumber *isPushAf = objc_getAssociatedObject(self, _cmd);
    return isPushAf.boolValue;
}

@end
