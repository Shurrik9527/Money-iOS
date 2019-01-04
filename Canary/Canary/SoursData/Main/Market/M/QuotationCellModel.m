//
//  QuotationCellModel.m
//  ixit
//
//  Created by yu on 15/8/19.
//  Copyright (c) 2015年 ixit. All rights reserved.
//

#import "QuotationCellModel.h"

@implementation QuotationCellModel

- (instancetype)initWithDic:(NSDictionary *)item {
    
    if (self = [super init]) {
        
        self.code = [item objectForKey:@"contract"];
        self.name = [item objectForKey:@"name"];
        self.out_price = [item objectForKey:@"sell"];
        self.excode =[item objectForKey:@"excode"];
        self.changerate = [item objectForKey:@"mp"];
        self.change = [item objectForKey:@"margin"];
        self.weipanId=[item objectForKey:@"quotationId"];
        
        
//        {
//            buy = "2303.2";
//            code = OIL;
//            excode = HPME;
//            id = 3;
//            isClosed = 1;
//            "last_close" = "2260.8";
//            low = "2253.6";
//            margin = "42.4";
//            mp = "1.88%";
//            name = "\U54c8\U8d35\U6cb9";
//            open = 2255;
//            sell = "2303.2";
//            time = "2016-09-05 20:46:06";
//            top = "2385.8";
//            updatetime = 1473079566000;
//        }
        
//        m.in_price = [item objectForKey:@"sell"];
//        NSString *open =[item objectForKey:@"open"];
//        if ([m.in_price floatValue]<=0) {
//            m.in_price = open;
//        }
//        if ([m.out_price floatValue]<=0) {
//            m.out_price = open;
//        }
//        self.lastclose_price = [item objectForKey:@"last_close"];
        
    }
    return self;
    
}



#pragma mark - 类方法


+ (id)objWithDic:(NSDictionary *)infoDic {
    return [[[self class] alloc] initWithDic:infoDic];
}

+ (NSArray *)objsWithList:(NSArray *)list {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in list) {
        [arr addObject:[[self class] objWithDic:dict]];
    }
    return [NSArray arrayWithArray:arr];
}



@end
