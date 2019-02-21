//
//  LTResponse.m
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LTResponse.h"

@implementation LTResponse

#pragma mark - 外部方法

+ (id)responseFailed:(NSError *)error {
    return [[LTResponse alloc] initWithRequestFailed:error];
}


+ (id)responseWithData:(NSData *)jsonData {
    return [[LTResponse alloc] initWithData:jsonData];
}
+ (id)responseWithDict:(NSDictionary *)dict {
    return [[LTResponse alloc] initWithDict:dict];
}
+ (id)responseWithObj:(id)obj {
    return [[LTResponse alloc] initWithObj:obj];
}



#pragma mark - Method

- (id)initWithData:(NSData *)jsonData {
    id jsonResult = [jsonData jsonStringToDictonary];
    return [[LTResponse alloc] initWithDict:jsonResult];
}

- (id)initWithObj:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]] ) {
        return [self initWithDict:obj];
    }
    return [self initWithArray:obj];
}


- (id)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSDictionary class]] && [dict count] > 0) {
            _rawDict = dict;
            //初始化基本参数
            _code = [_rawDict stringFoKey:@"msgCode"];
            _success = [[_rawDict stringFoKey:@"msgCode"] integerValue] == 0;
            _message = [_rawDict stringFoKey:@"msg"];
            _data = [_rawDict objectForKey:@"data"];
            //扩展属性
            if ([_data isKindOfClass:[NSDictionary class]]) {
                _resDict = [NSDictionary dictionaryWithDictionary:_data];
            } else if ([_data isKindOfClass:[NSArray class]]){
                _resArr = [NSArray arrayWithArray:_data];
            }
            
        }
        else {
            [self parseError];
        }
    }
    return self;
}



- (id)initWithArray:(NSArray *)array {
    if (self = [super init]) {
        if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
            _rawArr = array;
            _success = YES;
        }
        else {
            [self parseError];
        }
    }
    return self;
}



- (id)initWithRequestFailed:(NSError *)error {
    if (self = [super init]) {
        [self failedRequest:error];
    }
    return self;
}

/**
 *  @brief  生成解析失败时的结果对象
 *          程序若执行到此分支请检查接口返回数据的格式
 */
- (void)failedRequest:(NSError *)error {
    _success = NO;
    _code = [NSString stringWithInteger:error.code];
//    _message = [error.userInfo toJsonString];
}

//解析错误
- (void)parseError {
    _success = NO;
    _code = @"6777";
    _message = @"数据解析错误";
}

@end
