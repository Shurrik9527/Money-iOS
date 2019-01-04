//
//  NSObject+MJUtils.m
//  ixit
//
//  Created by litong on 16/9/26.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "NSObject+MJUtils.h"

@implementation NSObject (MJUtils)


#pragma mark - 字典数组 -> 模型数组
+ (NSArray *)objectsWithDicts:(id)dicts {
    NSMutableArray *arr = [self mj_objectArrayWithKeyValuesArray:dicts context:nil];
    return [NSArray arrayWithArray:arr];
}

#pragma mark - 字典 -> 模型
/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @return 新建的对象
 */
+ (instancetype)objectWithDict:(id)dict {
    return [self mj_objectWithKeyValues:dict context:nil];
}

#pragma mark - 模型 -> 字典
/**
 *  将模型转成字典
 *  @return 字典
 */
+ (NSMutableDictionary *)objectToDict {
    return [self mj_keyValues];
}

@end
