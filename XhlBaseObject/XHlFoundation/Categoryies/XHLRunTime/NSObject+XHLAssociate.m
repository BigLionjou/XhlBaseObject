//
//  NSObject+XHLAssociate.m
//  XHLPods
//
//  Created by xhl on 16/5/18.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import "NSObject+XHLAssociate.h"

@interface XHLAssociateWeakContainer : NSObject
@property (nonatomic, weak) id obj;
@end

@implementation XHLAssociateWeakContainer
@end


@implementation NSObject (XHLAssociate)

- (id)xhl_associateObjectForKey:(NSString *)key {
    if (!key) {
        return nil;
    }
    
    id content = objc_getAssociatedObject(self, (__bridge const void *)(key));
    if (content && [content isKindOfClass:[XHLAssociateWeakContainer class]]) {
        content = [(XHLAssociateWeakContainer *)content obj];
    }
    
    return content;
}

- (void)xhl_setAssociateObject:(id)object forKey:(NSString *)key {
    [self xhl_setAssociateObject:object forKey:key associationPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)xhl_setAssociateObject:(id)object forKey:(NSString *)key associationPolicy:(objc_AssociationPolicy)policy {
    if ([key isKindOfClass:[NSString class]] == NO || key.length == 0) {
        return;
    }
    
    id content = object;
    if ((policy == OBJC_ASSOCIATION_ASSIGN) && object) {
        XHLAssociateWeakContainer *weakContainer = objc_getAssociatedObject(self, (__bridge const void *)(key));
        if (weakContainer == nil || [weakContainer isKindOfClass:[XHLAssociateWeakContainer class]] == NO) {
            weakContainer = [XHLAssociateWeakContainer new];
        }
        weakContainer.obj = object;
        content = weakContainer;
        policy = OBJC_ASSOCIATION_RETAIN;
    }
    
    objc_setAssociatedObject(self, (__bridge const void *)(key), content, policy);
}

@end
