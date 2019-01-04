//
//  LiveTimeMo.h
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"


@interface LiveTimeMo : BaseMO


@property (nonatomic,copy) NSString *authorAvatar;
@property (nonatomic,copy) NSString *authorName;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *liveDescription;
@property (nonatomic,copy) NSString *professionalTitle;
@property (nonatomic,copy) NSString *liveTime;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *uuid;
@property (nonatomic,assign) NSInteger status;//直播状态（0，未直播，1直播中，2完成直播）

- (BOOL)isLiving;

/** 「震荡大师」一休 */
- (NSString *)name_fmt;
/** @[@"精准", @"幽默", @"专注贵金属投资经验"] */
- (NSArray *)introduction_fmt;

- (NSString *)startTime_fmt;

/*
 
     authorAvatar: "http://t.m.8caopan.com/images/appContent/author/0/0/24/20161229153520880.png",
     authorName: "一休",
     endTime: "11:30",
     introduction: "精准 | 幽默 | 专注贵金属投资经验",
     label: "",
     liveDescription: "视屏直播",
     liveTime: "10:00~11:30",
     professionalTitle: "特级分析师",
     startTime: "10:00",
     status: 2,
     uuid: "3afc5199-cab2-41bf-8fa4-c05d27928a5f"
 
 */


@end

