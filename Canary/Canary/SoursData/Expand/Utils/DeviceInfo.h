//
//  DeviceInfo.h
//  PandaINV
//
//  Created by Brain on 2017/2/28.
//  Copyright © 2017年 Brain. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]

@interface DeviceInfo : NSObject
//获取设备名
+ (NSString*)deviceModelName;
//获取系统版本号
+ (NSString*)deviceSystemVersion;
//获取app名
+(NSString *)appName;
//获取app版本
+(NSString *)appVersion;
//获取app build版本
+(NSString *)appBuildVersion;
//获取idfa
+(NSString *)getIdfa;
//保存idfa
+(void)saveIdfa;
//删除idfa
+(void)deleteIdfa;
//钥匙串是否保存过idfa
+(BOOL)keyChainSavedIdfa;
//idfa是否有效
+(BOOL)isIdfa:(NSString *)idfaStr;

+ (NSString*)guid;
@end
