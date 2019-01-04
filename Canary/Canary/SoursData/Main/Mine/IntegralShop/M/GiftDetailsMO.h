//
//  GiftDetailsMO.h
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseMO.h"

/** 积分明细 */
@interface GiftDetailsMO : BaseMO

@property (nonatomic,copy) NSString *createTimeStr;//时间
@property (nonatomic,copy) NSString *pointSourceName;//积分来源
@property (nonatomic,copy) NSString *pointsValue;//积分值

- (NSString *)createTimeStr_fmt;

/*
 {
     createTimeStr = "2016.12.14 19:48";
     pointSourceName = "\U5e7f\U8d35\U624080\U5143\U4ee3\U91d1\U5238";
     pointsValue = 40;
 }
 */

@end
