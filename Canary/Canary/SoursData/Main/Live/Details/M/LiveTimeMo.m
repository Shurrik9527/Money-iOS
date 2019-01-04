//
//  LiveTimeMo.m
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveTimeMo.h"

@implementation LiveTimeMo

- (BOOL)isLiving {
    BOOL bl = (self.status == 1);
    return bl;
}

- (NSString *)name_fmt {
    NSString *str = [NSString stringWithFormat:@"「%@」%@",self.professionalTitle,self.authorName];
    return str;
}

- (NSArray *)introduction_fmt {
    NSArray *arr = [self.introduction splitWithStr:@"|"];
    return arr;
}

- (NSString *)startTime_fmt {
    NSString *str = [NSString stringWithFormat:@"%@开播",self.startTime];
    return str;
}

@end
