//
//  LTRequest.m
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LTRequest.h"
#import "DataHundel.h"
@implementation LTRequest

#pragma mark - 普通请求

+ (void)baseOtherGet:(NSString *)url  finish:(FinishBlock)finish {
    [LTRequest baseOtherReq:url parameters:nil isPost:NO finish:finish];
}

+ (void)baseGet:(NSString *)url parameters:(NSDictionary *)parameters
         finish:(FinishBlock)finish {
    
    [LTRequest baseReq:url parameters:parameters isPost:NO cookie:nil responseHeads:NO encryptType:LTEncryptType_Non finish:finish];
}

+ (void)basePost:(NSString *)url parameters:(NSDictionary *)parameters
          finish:(FinishBlock)finish {
        [LTRequest baseReq:url parameters:parameters isPost:YES cookie:nil responseHeads:NO encryptType:LTEncryptType_Non finish:finish];
}


#pragma mark - 带 "auth" 和 "t" 的请求

+ (void)baseAuthGet:(NSString *)url parameters:(NSDictionary *)parameters
             finish:(FinishBlock)finish {
    [LTRequest baseReq:url parameters:parameters isPost:NO cookie:nil responseHeads:NO encryptType:LTEncryptType_Auth finish:finish];
}

+ (void)baseAuthPost:(NSString *)url parameters:(NSDictionary *)parameters
              finish:(FinishBlock)finish {
    [LTRequest baseReq:url parameters:parameters isPost:YES cookie:nil responseHeads:NO encryptType:LTEncryptType_Auth finish:finish];
}

+ (void)baseAuth:(NSString *)url parameters:(NSDictionary *)parameters imagePath:(NSString *)imagePath finish:(FinishBlock)finish {
    [LTRequest baseReq:url parameters:parameters isPost:YES cookie:nil responseHeads:NO imagePath:imagePath encryptType:LTEncryptType_Auth finish:finish];
}

#pragma mark - 带 Cookie 的请求

+ (void)baseGet:(NSString *)url parameters:(NSDictionary *)parameters
         cookie:(NSString *)cookie encryptType:(LTEncryptType)encryptType
         finish:(FinishBlock)finish {
    [LTRequest baseReq:url parameters:parameters isPost:NO cookie:cookie responseHeads:NO encryptType:LTEncryptType_Non finish:finish];
}

+ (void)basePost:(NSString *)url parameters:(NSDictionary *)parameters
          cookie:(NSString *)cookie encryptType:(LTEncryptType)encryptType
          finish:(FinishBlock)finish {
    [LTRequest baseReq:url parameters:parameters isPost:YES cookie:cookie responseHeads:NO encryptType:LTEncryptType_Non finish:finish];
}


#pragma mark - base

+ (void)baseReq:(NSString *)url parameters:(NSDictionary *)parameters isPost:(BOOL)isPost cookie:(NSString *)cookie responseHeads:(BOOL)responseHeads encryptType:(LTEncryptType)encryptType finish:(FinishBlock)finish {
    [LTRequest baseReq:url parameters:parameters isPost:isPost cookie:cookie responseHeads:responseHeads imagePath:nil encryptType:encryptType finish:finish];
}

+ (void)baseReq:(NSString *)url parameters:(NSDictionary *)parameters isPost:(BOOL)isPost cookie:(NSString *)cookie responseHeads:(BOOL)responseHeads imagePath:(NSString *)imagePath encryptType:(LTEncryptType)encryptType finish:(FinishBlock)finish {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *reqUrl = [url urlFormat];
    
    if (encryptType == LTEncryptType_Auth) {
        if (!isPost) {
            [dic setObject:@(kAPPType) forKey:@"sourceId"];
        }
        NSMutableDictionary *dict = [LTRequest addAuth:dic];
        dic = nil;
        dic = [NSMutableDictionary dictionaryWithDictionary:dict];
    }else if (encryptType==LTEncryptType_Other){
//        dic = [NSMutableDictionary dictionaryWithDictionary:@{}];
        
    }else {
        [dic setObject:@(kDeviceType) forKey:@"deviceType"];;
    }

    
#ifdef DEBUG
    [self log:dic url:reqUrl];//debug模式时，打印log
#else
#endif
    
    __weak AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kRequestTimeOut;
    if (encryptType==LTEncryptType_Other) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    }
    
    if(cookie) {
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    if (isPost) {
        [manager POST:reqUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            if (notemptyStr(imagePath)) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath] name:@"file" error:nil];
            }
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            LTResponse *result = [LTResponse responseWithDict:responseObject];
            if (responseHeads) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                result.allHeaderFields = response.allHeaderFields;
            }
            finish(result);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            LTResponse *result = [LTResponse responseFailed:error];
            finish(result);
        }];
    } else {
        [manager GET:reqUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            LTResponse *result = [LTResponse responseWithDict:responseObject];
            if (responseHeads) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                result.allHeaderFields = response.allHeaderFields;
            }
            finish(result);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            LTResponse *result = [LTResponse responseFailed:error];
            finish(result);
        }];
    }
}


