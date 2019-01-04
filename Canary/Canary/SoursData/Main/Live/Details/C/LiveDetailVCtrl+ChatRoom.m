//
//  LiveDetailVCtrl+ChatRoom.m
//  ixit
//
//  Created by litong on 16/10/28.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "LiveDetailVCtrl+ChatRoom.h"

@implementation LiveDetailVCtrl (ChatRoom)

- (void)createTipsWithMessage:(NSString *)msg time:(CGFloat)time {
//    CGFloat tmp = LTAutoW(16);
    CGFloat h = LTAutoW(52);
    if (!self.tips) {
        self.tips = [[LiveNoticeView alloc] initWithFrame:CGRectMake(ScreenW_Lit, self.tipsViewY, self.w_ , h)];
        [self.view addSubview:self.tips];
    }
    [self.tips configNoticeWithMsg:msg time:time];
}

- (void)reqTips {
    
}


#pragma mark - 聊天室

// 加入聊天室
- (void)enterChatRoom {
    kPublicData.chatRoomId=[NSNumber numberWithInteger:self.liveModel.chatRoomId.integerValue];
    self.isChatUser = [UserDefaults objectForKey:UD_ChatRoomUserKey];
    if (self.isChatUser)  {
        [self loginChatRoom];
    } else {
        [self regChatRoom];
    }
}
//离开聊天室
-(void)exitChatRoom {
    [self.chartroomVCtrl exitChatRoom];
    
    [[NIMSDK sharedSDK].chatroomManager removeDelegate:self];
}
//注册聊天室
- (void)regChatRoom {
    
    [self showLoadingWithMsg:nil];
    
    WS(ws);
    [RequestCenter requestRoomId:^(LTResponse *res) {
        [ws hideLoadingView];
        
        if (res.success) {
            
            self.isChatUser = YES;
            [UserDefaults setBool:self.isChatUser forKey:UD_ChatRoomUserKey];
            [ws loginChatRoom];
            
        } else {
            
            if ([res.code isEqualToString:@"40000"]) {
                [LTAlertView alertFieldMsg:@"请输入群聊昵称" sureTitle:@"确定" sureAction:^(NSString *inputStr) {
                    [ws loadRegistChatroomNickName:inputStr];
                } cancelTitle:@"取消" cancelAction:^{
                    [ws backAction];
                }];
            } else {
                if ([res.code isEqualToString:@"40001"]) {
                    [ws.view showTip:res.message];
                } else {
                    [LTAlertView alertMessage:res.message];
                }
            }
        }
    }];
    
}

//登录聊天室
- (void)loginChatRoom {
    
    WS(ws);
//    [self showLoadingWithMsg:@"登录聊天室中..."];
    
    //请将 NIMMyAccount 以及 NIMMyToken 替换成您自己提交到此App下的账号和密码
    if ([[NIMSDK sharedSDK].loginManager isLogined])
    {
        if ([[[NIMSDK sharedSDK].loginManager currentAccount]isEqualToString:UD_UserId])
        {
            [[NIMSDK sharedSDK].chatroomManager addDelegate:ws];
            [ws pushToLiveViewController];
        }
        else
        {
            [[NIMSDK sharedSDK].loginManager logout:^(NSError * _Nullable error) {
                NSLog(@"exit live and login.");
            }];
            [ws loginIM];
        }
    }
    else
    {
        [ws loginIM];
    }
    
    
}

-(void)loginIM
{
    WS(ws);
    NSLog(@"id === %@",UD_UserId);
    [[NIMSDK sharedSDK].loginManager login:UD_UserId token:@"defaultToken" completion:^(NSError *error) {
        ws.hadLoadData=NO;
        
        if (!error)  {
            [[NIMSDK sharedSDK].chatroomManager addDelegate:ws];
            [ws pushToLiveViewController];
        } else {
            NSString *toast = [NSString stringWithFormat:@"进入聊天室失败"];
            if (error.code==404) {
                toast = @"聊天室已关闭";
            }
            [LTAlertView alertMessage:toast];
        }
    }];

}


//注册进入聊天室昵称
- (void)loadRegistChatroomNickName:(NSString *)nickName {
    WS(ws);
    [RequestCenter reqChangeNickname:nickName finsh:^(LTResponse *res) {
        if (res.success) {
            [ws loginChatRoom];
             [ws.view showTip:@"修改昵称成功"];
        } else {
            [ws.view showTip:res.message];
        }
    }];
}

