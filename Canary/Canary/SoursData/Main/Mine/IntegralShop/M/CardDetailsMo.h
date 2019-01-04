//
//  CardDetailsMo.h
//  ixit
//
//  Created by Brain on 2017/4/6.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"
/*
 [0]	 	@"giftName" : @"特权-亏损包赔"
 [1]	 	@"giftLimitNum" : (long)3
 [2]	 	@"buyStatus" : (long)0
 [3]	 	@"giftAuthDesc" : @"抢购条件说明：r&n1.19999积分（积分可更改）兑换一次，不同等级享受相应折扣；r&n2.满足条件后，可参与抢购。"
 [4]	 	@"currTime" : (long)1491357911821
 [5]	 	@"giftId" : (long)12
 [6]	 	@"giftRemark" : @"注：每人只能抢购1种特权卡"
 [7]	 	@"takeNum" : (long)1
 [8]	 	@"giftDesc" : @"八元用户特权卡—亏损包赔r&n有效期：3月23日06：00-3月24日04：00r&n包赔上限：10000元"
 [9]	 	@"giftBigPic" : @"http://t.m.8caopan.com/images/gift/detail/20170330110704622.png"
 [10]	 	@"giftRuleDesc" : @"使用规则：r&n1.有效期内，使用现金建仓并平仓的交易，所产生的净亏损以积分形式得到补偿。100积分=1元。r&n2.净亏损=总亏损-总盈利。净亏损为负时，即说明用户有效期内整体盈利，不符合亏损包赔条件。r&n3.手续费、过夜费不计入亏损金额统计。r&n4.积分将于权限到期后第一个交易日统一返还。r&n5.八元操盘保留法律范围内对活动的解释权。"
 [11]	 	@"giftOrderRemark" : @"亏损部分以积分形式返还"
 */
@interface CardDetailsMo : BaseMO
@property (nonatomic,copy) NSString *giftName;/**< 特权卡详情名称*/
@property (nonatomic,copy) NSString *giftLimitNum;/**< 商品剩余数量*/
@property (nonatomic,assign) NSInteger buyStatus;/**< 购买状态：0=未购买 1=已购买 2=已抢光*/
@property (nonatomic,copy) NSString *giftAuthDesc;/**< 特权卡条件说明*/
@property (nonatomic,strong) NSNumber * currTime;/**< 特权卡结束时间*/
@property (nonatomic,copy) NSString *giftId;/**< 特权卡id*/
@property (nonatomic,copy) NSString *giftRemark; /**< 特权卡注意事项*/
@property (nonatomic,strong) NSNumber *takeNum;/**< 已兑换的人数*/
@property (nonatomic,copy) NSString *giftDesc; /**< 特权卡介绍*/
@property (nonatomic,copy) NSString *giftBigPic;/**< 特权卡图片*/
@property (nonatomic,copy) NSString *giftRuleDesc; /**< 特权卡使用规则*/
@property (nonatomic,copy) NSString *giftOrderRemark; /**< 特权卡订单相关备注*/
#pragma mark - history
/*
 [9]	@"giftPoins" : (long)3000
 [10]	@"giftRuleDesc" : @"使用规则：r&n1.有效期内，使用现金建仓并平仓的交易所产生的净盈利，将以积分形式获得同等金额奖励。100积分=1元。r&n2.净盈利=总盈利-总亏损。当净盈利为负时，说明用户整体亏损，不符合盈利双倍条件。r&n3.交易产生的手续费、过夜费不计入活动统计。r&n4.积分将于权限到期后第一个交易日统一返还。r&n5.八元操盘保留法律范围内对活动的解释权。"
 */
@property(copy,nonatomic)NSString * levelName;/**< 特权卡兑换时等级*/
@property (nonatomic,strong) NSNumber *levelNum;/**< 兑换时积分等级*/
@property (nonatomic,strong) NSNumber *rebateRate;/**< 兑换时积分折扣*/
@property (nonatomic,strong) NSNumber *giftPoins;/**< 兑换时所需积分*/

- (NSString *)rebateRate_fmt;
- (NSString *)vipLevelName_fmt;
@end
