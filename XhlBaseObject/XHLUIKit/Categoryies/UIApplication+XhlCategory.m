//
//  UIApplication+XhlCategory.m
//  XhlBaseObject
//
//  Created by xiaoshiheng on 2022/4/22.
//

#import "UIApplication+XhlCategory.h"
#import "NSString+XhlCategory.h"
#import <objc/runtime.h>


NSString * const ApplicationOpenSDKStringRelax = @"relax";

NSString * const ApplicationOpenSDKStringUMShaer = @"UMShaer";

NSString * const ApplicationOpenSDKStringUMLogin = @"UMLogin";


@implementation UIApplication (XhlCategory)

- (BOOL)isUMShaer{
    if(Xhl_StringIsEmpty(self.state)){
        return NO;
    }
    
    if([self.state isEqualToString:ApplicationOpenSDKStringUMShaer] || [self.state isEqualToString:ApplicationOpenSDKStringUMLogin]){
        return YES;
    }

    return NO;
}

- (void)setState:(NSString *)state{
    objc_setAssociatedObject(self, @selector(state), state, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)state{
    return objc_getAssociatedObject(self, _cmd);
}



- (BOOL)isRestoration{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setIsRestoration:(BOOL)isRestoration{
    objc_setAssociatedObject(self, @selector(isRestoration), @(isRestoration), OBJC_ASSOCIATION_RETAIN);
}

@end
