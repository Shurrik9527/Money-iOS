//
//  NSDictionary+Utilities.h
//  CarGuide
//
//  Created by  litong on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 * 安全取数据
 */

@interface NSDictionary (SafeObject)

/*! 
 * 并判断此对象是否属于类型_class
 * 若不是此类，则返回nil
 */
//- (id)objectFoKey:(NSString *)aKey withClass:(Class)_class;


#pragma mark -  对象

/*!
 * 必定返回 NSString对象
 * 非正常情况返回@""
 */
- (NSString *)stringFoKey:(NSString *)aKey;

/*!
 * 必定返回 NSNumber对象
 * 非正常情况返回@0
 */
- (NSNumber *)numberFoKey:(NSString *)aKey;

/*!
 * 必定返回 NSDictionary对象
 * 非正常情况返回 空字典
 */
- (NSDictionary *)dictionaryFoKey:(NSString *)aKey;

/*! 
 * 必定返回 NSMutableDictionary对象
 * 非正常情况返回 空可变字典
 */
- (NSMutableDictionary *)mutabledictionaryFoKey:(NSString *)aKey;

/*! 
 * 必定返回 NSArray对象
 * 非正常情况返回 空数字
 */
- (NSArray *)arrayFoKey:(NSString *)aKey;

/*! 
 * 必定返回 NSMutableArray对象
 * 非正常情况返回 空可变数组
 */
- (NSMutableArray *)mutablearrayFoKey:(NSString *)aKey;

/*!
 * 必定返回 NSDate对象
 * 非正常情况返回1970年0点
 */
- (NSDate *)dateFoKey:(NSString *)aKey;

#pragma mark -
#pragma mark 基础数据类型

/*! 
 * 并判断此对象是否是BOOL对象
 * 非正常情况返回0
 */
- (BOOL)boolFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是char对象
 * 非正常情况返回0
 */
- (char)charFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是double对象
 * 非正常情况返回0
 */
- (double)doubleFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是float对象
 * 非正常情况返回0
 */
- (float)floatFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是int对象
 * 非正常情况返回0
 */
- (int)intFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是NSInteger对象
 * 非正常情况返回0
 */
- (NSInteger)integerFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是long对象
 * 非正常情况返回0
 */
- (long)longFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是long long对象
 * 非正常情况返回0
 */
- (long long)longLongFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是short对象
 * 非正常情况返回0
 */
- (short)shortFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是unsigned char对象
 * 非正常情况返回0
 */
- (unsigned char)unsignedCharFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是unsigned int对象
 * 非正常情况返回0
 */
- (unsigned int)unsignedIntFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是NSUInteger对象
 * 非正常情况返回0
 */
- (NSUInteger)unsignedIntegerFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是unsigned long对象
 * 非正常情况返回0
 */
- (unsigned long)unsignedLongFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是unsigned long long对象
 * 非正常情况返回0
 */
- (unsigned long long)unsignedLongLongFoKey:(NSString *)aKey;

/*! 
 * 并判断此对象是否是unsigned short对象
 * 非正常情况返回0
 */
- (unsigned short)unsignedShortFoKey:(NSString *)aKey;






@end
