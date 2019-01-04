//
//  BankCarkMO.m
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BankCarkMO.h"

@implementation BankCarkMO

- (NSString *)end4BankNO {
    NSString *bno = _bankNo;
    NSString *str = [_bankNo substringFromIndex:(bno.length - 4)];
    return str;
}

@end
