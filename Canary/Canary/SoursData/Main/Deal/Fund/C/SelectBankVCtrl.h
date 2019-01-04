//
//  SelectBankVCtrl.h
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//
//  选择银行

#import "BaseTableVCtrl.h"

@class BankMO;
@protocol SelectBankDelegate <NSObject>

- (void)selectBank:(BankMO *)mo;

@end

@interface SelectBankVCtrl : BaseTableVCtrl

@property (nonatomic,assign) id<SelectBankDelegate> delegate;

@end


@interface BankMO : BaseMO

@property (nonatomic,copy) NSString *code;//银行编码
@property (nonatomic,copy) NSString *name;//银行名称
@property (nonatomic,copy) NSString *icon;//银行ICON

@end
