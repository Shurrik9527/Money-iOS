//
//  GiftMO.h
//  ixit
//
//  Created by litong on 2016/12/19.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseMO.h"

typedef NS_ENUM(NSUInteger, GiftMOType) {
    GiftMOType_quan = 0,//券
    GiftMOType_PrivilegedCard = 1,//特权卡
};
#define NFC_ExchangeGift       @"NFC_ExchangeGift"
#define GiftCellMoTypeKey        @"GiftCellMoTypeKey"
#define GiftCellMoKey               @"GiftCellMoKey"
#define GiftCellIndexPathKey    @"GiftCellIndexPathKey"
#define GiftEndTimeKey    @"GiftEndTimeKey"


/** 积分商城-商品模型 */
@interface GiftMO : BaseMO

@property (nonatomic,assign) NSInteger excode;/**< 交易所：1=广贵所，2=哈贵所，3=吉农所，4=华凝所*/
@property (nonatomic,copy) NSString *giftId;/**< 券id*/
@property (nonatomic,copy) NSString *giftName;/**< 券名*/
@property (nonatomic,copy) NSString *giftPic;/**< 券图片*/
@property (nonatomic,assign) CGFloat moneys;/**< 券面值*/
@property (nonatomic,strong) NSNumber * poins;/**< 券积分价格*/
@property (nonatomic,strong) NSNumber *takeNum;/**< 已兑换的人数*/
@property (nonatomic,copy) NSString *giftSmallPic;/**< 券小图片*/


@property (nonatomic,copy) NSString *giftLimitNum;//商品剩余数量
@property (nonatomic,assign) NSInteger buyStatus;//购买状态：0=未购买 1=已购买 2=已抢光
@property (nonatomic,assign) NSInteger giftType;//商品类型：1=代金券，2=直播室礼物，3=特权卡

@property (nonatomic,copy) NSString *btnTextColor;
@property (nonatomic,copy) NSString *subTextColorOpacity;

/**  */
@property (nonatomic,assign) BOOL btnNotEnable;//  YES:按钮不能点击

- (UIColor *)btnColor;
- (UIColor *)subTextColor;
//12,345积分
- (NSString *)points_fmt;
- (NSString *)takeNum_fmt;
- (NSString *)giftLimitNum_fmt;

/**
 {
     "excode":1,
     "giftId":3,
     "giftName":"广贵所8元代金券",
     "giftPic":"http://t.m.8caopan.com/images/gift/0/0/3/20161213150037062.png",
     "giftType":1,
     "moneys":8.00,
     "poins":800,
     "takeNum":2
 }
 
 */

@end



