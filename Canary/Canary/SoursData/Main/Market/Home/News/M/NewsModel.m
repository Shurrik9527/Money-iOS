//
//  NewsModel.m
//  ixit
//
//  Created by litong on 2016/11/8.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (void)changeTime {
    NSTimeInterval time = [_createTime doubleValue]/1000;
    NSString *oldYMDHms = [NSString stringFMD:kyMd_Hms withTimeInterval:time];
    NSString *nowYMD = [[NSDate date] chinaYMDString];
    NSArray *arr = [oldYMDHms splitWithStr:@" "];
    NSString *hms = nil;
    if (arr.count > 1) {
        hms = arr[1];
    }
    NSString *res = [NSString stringWithFormat:@"%@ %@",nowYMD,hms];
    
    NSDate *resDate = [NSDate dateFromString:res withFMT:kyMd_Hms];
    NSTimeInterval t = [resDate timeIntervalSince1970] *1000;
    _createTime = [NSNumber numberWithDouble:t];
}

+ (NSArray *)objsWithList:(NSArray *)list {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in list) {
        NewsModel *mo = [NewsModel objWithDict:dict];
        NSInteger top = mo.top;
        if (top> 0) {
            [mo changeTime];
        }
        [arr addObject:mo];
    }
    
    return arr;
}



- (NSString *)articleUrl {
    
    NSString *url = _articleUrl;
    if (emptyStr(url)) {
        return nil;
    }
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@?",url];
    NSString *userId = UD_UserId;
    if (userId) {
        [str appendFormat:@"userId=%@&",userId];
    }
    [str appendFormat:@"deviceType=%d&",kDeviceType];
    [str appendFormat:@"sourceId=%d&",kAPPType];
    [str appendFormat:@"informationId=%@&",_informactionId];
    [str appendFormat:@"articleId=%@",_articleId];
    
    return str;
}

- (NSString *)informactionContent {
    NSString *str = [_informactionContent trim];
    return str;
}

- (NSInteger)moreInt {
    NSInteger m = [self.more integerValue];
    NSInteger l = [self.less integerValue];
    NSInteger all = m + l;
    
    CGFloat mPer = 100.0*m/all;
    NSInteger mInt = round(mPer) ;
    return mInt;
}

- (NSString *)moreStr {
    NSInteger m = [self moreInt];
    NSString *mPer = [NSString stringWithFormat:@"%ld%@",(long)m,@"%"];
    return mPer;
}
- (NSString *)lessStr {
    NSInteger m = [self moreInt];
    NSInteger l = 100 - m;
    NSString *lPer = [NSString stringWithFormat:@"%ld%@",(long)l,@"%"];
    return lPer;
}

- (NSString *)authorPropose_fmt {
    if (emptyStr(_authorPropose)) {
        return nil;
    }
    return [NSString stringWithFormat:@"建议：%@",self.authorPropose];
}

- (UIColor *)titleColor {
    NSString *str = self.informactionAbstract;
    BOOL isRed = ([str contains:@"多"] || [str contains:@"涨"]);
    return isRed ? LTKLineRed : LTKLineGreen;
}

- (NSString *)createTimeYMD {
    NSString *ymd = [NSString stringFMD:@"MM月dd日" withTimeInterval:[self.createTime doubleValue]/1000];
    return ymd;
}

- (NSString *)getCellTypeTitle {
    NewsCellType tye = [self getCellType];
    if (tye == NewsCellType_Notice) {
        return @"  公告  ";
    }
    else if (tye == NewsCellType_MorningLayout) {
        return @"  早间布局  ";
    }
    else if (tye == NewsCellType_Quotation) {
        return @"  行情预演  ";
    }
    else if (tye == NewsCellType_DealChance) {
        return @"  专家解读  ";
    }
    else if (tye == NewsCellType_MorningNews) {
        return @"  早间资讯  ";
    }
    return @"";
}

- (NewsCellType)getCellType {
    return (NewsCellType)[self.informactionType integerValue];
}

- (NSString *)time_fmt {
    NSTimeInterval t = [self.createTime doubleValue]/1000;
    NSString *timeHMStr = [NSDate timeInterval:t withFMT:@"HH:mm"];
    return timeHMStr;
}

@end
