//
//  GiftChangeMO.m
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GiftChangeMO.h"

@implementation GiftChangeMO

//哈贵所8元代金券1张
- (NSString *)giftNameAndNum {
    NSString *str = [NSString stringWithFormat:@"%@%@张",_giftName,_giftNum];
    return str;
}

- (NSString *)totalPoins_fmt {
    long long int tp = llabs([_totalPoins longLongValue]);
    NSNumber *number = @(tp);
    NSString *str = [NSString stringWithFormat:@"%@积分",[number numberDecimalFmt]];
    return str;
}

- (NSString *)createTimeStr {
    if ([_createTimeStr contains:@"/"]) {
        NSString *str = [_createTimeStr replacStr:@"/" withStr:@"-"];
        return str;
    } else {
        return _createTimeStr;
    }
}

- (GiftMO *)toGfitMO {
    GiftMO *mo = [[GiftMO alloc] init];
    mo.giftId = _giftId;
    mo.giftName = _giftName;
    mo.giftPic = _giftPic;
    mo.poins = _totalPoins;
    mo.giftType = _giftType;
    return mo;
}

@end
