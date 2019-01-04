//
//  integralVC.h
//  ixit
//
//  Created by Brain on 2016/12/12.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "IntegralMo.h"

@implementation IntegralMo


- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.validPoints = [dict numberFoKey:@"validPoints"];
        self.totalPoints = [dict numberFoKey:@"totalPoints"];
        self.totalExp = [dict numberFoKey:@"totalExp"];
        
        self.levelNum = [dict numberFoKey:@"levelNum"];
        self.minExp = [dict numberFoKey:@"minExp"];
        
        self.maxExp = [dict numberFoKey:@"maxExp"];
        self.rebateRate = [dict numberFoKey:@"rebateRate"];
        
        self.pointsRanking = [dict stringFoKey:@"pointsRanking"];
        self.levelName = [dict stringFoKey:@"levelName"];
        
        self.nextLevelRate = [dict floatFoKey:@"nextLevelRate"];
        self.versionNo = [dict intFoKey:@"versionNo"];
        
        NSArray *arr = [dict arrayFoKey:@"levelList"];
        if (arr.count > 0) {
            [IntegralMo saveVipLvList:arr];
            [IntegralMo saveVipLvVer:_versionNo];
        }
        
        

    }
    return self;
}

-(void)setValidPoints:(NSNumber *)validPoints{
    NSInteger valid =labs([validPoints integerValue]);
    NSNumber *validN=[NSNumber numberWithInteger:valid];
    _validPoints=validN;
}

+ (instancetype)objWithDict:(id)dict {
    return [[self alloc] initWithDict:dict];
}

//升级需要的经验值
- (NSString *)upgradeExp_fmt {
    long long int max = [self.maxExp longLongValue];
    long long int min = [self.minExp longLongValue];
    long long int curNeed = max - min;
    long long int needExp = curNeed*(1-self.nextLevelRate);
    NSNumber *expNum = @(needExp);
    NSString *exp = [expNum numberDecimalFmt];
    return exp;
}

//保存等级和折扣
- (void)saveLvAndRebateRate {
    if (![LTUser hasLogin]) {
        return;
    }
    [LTUser setUserVipLv:self.levelNum];
    [LTUser setUserVipLvDiscount:[self rebateRate_fmt]];
}

- (NSString *)validPoints_fmt {
    NSString *str = [NSString stringWithFormat:@"积分: %@",[self.validPoints numberDecimalFmt]];
    return str;
}

- (NSString *)totalExp_fmt {
    NSString *str = [NSString stringWithFormat:@"成长值: %@",[self.totalExp numberDecimalFmt]];
    return str;
}

- (NSString *)validPointsAndTotalExp_fmt {
    NSString *str = [NSString stringWithFormat:@"%@    |    %@",self.totalExp_fmt,self.validPoints_fmt];
    return str;
}


- (NSString *)validPoints_fmt1 {
    NSString *str = [self.validPoints numberDecimalFmt];
    return str;
}

- (NSString *)pointsRanking_fmt {
    return @"";
//    NSString *str = [NSString stringWithFormat:@"打败%@的八元用户",_pointsRanking];
//    return str;
}

//等级图片名称 Shop_pic_V1
- (NSString *)levelImgName {
    NSString *str = [NSString stringWithFormat:@"Shop_pic_V%@",_levelNum];
    return str;
}

//9  (可享受积分商城 %@ 折优惠)
- (NSString *)rebateRate_fmt {
    CGFloat tf = [_rebateRate floatValue];
    if ( tf >= 1) {
        return @"0";
    }
    CGFloat f = tf * 10;
    NSString *str = [NSString stringWithFormat:@"%g",f];
    return str;
}

//V3会员9折
- (NSString *)vipLevelName_fmt {
    NSString *str = [NSString stringWithFormat:@"%@会员%@折",_levelName,self.rebateRate_fmt];
    if ([_levelNum integerValue]==1) {
        str=@"V1会员无优惠";
    }
    return str;
}



#pragma mark - utils

+ (void)saveVipLvVer:(NSInteger)ver {
    [UserDefaults setInteger:ver forKey:kVipLvVerKey];
}

+ (NSInteger)vipLvVer {
    NSInteger ver = [UserDefaults integerForKey:kVipLvVerKey];
    return ver;
}


#define kVipLvListKey   @"kVipLvListKey"
+ (void)saveVipLvList:(NSArray *)arr {
    NSString *jsonArr = [arr toJsonString];
    [UserDefaults setObject:jsonArr forKey:kVipLvListKey];
}

+ (NSArray *)vipLvList {
    NSString *jsonArr = [UserDefaults objectForKey:kVipLvListKey];
    NSArray *arr = [jsonArr jsonStringToArray];
    NSMutableArray *list = [NSMutableArray arrayWithObjects:@"0", nil];
    for (NSDictionary *dict in arr) {
        NSString *ex = [dict stringFoKey:@"maxExp"];
        [list addObject:ex];
    }
    
    if (list.count < 7) {
        [IntegralMo saveVipLvVer:0];
        NSMutableArray *list = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
        return list;
    }
    
    return list;
}


//#define vipLvFileName @"vipLvList"
//+ (NSString *)vipLvPath {
//    NSString *path = pathOfDocumentFile(vipLvFileName);
//    return path;
//}
//
//+ (void)saveVipLvList:(NSArray *)arr {
//    NSString *path = [IntegralModel vipLvPath];
//    [arr writeToFile:path atomically:YES];
//}
//
//+ (NSArray *)vipLvList {
//    NSString *path = [IntegralModel vipLvPath];
//    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
//    NSMutableArray *list = [NSMutableArray arrayWithObjects:@"0", nil];
//    for (NSDictionary *dict in arr) {
//        NSString *ex = [dict stringFoKey:@"maxExp"];
//        [list addObject:ex];
//    }
//
//    if (list.count < 7) {
//        [IntegralModel saveVipLvVer:0];
//        NSMutableArray *list = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
//        return list;
//    }
//
//    return list;
//}


@end
