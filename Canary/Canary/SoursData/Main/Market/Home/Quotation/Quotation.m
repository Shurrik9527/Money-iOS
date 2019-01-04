//
//  Quotation.m
//  ixit
//
//  Created by litong on 16/9/5.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "Quotation.h"

@implementation Quotation



- (instancetype)initWithDic:(NSDictionary *)item {
    if (self = [super init]) {
        self.weipanId=[item objectForKey:@"id"];
        self.name = [item objectForKey:@"name"];
        self.excode = [item objectForKey:@"excode"];
        self.code = [item objectForKey:@"code"];
        
        self.out_price = [item stringFoKey:@"sell"];
        self.buy = [item stringFoKey:@"buy"];
        self.change = [item objectForKey:@"margin"];
        self.changerate = [item objectForKey:@"mp"];

    }
    return self;
}

- (instancetype)initProductDic:(NSDictionary *)item {
    
    if (self = [super init]) {
        self.weipanId=[item stringFoKey:@"productId"];
        self.name = [item stringFoKey:@"name"];
        self.excode = [item stringFoKey:@"excode"];
        self.code = [item stringFoKey:@"contract"];
        
        self.out_price = [item stringFoKey:@"sell"];
        self.buy = [item stringFoKey:@"buy"];
        self.change = [item stringFoKey:@"margin"];
        self.changerate = [item stringFoKey:@"mp"];
        
    }
    return self;
    
}


- (NSString *)productNamed {
    return self.name;
}
- (NSString *)onlyKey {
    NSString *str = [NSString stringWithFormat:@"%@|%@",self.excode,self.code];
    return str;
}

- (NSString *)price_fmt {
    if (_out_price) {
        NSString *str = [LTUtils decimalPriceWithCode:_code floatValue:[self.out_price floatValue]];
        return str;
    }
    return nil;
}

- (NSString *)buy_fmt {
    return [LTUtils decimalPriceWithCode:_code floatValue:[self.buy floatValue]];
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

//产品列表直接转换成Quotation对象
+ (id)objProductDic:(NSDictionary *)infoDic {
    return [[[self class] alloc] initProductDic:infoDic];
}
+ (NSArray *)objsWithProductList:(NSArray *)list {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in list) {
        [arr addObject:[[self class] objProductDic:dict]];
    }
    return [NSArray arrayWithArray:arr];
}




@end