+ (void)baseOtherReq:(NSString *)url parameters:(NSDictionary *)parameters isPost:(BOOL)isPost finish:(FinishBlock)finish {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    NSString *reqUrl = [url urlFormat];
    
#ifdef DEBUG
    [self log:dic url:reqUrl];//debug模式时，打印log
#else
#endif
    
    __weak AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = kRequestTimeOut;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    if (isPost) {
        [manager POST:reqUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            LTResponse *res =  [LTResponse responseWithObj:responseObject];
            finish(res);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            LTResponse *res = [LTResponse responseFailed:error];
            finish(res);
        }];
    } else {
        [manager GET:reqUrl parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            LTResponse *res =  [LTResponse responseWithObj:responseObject];
            finish(res);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            LTResponse *res = [LTResponse responseFailed:error];
            finish(res);
        }];
    }
}


#pragma mark - 私有

+ (void)log:(NSDictionary *)dic url:(NSString *)url {
    
    NSLog(@"url = %@\n",url);
//
    NSLog(@"dic = %@\n",dic);
    
//    NSLog(@"url = %@\n",[url urlStringAddParmDict:dic]);
    
}


+ (NSMutableDictionary *)addAuth:(NSDictionary *)dic {
    
    NSString * timeString = [NSDate curMSString];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dict setObject:timeString forKey:@"t"];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"description" ascending:YES selector:@selector(compare:)];
    
    NSMutableString *ms = [NSMutableString string];
    for (NSString *str in [dict.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
        [ms appendString:[NSString stringWithFormat:@"%@",[dict objectForKey:str]]];
    }
    
    NSString *encryptKey = KAppEncryptKey;
    [ms appendString:encryptKey];
    NSString *auth = [ms md5];

    [dict setObject:auth forKey:@"auth"];
    return dict;
}




#pragma mark 生成加密参数地址

+ (NSString*)encryptParams:(NSDictionary*)dict {
    NSDate *date = [NSDate date];
    NSTimeInterval time = [date timeIntervalSince1970]*1000;
    long long int timestamp = ceil(time);
    
    NSString *result = @"";
    NSString *auth = @""; // 加密令牌
    BOOL bl = dict;
    for (int i=0;i<dict.allKeys.count;i++) {
        NSString *key = [dict.allKeys objectAtIndex:i];
        NSString *value = [dict objectForKey:key];
        auth = [auth stringByAppendingFormat:@"%@", value];
        if ([result isEqualToString:@""]) {
            result = [NSString stringWithFormat:@"%@=%@",key,value];
        }else{
            result = [result stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",key,value]];
        }
    }
    
    
    NSString *symbol = bl ? @"&" : @"";
    NSString *encryptKey = KAppEncryptKey;
    // MD5加密
    auth = [[NSString stringWithFormat:@"%@%d%lld%@",auth,kAPPType,timestamp,encryptKey] md5];
    result = [result stringByAppendingFormat:@"%@sourceId=%d&t=%lld&auth=%@",symbol, kAPPType, timestamp, auth];
    return result;
}



#define kAPI_KEY_SALT @"htm_key_market_2099"
#define kAPI_Token @"6a066cff07860a54000cf04ea53ebfe3"
//#define kAPI_Key @"ed284ef243ee3c6c02f85875842cf21f"
//  hash算法
+ (NSString *)calculateFx168Key:(NSString *)excode Code:(NSString*)code Type:(NSString*)type timeString:(NSString *)timeString {
    //只要后面6位
    NSString* time = [timeString substringFromIndex:4];
    //md5 hash
    NSString* token = excode;
    
    if (code) {
        token = [token stringByAppendingString:code];
    }
    if (type) {
        token = [token stringByAppendingString:type];
    }
    token = [token stringByAppendingString:time];
    token = [token stringByAppendingString:kAPI_Token];
    token = [token stringByAppendingString:kAPI_KEY_SALT];
    token = [token md5];
    //英文字符 全部为小写
    return [token lowercaseString];
}

//  行情数据接口hash地址
+ (NSString*)hashUrlStringWithExcode:(NSString*)excode Code:(NSString*)code Type:(NSString*)type FontUrl:(NSString*)fontUrl {
    // 加密算法后面加上
    //获取 unix时间 long long
    long long time = [[NSDate date] timeIntervalSince1970];//1000l;
    //转化为字符串
    NSString* timeString = [NSString stringWithFormat:@"%lld",time];
    
    NSString *key = nil;
    
    if ([excode isEqualToString:@"custom"]) {
        key = [self calculateFx168Key:excode Code:nil Type:type timeString:timeString];
    }else{
        key = [self calculateFx168Key:excode Code:code Type:type timeString:timeString];
    }
    
    NSString* url = fontUrl;
    
    url = [url stringByAppendingString:excode];
    if (code) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&code=%@",code]];
    }
    if (type) {
        url = [url stringByAppendingString:[NSString stringWithFormat:@"&type=%@",type]];
    }
    
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&time=%@",timeString]];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&key=%@",key]];
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&token=%@",kAPI_Token]];
    return url;
}



@end
