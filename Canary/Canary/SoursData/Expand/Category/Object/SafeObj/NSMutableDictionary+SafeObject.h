//
//  NSMutableDictionary+SafeObject.h
//  carassistant
//
//  Created by tong li on 12-6-26.
//  Copyright (c) 2012年 softlit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (SafeObject)

/*! 
 * 往可变长字典中放入一个对象
 * 并判断此对象是否属于类型_class
 * 若不是此类，则返回nil
 */
- (void)setObject:(id)anObject forKey:(NSString *)aKey withClass:(Class)_class;

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是NSString对象
 * 如不是直接return
 */
- (void)setString:(NSString *)anObject forKey:(NSString *)aKey;

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是NSDate对象
 * 如不是直接return
 */
- (void)setDate:(NSDate *)anObject forKey:(NSString *)aKey;

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是NSNumber对象
 * 如不是直接return
 */
- (void)setNumber:(NSNumber *)anObject forKey:(NSString *)aKey;

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是BOOL对象
 * 如不是直接return
 */
- (void)setBool:(BOOL)anObject forKey:(NSString *)aKey;

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是char对象
 * 如不是直接return
 */
- (void)setChar:(char)anObject forKey:(NSString *)aKey;

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是double对象
 * 如不是直接return
 */
- (void)setDouble:(double)anObject forKey:(NSString *)aKey;

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是float对象
 * 如不是直接return
 */
- (void)setFloat:(float)anObject forKey:(NSString *)aKey;

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是int对象
 * 如不是直接return
 */
- (void)setInt:(int)anObject forKey:(NSString *)aKey;

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是NSInteger对象
 * 如不是直接return
 */
- (void)setInteger:(NSInteger)anObject forKey:(NSString *)aKey;

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是NSUInteger对象
 * 如不是直接return
 */
- (void)setUInteger:(NSUInteger)anObject forKey:(NSString *)aKey;

@end
