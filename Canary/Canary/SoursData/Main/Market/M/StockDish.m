//
//  StockDish.m
//  FMStock
//
//  Created by dangfm on 15/5/4.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "StockDish.h"


@implementation StockDish

@dynamic quotetime;
@dynamic buy;
@dynamic decimal;
@dynamic draw;
@dynamic end;
@dynamic code;
@dynamic guid;
@dynamic high;
@dynamic last;
@dynamic lastclose;
@dynamic low;
@dynamic middle;
@dynamic name;
@dynamic open;
@dynamic order;
@dynamic sell;
@dynamic start;
@dynamic updown;
@dynamic updownrate;
@dynamic volume;

+(void)setStockDish:(StockDish*)stockdish Data:(NSDictionary *)dic{
    
    stockdish.buy = [dic objectForKey:@"Buy"];
    stockdish.code = [dic objectForKey:@"Code"];
    stockdish.decimal = [dic objectForKey:@"Decimal"];
    stockdish.draw = [dic objectForKey:@"Draw"];
    stockdish.end = [dic objectForKey:@"End"];
    stockdish.high = [dic objectForKey:@"High"];
    stockdish.last = [dic objectForKey:@"Last"];
    stockdish.lastclose = [dic objectForKey:@"LastClose"];
    stockdish.low = [dic objectForKey:@"Low"];
    stockdish.middle = [dic objectForKey:@"Middle"];
    stockdish.name = [dic objectForKey:@"Name"];
    stockdish.open = [dic objectForKey:@"Open"];
    NSNumber *order = [NSNumber numberWithDouble:[[dic objectForKey:@"Order"] intValue]];
    stockdish.order = order;
    NSNumber *quotetime = [NSNumber numberWithDouble:[[dic objectForKey:@"QuoteTime"] doubleValue]];
    stockdish.quotetime = quotetime;
    stockdish.sell = [dic objectForKey:@"Sell"];
    stockdish.start = [dic objectForKey:@"Start"];
    stockdish.updown = [dic objectForKey:@"UpDown"];
    stockdish.updownrate = [dic objectForKey:@"UpDownRate"];
    
    stockdish.volume = [dic objectForKey:@"Volume"];
    
    if ([stockdish.buy floatValue]<=0) {
        stockdish.buy = [dic objectForKey:@"Last"];
    }
    if ([stockdish.sell floatValue]<=0) {
        stockdish.sell = [dic objectForKey:@"Last"];
    }
    
    // 自己计算
    stockdish.updown = [LTUtils changeFormat:stockdish.sell ClosePrice:stockdish.lastclose];
    stockdish.updownrate = [LTUtils changeRateFormat:stockdish.sell ClosePrice:stockdish.lastclose];
}

@end
