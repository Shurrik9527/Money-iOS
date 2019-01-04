//
//  LTSocketServe.h
//  TestSocket
//
//  Created by litong on 2017/5/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTSocketConfig.h"
#import "GCDAsyncUdpSocket.h"

@interface LTSocketServe : NSObject

// socket连接
+ (void)connectSocket;
// 断开socket连接
+ (void)cutOffSocket;


//请求行情
+ (void)sendRTC:(NSString *)codes;
//请求所有行情
+ (void)sendRTCAll;
//停止请求行情
+ (void)stopRTC;


@end
