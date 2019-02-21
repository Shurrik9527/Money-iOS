//
//  HomeMarketList+CoreDataProperties.m
//  Canary
//
//  Created by jihaokeji on 2018/5/12.
//  Copyright © 2018年 litong. All rights reserved.
//
//

#import "HomeMarketList+CoreDataProperties.h"
#import "AppDelegate.h"
@implementation HomeMarketList (CoreDataProperties)

+ (NSFetchRequest<HomeMarketList *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"HomeMarketList"];
}

@dynamic buy_in;
@dynamic buy_out;
@dynamic close;
@dynamic dataStr;
@dynamic digit;
@dynamic high;
@dynamic isAllSelect;
@dynamic low;
@dynamic open;
@dynamic stops_level;
@dynamic symbol;
@dynamic symbol_cn;
@dynamic timeStr;
@dynamic trading;
@dynamic visible;


// 增加
+(BOOL)AddData:(MarketModel *)model{
    
    
    HomeMarketList *home=[NSEntityDescription insertNewObjectForEntityForName:@"HomeMarketList" inManagedObjectContext:kCoreDataContext];
    
    home.digit = model.digit;
    home.isAllSelect = model.digit;
    home.buy_in = model.buy_in;
    home.buy_out = model.buy_out;
    home.close = model.close;
    home.dataStr = model.dataStr;
    home.high = model.high;
    home.low = model.low;
    home.open = model.open;
    home.stops_level = model.stops_level;
    home.symbol = model.symbol;
    home.symbol_cn = model.symbol_cn;
    home.timeStr = model.timeStr;
    home.trading = model.trading;
    home.visible = home.visible;
    
    //保存, 将插入操作更新到数据库
    NSError *error;
    [kCoreDataContext save:&error];
    
    if (error == nil) {
        NSLog(@"数据存进去了");
        return YES;
    }
    return NO;
    
    
}

// 删除
+(void)DeleteAll{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HomeMarketList"];
    
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
    
    for (HomeMarketList*p in arr) {
        
        //删除数据
        [kCoreDataContext deleteObject:p];
        
    }
    
    //保存, 将删除操作更新到数据库中
    [kCoreDataContext save:nil];
}

+(void)Delete:(MarketModel *)model{
    
    NSString * string = model.symbol;
    
    //先查出数据, 然后再更新
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HomeMarketList"];
    
    //添加查询条件
    request.predicate=[NSPredicate predicateWithFormat:@"symbol=%@",string];
    
    //执行查询
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
    
    for (int i = 0; i < arr.count; i++) {
        
        if ([string isEqualToString:[[arr objectAtIndex:i] symbol]]) {
            
            for (HomeMarketList*home in arr) {
                
                [kCoreDataContext deleteObject:home];
            }
            
            
        }
    }
    
    [kCoreDataContext save:nil];
    
}

// 改
+ (void)andkey:(MarketModel*)model{
    
    //先查出数据, 然后再更新
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HomeMarketList"];
    
    if (!model.symbol || model.symbol.length == 0) {
        NSLog(@"symbol========%@",model.symbol);;
        return;
    }
    
    if ([model.symbol isEqual:[NSNull null]]) {
        NSLog(@"symbol========%@",model.symbol);;
        return;
    }
//    NSLog(@"symbol1111========%@",model.symbol);;

    //添加查询条件
    request.predicate=[NSPredicate predicateWithFormat:@"symbol=%@",model.symbol];

    //执行查询
    if (!request) {
        return;
    }
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:nil];
    
    for (int i = 0; i < arr.count; i++) {
        
        if ([model.symbol isEqualToString:[[arr objectAtIndex:i] symbol]]) {
            
            
            for (HomeMarketList *home in arr) {
                
                home.digit = model.digit;
                home.isAllSelect = model.digit;
                home.buy_in = model.buy_in;
                home.buy_out = model.buy_out;
                home.close = model.close;
                home.dataStr = model.dataStr;
                home.high = model.high;
                home.low = model.low;
                home.open = model.open;
                home.stops_level = model.stops_level;
                home.symbol = model.symbol;
                home.symbol_cn = model.symbol_cn;
                home.timeStr = model.timeStr;
                home.trading = model.trading;
                home.visible = home.visible;
               }
            
        }
        
    }
    
    NSError *error = nil;
    if ([kCoreDataContext save:&error]) {
//        NSLog(@"修改成功");
    }else{
        NSLog(@"修改失败");
    }
    
}

// 查找
+(NSArray *)searchAll
{
    //创建查询请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HomeMarketList"];
    
    NSError *error;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    
    if (error == nil) {
        return arr;
    }
    return nil;
}

// 按条件查找查找
+(NSArray *)searchConditions:(MarketModel *)model
{
    //创建查询请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"HomeMarketList"];
    //查询条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"symbol = %@",model.symbol];
    request.predicate = pre;
    NSError *error;
    NSArray *arr = [kCoreDataContext executeFetchRequest:request error:&error];
    
    if (error == nil) {
        return arr;
    }
    return nil;
}
@end
