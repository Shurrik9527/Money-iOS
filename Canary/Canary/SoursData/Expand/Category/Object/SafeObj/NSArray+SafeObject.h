//
//  NSArray+SafeObject.h
//  carassistant
//
//  Created by litong on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SafeObject)


/*!
 * 从数组中获取一个对象
 * 若越界，则返回nil
 */
- (id)objectAtIdx:(NSUInteger)index;


/*!
 * 从数组中获取一个对象
 * 并判断此对象是否属于类型_class
 * 若不是此类，则返回nil
 * 若越界，则返回nil
 */
- (id)objectAtIdx:(NSUInteger)index withClass:(Class)_class;

/*!
 * 从数组中获取一个NSArray
 * 若不是此类，则返回nil
 * 若越界，则返回nil
 */
- (NSArray *)arrayAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个NSMutableArray
 * 若不是此类，则返回nil
 * 若越界，则返回nil
 */
- (NSMutableArray *)mutableArrayAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个NSDictionary
 * 若不是此类，则返回nil
 * 若越界，则返回nil
 */
- (NSDictionary *)dictionaryAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个NSMutableDictionary
 * 若不是此类，则返回nil
 * 若越界，则返回nil
 */
- (NSMutableDictionary *)mutableDictionaryAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是NSString对象
 * 否则返回nil
 */
- (NSString *)stringAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是NSDate对象
 * 否则返回nil
 */
- (NSDate *)dateAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是NSNumber对象
 * 否则返回nil
 */
- (NSNumber *)numberAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个NSNumber、或者NSString对象
 * 并将此对象转化为BOOL值
 * 如果无法转换为BOOL值则返回NO
 */
- (BOOL)boolAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个NSNumber、或者NSString对象
 * 并将此对象转化为double值
 * 如果无法转换为double值则返回0.0
 */
- (double)doubleAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个NSNumber、或者NSString对象
 * 并将此对象转化为float值
 * 如果无法转换为float值则返回0.0
 */
- (float)floatAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个NSNumber、或者NSString对象
 * 并将此对象转化为int值
 * 如果无法转换为int值则返回0
 */
- (int)intAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个NSNumber、或者NSString对象
 * 并将此对象转化为NSInteger值
 * 如果无法转换为NSInteger值则返回0
 */
- (NSInteger)integerAtIdx:(NSUInteger)index;

/*!
 * 从数组中获取一个NSNumber、或者NSString对象
 * 并将此对象转化为NSUInteger值
 * 如果无法转换为NSUInteger值则返回0
 */
- (NSUInteger)uIntegerAtIdx:(NSUInteger)index;


/*
 ========================华丽的分割线===========================
 */

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否属于类型_class
 * 若不是此类，则返回nil
 */
- (id)lastObjectwithClass:(Class)_class;

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是NSString对象
 * 否则返回nil
 */
- (NSString *)lastString;

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是NSDate对象
 * 否则返回nil
 */
- (NSDate *)lastDate;

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是NSNumber对象
 * 否则返回nil
 */
- (NSNumber *)lastNumber;

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是BOOL对象
 * 否则返回nil
 */
- (BOOL)lastBool;

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是char对象
 * 否则返回nil
 */
- (char)lastChar;

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是double对象
 * 否则返回nil
 */
- (double)lastDouble;

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是float对象
 * 否则返回nil
 */
- (float)lastFloat;

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是int对象
 * 否则返回nil
 */
- (int)lastInt;

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是NSInteger对象
 * 否则返回nil
 */
- (NSInteger)lastInteger;

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是NSUInteger对象
 * 否则返回nil
 */
- (NSUInteger)lastUInteger;



@end
