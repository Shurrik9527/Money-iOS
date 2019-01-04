//
//  ProductMO.m
//  Canary
//
//  Created by litong on 2017/5/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ProductMO.h"

@implementation ProductMO

//预付款
//- (NSString *)priceWithbuyNum:(CGFloat)num buyType:(BuyType)buyType {
//    CGFloat f = [_sellMargin floatValue];
////    if (buyType == BuyType_Up) {
////        f = [_buyMargin floatValue];
////    }
//    CGFloat price = num * f;
//    NSString *priceStr = [LTUtils decimal2PWithFormat:price];
//    return priceStr;
//}

- (NSString *)priceWithCurPoint:(CGFloat)curPoint {
//    CGFloat price = curPoint * [_calculatePoint floatValue] * [_floatingPl floatValue];
    CGFloat price = curPoint * [_floatingPl floatValue];
    NSString *priceStr =  [LTUtils decimal2PWithFormat:price];
    return priceStr;
}

- (BOOL)closed {
    BOOL bl = [_isClosed integerValue] == 1;
    return !bl;
}


- (NSString *)buy_fmt {
    NSString *price = [LTUtils decimalPriceWithCode:_code floatValue:[_buy floatValue]];
    return price;
}
- (NSString *)sell_fmt {
    NSString *price = [LTUtils decimalPriceWithCode:_code floatValue:[_sell floatValue]];
    return price;
}


- (NSString *)wavePointEarnWithNum:(NSString *)num type:(BuyType)type {
    CGFloat numf = [num floatValue];
    CGFloat earnf = numf * [_floatingPl floatValue];
    NSString *str =  [LTUtils decimal2PWithFormat:earnf];
    NSString *po = self.calculatePoint;
    NSString *typeStr = (type == BuyType_Up) ? @"涨" : @"跌";
    NSString*earn = [NSString stringWithFormat:@"每%@最小波动点%@，赚%@美元", typeStr, po, str];
    return earn;
}

#pragma mark - 计算点位

- (NSString *)pointLoss:(BuyType)type {
    CGFloat loss = 0;
    CGFloat min = [self.minStopLoss floatValue];
    if (type == BuyType_Up) {
        CGFloat sell = [_sell floatValue];
        loss = sell - min;
    } else {
        CGFloat buy = [_buy floatValue];
        loss = buy + min;
    }
    NSString *str = [LTUtils decimalPriceWithCode:_code floatValue:loss];
    return str;
}

- (NSString *)pointProfile:(BuyType)type {
    CGFloat profile = 0;
    CGFloat min = [self.minStopProfile floatValue];
    if (type == BuyType_Up) {
        CGFloat sell = [_sell floatValue];
        profile = sell + min;
    } else {
        CGFloat buy = [_buy floatValue];
        profile = buy - min;
    }
    NSString *str = [LTUtils decimalPriceWithCode:_code floatValue:profile];
    return str;
}

//预计盈利   止损
- (NSString *)referEarnLoss:(NSString *)loss type:(BuyType)type num:(CGFloat)num {
    CGFloat lossf = [loss floatValue];
    CGFloat p = 0;
    if (type == BuyType_Up) {
        CGFloat buy = [_buy floatValue];
        p = buy - lossf;
    } else {
        CGFloat sell = [_sell floatValue];
        p = lossf - sell;
    }
    if (p <= 0) {
        p = 0;
    }
    CGFloat calculatePoint = [_calculatePoint floatValue];
    CGFloat oneP = [_floatingPl floatValue] / calculatePoint;
    CGFloat earn = num * oneP * p;
    NSString *str =  [LTUtils decimal2PWithFormat:earn];
    return str;
}

//预计盈利   止盈
- (NSString *)referEarnProfile:(NSString *)profile type:(BuyType)type num:(CGFloat)num {
    CGFloat profilef = [profile floatValue];
    CGFloat p = 0;
    if (type == BuyType_Up) {
        CGFloat buy = [_buy floatValue];
        p = profilef - buy;
    } else {
        CGFloat sell = [_sell floatValue];
        p = sell - profilef;
    }
    if (p <= 0) {
        p = 0;
    }
    CGFloat calculatePoint = [_calculatePoint floatValue];
    CGFloat oneP = [_floatingPl floatValue] / calculatePoint;
    CGFloat earn = num * oneP * p;
    NSString *str =  [LTUtils decimal2PWithFormat:earn];
    return str;
}

