//
//  MoneyRecordMO.h
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface MoneyRecordMO : BaseMO

@property (nonatomic,copy) NSString *mid;//id
@property (nonatomic,copy) NSString *amount;//金额
@property (nonatomic,copy) NSString *time;//时间
@property (nonatomic,copy) NSString *state;//状态
@property (nonatomic,copy) NSString *name;//出金 | 入金 | ...


//入金
//data.id	Long	流水号
//data.amount	BigDecimal	充值金额
//data.createTime	Date	充值时间
//data.state	String	充值状态

//data.balance	BigDecimal	余额
@property (nonatomic,copy) NSString *balance;//余额

//出金
//data.logNo	String	流水号
//data.balance	String	出金额
//data.lastHandleTime	String	处理时间
//data.state	String	处理状态-3.审批撤销,-2.审批拒绝,-1.审批不通过,0.正在审批,1.审批通过,2.已出金

//data.bankName	String	银行名称
//data.bankDepositName	String	银行名称
//data.bankNo	String	银行卡号
//data.mark	String	备注
@property (nonatomic,copy) NSString *bankName;//银行名称
@property (nonatomic,copy) NSString *bankDepositName;//银行名称
@property (nonatomic,copy) NSString *bankNo;//银行卡号
@property (nonatomic,copy) NSString *mark;//备注


+ (instancetype)inObjWithDict:(NSDictionary *)dict;
+ (NSArray *)inObjsWithList:(NSArray *)list;

+ (instancetype)outObjWithDict:(NSDictionary *)dict;
+ (NSArray *)outObjsWithList:(NSArray *)list;

@end
