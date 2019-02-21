//
//  SelfList+CoreDataProperties.h
//  Canary
//
//  Created by jihaokeji on 2018/5/12.
//  Copyright © 2018年 litong. All rights reserved.
//
//

#import "SelfList+CoreDataClass.h"
#import "MarketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelfList (CoreDataProperties)

+ (NSFetchRequest<SelfList *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *buy_in;
@property (nullable, nonatomic, copy) NSString *buy_out;
@property (nullable, nonatomic, copy) NSString *close;
@property (nullable, nonatomic, copy) NSString *dataStr;
@property (nonatomic) int64_t digit;
@property (nullable, nonatomic, copy) NSString *high;
@property (nonatomic) int64_t isAllSelect;
@property (nullable, nonatomic, copy) NSString *low;
@property (nullable, nonatomic, copy) NSString *open;
@property (nullable, nonatomic, copy) NSString *stops_level;
@property (nullable, nonatomic, copy) NSString *symbol;
@property (nullable, nonatomic, copy) NSString *symbol_cn;
@property (nullable, nonatomic, copy) NSString *timeStr;
@property (nonatomic) BOOL trading;
@property (nonatomic) BOOL visible;




// 增加
+(BOOL)AddData:(MarketModel *)model;
// 删除
+(void)DeleteAll;
+(void)Delete:(NSString *)model;
// 改变
+(void)andkey:(MarketModel*)model;
// 查找
+(NSArray *)searchAll;
// 按条件查找
+(NSArray *)searchConditions:(MarketModel *)model;

@end

NS_ASSUME_NONNULL_END
