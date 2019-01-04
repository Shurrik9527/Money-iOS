//
//  OutInGodModel.h
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OutInGodModel : NSObject

@property (nonatomic,copy)NSString * accountName;//账户名
@property (nonatomic,copy)NSString * accountNumber;//账号
@property (nonatomic,copy)NSString * amount;//金额
@property (nonatomic,copy)NSString * bankAddress;//开户行
@property (nonatomic,copy)NSString * bankName;//银行
@property (nonatomic,copy)NSString * commission;//手续费
@property (nonatomic,copy)NSString * commit;//备注
@property (nonatomic,copy)NSString * currency;//币种
@property (nonatomic,copy)NSString * date;//日期
@property (nonatomic,copy)NSString * exchangeRate;//汇率
@property (nonatomic,copy)NSString * NewId;//id
@property (nonatomic,copy)NSString * status;
@property (nonatomic,strong)NSMutableArray *mt4User;//存放信息数组
@end
