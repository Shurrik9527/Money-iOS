//
//  integralVC.h
//  ixit
//
//  Created by Brain on 2016/12/12.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseMO.h"

#define kVipLvVerKey   @"kVipLvVerKey"

/** 用户积分模型 */
@interface IntegralMo : BaseMO


@property(strong,nonatomic)NSNumber * validPoints;/*< 可用积分*/
@property(strong,nonatomic)NSNumber * totalPoints;/*< 累计积分*/
@property(strong,nonatomic)NSNumber * levelNum;/*< 当前等级*/
@property(strong,nonatomic)NSNumber *rebateRate;/*< 当前等级享受的折扣率*/

@property(copy,nonatomic)NSString * pointsRanking;/*< 积分排名百分比*/
@property(copy,nonatomic)NSString * levelName;/*< 当前等级名称*/

@property(strong,nonatomic)NSNumber * totalExp;/*< 累计经验*/
@property(strong,nonatomic)NSNumber * minExp;/*< 当前等级经验范围 最小值*/
@property(strong,nonatomic)NSNumber * maxExp;/*< 当前等级经验范围 最大值*/
@property(assign,nonatomic)CGFloat nextLevelRate;/*< 当前等级经验百分比*/

@property(assign,nonatomic)NSInteger versionNo;/*< 等级表版本号*/

+ (instancetype)objWithDict:(id)dict;

//升级需要的经验值
- (NSString *)upgradeExp_fmt;

//保存等级和折扣
- (void)saveLvAndRebateRate;

//积分: 12,345分
- (NSString *)validPoints_fmt;
//经验: 12,345
- (NSString *)totalExp_fmt;
//积分: 12,345分    |    经验: 12,345
- (NSString *)validPointsAndTotalExp_fmt;
//12,345
- (NSString *)validPoints_fmt1;
//打败20.35%的八元用户
- (NSString *)pointsRanking_fmt;
//等级图片名称 Shop_pic_V1
- (NSString *)levelImgName;
//9  (可享受积分商城 %@ 折优惠)
- (NSString *)rebateRate_fmt;
//V3会员9折
- (NSString *)vipLevelName_fmt;

//等级列表版本号
+ (NSInteger)vipLvVer;
//等级列表
+ (NSArray *)vipLvList;


/*
 levelName: "V1",
 levelNum: 1,
 maxExp: 10000,
 minExp: 0,
 nextLevelRate: 0,
 pointsRanking: "0.0%",
 rebateRate: 1,
 totalExp: 0,
 totalPoints: 0,
 validPoints: 0,
 versionNo: 1

 */

@end
