//
//  SelectSubBankVCtrl.h
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//
//  选择支行

#import "BaseTableVCtrl.h"

@class SubBankMO;
@protocol SelectSubBankDelegate <NSObject>

- (void)selectSubBank:(SubBankMO *)mo;

@end

@interface SelectSubBankVCtrl : BaseTableVCtrl


@property (nonatomic,copy) NSString *cityCode;//城市code
@property (nonatomic,copy) NSString *bankCode;//银行code
@property (nonatomic,assign) id<SelectSubBankDelegate> delegate;

@end


@interface SubBankMO : BaseMO

@property (nonatomic,copy) NSString *name;//支行名称
@property (nonatomic,copy) NSString *bankDepositId;//支行ID
@property (nonatomic,copy) NSString *address;//地址
@property (nonatomic,copy) NSString *tel;//支行电话

@end

