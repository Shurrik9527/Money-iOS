//
//  LiveGiftListMO.m
//  ixit
//
//  Created by litong on 2017/3/30.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveGiftListMO.h"

@implementation LiveGiftListMO

- (NSArray *)giftList_fmt {
    NSArray *arr = [LiveGiftMO objsWithList:self.giftList];
    return arr;
}

@end
