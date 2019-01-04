//
//  BaseMO.h
//  Canary
//
//  Created by litong on 2017/5/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseMO : NSObject

+ (NSArray *)objsWithList:(NSArray *)list;
+ (NSArray *)mutableObjsWithList:(NSArray *)list;
#pragma mark - 字典转模型
/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @return 新建的对象
 */
+ (instancetype)objWithDict:(id)dict;

#pragma mark - 模型 -> 字典
/**
 *  将模型转成字典
 *  @return 字典
 */
+ (NSMutableDictionary *)objToDict;

@end
