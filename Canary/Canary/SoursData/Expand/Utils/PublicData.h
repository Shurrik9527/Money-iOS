//
//  PublicData.h
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//  数据保存在内存中

#import <Foundation/Foundation.h>
#import "LiveMO.h"
//#import "NIMChatroomMember.h"
#import <NIMSDK/NIMChatroomMember.h>
#define kPublicData [PublicData sharedData]

@interface PublicData : NSObject

//是否是客服页
@property(assign,nonatomic)BOOL isCustomer;
@property(strong,nonatomic)NSMutableDictionary * replayCellHeight;
//标记自己在聊天室里的信息
@property(strong,nonatomic)NIMChatroomMember *mineInfoAtChatroom;
//chatroomId
@property(strong,nonatomic)NSNumber *chatRoomId;
//分时图的时间列表
@property(strong,nonatomic)NSMutableArray *timeList;
@property(strong,nonatomic)NSArray * json_stockindexs;
@property(strong,nonatomic)NSArray * json_defProTypeList;



@property (nonatomic,strong) LiveMO *liveMO;

//创建单例
+ (PublicData *)sharedData;
//判空方法
-(BOOL)isNull:(id)object;

@end
