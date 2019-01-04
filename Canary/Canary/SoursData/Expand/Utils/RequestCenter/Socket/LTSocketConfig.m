//
//  LTSocketConfig.m
//  TestSocket
//
//  Created by litong on 2017/5/10.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LTSocketConfig.h"


@implementation LTSocketConfig

+ (void)setHost:(NSString *)host {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:host forKey:kSocketHostKey];
}
+ (NSString *)getHost {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *host = [def objectForKey:kSocketHostKey];
    return host;
}

+ (void)setPort:(NSInteger)port {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:port forKey:kSocketPortKey];
}
+ (NSInteger)getPort {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSInteger port = [def integerForKey:kSocketPortKey];
    return port;
}

+ (void)setToken:(NSString *)token {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:token forKey:kSocketTokenKey];
}
+ (NSString *)getToken {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *token = [def objectForKey:kSocketTokenKey];
    return token;
}


@end
