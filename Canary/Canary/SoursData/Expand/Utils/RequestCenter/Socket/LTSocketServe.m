//
//  LTSocketServe.m
//  TestSocket
//
//  Created by litong on 2017/5/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LTSocketServe.h"
#import "GCDAsyncSocket.h"



#define kResErrorCode     @"00003"    //"errorInfo":"服务器验证失
#define kMaxConnetCount     5

@interface LTSocketServe ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;       // socket
@property(nonatomic , copy)NSString *tempStr;
@property(nonatomic , copy)NSString *codes;
@property(nonatomic , assign)BOOL conneted;//YES:连接成功
@property (nonatomic,assign) NSInteger reConnetCount;//连接次数
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) BOOL receivedMessage;//YES:接收到消息

@end

@implementation LTSocketServe

static LTSocketServe *socketServe = nil;

+ (LTSocketServe *)sharedSocketServe {
    @synchronized(self) {
        if(socketServe == nil) {
            socketServe = [[[self class] alloc] init];
            socketServe.codes = @"";
            socketServe.tempStr = @"";
            socketServe.conneted = NO;
            socketServe.reConnetCount = 0;
            socketServe.receivedMessage = NO;
        }
    }
    return socketServe;
}

+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (socketServe == nil) {
            socketServe = [super allocWithZone:zone];
            socketServe.codes = @"";
            socketServe.tempStr = @"";
            socketServe.conneted = NO;
            socketServe.reConnetCount = 0;
            socketServe.receivedMessage = NO;
            return socketServe;
        }
    }
    return nil;
}

#pragma  mark 3次握手

+ (void)connectSocket {
    LTSocketServe *socketServe = [LTSocketServe sharedSocketServe];
    
    if (![socketServe conneted]) {//未连接
        [socketServe cutOffSocket];//先断开,避免之前的socket未断开导致闪退
        socketServe.socket.userData = LTSocketOfflineByServer;
        [socketServe startConnectSocket];
    } else {
        //已连接，校验
        [LTSocketServe checkConnect];
    }
    
}

//校验连接
+ (void)checkConnect {
    LTSocketServe *socketServe = [LTSocketServe sharedSocketServe];
    if (socketServe.conneted) {
        NSLog(@"校验...");
        NSString *longConnect = [LTSocketServe connectJsonPrams];
        [socketServe sendMessage:longConnect timeout:TIME_OUT];
    }
}


#pragma mark 开始连接

- (void)startConnectSocket {
    NSLog(@"---------长连接开始连接----------");
    NSString *host = [LTSocketConfig getHost];
    NSInteger port = [LTSocketConfig getPort];

    if (emptyStr(host)) {
        return;
    }
    self.socket= [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [self.socket connectToHost:host onPort:port withTimeout:TIME_OUT error:&error];
    
}


#pragma mark 用户断开连接
- (void)cutOffSocket {
    NSLog(@"---------长连接、用户断开----------");
    [self.socket disconnect];
}

#pragma mark 向服务器发送数据
- (void)sendMessage:(id)message timeout:(NSTimeInterval)timeout {
    NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:cmdData withTimeout:timeout tag:1];
}

- (void)sendMessage:(id)message {
    if (_conneted) {
        NSData *cmdData = [message dataUsingEncoding:NSUTF8StringEncoding];
        [self.socket writeData:cmdData withTimeout:WRITE_TIME_OUT tag:1];
    }
}


// 断开socket连接
+ (void)cutOffSocket {
    NSLog(@"---------长连接断开----------");
    [[LTSocketServe sharedSocketServe] cutOffSocket];
}


//请求行情
+ (void)sendRTC:(NSString *)codes {
    LTSocketServe *socketServe = [LTSocketServe sharedSocketServe];
    socketServe.codes = codes;
    NSString *jsonParm = [LTSocketServe rtcJsonPrams:codes];
    [socketServe sendMessage:jsonParm];
}
//请求所有行情
+ (void)sendRTCAll {
    [self stopRTC];
    NSLog(@"---------长连接请求开启所有----------");
    NSString *codes = [LTUser homeProductListString];
    [LTSocketServe sendRTC:codes];
}
//停止请求行情
+ (void)stopRTC {
    NSLog(@"---------长连接请求关闭----------");
    NSString *codes = @"";
    [LTSocketServe sendRTC:codes];
}



#pragma mark - utis -

#pragma mark 校验长连接格式
+ (NSString *)connectJsonPrams {
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    long long int t =  ceil(time);
    NSString *auth = [LTSocketServe socketAuth:t];
    
    NSDictionary *dict =
    @{
      @"type":@"connect",
      @"p":@{
              @"t":@(t),
              @"auth":auth
              }
      };
    
    NSString *authJson = [dict toJsonString];
    NSString *resJson = [NSString stringWithFormat:@"%@$_",authJson];
    
    return resJson;
}

