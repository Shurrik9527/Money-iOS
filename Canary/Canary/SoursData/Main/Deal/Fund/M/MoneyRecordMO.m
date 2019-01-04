//
//  MoneyRecordMO.m
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MoneyRecordMO.h"

@implementation MoneyRecordMO

//入金
+ (instancetype)inObjWithDict:(NSDictionary *)dict {
    MoneyRecordMO *mo = [[MoneyRecordMO alloc] init];
    mo.mid = [dict stringFoKey:@"id"];
    mo.amount = [dict stringFoKey:@"amount"];
    mo.time = [dict stringFoKey:@"createTime"];
    mo.state = [dict stringFoKey:@"state"];
    mo.balance = [dict stringFoKey:@"balance"];
    mo.name = [dict stringFoKey:@"title"];
    return mo;
}
+ (NSArray *)inObjsWithList:(NSArray *)list {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in list) {
        MoneyRecordMO *mo = [MoneyRecordMO inObjWithDict:dict];
        [arr addObject:mo];
    }
    return [NSArray arrayWithArray:arr];
}


//出金
+ (instancetype)outObjWithDict:(NSDictionary *)dict {
    MoneyRecordMO *mo = [[MoneyRecordMO alloc] init];
    mo.mid = [dict stringFoKey:@"logNo"];
    mo.amount = [dict stringFoKey:@"balance"];
    mo.time = [dict stringFoKey:@"lastHandleTime"];
    mo.state = [dict stringFoKey:@"state"];
    mo.name = [dict stringFoKey:@"title"];
    
    mo.bankName = [dict stringFoKey:@"bankName"];
    mo.bankDepositName = [dict stringFoKey:@"bankDepositName"];
    mo.bankNo = [dict stringFoKey:@"bankNo"];
    mo.mark = [dict stringFoKey:@"mark"];
    return mo;
}
+ (NSArray *)outObjsWithList:(NSArray *)list {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in list) {
        MoneyRecordMO *mo = [MoneyRecordMO outObjWithDict:dict];
        [arr addObject:mo];
    }
    return [NSArray arrayWithArray:arr];
}

@end
