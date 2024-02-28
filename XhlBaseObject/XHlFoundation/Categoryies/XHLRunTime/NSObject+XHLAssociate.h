//
//  NSObject+XHLAssociate.h
//  XHLPods
//
//  Created by xhl on 16/5/18.
//  Copyright © 2016年 xhl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 * 关联对象的 get 和 set 方法
 * 详细介绍请看README-XHLRuntime
 */

@interface NSObject (XHLAssociate)

/**
 * @brief 关联对象的 get 方法
 *
 * @param key 关联对象的 key 值
 * @return id 关联对象
 */
- (id)xhl_associateObjectForKey:(NSString *)key;

/**
 * @brief 关联对象默认的 set 方法, 对应 strong 类型的属性修饰符，相当于 xhl_setAssociateObject: forKey: associationPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC
 *
 * @param object 关联对象
 * @param key 关联对象的 key 值
 */
- (void)xhl_setAssociateObject:(id)object forKey:(NSString *)key;

/**
 * @brief 关联对象的 set 方法
 *
 * @param object 关联对象
 * @param key 关联对象的 key 值
 * @param policy 属性修饰符，建议根据需要使用 OBJC_ASSOCIATION_ASSIGN OBJC_ASSOCIATION_RETAIN_NONATOMIC OBJC_ASSOCIATION_COPY_NONATOMIC
 */
- (void)xhl_setAssociateObject:(id)object forKey:(NSString *)key associationPolicy:(objc_AssociationPolicy)policy;

@end
