//
//  BaseMO.m
//  Canary
//
//  Created by litong on 2017/5/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"
#import "NSObject+MJUtils.h"

@implementation BaseMO

+ (NSArray *)objsWithList:(NSArray *)list {
    NSArray *arr = [self objectsWithDicts:list];
    return [NSArray arrayWithArray:arr];
}

+ (NSArray *)mutableObjsWithList:(NSArray *)list {
    NSArray *arr = [self objectsWithDicts:list];
    return[NSMutableArray arrayWithArray:arr];
}

#pragma mark - 字典转模型
/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @return 新建的对象
 */
+ (instancetype)objWithDict:(id)dict {
    return [self objectWithDict:dict];
}

#pragma mark - 模型 -> 字典
/**
 *  将模型转成字典
 *  @return 字典
 */
+ (NSMutableDictionary *)objToDict {
    return [self objToDict];
}

@end
