//
//  SelectBankView.h
//  Canary
//
//  Created by litong on 2017/6/3.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BasePopView.h"
#import "BankCardCell.h"

@protocol SelectBankViewDelegate <NSObject>

@optional
- (void)pushBindCard;
- (void)selectedBank:(BankCarkMO *)mo;

@end

@interface SelectBankView : BasePopView

@property (nonatomic,assign) id<SelectBankViewDelegate> delegate;
- (void)configBanks:(NSArray *)banks;

@end
