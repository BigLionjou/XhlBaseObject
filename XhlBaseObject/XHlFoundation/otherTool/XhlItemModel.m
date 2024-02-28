//
//  XhlItemModel.m
//  XhlBaseObjectDemo
//
//  Created by 龚魁华 on 2019/6/13.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "XhlItemModel.h"

@implementation XhlItemModel

- (BOOL)isEqual:(XhlItemModel *)object {
    if ([object isKindOfClass:[self class]] && self.data != nil) {
        return [self.data isKindOfClass:object.data];
    }
    return [super isEqual:object];
}

@end
