//
//  MyGainModel.m
//  ixit
//
//  Created by litong on 2016/11/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "MyGainModel.h"

@implementation MyGainModel

- (NSString *)price_fmt {
    CGFloat f = [_productPrice floatValue];
    NSString *str = [NSString stringWithFormat:@"(%g元/手)",f];
    return str;
}



@end
