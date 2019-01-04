//
//  Quotation.h
//  ixit
//
//  Created by litong on 16/9/5.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Quotation : BaseMO


@property (nonatomic, copy) NSString * weipanId;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * excode;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * out_price;//sell
@property (nonatomic, copy) NSString * buy;
@property (nonatomic, copy) NSString * change;
@property (nonatomic, copy) NSString * changerate;

- (NSString *)productNamed;
- (NSString *)onlyKey;
- (NSString *)price_fmt;//out_price;//sell
- (NSString *)buy_fmt;//buy

#pragma mark - 类方法

+ (id)objWithDic:(NSDictionary *)infoDic;

+ (NSArray *)objsWithList:(NSArray *)list;

//产品列表直接转换成Quotation对象
+ (id)objProductDic:(NSDictionary *)infoDic;
+ (NSArray *)objsWithProductList:(NSArray *)list;



//{
//    buy = "2303.2";
//    code = OIL;
//    excode = HPME;
//    id = 3;
//    isClosed = 1;
//    "last_close" = "2260.8";
//    low = "2253.6";
//    margin = "42.4";
//    mp = "1.88%";
//    name = "\U54c8\U8d35\U6cb9";
//    open = 2255;
//    sell = "2303.2";
//    time = "2016-09-05 20:46:06";
//    top = "2385.8";
//    updatetime = 1473079566000;
//}


//buy = "5879.78";
//code = NAS100;
//excode = FXBTG;
//id = "";
//isClosed = "";
//"last_close" = "5884.63";
//low = "5875.13";
//margin = "-6.50";
//mp = "-0.11%";
//name = "\U7eb3\U65af\U8fbe\U514b\U6307\U6570";
//open = "5877.63";
//sell = "5878.13";
//time = "2017-06-05 10:27:15";
//top = "5882.33";
//updatetime = 1496629635865;


@end
