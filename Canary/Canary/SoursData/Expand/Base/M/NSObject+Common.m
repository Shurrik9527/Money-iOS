//
//  NSObject+Common.m
//  Canary
//
//  Created by Brain on 2017/5/27.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSObject+Common.h"

@implementation NSObject (Common)
// 判断对象是否为空
- (BOOL)isNotNull {
    
    if (self == NULL) {
        return NO;
    }
    else if ([self isEqual:[NSNull null]])
    {
        return NO;
    }
    else if ([self isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if (self==nil)
    {
        return NO;
    }
    
    return YES;
}

@end
