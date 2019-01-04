//
//  StockDish.h
//  FMStock
//
//  Created by dangfm on 15/5/4.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StockDish : NSManagedObject

@property (nonatomic, retain) NSNumber * quotetime;
@property (nonatomic, copy) NSString * buy;
@property (nonatomic, copy) NSString * decimal;
@property (nonatomic, copy) NSString * draw;
@property (nonatomic, copy) NSString * end;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * guid;
@property (nonatomic, copy) NSString * high;
@property (nonatomic, copy) NSString * last;
@property (nonatomic, copy) NSString * lastclose;
@property (nonatomic, copy) NSString * low;
@property (nonatomic, copy) NSString * middle;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * open;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, copy) NSString * sell;
@property (nonatomic, copy) NSString * start;
@property (nonatomic, copy) NSString * updown;
@property (nonatomic, copy) NSString * updownrate;
@property (nonatomic, copy) NSString * volume;

+(void)setStockDish:(StockDish*)stockdish Data:(NSDictionary *)dic;

@end
