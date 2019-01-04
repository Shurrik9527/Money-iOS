//
//  QuotationDetailModel.h
//  ixit
//
//  Created by yu on 15/8/27.
//  Copyright (c) 2015年 ixit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuotationDetailModel : NSObject

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
@property (nonatomic, copy) NSNumber * order;
@property (nonatomic, copy) NSString * sell;
@property (nonatomic, copy) NSString * start;
@property (nonatomic, copy) NSString * updown;
@property (nonatomic, copy) NSString * updownrate;
@property (nonatomic, copy) NSString * volume;
@property (nonatomic, copy) NSString * excode;
@property (nonatomic, copy) NSString * isClosed;
@property (nonatomic, copy) NSString * time;

//长链接
-(void)dataWithProductDic:(NSDictionary *)item;

#pragma mark - 类方法

+ (id)objWithDic:(NSDictionary *)infoDic;

+ (NSArray *)objsWithList:(NSArray *)list;

@end
