//
//  QuotationCellModel.h
//  ixit
//
//  Created by yu on 15/8/19.
//  Copyright (c) 2015年 ixit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuotationCellModel : NSObject
@property (nonatomic, retain) NSNumber * addtime;
@property (nonatomic, copy) NSString * guid;
@property (nonatomic, copy) NSString * in_price;
@property (nonatomic, retain) NSNumber * istop;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, copy) NSString * last_price;
@property (nonatomic, copy) NSString * lastclose_price;

@property (nonatomic, copy) NSString * changerate;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * out_price;
@property (nonatomic, copy) NSString * change;
@property (nonatomic, copy) NSString * excode;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * weipanId;




#pragma mark - 类方法

+ (id)objWithDic:(NSDictionary *)infoDic;

+ (NSArray *)objsWithList:(NSArray *)list;

@end
