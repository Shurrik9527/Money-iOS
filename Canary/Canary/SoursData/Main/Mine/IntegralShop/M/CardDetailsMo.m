//
//  CardDetailsMo.m
//  ixit
//
//  Created by Brain on 2017/4/6.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "CardDetailsMo.h"

@implementation CardDetailsMo
//9  (可享受积分商城 %@ 折优惠)
- (NSString *)rebateRate_fmt {
    CGFloat tf = [_rebateRate floatValue];
    if ( tf >= 1) {
        return @"0";
    }
    CGFloat f = tf * 10;
    NSString *str = [NSString stringWithFormat:@"%g",f];
    return str;
}
- (NSString *)vipLevelName_fmt {
    NSString *str = [NSString stringWithFormat:@"%@会员%@折",_levelName,self.rebateRate_fmt];
    return str;
}

@end
