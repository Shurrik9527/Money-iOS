//
//  BankCarkMO.h
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface BankCarkMO : BaseMO

@property (nonatomic,copy) NSString *bankId;
@property (nonatomic,copy) NSString *bankNo;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *bankName;

- (NSString *)end4BankNO;

// = "\U4e2d\U56fd\U94f6\U884c";
// = "31231*********23123";
//icon = "https://test-fxbtg-static.8caopan.com/images/bankIcon/fund_icon_BOC@3x.png";
//id = b1a09c4b40d44796b6c6d8d4bff7d967o8b42c00863c453aaf705a669faaed34f0aef433e53c4ede8b42e7b45d942530t45a2198cc1f4be8b070490090adf42f;

@end
