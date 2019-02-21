//
//  JWTHundel.m
//  Canary
//
//  Created by 孙武东 on 2019/1/17.
//  Copyright © 2019 litong. All rights reserved.
//

#import "JWTHundel.h"
#import "INBRSA.h"
#import "WebSocket.h"
#import "INBSecurityCrypto.h"

@interface JWTHundel()

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)NSString *public_key_string;
@property (nonatomic, strong)NSString *private_key_string;

@end

@implementation JWTHundel

+ (JWTHundel *)shareHundle{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        
    });
    return instance;
}

- (void)createRSAHandler{
    
    NSString *private_key_string = @"MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC/hSJ6m+puIDdtd94zGKxmRbnF1RHVCOQIWKh5GZY/AFTBo+7u95OiB7xxXH2AQYTt6oIGEa4C+iENVVoTEiiykCxvuOZ2OA0TLAiGrZcGap5DBNWspxxNHrP0246p+CwNxeDrtUIsbkjmTnM8hicAgIdfhz/JXIQH/6dUJjVJTXDh92IkYkN6TjCZtgwoJJXyHWUvEjJeM2alutLtVFwQWo4j4wcUaqAN5PXcFpTqSlqSoY4l7BalwfXrnpPQtZkvuhn6W0BU1Ygpp6TyEOwAOO6r2WmrYPcFz/Jha7/J7bd3eVCUq1tLX5KrWNcy5dvgqi8y5f1Q/RuXYjszVWJ9AgMBAAECggEBALmbs1CULlxQCKeklcl7TglH5cSevEtz9FtKYOwMKhogngOUdolNktxjFvPeKRrVZJiWvzBWjggAlWuwnj0BSkPTid00mtVTeQhtkk3DiiwDxCE7XEGZKspqyQiyh86d30Px1AtbfShGMYxR10h+0umfppKkJuNlL+f4khfxd47zOE+QMF4dUSNk6jxJPqTVOjF1k1rPaBrjZ96vhaaqvgr0sF6hLf41SUFo8dbCpMh+H12HvfDDd2WwXG6FkF99TBm0/yicp6CJoqNFKu/qdWsITLRdk6fsJ24X6nEvmR2Hpq2l7VNvZ/ByU4j+GP9hzsvpc7bpDSUFzUkfuKsBhEECgYEA+BAwT6Z6tOMF820ANs6uXRi86iTnwi+XkhgBoYpXHtxsnKtMbywA24wc436OkfIrQ7sJdhLyIS5p2KUa4hgvNZ4GY7DFSANQAd9XmBS8VsrDGwwcT6ID/YDaFEXd9/JNq6KRgcE1jU8PZlpwenKLThjodqW22i9Q3ITl0ORl0wkCgYEAxaXRW86t3aspMlwWkHEfOrdwqg0Y1C4kpGVCMSDBtlLlz+xK7aY/5lpq9a07B2HXMyuxOyV8wm0NDk9uHmn6UaUgBvEEm/TQAWXDDPsq2kV0cPGn1gzg7msHtoXK2/dyoOT4FF9ocRCHlgJmpjtAc23nyZdpJUBXibL/MXUtbNUCgYBMoQubf00Gld7fvLtFMwGQBrVNC0uApB0JZ1sRoN+ay/LNTulUql41dAn0iMLX+Nw+lwesLtwXPfQ6lX5Be8ERqhhFMXUv8r4DZg/0DevET+yHbW1NeDoNVIGJo6+XCYXO0HBsidfWKCcUsjluyfWYkX82L6jVq6oqBO/NYNDHqQKBgBbB4vtJLufJH3M2+zoibFAccxKBc4xqy7lKF3cEqIlPvjpUoMQAUnc5jfs/uP4+m8K+kyeWR2kzmT8+khVaaoIgGzHxanBynciraOwDt4luWdvvVz3kObn6BOdVPGhbc41nD9F4stPh7VquaBdX1zHzQ68IigjKAcpPG+cb8OEJAoGAbMKLrQ9No/sb52hoQPY4dDmWtJGS6xsVExzk0ZPDYlZcRIveK3K7QJPL6o/sXSIjq+XThTdw/ozVNtxgqvgrYbri1ZMVoP30A1ZjSYY4X/51eQx9Iwx+OITVSvj/MQ64zdaL/rQJaT1lt7PnwTm87vMmnNGmvmhzNe2CBV64/TE=";
    
    self.private_key_string = private_key_string;

    //本地生产
    self.public_key_string = @"MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAv4UiepvqbiA3bXfeMxisZkW5xdUR1QjkCFioeRmWPwBUwaPu7veToge8cVx9gEGE7eqCBhGuAvohDVVaExIospAsb7jmdjgNEywIhq2XBmqeQwTVrKccTR6z9NuOqfgsDcXg67VCLG5I5k5zPIYnAICHX4c/yVyEB/+nVCY1SU1w4fdiJGJDek4wmbYMKCSV8h1lLxIyXjNmpbrS7VRcEFqOI+MHFGqgDeT13BaU6kpakqGOJewWpcH1656T0LWZL7oZ+ltAVNWIKaek8hDsADjuq9lpq2D3Bc/yYWu/ye23d3lQlKtbS1+Sq1jXMuXb4KovMuX9UP0bl2I7M1VifQIDAQAB";
    
}

