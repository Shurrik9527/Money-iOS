//
//  NSMutableDictionary+SafeObject.m
//  carassistant
//
//  Created by tong li on 12-6-26.
//  Copyright (c) 2012年 softlit. All rights reserved.
//

#import "NSMutableDictionary+SafeObject.h"

@implementation NSMutableDictionary (SafeObject)

/*! 
 * 从可变长字典中获取一个对象
 * 并判断此对象是否属于类型_class
 * 若不是此类，则返回nil
 */
- (void)setObject:(id)anObject forKey:(NSString *)aKey withClass:(Class)_class {

    assert([anObject isKindOfClass:_class]);
    
    if (![anObject isKindOfClass:_class]) {
        return;
    } else {
        [self setObject:anObject forKey:aKey];
    }
}

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是NSString对象
 * 如不是直接return
 */
- (void)setString:(NSString *)anObject forKey:(NSString *)aKey {
    [self setObject:anObject forKey:aKey withClass:[NSString class]];
}

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是NSDate对象
 * 如不是直接return
 */
- (void)setDate:(NSDate *)anObject forKey:(NSString *)aKey {
    [self setObject:anObject forKey:aKey withClass:[NSData class]];
}

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是NSNumber对象
 * 如不是直接return
 */
- (void)setNumber:(NSNumber *)anObject forKey:(NSString *)aKey {
    [self setObject:anObject forKey:aKey withClass:[NSNumber class]];
}

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是BOOL对象
 * 如不是直接return
 */
- (void)setBool:(BOOL)anObject forKey:(NSString *)aKey {
    [self setNumber:[NSNumber numberWithBool:anObject] forKey:aKey];
}

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是char对象
 * 如不是直接return
 */
- (void)setChar:(char)anObject forKey:(NSString *)aKey {
    [self setNumber:[NSNumber numberWithChar:anObject] forKey:aKey];
}

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是double对象
 * 如不是直接return
 */
- (void)setDouble:(double)anObject forKey:(NSString *)aKey {
    [self setNumber:[NSNumber numberWithDouble:anObject] forKey:aKey];
}

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是float对象
 * 如不是直接return
 */
- (void)setFloat:(float)anObject forKey:(NSString *)aKey {
    [self setNumber:[NSNumber numberWithFloat:anObject] forKey:aKey];
}

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是int对象
 * 如不是直接return
 */
- (void)setInt:(int)anObject forKey:(NSString *)aKey {
    [self setNumber:[NSNumber numberWithInt:anObject] forKey:aKey];
}

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是NSInteger对象
 * 如不是直接return
 */
- (void)setInteger:(NSInteger)anObject forKey:(NSString *)aKey {
    [self setNumber:[NSNumber numberWithInteger:anObject] forKey:aKey];
}

/*! 往可变长字典中放入一个对象
 * 并判断此对象是否是NSUInteger对象
 * 如不是直接return
 */
- (void)setUInteger:(NSUInteger)anObject forKey:(NSString *)aKey {
    [self setNumber:[NSNumber numberWithUnsignedChar:anObject] forKey:aKey];
}

@end
