//
//  NIMChatroomMessageDataProvider.m
//  NIM
//
//  Created by chris on 15/12/14.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import "ChatroomMessageDataProvider.h"

@interface ChatroomMessageDataProvider ()

@property (nonatomic, copy) NSString *roomId;

@end

@implementation ChatroomMessageDataProvider

- (instancetype)initWithChatroom:(NSString *)roomId {
    self = [super init];
    if (self) {
        _roomId = roomId;
    }
    return self;
}
//- (instancetype)initWithSession:(NIMSession *)session
//{
//    self = [super init];
//    if (self)
//    {
//        _session = session;
//    }
//    return self;
//}

//- (void)pullDown:(NIMMessage *)firstMessage handler:(NIMKitDataProvideHandler)handler {
//
//    NIMHistoryMessageSearchOption *option = [[NIMHistoryMessageSearchOption alloc] init];
//    option.startTime = firstMessage.timestamp;
//    option.limit = 10;
//    if (_session.sessionType==NIMSessionTypeP2P && _session)
//    {
//        [[NIMSDK sharedSDK].conversationManager fetchMessageHistory:self.session option:option result:^(NSError *error, NSArray *messages) {
//            if (handler) {
//                handler(error,messages.reverseObjectEnumerator.allObjects);
//                if (handler)
//                {
//                    handler(error, messages.reverseObjectEnumerator.allObjects);
//                }
//            };
//        }];
//    }
//    else
//    {
//        [[NIMSDK sharedSDK]
//         .chatroomManager fetchMessageHistory:self.roomId
//         option:option
//         result:^(NSError *error, NSArray *messages) {
//             if (handler) {
//                 handler(error, messages.reverseObjectEnumerator.allObjects);
//             }
//         }];
//
//    }
//}

- (BOOL)needTimetag {
    return NO;
}

@end