- (NSString *)getRSAKEY:(NSString *)jsonStr{
    

    INBRSA *rsa = [INBRSA sharedINBRSA];
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"private_key" ofType:@"p12"];
 
    [rsa keysFromPersonalInformationExchangeFile:path password:@"123456"];
 
    rsa.padding = kSecPaddingPKCS1SHA256;
    
    NSData *sigData = [rsa signDataWithPrivateKey:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *sig = [sigData base64EncodedStringWithOptions:0];
    
//    NSLog(@"%@",sig);
    
    [rsa verifyDataWithPublicKey:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] digitalSignature:sigData];
    
//    NSLog(@"siggggg === %@",sig);
    return sig;
}

- (NSString *)retureParamsString:(NSDictionary *)params{
    
    NSString *string;
    
    for (NSString *key in [params allKeys]) {
       NSString *value = [NSString stringWithFormat:@"%@%@:%@",string.length == 0 ? @"" : @",",key,params[key]];
        
        string = [NSString stringWithFormat:@"%@%@",string ? string : @"",value];
    }
    
    return string;
}



- (void)createLogin{
    
    [self getScoketAddress];
    [self createRSAHandler];
    
    if ([LTUser hasLogin]) {
        
        NSString * urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/login/passwordLogin"];
        NSDictionary * dic = @{@"loginName":[NSUserDefaults objFoKey:@"loginName"],@"password":[NSUserDefaults objFoKey:@"password"]};
        NSLog(@"dic === %@",dic);
        
        [[NetworkRequests sharedInstance] LoginPOST:urlString dict:dic succeed:^(id data) {
            NSLog(@"data === %@",data);
            
            if ([[data objectForKey:@"msgCode"] integerValue] == 0) {
                [self uploadPublicKey];
                [self createTimer];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}


- (void)createTimer{
    
    if (!self.timer) {
        
        self.timer = [NSTimer timerWithTimeInterval:60 * 5 target:self selector:@selector(reloadJWT) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

        
    }
    
}

- (void)removeTimer{
    
    if (self.timer) {
        [self.timer invalidate];
    }
    
}

- (void)reloadJWT{
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/login/refreshJWT"];
    
    [[NetworkRequests sharedInstance] SWDPOST:urlString dict:nil succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        
        NSLog(@"res === %@",resonseObj);
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)getScoketAddress{
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/symbolInfo/getWebSocketAddress"];

    [[NetworkRequests sharedInstance] SWDGET:urlString dict:nil succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        
        NSLog(@"res === %@",resonseObj);
        if (isSuccess) {
            [GlobalData instance].socketUrl = resonseObj;
            [[WebSocket shareDataAsSocket] startConnectSocket];
        }
        
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)uploadPublicKey{
    
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/login/uploadPublicKey"];
    [[NetworkRequests sharedInstance] SWDPOST:urlString dict:@{@"publicKey":self.public_key_string} succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        
        NSLog(@"上传公钥 === %@",resonseObj);
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
