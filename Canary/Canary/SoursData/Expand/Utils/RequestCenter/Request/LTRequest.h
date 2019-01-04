//
//  LTRequest.h
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "LTResponse.h"
#define kRequestTimeOut         30


typedef void (^FinishBlock)(LTResponse *res);

typedef NS_ENUM(NSUInteger, LTEncryptType) {
    LTEncryptType_Non,//不加密，不添加Auth和t
    LTEncryptType_Auth,//不加密，仅添加Auth和t
    LTEncryptType_Other,//什么都不加

};

@interface LTRequest : NSObject

#pragma mark - 普通请求
+ (void)baseOtherGet:(NSString *)url  finish:(FinishBlock)finish;
+ (void)baseGet:(NSString *)url parameters:(NSDictionary *)parameters
          finish:(FinishBlock)finish;

+ (void)basePost:(NSString *)url parameters:(NSDictionary *)parameters
          finish:(FinishBlock)finish;


#pragma mark - 带 "auth" 和 "t" 的请求

+ (void)baseAuthGet:(NSString *)url parameters:(NSDictionary *)parameters
              finish:(FinishBlock)finish;

+ (void)baseAuthPost:(NSString *)url parameters:(NSDictionary *)parameters
          finish:(FinishBlock)finish;

+ (void)baseAuth:(NSString *)url parameters:(NSDictionary *)parameters imagePath:(NSString *)imagePath finish:(FinishBlock)finish;

#pragma mark - 带 Cookie 的请求

+ (void)baseGet:(NSString *)url parameters:(NSDictionary *)parameters
         cookie:(NSString *)cookie encryptType:(LTEncryptType)encryptType
         finish:(FinishBlock)finish;

+ (void)basePost:(NSString *)url parameters:(NSDictionary *)parameters
         cookie:(NSString *)cookie encryptType:(LTEncryptType)encryptType
         finish:(FinishBlock)finish;



#pragma mark -  基础方法

+ (void)baseReq:(NSString *)url parameters:(NSDictionary *)parameters isPost:(BOOL)isPost cookie:(NSString *)cookie responseHeads:(BOOL)responseHeads encryptType:(LTEncryptType)encryptType finish:(FinishBlock)finish;


/***  base请求 ***
 *   url ：请求地址 NSString
 *   parameters ：请求参数 NSDictionary
 *   isPost ：是否Post请求  BOOL
 *   cookie ：head中添加cookie
 *   responseHeads ：返回数据中获取  allHeaderFields
 *   imagePath：图片路径
 *   encryptType ：见 LTEncryptType
 *   finish ：回调block
 */
+ (void)baseReq:(NSString *)url parameters:(NSDictionary *)parameters isPost:(BOOL)isPost cookie:(NSString *)cookie responseHeads:(BOOL)responseHeads imagePath:(NSString *)imagePath encryptType:(LTEncryptType)encryptType finish:(FinishBlock)finish;

#pragma mark - 生成加密参数地址
+ (NSMutableDictionary *)addAuth:(NSDictionary *)dic;
+ (NSString*)encryptParams:(NSDictionary*)dict;
//  hash算法
+ (NSString *)calculateFx168Key:(NSString *)excode Code:(NSString*)code Type:(NSString*)type timeString:(NSString *)timeString;
//  行情数据接口hash地址
+(NSString*)hashUrlStringWithExcode:(NSString*)excode Code:(NSString*)code Type:(NSString*)type FontUrl:(NSString*)fontUrl;


@end
