//
//  webSocket.h
//  Canary
//
//  Created by 孙武东 on 2019/1/21.
//  Copyright © 2019 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "SocketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebSocket : NSObject<SRWebSocketDelegate>

typedef void (^ReturnSocketBlock) (SocketModel *socketModel);

- (void)startConnectSocket;//开始连接

//- (void)cutOffSocket ;//断开连接
+ (WebSocket *)shareDataAsSocket;

@property(nonatomic, copy) ReturnSocketBlock returnValueBlock;

@end

NS_ASSUME_NONNULL_END
