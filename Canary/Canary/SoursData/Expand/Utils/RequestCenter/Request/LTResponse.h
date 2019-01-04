//
//  LTResponse.h
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LTResponse : NSObject

@property(nonatomic, readonly, copy) NSString *code;
@property(nonatomic, readonly, copy) NSString *message;
@property(nonatomic, readonly, strong) id data;
@property(nonatomic, readonly, assign) BOOL success;


@property(nonatomic, strong) NSDictionary *allHeaderFields;

#pragma mark - 扩展属性

//实际数据数组 由resData转换NSArray类型
@property(nonatomic,readonly,strong)NSArray *resArr;
//实际数据字典  由resData转换NSDictionary类型
@property(nonatomic,readonly,strong)NSDictionary *resDict;

#pragma mark - 兼容
//接口返回的原始（字典）数据
@property(nonatomic,readonly,strong)NSDictionary *rawDict;
//接口返回的原始（数组）数据
@property(nonatomic,readonly,strong)NSArray *rawArr;
//接口返回的原始json数据
@property(nonatomic,readonly,strong)NSString *rawJson;


#pragma mark - Method
+ (id)responseFailed:(NSError *)error;

+ (id)responseWithData:(NSData *)jsonData;
+ (id)responseWithDict:(NSDictionary *)dict;
+ (id)responseWithObj:(id)obj;

@end
