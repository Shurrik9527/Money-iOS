//
//  NSDictionary+Utilities.m
//  CarGuide
//
//  Created by  litong on 12-4-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+SafeObject.h"
#import "NSString+LT.h"

@implementation NSDictionary (SafeObject)


/*! 从字典中获取一个对象
 * 并判断此对象是否属于类型_class
 * 否则返回nil
 */
- (id)objectFoKey:(NSString *)aKey withClass:(Class)_class {
    id object = [self objectForKey:aKey];
    
    if (!object || [object isKindOfClass:[NSNull class]] || object == NULL) {
        return nil;
    }
    
//    assert([object isKindOfClass:_class]);
    
    if (![object isKindOfClass:_class]) {
        object = nil;
    }
    
    return object;
}


#pragma mark - 对象

- (NSString *)stringFoKey:(NSString *)aKey {
    id obj = [self objectForKey:aKey];
    
    if (obj == nil || obj == Nil || obj == NULL ||
        [obj isEqual:[NSNull null]] ||
        [obj isKindOfClass:[NSNull class]]) {
        return @"";
    } else if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",obj];
    }
    return @"";
}

- (NSNumber *)numberFoKey:(NSString *)aKey {
    id obj = [self objectForKey:aKey];
    
    if (obj == nil || obj == Nil || obj == NULL ||
        [obj isEqual:[NSNull null]] ||
        [obj isKindOfClass:[NSNull class]]) {
        return @0;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        NSString *str = obj;
        return [str toNumber];
    }
    return @0;
}

- (NSDictionary *)dictionaryFoKey:(NSString *)aKey {
    NSDictionary *obj = [self objectFoKey:aKey withClass:[NSDictionary class]];
    if (obj) {
        return obj;
    }
    return [NSDictionary dictionary];
}

- (NSMutableDictionary *)mutabledictionaryFoKey:(NSString *)aKey {
    NSMutableDictionary *obj = [self objectFoKey:aKey withClass:[NSMutableDictionary class]];
    if (obj) {
        return obj;
    }
    return [NSMutableDictionary dictionary];
}

- (NSArray *)arrayFoKey:(NSString *)aKey {
    NSArray *obj = [self objectFoKey:aKey withClass:[NSArray class]];
    if (obj) {
        return obj;
    }
    return [NSArray array];
}

- (NSMutableArray *)mutablearrayFoKey:(NSString *)aKey {
    NSMutableArray *obj = [self objectFoKey:aKey withClass:[NSMutableArray class]];
    if (obj) {
        return obj;
    }
    return [NSMutableArray array];
}

- (NSDate *)dateFoKey:(NSString *)aKey {
    NSDate *obj = [self objectFoKey:aKey withClass:[NSDate class]];
    
    if (obj) {
        return obj;
    }
    return [NSDate dateWithTimeIntervalSince1970:0];
}


#pragma mark - 基础数据类型

- (BOOL)boolFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] boolValue];
}

- (char)charFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] charValue];
}

- (double)doubleFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] doubleValue];
}

- (float)floatFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] floatValue];
}

- (int)intFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] intValue];
}

- (NSInteger)integerFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] integerValue];
}

- (long)longFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] longValue];
}

- (long long)longLongFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] longLongValue];
}

- (short)shortFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] shortValue];
}

- (unsigned char)unsignedCharFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] unsignedCharValue];
}

- (unsigned int)unsignedIntFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] unsignedIntValue];
}

- (NSUInteger)unsignedIntegerFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] unsignedIntegerValue];
}

- (unsigned long)unsignedLongFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] unsignedLongValue];
}

- (unsigned long long)unsignedLongLongFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] unsignedLongLongValue];
}

- (unsigned short)unsignedShortFoKey:(NSString *)aKey {
    return [[self numberFoKey:aKey] unsignedShortValue];
}


@end
