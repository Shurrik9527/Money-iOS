//
//  NIMChatroomMessageDataProvider.h
//  NIM
//
//  Created by chris on 15/12/14.
//  Copyright © 2015年 Netease. All rights reserved.
//

//#import "NIMKitMessageProvider.h"
#import <Foundation/Foundation.h>

@interface ChatroomMessageDataProvider : NSObject

- (instancetype)initWithChatroom:(NSString *)roomId;
//@property (nonatomic,strong) NIMSession *session;
@property (nonatomic,assign) NSInteger limit;
- (instancetype)initWithSession:(NSObject *)session;

@end
