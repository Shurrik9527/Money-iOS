//
//  PushRemindConfigModel.m
//  ixit
//
//  Created by Brain on 2017/2/20.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "PushRemindConfigModel.h"

@implementation PushRemindConfigModel

// pointListStr = "5,10,15,20";
- (NSArray *)pointList_fmt {
    NSArray *arr = [self.pointListStr splitWithStr:@","];
    return arr;
}

@end
