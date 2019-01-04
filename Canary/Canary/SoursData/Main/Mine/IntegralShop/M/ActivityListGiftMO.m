//
//  ActivityListGiftMO.m
//  ixit
//
//  Created by litong on 2017/3/31.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ActivityListGiftMO.h"

@implementation ActivityListGiftMO

- (NSArray *)giftList_fmt {
    NSArray *arr = _giftList;
    NSMutableArray *res = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        GiftMO *mo = [GiftMO objWithDict:dict];
        //是否已兑换：0=否 ； 1=是
        mo.btnNotEnable = (_status == 1);
        [res addObject:mo];
    }
    
    return res;
}

@end
