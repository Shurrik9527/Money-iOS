//
//  PollADModel.h
//  ixit
//
//  Created by litong on 2016/11/8.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface PollADModel : BaseMO

@property (nonatomic,strong) NSString *image;//图片URL
@property (nonatomic,strong) NSString *desc;//点击跳转网页的title
@property (nonatomic,strong) NSString *link;//点击跳转网页的url
@property (nonatomic,assign) NSInteger *BannerID;//BannerID
@property (nonatomic,strong) NSString *view_count;//浏览次数
@property (nonatomic,strong) NSString *datetime;
@property (nonatomic,strong) NSString *bannerDesc;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *imgAddress;
@property (nonatomic,strong) NSString *sortNo;

//contentId: 1543,
//title: "测试注册",
//image_url: "http://t.m.8caopan.com/images/appContent/list/0/0/1543/20160406112158399.jpg",
//url: "8caopan://register",
//summary: "测试注册",
//add_time: "2016-03-13 15:13:52"

@end
