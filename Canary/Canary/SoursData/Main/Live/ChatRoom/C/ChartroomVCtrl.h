//
//  ChartroomVCtrl.h
//  ixit
//
//  Created by litong on 16/10/27.
//  Copyright © 2016年 litong. All rights reserved.
//

//#import "NIMKit.h"
#import <NIMSDK/NIMSDK.h>

@interface ChartroomVCtrl : UIViewController

@property (nonatomic, strong) NIMChatroom *chatroom;

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;
-(void)exitChatRoom;

@end