//获取聊天室成员
- (void)requestTeamHandler:(NIMChatroomMembersHandler)handler
{
    NIMChatroomMemberRequest *request = [[NIMChatroomMemberRequest alloc] init];
    request.roomId = self.liveModel.chatRoomId;
    request.type = NIMChatroomFetchMemberTypeRegular;
    request.limit = 20;
    
    [[NIMSDK sharedSDK].chatroomManager fetchChatroomMembers:request
                                                  completion:^(NSError *error, NSArray *members) {
                                                      NSArray *result;
                                                      if (!error) {
                                                          result = [members arrayByAddingObjectsFromArray:members];
                                                      }
                                                      handler(error, result);
                                                  }];
}
//获取聊天室会员信息
- (void)pushToLiveViewController {
    WS(ws);
    NSInteger levelNum=1;
    if ([NSObject isNotNull:[LTUser userVipLv]]) {
        levelNum = [[LTUser userVipLv] integerValue];
    }
    NSString *roomExt=[[NSMutableDictionary dictionaryWithObject:@(levelNum) forKey:@"levelNum"] toJsonString];
    NIMChatroomEnterRequest *request = [[NIMChatroomEnterRequest alloc] init];
    request.roomId = self.liveModel.chatRoomId;
    request.roomExt = roomExt;
    [[[NIMSDK sharedSDK] chatroomManager] enterChatroom:request completion:^(NSError *error, NIMChatroom *chatroom, NIMChatroomMember *me)
     {
        kPublicData.mineInfoAtChatroom = me;
         if (error == nil)
         {
             [ws requestTeamHandler:^(NSError *error, NSArray *members) {
                 //注入 NIMKit 内容提供者
                 DataProvider *dataProvider = [DataProvider new];
                 dataProvider.roomId = ws.liveModel.chatRoomId;
                 dataProvider.members = members;
//                 [[NIMSDK sharedKit] setProvider:dataProvider];
             }];
             ws.chartroomVCtrl = [[ChartroomVCtrl alloc] initWithChatroom:chatroom];
             [ws.scView setView:ws.chartroomVCtrl.view toIndex:0];
//             [ws showPersonNum:chatroom.onlineUserCount];
         } else {
             NSString *toast = [NSString stringWithFormat:@"进入聊天室失败"];
             if (error.code==404) {
                 toast = @"聊天室已关闭";
             }
             [ws.view showTip:toast];
         }
         
     }];
}



#pragma mark  NIMChatroomManagerDelegate

- (void)chatroom:(NSString *)roomId beKicked:(NIMChatroomKickReason)reason {
    NSString *toast = [NSString stringWithFormat:@"你被踢出聊天室"];
    WS(ws);
    [LTAlertView alertMessage:toast sureAction:^{
        [ws popVC];
    }];
    
    
}

- (void)chatroom:(NSString *)roomId connectionStateChanged:(NIMChatroomConnectionState)state {
//    NSLog(@"chatroomId : %@ connectionStateChanged:%zd", roomId, state);
}



#pragma mark  以下是 聊天室 黑名单 特殊处理
- (void)clearBlacklist {
    WS(ws);
    [RequestCenter requestRoomId:^(LTResponse *res) {
        if (res.success) {
            self.isChatUser = [UserDefaults boolForKey:UD_ChatRoomUserKey];
            if (!self.isChatUser) {
                self.isChatUser = YES;
                [UserDefaults setBool:self.isChatUser forKey:UD_ChatRoomUserKey];
            }
        } else {
            if ([res.code isEqualToString:@"40001"]) {
                [ws showTipAndAutoBack:res.message];
            }
        }
    }];
    
}

- (void)showTipAndAutoBack:(NSString *)msg {
    [self.view showTip:msg afterHide:2];
    [self backAction];
}

- (void)pollingBlackList {
    if (!self.myTimer) {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:60.f target:self selector:@selector(clearBlacklist) userInfo:nil repeats:YES];
    }
}

- (void)canclePollingBlackList {
    if (self.myTimer) {
        [self.myTimer setFireDate:[NSDate distantFuture]];
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

#pragma mark  能否发图片

- (void)reqCheckSendPic {
    
    if (!self.canSendPic) {
        [LTAlertView alertTitle:@"聊天室暂时禁止发送图片"];
        return;
    }
    
    WS(ws);
    [RequestCenter requestCheckSendPic:self.liveModel.channelId chatRoomId:self.liveModel.chatRoomId finish:^(LTResponse *res) {
        if (res.success) {
            NSInteger resInt = [res.rawDict integerFoKey:@"data"];
            BOOL canSendPic = (resInt == 0);
            ws.canSendPic = canSendPic;
            
            if (!canSendPic) {
                [LTAlertView alertTitle:@"聊天室暂时禁止发送图片"];
                return;
            } else {
//                [ws.chartroomVCtrl selectPic];
            }
        }
    }];
}


@end
