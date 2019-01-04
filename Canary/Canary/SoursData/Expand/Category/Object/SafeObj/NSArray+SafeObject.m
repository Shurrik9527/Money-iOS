//
//  NSArray+SafeObject.m
//  carassistant
//
//  Created by litong on 12-6-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSArray+SafeObject.h"

@implementation NSArray (SafeObject)

/*!
 * 从数组中获取一个对象
 * 若越界，则返回nil
 */
- (id)objectAtIdx:(NSUInteger)index {
    if (index < self.count) {
        id object = [self objectAtIndex:index];
        return object;
    }
    return nil;
}


/*!
 * 从数组中获取一个对象
 * 并判断此对象是否属于类型_class
 * 若不是此类，则返回nil
 * 并判断下标是否越界
 * 若越界，则返回nil
 */
- (id)objectAtIdx:(NSUInteger)index withClass:(Class)_class {
    
    if (index < self.count) {
        id object = [self objectAtIndex:index];
    
        if ([object isKindOfClass:_class]) {
            return object;
        }
    }
    
    return nil;
}

/*
 * 从数组中获取一个NSArray
 * 若不是此类，则返回nil
 * 若越界，则返回nil
 */
- (NSArray *)arrayAtIdx:(NSUInteger)index {
    return [self objectAtIdx:index withClass:[NSArray class]];
}

/*
 * 从数组中获取一个NSMutableArray
 * 若不是此类，则返回nil
 * 若越界，则返回nil
 */
- (NSMutableArray *)mutableArrayAtIdx:(NSUInteger)index {
    return [self objectAtIdx:index withClass:[NSMutableArray class]];
}

/*
 * 从数组中获取一个NSDictionary
 * 若不是此类，则返回nil
 * 若越界，则返回nil
 */
- (NSDictionary *)dictionaryAtIdx:(NSUInteger)index {
    return  [self objectAtIdx:index withClass:[NSDictionary class]];
}

/*
 * 从数组中获取一个NSMutableDictionary
 * 若不是此类，则返回nil
 * 若越界，则返回nil
 */
- (NSMutableDictionary *)mutableDictionaryAtIdx:(NSUInteger)index {
    return [self objectAtIdx:index withClass:[NSMutableDictionary class]];
}

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是NSString对象
 * 否则返回nil
 */
- (NSString *)stringAtIdx:(NSUInteger)index {
    return [self objectAtIdx:index withClass:[NSString class]];
}

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是NSDate对象
 * 否则返回nil
 */
- (NSDate *)dateAtIdx:(NSUInteger)index {
    return [self objectAtIdx:index withClass:[NSData class]];
}

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是NSNumber对象
 * 否则返回nil
 */
- (NSNumber *)numberAtIdx:(NSUInteger)index {
    return [self objectAtIdx:index withClass:[NSNumber class]];
}

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是BOOL对象
 * 否则返回nil
 */
- (BOOL)boolAtIdx:(NSUInteger)index {
    return [[self numberAtIdx:index] boolValue];
}

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是char对象
 * 否则返回nil
 */
- (char)charAtIdx:(NSUInteger)index {
    return [[self numberAtIdx:index] boolValue];
}

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是double对象
 * 否则返回nil
 */
- (double)doubleAtIdx:(NSUInteger)index {
    return [[self numberAtIdx:index] doubleValue];
}

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是float对象
 * 否则返回nil
 */
- (float)floatAtIdx:(NSUInteger)index {
    return [[self numberAtIdx:index] floatValue];
}

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是int对象
 * 否则返回nil
 */
- (int)intAtIdx:(NSUInteger)index {
    return [[self numberAtIdx:index] intValue];
}

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是NSInteger对象
 * 否则返回nil
 */
- (NSInteger)integerAtIdx:(NSUInteger)index {
    return [[self numberAtIdx:index] integerValue];
}

/*!
 * 从数组中获取一个对象
 * 并判断此对象是否是NSUInteger对象
 * 否则返回nil
 */
- (NSUInteger)uIntegerAtIdx:(NSUInteger)index {
    return [[self numberAtIdx:index] unsignedIntegerValue];
}

/*
========================华丽的分割线===========================
 */

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否属于类型_class
 * 若不是此类，则返回nil
 */
- (id)lastObjectwithClass:(Class)_class {
    
    id object = [self lastObject];
    
    if (![object isKindOfClass:_class]) {
        object = nil;
    }
    
    return object;
}

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是NSString对象
 * 否则返回nil
 */
- (NSString *)lastString {
    return [self lastObjectwithClass:[NSString class]];
}

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是NSDate对象
 * 否则返回nil
 */
- (NSDate *)lastDate {
    return [self lastObjectwithClass:[NSData class]];
}

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是NSNumber对象
 * 否则返回nil
 */
- (NSNumber *)lastNumber {
    return [self lastObjectwithClass:[NSNumber class]];
}

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是BOOL对象
 * 否则返回nil
 */
- (BOOL)lastBool {
    return [[self lastNumber] boolValue];
}

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是char对象
 * 否则返回nil
 */
- (char)lastChar {
    return [[self lastNumber] charValue];
}

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是double对象
 * 否则返回nil
 */
- (double)lastDouble {
    return [[self lastNumber] doubleValue];
}

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是float对象
 * 否则返回nil
 */
- (float)lastFloat {
    return [[self lastNumber] floatValue];
}

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是int对象
 * 否则返回nil
 */
- (int)lastInt {
    return [[self lastNumber] intValue];
}

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是NSInteger对象
 * 否则返回nil
 */
- (NSInteger)lastInteger {
    return [[self lastNumber] integerValue];
}

/*!
 * 从数组中获取最后一个对象
 * 并判断此对象是否是NSUInteger对象
 * 否则返回nil
 */
- (NSUInteger)lastUInteger {
    return [[self lastNumber] unsignedIntegerValue];
}


@end
