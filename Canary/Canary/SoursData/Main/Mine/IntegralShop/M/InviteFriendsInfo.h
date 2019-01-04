//
//  InviteFriendsInfo.h
//  ixit
//
//  Created by litong on 2017/1/19.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"

#define kMeIFRedTittle  @"赚积分"

@interface InviteFriendsInfo : BaseMO

/** 活动状态：0=结束，1=开启 */
@property (nonatomic,assign) BOOL status;

@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *linkTitle;
@property (nonatomic,copy) NSString *pic;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subject;

- (NSString *)title_fmd;

/*
 link = "http://t.w.8caopan.com/activity/hyyq/?userId=125068&sourceId=10";
 linkTitle = "\U9080\U8bf7\U597d\U53cb";
 pic = "http://t.m.8caopan.com/static/images/hyyq.png";
 status = 1;
 subject = "800\U4e07\U73b0\U91d1,\U9001\U5b8c\U4e3a\U6b62";
 title = "\U9080\U8bf7\U597d\U53cb\U8d5a\U53d6\U79ef\U5206";
 */

@end
