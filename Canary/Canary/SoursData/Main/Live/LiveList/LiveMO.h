//
//  LiveMO.h
//  Canary
//
//  Created by litong on 2017/5/15.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"
#import "LiveTimeMo.h"

@interface LiveMO : BaseMO

@property (nonatomic, copy) NSString *channelId;//	直播室编号
@property (nonatomic, copy) NSString *channelName;//	直播频道名称
@property (nonatomic, copy) NSString *channelDescribe;//	直播室描述
@property (nonatomic, copy) NSString *channelStatus;//	直播室状态  1:直播中  0:休息中
@property (nonatomic, copy) NSString *channelStatusName;//	直播室状态名称
@property (nonatomic, copy) NSString *rtmpDownstreamAddress;//	拉流地址
@property (nonatomic, copy) NSString *hlsDownstreamAddress;//	拉流地址
@property (nonatomic, copy) NSString *chatRoomId;//	聊天室编号
@property (nonatomic, copy) NSString *activityName;//	活动名称
@property (nonatomic, copy) NSString *liveTime;//	直播时间段
//@property (nonatomic, copy) NSString *sendPicStatus;//	是否允许发图片（0，允许，1不允许）
@property (nonatomic,assign) NSInteger sendPicStatus;//1:聊天室不允许发送图片, 0:可以
@property (nonatomic, copy) NSString *image;//	背景图地址
@property (nonatomic, copy) NSString *hidden;//	是否隐藏
@property (nonatomic, copy) NSString *onlineNumber;//	在线人数
@property (nonatomic, copy) NSString *onlineNumberSimpleName;//	在线人数（万为单位保留两位小数，小于10000则用数字表示）
@property (nonatomic, copy) NSString *color;//	活动字体颜色
@property (nonatomic, copy) NSString *authorId;//	Long	作者编号
@property (nonatomic, copy) NSString *authorName;//	作者名称
@property (nonatomic, copy) NSString *label;//	标签（多个逗号分隔）
@property (nonatomic, assign) NSInteger isPay;//int	是否为付费观看的（1免费，2付费）
@property (nonatomic, assign) NSInteger channelType	;//int	直播室类型（1.文字直播，2视频）
@property (nonatomic, strong) NSArray *liveTimeList;//	JSONARRAY	segmentModel字段一致
@property (nonatomic, copy) NSDictionary *segmentModel;//	JSON

@property (nonatomic, copy) NSString *cardId;

+ (NSArray *)objsWithList:(NSArray *)list;

- (BOOL)canShow;
- (NSString *)onlineNumberSimpleName_fmt;
- (NSString *)cardId_fmt;
- (BOOL)isLiving;
- (BOOL)canSendPic;
- (NSString *)beginTime_fmt;
- (NSString *)descStr_fmt;
- (NSString *)lableStr_fmt;
- (NSArray *)liveTimeList_fmt;
- (LiveTimeMo *)segmentModel_fmt;


@end
