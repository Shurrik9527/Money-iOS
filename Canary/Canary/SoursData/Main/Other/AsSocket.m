//
//  AsSocket.m
//  SocketClient-Demo
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 www.skyfox.org. All rights reserved.
//

#import "AsSocket.h"
#import "GCDAsyncSocket.h"
#import "SocketModel.h"
#define TIME_OUT     20
#define HOST @"quotation.moamarkets.com"
#define PORT  1234

@interface AsSocket ()<GCDAsyncSocketDelegate>
@property (nonatomic, strong) GCDAsyncSocket *socket;       // socket
@end

@implementation AsSocket

+ (AsSocket *) shareDataAsSocket{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)startConnectSocket {
    self.socket= [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    [self.socket connectToHost:HOST onPort:PORT withTimeout:TIME_OUT error:&error];
    if (error!=nil) {
        NSLog(@"连接失败：%@",error);
    }else{
        NSLog(@"连接成功");
    }};
- (void)socket:(GCDAsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    if (err) {
        NSLog(@"错误报告：%@",err);
    }else{
        NSLog(@"连接工作正常");
    }
    self.socket = nil;
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSData *writeData = [@"connected\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    [sock writeData:writeData withTimeout:-1 tag:0];
    [sock readDataWithTimeout:-1 tag:200];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSMutableArray* socketArray =[NSMutableArray array];
    NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length])];
     NSString * msg= [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
//    NSLog(@"socket网络请求%@",msg);
    if(msg)
    {
        if ([self isCatipalLetter:[msg substringToIndex:3]]) {
        [socketArray removeAllObjects];
        socketArray =[SocketModel mj_objectArrayWithKeyValuesArray:[self editorString:msg]];
        WS(ws)
        if (ws.returnValueBlock) {
            ws.returnValueBlock(socketArray);
    }
    else
    {
        NSLog(@"错误");
    }
        }else
        {
            msg = nil;
        }
    }
    [sock readDataWithTimeout:-1 tag:0]; //一直监听网络
}
#pragma mark 用户断开连接
- (void)cutOffSocket {
    NSLog(@"---------长连接、用户断开----------");
    [self.socket disconnect];
}
#pragma mark - 得到socket数据的处理
-(NSMutableArray *)editorString:(NSString *)string
{
    NSMutableArray * temp =[NSMutableArray array];
    NSArray * array =[NSArray array];
    array = [string componentsSeparatedByString:@">"];
    NSMutableArray * mbArray =[NSMutableArray array];
    mbArray =[NSMutableArray arrayWithArray:array];
    //删除最后的空格
    [mbArray removeLastObject];
    //分割|字符
    NSArray * pArr =[NSArray array];
    for (NSString  * str in mbArray) {
        pArr=[str componentsSeparatedByString:@"|"];
        NSDictionary * dic =[NSDictionary dictionary];
        dic = @{@"symbol":[pArr objectAtIndex:0], @"dataStr":[pArr objectAtIndex:1],@"timeStr":[pArr objectAtIndex:2],@"buy_out":[pArr objectAtIndex:3],@"buy_in":[pArr objectAtIndex:4]};
        [temp addObject:dic];
    }
        return temp;
    
}

//判断是不是大写字母
- (BOOL)isCatipalLetter:(NSString *)str
{
    if ([str characterAtIndex:0] >= 'A' && [str characterAtIndex:0] <= 'Z') {
        return YES;
    }
    return NO;
    
}

@end
