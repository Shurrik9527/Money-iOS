//
//  GiftChangeMO.h
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseMO.h"
#import "GiftMO.h"

/** 兑换历史MO */
@interface GiftChangeMO : BaseMO


@property (nonatomic,copy) NSString *giftPic;//商品图片
@property (nonatomic,copy) NSString *giftSmallPic;//商品图片

@property (nonatomic,copy) NSString *createTimeStr;//兑换时间
@property (nonatomic,copy) NSString *giftName;//商品名称
@property (nonatomic,copy) NSString *fullName;
@property (nonatomic,copy) NSString *specDesc;
@property (nonatomic,strong) NSNumber *giftNum;//兑换的数量
@property (nonatomic,strong) NSNumber *totalPoins;//总共消费的积分
@property (nonatomic,copy) NSString *historyRecId;
@property (nonatomic,copy) NSString *giftId;//商品ID
@property (nonatomic,assign) NSInteger giftType;//商品类型：1=代金券，2=直播室礼物，3=特权卡，4=实物兑换

//哈贵所8元代金券1张
//- (NSString *)giftNameAndNum;
//1,000积分
- (NSString *)totalPoins_fmt;

- (GiftMO *)toGfitMO;


/*
 {
         createTimeStr = "2017-04-10 23:35";
         fullName = "\U795e\U53551\U4e2a";
         giftId = 14;
         giftName = "\U795e\U5355";
         giftNum = 1;
         giftPic = "http://t.m.8caopan.com/images/gift/0/0/14/20170405193012474.png";
         giftSmallPic = "http://t.m.8caopan.com/images/gift/0/0/14/20170405193012474.png";
         giftType = 2;
         historyRecId = 2785;
         totalPoins = "-88";
 }
 
 */

@end
