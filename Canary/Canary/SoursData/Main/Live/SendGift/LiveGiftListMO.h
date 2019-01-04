//
//  LiveGiftListMO.h
//  ixit
//
//  Created by litong on 2017/3/30.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"
#import "LiveGiftMO.h"

/** 聊天室礼物列表 */
@interface LiveGiftListMO : BaseMO

@property (nonatomic, copy) NSString *validPoints;//	可用积分
@property (nonatomic, assign) NSInteger levelNum;//	当前等级数
@property (nonatomic, assign) CGFloat rebateRate;//	等级折扣率
@property (nonatomic,strong) NSArray *giftList;//礼物列表
@property (nonatomic, assign) NSInteger picVersionNo;

- (NSArray *)giftList_fmt;

@end
