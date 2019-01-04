//
//  LiveDetailVCtrl+SendGift.m
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveDetailVCtrl+SendGift.h"
#import "SGOperationManager.h"


@implementation LiveDetailVCtrl (SendGift)

- (void)hideAndClearGift {
    SGOperationManager *manager = self.giftManager;
    [manager cancleAllOperation];
}

- (void)operationManagerRemoveAllData {
    SGOperationManager *manager = self.giftManager;
    manager.parentView = nil;
    [manager clearData];
    self.giftListView = nil;
}

- (void)reqLiveWatchUserAdd {
    NSString *authorID = [self.liveModel authorId];
    NSString *liveLookerKey = [NSString stringWithFormat:@"AuthorId%@LiveLookerId%@",authorID,UD_UserId];
    BOOL bl = [UserDefaults boolForKey:liveLookerKey];
    if (bl) {
        return;
    }
    __block NSString *liveLookerKey0 = [liveLookerKey copy];
    [RequestCenter reqLiveWatchUserAdd:authorID finish:^(LTResponse *res) {
        if (res.success) {
            [UserDefaults setBool:NO forKey:liveLookerKey0];
        }
    }];
}

- (void)createGiftListView {
    self.giftListView = [[GiftListView alloc] init];
    [self.view addSubview:self.giftListView];
    
    WS(ws);
    [self.giftListView setSendGiftBlock:^(NSInteger selectId){
        [ws sendGiftAction:selectId];
    }];
}

- (void)reqGiftList {
    WS(ws);
    [RequestCenter reqLiveGifts:0 pageSize:20 finish:^(LTResponse *res) {
        if (res.success) {
            [ws configGiftData:res.resDict];
        } else {
            [ws.view showTip:res.message];
        }
    }];
}

- (void)configGiftData:(NSDictionary *)dict {
    LiveGiftListMO *liveGiftListMO = [LiveGiftListMO objWithDict:dict];
    
    NSInteger oldVer = [LiveGiftMO giftDataVer];
    NSInteger ver = liveGiftListMO.picVersionNo;
    if (oldVer < ver) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setInteger:ver forKey:kGiftDataVerKey];
        NSArray *arr = [liveGiftListMO giftList_fmt];
        for (LiveGiftMO *mo in arr) {
            [dic setObject:mo.giftPic forKey:[LiveGiftMO giftImgKey:mo.giftId]];
        }
        [LiveGiftMO saveGiftImgDict:dic];
    }
    
    self.liveGiftListMO = liveGiftListMO;
    [self.giftListView configData:liveGiftListMO name:self.liveModel.segmentModel_fmt.authorName];
}

- (void)giftButtonAciton {
    [self showGiftView:YES];
    return;
}

- (void)showGiftView:(BOOL)show {
    [self.giftListView showView:YES];
}

/** 分析师收到礼物   云信长连接消息
 */
- (void)analystReceiveGift:(NSNotification *)sender {
    NSLog(@"analystReceiveGift");
    NSDictionary *dict = (NSDictionary *)sender.userInfo;
    NSLog(@"analystReceiveGift = %@",dict);
    
    if (!self.needHideGift) {
        [self receiveGiftAction:dict];
    }
}


- (void)sendGiftAction:(NSInteger)selectId {
    
    NSArray *gifts = self.liveGiftListMO.giftList_fmt;
    LiveGiftMO *mo = gifts[selectId];
    
//    giftId	true	普通参数	Long		礼物ID
//    authorId	true	普通参数	Long		老师ID
//    channelId	true	普通参数	String		直播室ID
//    roomId	true	普通参数	Long		聊天室ID
    NSDictionary *dict = @{
                           @"giftId" : mo.giftId,
                           @"authorId" : self.liveModel.authorId,
                           @"channelId" : self.liveModel.channelId,
                           @"roomId" : self.liveModel.chatRoomId,
                           };
    WS(ws);
    [RequestCenter reqLiveGiftExchange:dict finish:^(LTResponse *res) {
        if (res.success) {
            NSString *validPoints = [res.resDict stringFoKey:@"validPoints"];
            [ws.giftListView refValidPoints:validPoints];
        } else {
            [ws.view showTip:res.message];
        }
    }];
    
}

- (void)mineSendGift:(LiveGiftMO *)mo configPoint:(NSString *)validPoints {
    [self.giftListView refValidPoints:validPoints];
    
    SendGiftMo *giftMo = [[SendGiftMo alloc] init];
    giftMo.senderId = UD_UserId;
    giftMo.senderName = UD_NickName;
    giftMo.senderLv = [[LTUser userVipLv] integerValue];
    
    giftMo.giftId = mo.giftId;
    giftMo.giftName = mo.giftName;
    giftMo.giftCount = 1;
    
    [self showGiftAnimate:giftMo];
}

- (void)receiveGiftAction:(NSDictionary *)dic {
//    NSLog(@"receiveGiftAction = %@",dic);
    SendGiftMo *giftMo = [SendGiftMo objWithDict:dic];
    if (!giftMo) {
        return;
    }
//    if ([giftMo.senderId isEqualToString:UD_UserId]) {
//        return;
//    }
    if (self.segmentView.curIdx==0) {
        [self showGiftAnimate:giftMo];
    }
}


- (void)showGiftAnimate:(SendGiftMo *)giftMo {
    if (!self.giftManager) {
        self.giftManager = [SGOperationManager sharedManager];
        self.giftManager.parentView = self.view;
    }
    [self.giftManager animWithOnlyKey:giftMo.onlyKey model:giftMo finishedBlock:^(BOOL result) {
        
    }];
//    SGOperationManager *manager = [SGOperationManager sharedManager];
//    manager.parentView = self.view;
//    [manager animWithUserID:giftMo.onlyKey model:giftMo finishedBlock:^(BOOL result) {
//
//    }];
}




/*

#define names @[@"张三ddddddddddddd", @"李四要发要发要发要发", @"王五来了", @"马六你大爷", @"弯弯の月牙儿"]
#define lvs @[@(2), @(6), @(7), @(5), @(4)]
// 模拟收到礼物消息的回调
- (void)receiveGiftAction:(NSInteger)selectId {
    
    NSArray *gifts = self.liveGiftListMO.giftList_fmt;
    LiveGiftMO *mo = gifts[selectId];
    
    int x = arc4random() % 5;
    NSString *name = names[x];
    NSString *senderId = [NSString stringWithFormat:@"%d",x];
    // 礼物模型
    SendGiftMo *giftMo = [[SendGiftMo alloc] init];
    giftMo.giftName = mo.giftImgName_ftm;
    giftMo.senderName = name;
    giftMo.senderId = senderId;
    giftMo.senderLv = [lvs[x] integerValue];
    giftMo.giftCount = 1;
    
    
    SGOperationManager *manager = [SGOperationManager sharedManager];
    manager.parentView = self.view;
    // 用用户唯一标识 msg.senderChatID 存礼物信息,model 传入礼物模型
    [manager animWithUserID:[NSString stringWithFormat:@"%@",senderId] model:giftMo finishedBlock:^(BOOL result) {
        
    }];
}
*/

@end
