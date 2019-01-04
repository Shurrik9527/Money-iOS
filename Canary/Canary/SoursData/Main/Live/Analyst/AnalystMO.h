//
//  AnalystMO.h
//  ixit
//
//  Created by litong on 2017/3/30.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface AnalystMO : BaseMO


@property (nonatomic, copy) NSString *auhtorName;// "一休",
@property (nonatomic, copy) NSString *authorId;// 24,
@property (nonatomic, copy) NSString *createTime;// 1490856643000,
@property (nonatomic, assign) NSInteger giftCount;// 1,礼物总个数
@property (nonatomic, copy) NSString *integralCount;// 88,
@property (nonatomic, copy) NSString *integralCountSimpleName;// "0.01万",总积分
@property (nonatomic, assign) NSInteger liveTimeCount;// 0,
@property (nonatomic, copy) NSString *liveTimeCountSimpleName;// "0万",直播总时长
@property (nonatomic, assign) NSInteger reminderCount;// 0,
@property (nonatomic, copy) NSString *reminderCountSimpleName;// "0万",总订阅数
@property (nonatomic, assign) NSInteger watchCount;// 0,
@property (nonatomic, copy) NSString *watchCountSimpleName;// "0.01万"总观看人数(JSON对象属性)

- (NSString *)liveTimeCount_fmt;
- (NSString *)watchCount_fmt;
- (NSString *)integralCount_fmt;

@end
