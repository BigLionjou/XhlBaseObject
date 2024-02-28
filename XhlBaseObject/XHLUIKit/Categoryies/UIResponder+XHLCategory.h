//
//  UIResponder+CQCategory.h
//  PodManager
//
//  Created by 龚魁华 on 2018/7/12.
//  Copyright © 2018年 mn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (XHLCategory)

/*用例
 传值
 [self xhl_routerEventWithName:@"selectFile"
                        userInfo:@{@"cellHeight":@(nHeight),
                                    @"urls":urls,
                                    @"videoCover":self.videoCover}];
 
 接受值
 
 #pragma mark - event
 - (void)xhl_routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
         if ([eventName isEqualToString:@"selectFile"]) {
         NSArray *urls = cq_dicArray(userInfo, @"urls");
         self.model.listImgUrl = [urls backCommaStr];
         }
 }
 */

//子视图与父视图可以进行传值操作
- (void)xhl_routerEventWithName:(NSString *)eventName userInfo:(id)userInfo;

- (void)xhl_routerEventWithName:(NSString *)eventName userInfo:(id)userInfo complete:(void (^)(id parameter))complete;
@end
