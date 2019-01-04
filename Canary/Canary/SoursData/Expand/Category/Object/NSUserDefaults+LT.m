//
//  NSUserDefaults+LT.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSUserDefaults+LT.h"

@implementation NSUserDefaults (LT)

+ (id)objFoKey:(NSString*)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id value=[defaults objectForKey:key];
    defaults = nil;
    return value;
}

+ (void)setObj:(id)value foKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value ? value : @"" forKey:key];
    [defaults synchronize];
    defaults = nil;
}

+ (void)removeObjFoKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
    defaults = nil;
}

+ (void)removeAll {
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [udf dictionaryRepresentation];
    for (NSString *key in dic.allKeys) {
        [udf removeObjectForKey:key];
    }
}


@end
