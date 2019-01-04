//
//  ActivityListGiftMO.h
//  ixit
//
//  Created by litong on 2017/3/31.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"
#import "GiftMO.h"

@interface ActivityListGiftMO : BaseMO


@property (nonatomic,assign) NSInteger giftType;//商品类型：1=代金券，2=直播室礼物，3=特权卡
@property (nonatomic,assign) NSInteger status;//是否已兑换：0=否 ； 1=是
@property (nonatomic,copy) NSString *actTitle;//活动标题
@property (nonatomic,copy) NSString *actDesc;//活动说明
@property (nonatomic,copy) NSString *actEndTime;//活动结束时间
@property (nonatomic,copy) NSString *actStartTime;//活动开始时间
@property (nonatomic,copy) NSString *currTime;//系统当前时间
@property (nonatomic,strong) NSArray *giftList;//



- (NSArray *)giftList_fmt;

/*
 
     actDesc: "只能抢购1种特权卡",
     actEndTime: 1491429600000,
     actStartTime: 1490652000000,
     actTitle: "会员特权 限时兑换",
     currTime: 1491275495616,
     giftList: [],
     giftType: 3,
     status: 0
 
 */


@end
