//
//  webSocket.m
//  Canary
//
//  Created by 孙武东 on 2019/1/21.
//  Copyright © 2019 litong. All rights reserved.
//

#import "WebSocket.h"
#define TIME_OUT     20
#define HOST @"quotation.moamarkets.com"
#define PORT  1234

@interface WebSocket ()

@property (nonatomic,strong)SRWebSocket *webSocket;

@end

@implementation WebSocket

+ (WebSocket *) shareDataAsSocket{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)startConnectSocket {
    
    NSString *url = [NSString stringWithFormat:@"ws://www.zhangstz.com/royal/websocket/%@",[GlobalData instance].socketUrl];
    
    NSLog(@"url ==== %@",url);
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    self.webSocket.delegate = self;
    [self.webSocket open];
    
}

//成功连接
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Websocket Connected");
}
//连接失败，打印错误信息
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@":( Websocket Failed With Error %@", error);
    self.webSocket = nil;
}
//接收服务器发送信息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
//    NSLog(@"Received \"%@\"", message);
    
    if(message)
    {
        
        NSDictionary *dic = [self dictionaryWithJsonString:message];
        
        if (dic) {
//            NSLog(@"%@", dic);
           SocketModel *model = [SocketModel mj_objectWithKeyValues:dic];
            if (self.returnValueBlock) {
                self.returnValueBlock(model);
            }
        }
        
    }
}
// 长连接关闭
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"WebSocket closed");
    self.webSocket = nil;
}

//该函数是接收服务器发送的pong消息
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"%@",reply);
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"SessionReplayAttachment == json解析失败");
        return nil;
    }
    return dic;
}

@end
