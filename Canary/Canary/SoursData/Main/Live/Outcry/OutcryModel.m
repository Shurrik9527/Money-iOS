//
//  OutcryModel.m
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "OutcryModel.h"

@implementation OutcryModel

#define markLimit 2
- (NSArray *)lable_fmt {
    NSArray *arr = [self.label splitWithStr:@","];
    if (arr.count > markLimit) {
        arr = [arr subarrayWithRange:NSMakeRange(0, markLimit)];
    }
    return arr;
}

- (NSAttributedString *)styleContent_fmt {
    NSAttributedString *ABStr = [[NSAttributedString alloc] initWithData:[self.styleContent dataUsingEncoding:NSUnicodeStringEncoding]
                                     options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                          documentAttributes:nil
                                       error:nil];
    return ABStr;
}

- (BOOL)top_fmt {
    return self.top > 0;
}


- (NSString *)createTime_fmt {
    
    NSString *ct = self.createTime;
    if (!ct) {
        return ct;
    }
    
    double dt = [ct doubleValue];
    double tf = (dt > pow(10, 11)) ? dt / 1000 : dt;
    
    ct = [NSString stringWithFormat:@"%f",tf];
    NSString *ymd  = [ct timeIntervalStringToFMD:@"yyyy-MM-dd HH:mm"];
    NSString *curymd = [[NSDate date] chinaYMDString];
    
    if ([ymd contains:curymd]) { //今天
        NSString *timeStr = [ct timeIntervalStringToFMD:@"HH:mm"];
        return [NSString stringWithFormat:@"今天  %@",timeStr];
    } else {
        return ymd;
    }
    
//    NSString *dateStr = self.createTime;
//    if (!dateStr) {
//        return dateStr;
//    }
//    
//    NSString *ymd = [dateStr stringFMD:@"yyyy-MM-dd HH:mm"];
//    NSString *curymd = [[NSDate date] beijingYMDString];
//    
//    if ([ymd contains:curymd]) { //今天
//        NSString *timeStr = [dateStr stringFMD:@"HH:mm"];
//        return [NSString stringWithFormat:@"今天  %@",timeStr];
//    } else {
//        return ymd;
//    }
}

@end
