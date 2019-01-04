//
//  PushRemindConfigModel.h
//  ixit
//
//  Created by Brain on 2017/2/20.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseMO.h"

@interface PushRemindConfigModel : BaseMO
/*
 code = HGNI;
 excode = HPME;
 exname = "\U54c8\U5c14\U6ee8\U8d35\U91d1\U5c5e\U4ea4\U6613\U4e2d\U5fc3";
 id = 8;
 limitSize = 4;
 maxSlidPoint = 10;
 minSlidPoint = 10;
 name = "\U54c8\U8d35\U954d";
 pointListStr = "5,10,15,20";
 status = 0;
 timeOut = 24;
 */
@property(copy,nonatomic)NSString * code;
@property(copy,nonatomic)NSString * excode;
@property(copy,nonatomic)NSString * exname;
@property(copy,nonatomic)NSString * qid;
@property(strong,nonatomic)NSNumber * limitSize;
@property(strong,nonatomic)NSNumber * maxSlidPoint;
@property(strong,nonatomic)NSNumber * minSlidPoint;
@property(copy,nonatomic)NSString * name;
@property(copy,nonatomic)NSString * pointListStr;
@property(strong,nonatomic)NSNumber * status;
@property(strong,nonatomic)NSNumber * timeOut;

// pointListStr = "5,10,15,20";
- (NSArray *)pointList_fmt;

@end