//- (NSString *)pointLoss:(BuyType)type point:(CGFloat)point {
//    CGFloat loss = 0;
//    CGFloat min = [self.minStopLoss floatValue];
//    if (type == BuyType_Up) {
//        CGFloat sell = [_sell floatValue];
//        loss = sell - min + point;
//    } else {
//        CGFloat buy = [_buy floatValue];
//        loss = buy + min + point;
//    }
//    NSString *str = [LTUtils decimalPriceWithCode:_code floatValue:loss];
//    return str;
//}
//
//- (NSString *)pointProfile:(BuyType)type point:(CGFloat)point {
//    CGFloat profile = 0;
//    CGFloat min = [self.minStopProfile floatValue];
//    if (type == BuyType_Up) {
//        CGFloat sell = [_sell floatValue];
//        profile = sell + min + point;
//    } else {
//        CGFloat buy = [_buy floatValue];
//        profile = buy - min + point;
//    }
//    NSString *str = [LTUtils decimalPriceWithCode:_code floatValue:profile];
//    return str;
//}

#pragma mark - 买涨、跌 人数

- (NSString *)buyUpRate_fmtStr {
    NSInteger rate = [self.buyRate integerValue];
    NSString *rateString = [NSString stringWithFormat:@"%ld%%",rate];
    NSString *str = [NSString stringWithFormat:@"%@人选择",rateString];
    return str;
}
- (NSString *)buyDownRate_fmtStr {
    NSInteger rate = 100 - [self.buyRate integerValue];
    NSString *rateString = [NSString stringWithFormat:@"%ld%%",rate];
    NSString *str = [NSString stringWithFormat:@"%@人选择",rateString];
    return str;
}



- (NSAttributedString *)buyUpRate_fmtABStr {
    NSString *bigStr = @"买涨 ";
    NSString *smallStr = [self buyUpRate_fmtStr];
    NSAttributedString *ABStr = [self ABStr:bigStr smallStr:smallStr];
    return ABStr;
}
- (NSAttributedString *)buyDownRate_fmtABStr {
    NSString *bigStr = @"买跌 ";
    NSString *smallStr = [self buyDownRate_fmtStr];
    NSAttributedString *ABStr = [self ABStr:bigStr smallStr:smallStr];
    return ABStr;
}

#pragma mark - utils

#define kBuyFontBig     autoFontSiz(15)
#define kBuyFontSmall  autoFontSiz(12)
- (NSAttributedString *)ABStr:(NSString *)bigStr smallStr:(NSString *)smallStr {
    NSString *str = [NSString stringWithFormat:@"%@%@", bigStr, smallStr];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    [ABStr setAttributes:@{NSFontAttributeName:kBuyFontBig} range:NSMakeRange(0, bigStr.length)];
    [ABStr setAttributes:@{NSFontAttributeName:kBuyFontSmall} range:NSMakeRange(bigStr.length, smallStr.length)];
    return ABStr;
}

#pragma mark 价格排序的2维数组
+ (NSArray *)sortTo2DWithProductList:(NSArray *)productlist {

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSInteger plCount = productlist.count;
    for (NSInteger i = 0; i < plCount; i++) {

        ProductMO *model = productlist[i];
        if(![[dic allKeys] containsObject:model.contract]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:model];
            [dic setObject:array forKey:model.contract];
        } else {

            NSMutableArray *array = [dic objectForKey:model.contract];
            NSInteger arrayCount = array.count;
            for (NSInteger j = 0; j < arrayCount; j++) {
                ProductMO *mo = array[j];
                if (model.price.floatValue < mo.price.floatValue) {
                    [array insertObject:model atIndex:j];
                    break;
                }
                if (j == array.count - 1) {
                    [array addObject:model];
                    break;
                }
            }

        }
    }

    NSArray *allKeys = [dic allKeys];
    for (NSString *key in allKeys) {
        NSArray *vs = [dic arrayFoKey:key];
        if (vs.count >= 3) {
            NSArray *tempArr = [vs subarrayWithRange:NSMakeRange(0, 3)];
            [arr addObject:tempArr];
        }
    }

    return arr;
}

@end

