//
//  XhlButtonConfigModel.m
//  XhlWebView
//
//  Created by gongkuihua on 2022/8/8.
//

#import "XhlButtonConfigModel.h"
#import "NSDictionary+XhlCategory.h"

@implementation XhlButtonConfigModel
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        if ([dict.allKeys containsObject:@"title"]) {
            self.title = xhl_dicString(dict, @"title");
        }
        if ([dict.allKeys containsObject:@"selectTitle"]) {
            self.selectTitle = xhl_dicString(dict, @"selectTitle");
        }
        if ([dict.allKeys containsObject:@"type"]) {
            self.type = xhl_dicString(dict, @"type");
        }
        if ([dict.allKeys containsObject:@"selectIcon"]) {
            self.selectIcon = xhl_dicString(dict, @"selectIcon");
        }
        if ([dict.allKeys containsObject:@"icon"]) {
            self.icon = xhl_dicString(dict, @"icon");
        }
        if ([dict.allKeys containsObject:@"defaultIcon"]) {
            self.icon = xhl_dicString(dict, @"defaultIcon");
        }
        if ([dict.allKeys containsObject:@"event"]) {
            self.event = xhl_dicString(dict, @"event");
        }
      
       
    }
    return self;
}
@end
