//
//  LTSocketConfig.h
//  TestSocket
//
//  Created by litong on 2017/5/10.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, LTSocketOffline) {
    LTSocketOfflineByServer,      //服务器掉线
    LTSocketOfflineByUser,        //用户断开
    LTSocketOfflineByWifiCut,     //wifi 断开
};

#define kResConnect         @"connect"
#define kResRTC                @"rtc"
#define kResQP                @"qp"

//设置连接超时
#define TIME_OUT 20
//设置读取超时 -1 表示不会使用超时
#define READ_TIME_OUT (-1)
//设置写入超时 -1 表示不会使用超时
#define WRITE_TIME_OUT (-1)
//每次最多读取多少
#define MAX_BUFFER     MAXFLOAT //1024


@interface LTSocketConfig : NSObject

+ (void)setHost:(NSString *)host;
+ (NSString *)getHost;

+ (void)setPort:(NSInteger)port;
+ (NSInteger)getPort;

+ (void)setToken:(NSString *)token;
+ (NSString *)getToken;


@end
