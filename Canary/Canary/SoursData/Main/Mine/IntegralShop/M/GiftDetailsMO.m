//
//  GiftDetailsMO.m
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GiftDetailsMO.h"

@implementation GiftDetailsMO

- (NSString *)createTimeStr_fmt {
    NSString *timeStr = [_createTimeStr stringFMD:@"yyyy-MM-dd HH:mm" withSelfFMT:@"yyyy.MM.dd HH:mm"];
    return timeStr;
}

@end
