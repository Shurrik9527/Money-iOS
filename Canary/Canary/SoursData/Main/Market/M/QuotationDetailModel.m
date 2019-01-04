//
//  QuotationDetailModel.m
//  ixit
//
//  Created by yu on 15/8/27.
//  Copyright (c) 2015年 ixit. All rights reserved.
//

#import "QuotationDetailModel.h"

@implementation QuotationDetailModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"Id"];
    }
}
- (instancetype)initWithDic:(NSDictionary *)item {
    
    if (self = [super init])
    {
        self.buy = [item objectForKey:@"buy"];
        self.excode=[item objectForKey:@"excode"];

        self.quotetime = [item objectForKey:@"quotetime"];
        self.decimal = [item objectForKey:@"decimal"];
        self.end = [item objectForKey:@"end"];
        self.code = [item objectForKey:@"code"];
        self.guid =[item objectForKey:@"guid"];
        self.high = [item objectForKey:@"high"];
        self.last = [item objectForKey:@"last"];
        self.lastclose=[item objectForKey:@"lastclose"];
        self.low = [item objectForKey:@"low"];
        self.middle = [item objectForKey:@"middle"];
        self.name = [item objectForKey:@"name"];
        self.open =[item objectForKey:@"open"];
        self.order = [item objectForKey:@"order"];
        self.sell = [item objectForKey:@"sell"];
        self.start=[item objectForKey:@"start"];
        self.updown = [item objectForKey:@"updown"];
        self.updownrate=[item objectForKey:@"updownrate"];
        self.volume = [item objectForKey:@"volume"];

    }
    return self;
}
-(void)dataWithProductDic:(NSDictionary *)item
{
#warning 由于长链接数据有问题时，缺少数据可能导致后续处理出错
    NSLog(@"item1=%@",item);
    if (item.allKeys.count<10) {
        return;
    }
    
    self.buy = [item stringFoKey:@"buy"];
    self.code = [item stringFoKey:@"code"];
    self.excode = [item stringFoKey:@"excode"];
    self.isClosed = [item stringFoKey:@"isClosed"];
    self.lastclose=[item stringFoKey:@"last_close"];
    self.low = [item stringFoKey:@"low"];
    self.updown = [item stringFoKey:@"margin"];
    self.updownrate=[item stringFoKey:@"mp"];
    self.name = [item stringFoKey:@"name"];
    self.open =[item stringFoKey:@"open"];
    self.sell = [item stringFoKey:@"sell"];
    self.time = [item stringFoKey:@"time"];
    self.high = [item stringFoKey:@"top"];
    self.quotetime = [item numberFoKey:@"updatetime"];
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
