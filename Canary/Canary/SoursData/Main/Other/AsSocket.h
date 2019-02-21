//
//  AsSocket.h
//  SocketClient-Demo
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

@interface AsSocket : NSObject
typedef void (^ReturnValueBlock) (NSMutableArray *socketArray);

- (void)startConnectSocket;//开始连接
- (void)cutOffSocket ;//断开连接
+ (AsSocket *)shareDataAsSocket;
@property(nonatomic, copy) ReturnValueBlock returnValueBlock;

@end
