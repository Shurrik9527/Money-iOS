//
//  LiveDetailVCtrl+SendGift.h
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveDetailVCtrl.h"

@interface LiveDetailVCtrl (SendGift)

- (void)hideAndClearGift;
- (void)operationManagerRemoveAllData;
- (void)reqLiveWatchUserAdd;
- (void)createGiftListView;
- (void)reqGiftList;

//点击礼物按钮
- (void)giftButtonAciton;
/** 分析师收到礼物   云信长连接消息
 */
- (void)analystReceiveGift:(NSNotification *)sender;


@end
