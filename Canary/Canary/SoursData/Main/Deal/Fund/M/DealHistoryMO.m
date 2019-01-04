//
//  DealHistoryMO.m
//  Canary
//
//  Created by litong on 2017/6/5.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "DealHistoryMO.h"

@implementation DealHistoryMO
//建仓金额
-(NSString *)amount_fmt{
    NSString *str=[LTUtils decimal2PWithFormat:self.amount.floatValue];
    return str;
}
//建仓价
-(NSString *)createPrice_fmt{
    NSString *str=[LTUtils decimalPriceWithCode:self.code floatValue:self.createPrice.floatValue];
    return str;
}
//平仓价
-(NSString *)closePrice_fmt{
    NSString *str=[LTUtils decimalPriceWithCode:self.code floatValue:self.closePrice.floatValue];
    return str;
}

-(NSString *)stopLoss_fmt{
    NSString *str=[LTUtils decimalPriceWithCode:self.code floatValue:self.stopLoss.floatValue];
    return str;
}
-(NSString *)stopProfit_fmt{
    NSString *str=[LTUtils decimalPriceWithCode:self.code floatValue:self.stopProfit.floatValue];
    return str;
}

- (NSString *)closeTime_fmt {
    NSString *timeStr = [self.closeTime stringFMD:@"M-d HH:mm" withSelfFMT:kyMd_Hms];
    return timeStr;
}


-(NSString *)profitLoss_fmt{
    NSString *str=[LTUtils decimal2PWithFormat:self.profitLoss.floatValue];
    return str;

}
- (NSString *)deferred_fmt{
    NSString *str=[LTUtils decimal2PWithFormat:self.deferred.floatValue];
    if (self.deferred.floatValue>0 && ![self.deferred isEqualToString:@"0"]) {
        str=[@"+" stringByAppendingString:str];
    }
    return str;
}
-(NSString *)fee_fmt{
    NSString *str=[LTUtils decimal2PWithFormat:self.fee.floatValue];
    return str;
}


-(NSString *)closeTypeStr{
    NSInteger closeTypeNum=self.closeType.integerValue;
    NSString *closeTypeStr=@"手动平仓";
    //3.手动平仓,4.止盈平仓,5.止损平仓,6.爆仓,7.休市平仓
    switch (closeTypeNum) {
        case 3:
            closeTypeStr=@"手动平仓";
            break;
        case 4:
            closeTypeStr=@"止盈平仓";
            break;
        case 5:
            closeTypeStr=@"止损平仓";
            break;
        case 6:
            closeTypeStr=@"爆仓";
            break;
        case 7:
            closeTypeStr=@"休市平仓";
            break;
        default:
            closeTypeStr=@"系统平仓";
            break;
    }
    return closeTypeStr;
}

@end
