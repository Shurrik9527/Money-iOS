//
//  LiveDetailVCtrl+ChatRoom.h
//  ixit
//
//  Created by litong on 16/10/28.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "LiveDetailVCtrl.h"

@interface LiveDetailVCtrl (ChatRoom)

- (void)reqCheckSendPic;
- (void)createTipsWithMessage:(NSString *)msg time:(CGFloat)time;
- (void)reqTips;

- (void)enterChatRoom;
- (void)exitChatRoom;
- (void)pollingBlackList;
- (void)canclePollingBlackList;

@end
