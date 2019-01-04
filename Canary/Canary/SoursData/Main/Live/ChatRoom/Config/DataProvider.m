//
//  DataProvider.m
//  DemoApplication
//
//  Created by chris on 15/10/7.
//  Copyright © 2015年 chris. All rights reserved.
//

#import "DataProvider.h"

@implementation DataProvider
//- (NIMKitInfo *)infoByUser:(NSString *)userId
//                 inSession:(NIMSession *)session
//{
//    BOOL needFetchInfo = NO;
//    NIMSessionType sessionType = session.sessionType;
//    NIMKitInfo *info = [[NIMKitInfo alloc] init];
//    info.infoId = userId;
//    info.showName = userId; //默认值
//    switch (sessionType) {
//        case NIMSessionTypeP2P:
//        case NIMSessionTypeTeam:
//        {
//            NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userId];
//            NIMUserInfo *userInfo = user.userInfo;
//            NIMTeamMember *member = nil;
//            if (sessionType == NIMSessionTypeTeam)
//            {
//                member = [[NIMSDK sharedSDK].teamManager teamMember:userId
//                                                             inTeam:session.sessionId];
//            }
//            NSString *name = [self nickname:user
//                                 memberInfo:member];
//            if (name)
//            {
//                info.showName = name;
//            }
//            info.avatarUrlString = userInfo.thumbAvatarUrl;
//            
//            if (userInfo == nil)
//            {
//                needFetchInfo = YES;
//            }
//        }
//            break;
//        case NIMSessionTypeChatroom:
//            NSAssert(0, @"invalid type"); //聊天室的Info不会通过这个回调请求
//            break;
//        default:
//            NSAssert(0, @"invalid type");
//            break;
//    }
//    
//    if (needFetchInfo)
//    {
//        NSArray *userIds=@[userId];
////        __weak typeof(self) weakSelf = self;
//        [[NIMSDK sharedSDK].userManager fetchUserInfos:userIds
//                                            completion:^(NSArray *users, NSError *error) {
//                                                if (!error) {
//                                                    [[NIMKit sharedKit] notfiyUserInfoChanged:userIds];
//                                                }
//                                            }];
//        
//    }
//    return info;
//}
//- (NIMKitInfo *)infoByUser:(NSString *)userId withMessage:(NIMMessage *)message {
//    if (message.session.sessionType == NIMSessionTypeChatroom)
//    {
//        NIMMessageChatroomExtension *ext = [message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]] ?
//        (NIMMessageChatroomExtension *)message.messageExt : nil;
//        NIMKitInfo *info = [[NIMKitInfo alloc] init];
//        info.avatarImage = [UIImage imageNamed:@"DefaultAvatar"];
//        info.infoId = userId;
//        info.showName = message.senderName;
//        info.avatarUrlString = ext.roomAvatar;
//        NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:[NIMSDK sharedSDK].loginManager.currentAccount];
//        if ([user.userId isEqualToString:userId]) {
//            info.showName = [user.userInfo.nickName copy];
//            info.avatarUrlString = user.userInfo.avatarUrl;
//            if (kPublicData.mineInfoAtChatroom.type == NIMChatroomMemberTypeCreator ||
//                kPublicData.mineInfoAtChatroom.type == NIMChatroomMemberTypeManager)
//            {
//                //判断自身是否为管理员
//                info.isUserManger=YES;
//            }
//            else
//            {
//                info.isUserManger=NO;
//            }
//        } else {
//            //用于判断是否在用户列表中
//            __block BOOL isHasUser=NO;
//            [self.members enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop)
//             {
//                 NIMChatroomMember *member = (NIMChatroomMember *) obj;
//                 if ([member.userId isEqualToString:userId]) {
//                     isHasUser = YES;
//                     info.showName = member.roomNickname;
//                     info.avatarUrlString = member.roomAvatar;
//                     info.showName = [NSString stringWithFormat:@"%@", member.roomNickname];
//                     //管理员或者创建者
//                     if (member.type == NIMChatroomMemberTypeManager ||member.type == NIMChatroomMemberTypeCreator) {
//                         info.isUserManger=YES;
//                     }
//                     else
//                     {
//                         info.isUserManger=NO;
//                     }
//                 }
//             }];
//            if (!isHasUser)
//            {
//                info.isUserManger=NO;
//            }
//        }
//        return info;
//    }
//    else
//    {
//        return [self infoByUser:userId
//                      inSession:message.session];
//    }
//}
#pragma mark - nickname
- (NSString *)nickname:(NIMUser *)user
            memberInfo:(NIMTeamMember *)memberInfo
{
    NSString *name = nil;
    do{
        if ([user.alias length])
        {
            name = user.alias;
            break;
        }
        if (memberInfo && [memberInfo.nickname length])
        {
            name = memberInfo.nickname;
            break;
        }
        
        if ([user.userInfo.nickName length])
        {
            name = user.userInfo.nickName;
            break;
        }
    }while (0);
    return name;
}
@end
