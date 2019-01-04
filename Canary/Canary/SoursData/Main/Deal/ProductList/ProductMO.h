//
//  ProductMO.h
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//
//  产品列表模型

#import "BaseMO.h"
typedef NS_ENUM(NSInteger, BuyType) {
    BuyType_Non = 0,
    BuyType_Up,   // 买涨
    BuyType_Down, // 买跌
};
@interface ProductMO : BaseMO

@property (nonatomic,copy) NSString *excode;
@property (nonatomic, copy) NSString *productId;//产品id
@property (nonatomic, copy) NSString *name;//产品名称
@property (nonatomic, copy) NSString *mp;//浮动比例幅 （涨幅、跌幅）
@property (nonatomic, copy) NSString *margin;//浮动点数 （涨幅、跌幅）

@property (nonatomic, copy) NSString *sell;//卖出价
@property (nonatomic, copy) NSString *buy;//买入价
@property (nonatomic, copy) NSString *buyRate;//买涨人数比例%

@property (nonatomic, copy) NSString *sellMargin;//卖出1手所需预付款
@property (nonatomic, copy) NSString *buyMargin;//买入1手所需预付款

@property (nonatomic, copy) NSString *slMoveNum;//建仓手数每次加减的值
@property (nonatomic, copy) NSString *maxSl;//最大手数
@property (nonatomic, strong) NSNumber *minSl;//最小手数
//- (NSString *)priceWithbuyNum:(CGFloat)num buyType:(BuyType)buyType;

@property (nonatomic, copy) NSString *minStopLoss;//最小止损点数
@property (nonatomic, copy) NSString *minStopProfile;//最小止盈点数
@property (nonatomic, copy) NSString *minMovePoint;//止盈止损，每次加减最小值

@property (nonatomic, copy) NSString *isClosed;//是否休市
@property (nonatomic, copy) NSString *calculatePoint;//金额计算的行情最小单位
@property (nonatomic, copy) NSString *floatingPl;//浮动最小单位1个点的金额（美元）
- (NSString *)priceWithCurPoint:(CGFloat)point;
@property (nonatomic, copy) NSString *contractNumber;//合约量

@property (nonatomic, copy) NSString *upDeferredFee;//买涨过夜费
@property (nonatomic, copy) NSString *downDeferredFee;//买跌过夜费

@property (nonatomic, copy) NSString *pointDiff;//点差
@property (nonatomic, copy) NSString *lever;//杠杆
@property (nonatomic, copy) NSString *code;//错误编码

@property (nonatomic, copy) NSString *contractExpire;//合约到期信息提示
@property (nonatomic, copy) NSString *price;       /**< 产品价格（一手）*/



@property (nonatomic, copy) NSString *contract;    /**< 产品代码 */

/** 休市提示message */
@property (nonatomic,copy) NSString *closePrompt;

- (BOOL)closed;

- (NSString *)buy_fmt;
- (NSString *)sell_fmt;
//- (NSString *)wavePointEarnWithNum:(NSString *)num type:(BuyType)type ;
//
//
//#pragma mark - 计算点位
////止损
//- (NSString *)pointLoss:(BuyType)type;
////止盈
//- (NSString *)pointProfile:(BuyType)type;
//
//////止损
////- (NSString *)pointLoss:(BuyType)type point:(CGFloat)point;
//////止盈
////- (NSString *)pointProfile:(BuyType)type point:(CGFloat)point;
//
////预计盈利   止损
//- (NSString *)referEarnLoss:(NSString *)loss type:(BuyType)type num:(CGFloat)num;
////预计盈利   止盈
//- (NSString *)referEarnProfile:(NSString *)profile type:(BuyType)type num:(CGFloat)num;
//


#pragma mark - 买涨、跌 人数
- (NSString *)buyUpRate_fmtStr;
- (NSString *)buyDownRate_fmtStr;
- (NSAttributedString *)buyUpRate_fmtABStr;
- (NSAttributedString *)buyDownRate_fmtABStr;



#pragma mark 价格排序的2维数组
+ (NSArray *)sortTo2DWithProductList:(NSArray *)pList;

@end
