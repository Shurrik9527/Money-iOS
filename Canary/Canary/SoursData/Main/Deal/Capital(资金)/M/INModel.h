//
//  INModel.h
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INModel : NSObject

@property (nonatomic,copy)NSString * amount;//金额
@property (nonatomic,copy)NSString * amountCNY;//人民币金额
@property (nonatomic,copy)NSString * commit;//备注
@property (nonatomic,copy)NSString * currency;//币种
@property (nonatomic,copy)NSString * date;//日期
@property (nonatomic,copy)NSString * gateway;//支付网关
@property (nonatomic,copy)NSString * NewID;//ID
@property (nonatomic,copy)NSString * status;//WAIT- 等待支付/SUCCESS- 支付成功 
@property (nonatomic,copy)NSString * transId;//流水号


@end
