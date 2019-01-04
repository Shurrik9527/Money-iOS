//
//  ChartroomVCtrl.m
//  ixit
//
//  Created by litong on 16/10/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "ChartroomVCtrl.h"
#import "ChatConfigure.h"

@interface ChartroomVCtrl ()

@property (nonatomic, strong) ChatConfigure *config;

@end

@implementation ChartroomVCtrl

- (void)dealloc {
    NSLog(@"ChartroomVCtrl dealloc");
}

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom {
//    self = [super initWithSession:[NIMSession session:chatroom.roomId type:NIMSessionTypeChatroom]];
//    if (self) {
//        _chatroom = chatroom;
//    }
    return self;
}

- (void)sendMessage:(NIMMessage *)message didCompleteWithError:(NSError *)error {
//    [super sendMessage:message didCompleteWithError:error];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64);
}

//- (id<NIMSessionConfig>)sessionConfig {
//    return self.config;
//}
-(void)exitChatRoom{
    [[NIMSDK sharedSDK].chatroomManager exitChatroom:_chatroom.roomId completion:nil];
}
#pragma mark - Get
- (ChatConfigure *)config {
    if (!_config) {
        _config = [[ChatConfigure alloc] initWithChatroom:self.chatroom.roomId];
    }
    return _config;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
