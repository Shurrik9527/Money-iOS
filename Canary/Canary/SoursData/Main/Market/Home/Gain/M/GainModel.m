//
//  GainModel.m
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GainModel.h"

@implementation GainModel

- (NSString *)profitRate {
    NSString *str = [NSString stringWithFormat:@"%ld%%",(long)[_profitRate integerValue]];
    return str;
}

@end
