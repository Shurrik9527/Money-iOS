//
//  DeviceInfo.m
//  PandaINV
//
//  Created by Brain on 2017/2/28.
//  Copyright © 2017年 Brain. All rights reserved.
//

#import "DeviceInfo.h"
#import <sys/utsname.h>
#import "KeyChainManager.h"

@implementation DeviceInfo
static NSString * const kAppDictionaryKey = @"com.PandaINV.dictionaryKey";
static NSString * const kAppKeyChainKey = @"com.PandaINV.keychainKey";


+ (NSString*)deviceModelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceModel;
}
+ (NSString*)deviceSystemVersion{
    return [[UIDevice currentDevice] systemVersion];
}
//获取app名
+(NSString *)appName{
    return [[[NSBundle mainBundle] infoDictionary]  objectForKey:@"CFBundleDisplayName"];
}
//获取app版本
+(NSString *)appVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}
//获取app build版本
+(NSString *)appBuildVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}
//获取idfa
+(NSString *)getIdfa{
    NSString *idfa = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSMutableDictionary *keyDic=[KeyChainManager load:kAppKeyChainKey];
    if (!keyDic) {
        NSString *idfa2=[keyDic stringFoKey:kAppDictionaryKey];
        if (!emptyStr(idfa2)) {
            idfa=idfa2;
        }
    }
    NSLog(@"idfa = %@",idfa);
    return idfa;
}
//保存idfa
+(void)saveIdfa{
    NSString *idfa=[self getIdfa];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:idfa forKey:kAppDictionaryKey];
    [KeyChainManager save:kAppKeyChainKey data:tempDic];
}
//删除idfa
+(void)deleteIdfa{
    [KeyChainManager delete:kAppKeyChainKey];
}
//钥匙串是否保存过idfa
+(BOOL)keyChainSavedIdfa{
    NSMutableDictionary *keyDic=[KeyChainManager load:kAppKeyChainKey];
    if (!keyDic) {
        NSString *idfa2=[keyDic stringFoKey:kAppDictionaryKey];
        if (!emptyStr(idfa2)) {
            return YES;
        }
    }
    return NO;
}

//idfa是否有效
+(BOOL)isIdfa:(NSString *)idfaStr{
    if (!emptyStr(idfaStr)) {
        if([idfaStr isEqualToString:@"00000000-0000-0000-0000-000000000000"] ||
           [idfaStr isEqualToString:@"00000000000000000000000000000000"]) {
            //无效idfa ios10:00000000-0000-0000-0000-000000000000 ios9:00000000000000000000000000000000
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
    
}
//获取guid
+ (NSString*)guid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}

@end
