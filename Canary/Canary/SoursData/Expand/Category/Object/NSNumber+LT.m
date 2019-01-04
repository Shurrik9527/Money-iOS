//
//  NSNumber+LT.m
//  LTDevDemo
//
//  Created by litong on 2017/1/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSNumber+LT.h"

@implementation NSNumber (LT)

- (NSString *)toString {
    return [NSString stringWithFormat:@"%@",self];
}

/**  123456789 -> @"123,456,789" */
- (NSString *)numberDecimalFmt {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSString *str = [formatter stringFromNumber:self];
    return str;
}

@end
