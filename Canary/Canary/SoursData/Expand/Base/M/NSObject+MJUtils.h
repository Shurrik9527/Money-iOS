//
//  NSObject+MJUtils.h
//  ixit
//
//  Created by litong on 16/9/26.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJKeyValue.h"

@interface NSObject (MJUtils)

#pragma mark - 字典数组 -> 模型数组
/**
 *  通过字典数组来创建一个模型数组
 *  @param keyValuesArray 字典数组(可以是NSDictionary、NSData、NSString)
 *  @return 模型数组
 */
+ (NSArray *)objectsWithDicts:(id)dicts;

#pragma mark - 字典 -> 模型
/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @return 新建的对象
 */
+ (instancetype)objectWithDict:(id)dict;

 #pragma mark - 模型 -> 字典
/**
 *  将模型转成字典
 *  @return 字典
 */
+ (NSMutableDictionary *)objectToDict;

@end
