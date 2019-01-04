//
//  ChanceModel.h
//  Canary
//
//  Created by jihaokeji on 2018/5/3.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChanceModel : NSObject
/*
 "basic_detail" = "<null>";
 "basic_title" = "<null>";
 "basic_trend" = "<null>";
 date = "2018-03-12";
 id = 15;
 name = "\U82f1\U9551\U7f8e\U5143";
 range = 40;
 suggest = "\U76ee\U68070.789,\U6b62\U635f30%";
 "technology_detail" = "<null>";
 "technology_image" = "<null>";
 time = "00:00:01";
 title = "\U6fb3\U5143\U7f8e\U5143\U591a\U5934\U8d8b\U52bf\U4e0a\U653b";
 trend = "\U770b\U591a";
 type = "\U4e13\U5bb6\U89e3\U8bfb1";
 */

@property (nonatomic,copy)NSString * basic_detail;//不知名参数
@property (nonatomic,copy)NSString * basic_title;//不知名参数
@property (nonatomic,copy)NSString * basic_trend;//不知名参数
@property (nonatomic,copy)NSString * date;//日期
@property (nonatomic,copy)NSString * ID;//文章id
@property (nonatomic,copy)NSString * name;//文章名称
@property (nonatomic,copy)NSString * range;//买涨比例
@property (nonatomic,copy)NSString * suggest;//建议
@property (nonatomic,copy)NSString * technology_detail;//描述
@property (nonatomic,copy)NSString * technology_image;//描述图片
@property (nonatomic,copy)NSString * time;//时间
@property (nonatomic,copy)NSString * title;// 标题
@property (nonatomic,copy)NSString * trend;//品种名称
@property (nonatomic,copy)NSString * type;//类型


@end
