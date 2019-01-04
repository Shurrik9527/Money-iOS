//
//  AnalystMO.m
//  ixit
//
//  Created by litong on 2017/3/30.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "AnalystMO.h"

@implementation AnalystMO

- (NSString *)liveTimeCount_fmt {
    if (self.liveTimeCount == 0) {
        return @"0";
    }
    return self.liveTimeCountSimpleName;
}

- (NSString *)watchCount_fmt {
    if (self.watchCount == 0) {
        return @"0";
    }
    return self.watchCountSimpleName;
}

- (NSString *)integralCount_fmt {
    if (self.integralCount == 0) {
        return @"0";
    }
    return self.integralCountSimpleName;
}

@end