#pragma mark 行情长连接格式
+ (NSString *)rtcJsonPrams:(NSString *)codes {
    if (!codes) {
        return nil;
    }
    
    NSDictionary *dict =
    @{
      @"type":@"rtc",
      @"p":@{
              @"codes": codes
              }
      };
    
    NSString *jsonStr = [dict toJsonString];
    NSString *resJsonStr = [NSString stringWithFormat:@"%@$_",jsonStr];
    return resJsonStr;
}

#pragma mark 生成验证auth
+ (NSString *)socketAuth:(long long int)t {
    NSString *keyAES128Decrypt = KAppEncryptKey;
    NSString *authString = [NSString stringWithFormat:@"connect_%lld_%@",t,keyAES128Decrypt];
    NSString *auth = [authString md5];
    return auth;
}


#pragma mark - GCDAsyncSocketDelegate

//是否连接
- (BOOL)connectToHost:(NSString*)host onPort:(uint16_t)port error:(NSError**)errPtr {
    if (errPtr) {
        NSLog(@"err");
        return NO;
    } else {
        return YES;
    }
}

//连接成功回调
- (void)socket:(GCDAsyncSocket*)sock didConnectToHost:(NSString*)host port:(UInt16)port {
    _conneted = YES;
    [LTSocketServe checkConnect];
}

//连接失败回调，失败最多重连5次，间隔为2的n次方，超过次数后，就不再重连了
- (void)socketDidDisconnect:(GCDAsyncSocket*)sock withError:(NSError*)err {
    _conneted = NO;
    
    if (_reConnetCount >= 0 && _reConnetCount <= kMaxConnetCount) {
        [_timer invalidate];
        _timer = nil;
        NSTimeInterval time = pow(2, _reConnetCount);
        _timer= [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(reconnection) userInfo:nil repeats:NO];
        _reConnetCount++;
        
        NSLog(@"socket did reconnection,after %f s try again",time);
        
    } else {
        _reConnetCount = 0;
        NSLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    }
}



//重连
- (void)reconnection {
    [[LTSocketServe sharedSocketServe] startConnectSocket];
}


//读取消息
- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag {
    [self.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}

//接受消息成功之后回调
- (void)socket:(GCDAsyncSocket*)sock didReadData:(NSData*)data withTag:(long)tag {
    if (!_receivedMessage) {
        _receivedMessage = YES;
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startConnectSocket) object:nil];
    }
    
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (emptyStr(str)) {
        [self.socket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
        return;
    }
    
    NSString *temp = [self.tempStr stringByAppendingString:str];
//    NSLog(@"temp== \n%@",temp);
    
    if ([temp containsString:@"$_"]) {
        NSMutableArray *jsonStrList = [NSMutableArray arrayWithArray:[temp splitWithStr:@"$_"]];
        
        if (jsonStrList.count > 0) {
            NSString *lastStr = [jsonStrList lastObject];
            if (emptyStr(lastStr)) {
                self.tempStr = @"";
            } else {
                self.tempStr = lastStr;
            }
            [jsonStrList removeObjectAtIndex:(jsonStrList.count -1)];
        }
        
        [self configDatas:jsonStrList];
        
    } else {
        self.tempStr = temp;
        
    }
    
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}


#pragma mark 心跳连接
- (void)checkLongConnectByServe {
    NSString *longConnect = [LTSocketServe connectJsonPrams];
    NSData   *data  = [longConnect dataUsingEncoding:NSUTF8StringEncoding];
    [self.socket writeData:data withTimeout:1 tag:1];
}



- (void)configDatas:(NSArray *)jsonStrList {
    for (NSString *jsonStr in jsonStrList) {
        NSDictionary *dic=[jsonStr jsonStringToDictonary];
        
        if (dic) {
            NSString *typ = [dic stringFoKey:@"type"];
            BOOL suc = [dic boolFoKey:@"success"];
            NSArray *arr = [NSArray arrayWithObject:dic];
            if (suc) {
                if ([typ isEqualToString:kResConnect]) {
                    NSLog(@"校验成功...");
                    [LTSocketServe sendRTC:_codes];
                }
                if ([typ isEqualToString:kResQP]) {//行情
                    [[NSNotificationCenter defaultCenter] postNotificationName:NFC_SocketUpdateQuotations object:arr];
                }
            }
            
            else {
                NSString *errorCode = [dic stringFoKey:@"errorCode"];
                if ([errorCode isEqualToString:kResErrorCode]) {//校验失败
                    NSLog(@"校验失败...重新校验");
                }
                if ([typ isEqualToString:kResQP]) {//行情
                    [[NSNotificationCenter defaultCenter] postNotificationName:NFC_SocketUpdateQuotationsFailure object:arr];
                    [LTSocketServe sendRTC:_codes];
                }
            }
            
        }
    }
}


@end
