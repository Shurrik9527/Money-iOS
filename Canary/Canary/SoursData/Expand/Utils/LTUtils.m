//
//  LTUtils.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LTUtils.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
//#import "DataOperation.h"
#import "SelfStock.h"

@implementation LTUtils
#define kUserId @"userId"
#define reSetVersion @"1.0.0" //重置行情版本

+ (CGFloat)autowh:(CGFloat)w {
    if (ScreenW_Lit < Lit_iphone6W) {
        return ((1.0*(w))*(ScreenW_Lit/Lit_iphone6W));
    } else {
        return (w);
    }
}

+ (BOOL)noHide {
    return YES;
}


//格式化小数 四舍五入类型 保留4位小数
+ (NSString *)decimal4PWithFormat:(CGFloat)floatValue {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.0000"];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatValue]];
}

//格式化小数 四舍五入类型 保留2位小数
+ (NSString *)decimal2PWithFormat:(CGFloat)floatValue {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"0.00"];
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatValue]];
}

//根据code 格式化小数
+ (NSString *)decimalPriceWithCode:(NSString *)code floatValue:(CGFloat)floatValue {
    NSString *numStr = [LTUtils pointWithCode:code];
    if (!numStr) {
        return [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:floatValue]];
    }
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *str = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:floatValue]];
    if(notemptyStr(numStr)){
        [numberFormatter setPositiveFormat:numStr];
        str = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatValue]];
    }
    return str;
}

//产品小数点位数
+ (NSString *)pointWithCode:(NSString *)code {
    if ([code isEqualToString:@"USOIL"]) {    //美原油 USOIL -3，
        return @"0.000";
    }
    else if ([code isEqualToString:@"XAUUSD"]) {        //黄金 XAUUSD -2，
        return @"0.00";
    }
    else if ([code isEqualToString:@"XAGUSD"]) {        //白银 XAGUSD -3，
        return @"0.000";
    }
    else if ([code isEqualToString:@"USDJPY"]) {        //美日 USDJPY -3，
        return @"0.000";
    }
    else if ([code isEqualToString:@"EURUSD"]) {        //欧美 EURUSD -5，
        return @"0.00000";
    }
    else if ([code isEqualToString:@"AUDUSD"]) {        //澳美 AUDUSD -5，
        return @"0.00000";
    }
    else if ([code isEqualToString:@"CNH300"]) {        //沪深 CNH300 -2，
        return @"0.00";
    }
    else if ([code isEqualToString:@"NAS100"]) {//纳斯达克 NAS100 -2
        return @"0.00";
    } else {
        return nil;
    }
}

#pragma mark 判空

/** 是否为空(nil、NULL、[NSNull class]、空格)字符串
 * 空：yes   非空：no  */
+ (BOOL)emptyString:(NSString *)str {
    return ![LTUtils notEmptyString:str];
    
    //    return (UD_UserId.integerValue > 0);
}

+ (BOOL)notEmptyString:(NSString *)str {
    
    if (![str isKindOfClass:[NSString class]])
    {
        str=[NSString stringWithFormat:@"%@",str];
    }
    
    BOOL bl = [LTUtils isNotNull:str];
    
    if (!bl) {
        return NO;
    }
    else if ([str isEqualToString:@"(null)"]) {//stringWithFormat (nil，Nil，NULL) --> @"(null)"
        return NO;
    }
    
    else if ([str isEqualToString:@"<null>"]) {//stringWithFormat ([NSNull null]) --> @"<null>"
        return NO;
    }
    
    NSString *s = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (s.length == 0) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isNull:(id)obj {
    return ![LTUtils isNotNull:obj];
}

+ (BOOL)isNotNull:(id)obj {
    if (obj == NULL) {//NULL是基本数据类型为空
        return NO;
    }
    
    else if (obj == nil)  {//nil是一个对象指针为空
        return NO;
    }
    
    else if (obj == Nil) {//Nil是一个类指针为空
        return NO;
    }
    
    else if ([obj isEqual:[NSNull null]])  {
        //[NSNull null]用来在NSArray和NSDictionary中加入非nil（表示列表结束）的空值
        return NO;
    }
    
    else if ([obj isKindOfClass:[NSNull class]]) {
        return NO;
    }
    
    
    return YES;
}

#pragma mark 字符查找、包含

+ (BOOL)searchStr:(NSString *)str isContainStr:(NSString *)subStr {
    BOOL bl = [str contains:subStr];
    return bl;
}

#pragma mark 页面跳转  Schemes

#define ixitScheme1     @"8caopan://"
#define ixitScheme2     @"touzile://"
#define ixitScheme3     @"caopan8://"

+ (BOOL)isIxitScheme:(NSString *)str {
    if ([str hasPrefix:ixitScheme1] ||
        [str hasPrefix:ixitScheme2] ||
        [str hasPrefix:ixitScheme3]) {
        return YES;
    }
    return NO;
}

+ (BOOL)schemeCheck:(NSString *)checkStr eqStr:(NSString *)eqStr {
    NSString *str1 = [NSString stringWithFormat:@"%@%@",ixitScheme1,checkStr];
    NSString *str2 = [NSString stringWithFormat:@"%@%@",ixitScheme2,checkStr];
    NSString *str3 = [NSString stringWithFormat:@"%@%@",ixitScheme3,checkStr];
    if ([eqStr contains:str1] ||
        [eqStr contains:str2] ||
        [eqStr contains:str3]) {
        return YES;
    }
    return NO;
}

//注册
+ (BOOL)schemeRegister:(NSString *)eqStr {
    return [LTUtils schemeCheck:kSS_register eqStr:eqStr];
}

// 充值界面
+ (BOOL)schemeCashin:(NSString *)eqStr {
    return [LTUtils schemeCheck:kSS_cashin eqStr:eqStr];
}

//交易界面
+ (BOOL)schemeTrade:(NSString *)eqStr {
    return [LTUtils schemeCheck:kSS_trade eqStr:eqStr];
}

//看行情界面
+ (BOOL)schemeMarket:(NSString *)eqStr {
    return [LTUtils schemeCheck:kSS_market eqStr:eqStr];
}

//分享页面
+ (BOOL)schemeShare:(NSString *)eqStr {
    return [LTUtils schemeCheck:kSS_share eqStr:eqStr];
}

//直播
+ (BOOL)schemeLiveList:(NSString *)eqStr {
    return [LTUtils schemeCheck:kSS_liveList eqStr:eqStr];
}


#pragma mark app信息
/* 项目bundleID */
NSString *identifier_() {
    return [[NSBundle mainBundle] bundleIdentifier];
}

/* 项目名称 */
NSString *displayName_() {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}



NSString *shortVersionString_() {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleShortVersionString"];
}
NSInteger shortVersionInt_() {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *verStr = [dict objectForKey:@"CFBundleShortVersionString"];
    NSString *ver = [verStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger version = [ver integerValue];
    return version;
}

NSInteger integerVersion_() {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return [[dict objectForKey:@"CFBundleVersion"] integerValue];
}




//获取vip等级
+(UIColor *)vipColor:(NSInteger)level {
    NSInteger index = level-1>0?level-1:0;
    index=index<kMeVipColor.count-1?index:kMeVipColor.count-1;
    NSString *vipHex=kMeVipColor[index];
    UIColor * vipColor=[UIColor colorFromHexString:vipHex];
    return vipColor;
}

//手机号码 中间 4个*
+ (NSString *)phoneNumMid4Star {
    NSString *pn = [UserDefaults stringForKey:kMobile];
    if ([pn is_PhoneNumber]) {
        NSString * res = [pn stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return res;
    }
    return pn;
}


+ (NSInteger)pageNumWith:(NSInteger)allNum onePageSize:(NSInteger)onePageSize {
    NSInteger num = allNum/onePageSize;
    NSInteger yushu = allNum % onePageSize;
    if (yushu > 0) {
        num+=1;
    }
    return num;
}

//判断是否为整形：
+ (BOOL)isPureInt:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}


/**
 *  传入一个view进行旋转
 *
 *  @param rotationView 将要进行旋转的view
 */
+(void)startRotationAnimation:(UIView *)rotationView
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 *20];
    rotationAnimation.duration = 10;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [rotationView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
/**
 *  结束旋转动画
 */
+(void)endAnimation:(UIView *)rotationView
{
    [rotationView.layer removeAllAnimations];
}



#pragma mark - url添加默认参数

+ (NSString *)urlAddDefaultPrams:(id )url {
    NSString *urlStr=[NSString stringWithFormat:@"%@",url];
    if (emptyStr(urlStr)) {
        return nil;
    }
    if ([urlStr containsString:@"userId"]) {
        return urlStr;
    }
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@?",url];
    NSString *userId = UD_UserId;
    if (userId) {
        [str appendFormat:@"userId=%@&",userId];
    }
    [str appendFormat:@"deviceType=%d&",kDeviceType];
    [str appendFormat:@"sourceId=%d",kAPPType];
    
    return str;
}







#pragma mark - iphone类型4、5、6、6p
+ (NSString *)iphoneType {
    if (iPhone4) {
        return @"fourImage";
    } else if (iPhone5) {
        return @"fiveImage";
    } else if (iPhone6) {
        return @"sixImage";
    } else if (iPhone6Plus) {
        return @"sixPlusImage";
    } else  {
        return @"sixPlusImage";
    }
}

//返回机型
+ (NSString *)iphoneDeviceModel{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone5s";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone6";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone6Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone6sPlus";
    if ([platform isEqualToString:@"iPhone8,3"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhoneSE";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone7";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone7Plus";
    
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPodTouch";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPodTouch2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPodTouch3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPodTouch4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPodTouch5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPodTouch6G";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad2";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad4";
    
    //iPad Air
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPadAir";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPadAir2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPadAir2";
    
    //iPad mini
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPadmini1G";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPadmini2";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPadmini3";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPadmini4";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPadmini4";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhoneSimulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhoneSimulator";
    return platform;
    
}
//提交bug时，提交的信息：应用版本，手机型号、系统版本
+ (NSString *)debugInfo {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *ver0 = [dict objectForKey:@"CFBundleShortVersionString"];
    NSString *ver1 = [NSString stringWithFormat:@"%@",[dict objectForKey:@"CFBundleVersion"] ];
    NSString *verStr = [NSString stringWithFormat:@"应用版本：V%@ ，%@",ver0,ver1];
    
    NSString *iphoneType = [LTUtils iphoneDeviceModel];
    NSString *iOSVer = [NSString stringWithFormat:@"%g",iOSSystemVersion];
    NSString *deviceInformation = [NSString stringWithFormat:@"手机型号：%@ \n系统版本:%@",iphoneType,iOSVer];
    NSString *mos = [LTUtils noHide] ? @"模式：正常" : @"模式：受限";
    NSString *res = [NSString stringWithFormat:@"%@\n%@\n%@",verStr,deviceInformation,mos];
    
    return res;
}




#pragma mark - 系统

//应用程序的名字
+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}


/* 项目bundleID */
NSString *bundleIdentifier() {
    return [[NSBundle mainBundle] bundleIdentifier];
}

/* 项目名称 */
NSString *bundleDisplayName() {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}



NSString *bundleShortVersionString() {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleShortVersionString"];
}
NSInteger bundleShortVersionInt() {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *verStr = [dict objectForKey:@"CFBundleShortVersionString"];
    NSString *ver = [verStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger version = [ver integerValue];
    return version;
}

NSInteger bundleIntegerVersion() {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return [[dict objectForKey:@"CFBundleVersion"] integerValue];
}




#pragma mark 设置配置值
+(void)setSeting:(NSString *)key Value:(id)value{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
    defaults = nil;
}
#pragma mark - 移除配置
+(void)removeSetingWithKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
    defaults = nil;
}
+ (void)setSetingDefaultValue {
    // 简单均线
    if ([[self getSeting:@"SMA_N1"] isEqualToString:@""] || ![self getSeting:@"SMA_N1"]) {
        [self setSeting:@"SMA_N1" Value:@"5"];
    }
    if ([[self getSeting:@"SMA_N2"] isEqualToString:@""] || ![self getSeting:@"SMA_N2"]) {
        [self setSeting:@"SMA_N2" Value:@"10"];
    }
    if ([[self getSeting:@"SMA_N3"] isEqualToString:@""] || ![self getSeting:@"SMA_N3"]) {
        [self setSeting:@"SMA_N3" Value:@"20"];
    }
    if ([[self getSeting:@"SMA_N4"] isEqualToString:@""] || ![self getSeting:@"SMA_N4"]) {
        [self setSeting:@"SMA_N4" Value:@"60"];
    }
    if ([[self getSeting:@"SMA_N5"] isEqualToString:@""] || ![self getSeting:@"SMA_N5"]) {
        [self setSeting:@"SMA_N5" Value:@"120"];
    }
    // BOLL布林轨道
    if ([[self getSeting:@"BOLL_N"] isEqualToString:@""] || ![self getSeting:@"BOLL_N"]) {
        [self setSeting:@"BOLL_N" Value:@"20"];
    }
    if ([[self getSeting:@"BOLL_K"] isEqualToString:@""] || ![self getSeting:@"BOLL_K"]) {
        [self setSeting:@"BOLL_K" Value:@"2"];
    }
    // EMA(指数平均指标)
    if ([[self getSeting:@"EMA_N"] isEqualToString:@""] || ![self getSeting:@"EMA_N"]) {
        [self setSeting:@"EMA_N" Value:@"20"];
    }
    // MACD 指数平滑异同平均线
    if ([[self getSeting:@"MACD_N1"] isEqualToString:@""] || ![self getSeting:@"MACD_N1"]) {
        [self setSeting:@"MACD_N1" Value:@"12"];
    }
    if ([[self getSeting:@"MACD_N2"] isEqualToString:@""] || ![self getSeting:@"MACD_N2"]) {
        [self setSeting:@"MACD_N2" Value:@"26"];
    }
    if ([[self getSeting:@"MACD_P"] isEqualToString:@""] || ![self getSeting:@"MACD_P"]) {
        [self setSeting:@"MACD_P" Value:@"9"];
    }
    
    // KDJ 随机指标
    if ([[self getSeting:@"KDJ_N"] isEqualToString:@""] || ![self getSeting:@"KDJ_N"]) {
        [self setSeting:@"KDJ_N" Value:@"9"];
    }
    // RSI 相对强弱指标
    if ([[self getSeting:@"RSI_N1"] isEqualToString:@""] || ![self getSeting:@"RSI_N1"]) {
        [self setSeting:@"RSI_N1" Value:@"6"];
    }
    if ([[self getSeting:@"RSI_N2"] isEqualToString:@""] || ![self getSeting:@"RSI_N2"]) {
        [self setSeting:@"RSI_N2" Value:@"12"];
    }
    if ([[self getSeting:@"RSI_N3"] isEqualToString:@""] || ![self getSeting:@"RSI_N3"]) {
        [self setSeting:@"RSI_N3" Value:@"24"];
    }
    if ([[self getSeting:@"IsLoadNewsImg"] isEqualToString:@""] || ![self getSeting:@"IsLoadNewsImg"]) {
        [self setSeting:@"IsLoadNewsImg" Value:@"1"];
    }
    if ([UD_UserId isKindOfClass:[NSNumber class]]) {
        NSString *userId=[NSString stringWithFormat:@"%@",UD_UserId];
        NSLog(@"change UserId Class Type");
        UD_SetObjForKey(userId, kUserId);
    }
    // 加三个默认自选
    NSString *vkey = [NSString stringWithFormat:@"reSetSelfStock_%@",reSetVersion];
    BOOL flag= [[[NSUserDefaults standardUserDefaults] objectForKey:vkey] boolValue];
    if([bundleShortVersionString() isEqualToString:reSetVersion] && !flag)
    {
//        [DataOperation deleteTable:@"SelfStock"];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:vkey];
//        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    NSArray *selfstock = [DataOperation select:@"SelfStock" Where:nil orderBy:@"order" sortType:YES];
//    if (selfstock.count<=0) {
//        NSArray *defaultSelf = (NSArray*)ThemeJson(@"defaultSelfStocks");
//        for (int i=0; i<defaultSelf.count; i++) {
//            NSDictionary *dic = (NSDictionary*)[defaultSelf objectAtIndex:i];
//            NSString *name = [dic objectForKey:@"name"];
//            NSString *code = [dic objectForKey:@"code"];
//            NSString *excode = [dic objectForKey:@"excode"];
//            // 存储
//            [DataOperation addUsingBlock:^(NSManagedObjectContext *context){
//                NSString *guid = [UtilsLit guid];
//                SelfStock *s = [NSEntityDescription insertNewObjectForEntityForName:@"SelfStock" inManagedObjectContext:context];
//                s.name = name;
//                s.guid = guid;
//                s.code = code;
//                s.istop = [NSNumber numberWithInt:1];
//                if (i>2) {
//                    s.istop = [NSNumber numberWithInt:0];
//                }
//                s.addtime = [NSNumber numberWithDouble:[NSDate curMS]];
//                s.in_price = [NSString stringWithFormat:@"0.00"];
//                s.out_price = [NSString stringWithFormat:@"0.00"];
//                s.change = [NSString stringWithFormat:@"0.00"];
//                s.changerate = [NSString stringWithFormat:@"0.00"];
//                s.excode = excode;
//                s.order = [NSNumber numberWithInt:(i+1)];
//                [DataOperation save];
//                s = nil;
//            }];
//        }
//    }
//    selfstock = nil;
    
}

#pragma mark 获取设置值
+(NSString *)getSeting:(NSString*)key{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *value=[defaults objectForKey:key];
    defaults = nil;
    return value;
}
+(NSString *)middleTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSString *middleTime = @"18:00";
    NSArray *startArr=[startTime componentsSeparatedByString:@":"];
    NSArray *endArr=[endTime componentsSeparatedByString:@":"];
    if (startArr.count<2 || endArr.count<2)
    {
        return middleTime;
    }
    NSInteger startHour = [startArr[0] integerValue];
    NSInteger startMin = [startArr[1] integerValue];
    NSInteger mincount1 = startHour *60 + startMin;
    
    NSInteger endHour = [endArr[0] integerValue];
    NSInteger endMin = [endArr[1] integerValue];
    NSInteger mincount2 = endHour *60 + endMin;
    
    NSInteger mincount = 24*60-mincount1 + mincount2;
    if (endHour>12 && endHour<=24)
    {
        mincount = mincount2 - mincount1;
    }
    NSInteger min = mincount/2;
    NSInteger midMin = min%60+startMin;
    NSInteger midHour  = min/60+startHour;
    
    if (midMin >60)
    {
        midMin=midMin-60;
        midHour+=1;
    }
    middleTime = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)midHour,(long)midMin];
    return middleTime;
}
+(NSInteger)timeNumberWithType:(NSString *)_type
{
    NSInteger timeNumber = 0;
    //    NSArray *titles = @[@"分时",@"1分",@"5分",@"15分",@"30分",@"60分",@"4小时",@"日线",@"周线"];
    NSArray *timeArr = @[@"",@"10",@"2",@"3",@"4",@"5",@"9",@"6",@"7"];
    NSInteger numType = 0;
    if ([timeArr containsObject:_type])
    {
        for (int i = 0; i<timeArr.count; i++)
        {
            NSString *type = timeArr[i];
            if ([_type isEqualToString:type])
            {
                numType=i;
                break;
            }
        }
    }
    switch (numType) {
        case 0:
            timeNumber = 60;
            break;
        case 1:
            timeNumber = 60;
            break;
        case 2:
            timeNumber = 60*5;
            break;
        case 3:
            timeNumber = 60*15;
            break;
        case 4:
            timeNumber = 60*30;
            break;
        case 5:
            timeNumber = 60*60;
            break;
        case 6:
            timeNumber = 60*60*4;
            break;
        case 7:
            timeNumber = 60*60*24;
            break;
        case 8:
            timeNumber = 60*60*24*7;
            break;
            
        default:
            break;
    }
    return timeNumber;
}

#pragma mark - 涨跌幅
+(NSString *)changeRateFormat:(NSString*)sellprice ClosePrice:(NSString*)closeprice{
    CGFloat sp = [sellprice floatValue];
    CGFloat cp = [closeprice floatValue];
    // 涨跌幅计算公式
    CGFloat p = (sp-cp)/sp * 100;
    NSString *price = [NSString stringWithFormat:@"%.2f",p];
    return price;
}

+(NSString *)changeFormat:(NSString*)sellprice ClosePrice:(NSString*)closeprice{
    CGFloat sp = [sellprice floatValue];
    CGFloat cp = [closeprice floatValue];
    // 涨跌幅计算公式
    CGFloat p = sp-cp;
    NSString *price = [NSString stringWithFormat:@"%.2f",p];
    return price;
}

+(void)createCacheWithFileName:(NSString*)filename Path:(NSString*)path Content:(NSDictionary*)content{
    //获取应用程序沙盒的Library目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/%@",path]];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL isdirectory = YES;
    if (![filemanager fileExistsAtPath:path isDirectory:&isdirectory]) {
        [filemanager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //NSLog(@"path:%@",path);
    //得到完整的文件名
    NSString *fullFileName=[path stringByAppendingPathComponent:filename];
    NSString *jsonstr = [content JSONRepresentation];
    [jsonstr writeToFile:fullFileName atomically:YES encoding:NSUTF8StringEncoding error:nil];
    fullFileName = nil;
    paths = nil;
    
}


+(NSDictionary*)readCacheWithFileName:(NSString*)filename Path:(NSString*)path{
    //获取应用程序沙盒的Library目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/%@",path]];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL isdirectory = YES;
    if (![filemanager fileExistsAtPath:path isDirectory:&isdirectory]) {
        [filemanager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //NSLog(@"path:%@",path);
    //得到完整的文件名
    NSString *fullFileName=[path stringByAppendingPathComponent:filename];
    NSString *jsonstr = [NSString stringWithContentsOfFile:fullFileName encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dic = [jsonstr JSONValue];
    fullFileName = nil;
    return dic;
}

+(NSString*)realPathWithFileName:(NSString*)filename Path:(NSString*)path{
    //获取应用程序沙盒的Library目录
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
    path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"/Caches/%@",path]];
    NSFileManager *filemanager = [NSFileManager defaultManager];
    BOOL isdirectory = YES;
    if (![filemanager fileExistsAtPath:path isDirectory:&isdirectory]) {
        [filemanager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //NSLog(@"path:%@",path);
    //得到完整的文件名
    NSString *fullFileName=[path stringByAppendingPathComponent:filename];
    
    return fullFileName;
}



+ (NSString*)priceFormat:(NSString*)price
{
    
    if (price.length>15 || price.length<=0) {
        return @"0.00";
    }
    @try {
        // 去掉后面的0
        if ([[price substringFromIndex:(price.length-1)] isEqualToString:@"0"] && [price rangeOfString:@"."].location!=NSNotFound) {
            price = [price substringToIndex:(price.length-1)];
        }
        if ([[price substringFromIndex:(price.length-1)] isEqualToString:@"0"] && price.length>0 && [price rangeOfString:@"."].location!=NSNotFound) {
            price = [price substringToIndex:(price.length-1)];
        }
        if ([[price substringFromIndex:(price.length-1)] isEqualToString:@"."] && price.length>0) {
            price = [price substringToIndex:(price.length-1)];
        }
        if (price.length>7) {
            price = [price substringToIndex:7];
            //price = [NSString stringWithFormat:@"%4.f",[price floatValue]];
        }
        if ([[price substringFromIndex:price.length-1] isEqualToString:@"."] && price.length>0) {
            price = [price substringToIndex:price.length-1];
        }
        if (fabs([price floatValue])<1 && [price floatValue]>0 && price.length>4) {
            price = [price substringToIndex:4];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    
    return price;
}
+(NSString *)getNowTimeString
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"%@", localeDate);
    NSString *nowTime=[formatter stringFromDate:localeDate];
    return nowTime;
}
#pragma mark - 获取当前天数
+(NSString *)getNowDayString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSLog(@"%@", localeDate);
    NSString *nowTime=[formatter stringFromDate:localeDate];
    return nowTime;
}
+(NSString*)toDescriptionStringWithTimestamp:(double)timestamp{
    NSString * des;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:MM:ss"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    if (!date) {
        return 0;
    }
    
    // 比较
    NSDate *nowDate = [NSDate date];
    // 比较结果 发布时间与当前时间相差的秒数
    NSTimeInterval result = [self compareWithTime:nowDate TimeTow:date];
    //result = abs(result);
    // 凌晨到现在的秒数
    [formatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSDate *today00Date = [formatter dateFromString:[formatter stringFromDate:nowDate]];
    NSTimeInterval today00toNowSenconds = [self compareWithTime:nowDate TimeTow:today00Date];;
    NSDateComponents *comps = [self getDateComponents:date];
    
    //今天
    NSInteger hour = comps.hour;
    NSString *j = @"上午";
    if (hour>12) {
        j = @"下午";
        hour -= 12;
    }
    if (result<=today00toNowSenconds) {
        
        NSString *m = [NSString stringWithFormat:@"%ld",(long)comps.minute];
        if (comps.minute<10) {
            m = [NSString stringWithFormat:@"0%ld",(long)comps.minute];
        }
        des = [NSString stringWithFormat:@"%@ %ld:%@",j,(long)hour,m];
    }
    else{
        des = [NSString stringWithFormat:@"%ld月%ld日 %@ %ld:%ld",(long)comps.month,(long)comps.day,j,(long)hour,(long)comps.minute];
    }
    formatter = nil;
    j = nil;
    return des;
}
+(NSArray*)changeTimesWithStartTime:(NSString*)starttime MiddleTime:(NSString*)middletime EndTime:(NSString*)endtime Vertical:(int)vertical{
    if (![starttime containsString:@":"] || ![middletime containsString:@":"] || ![endtime containsString:@":"]) {
        return @[];
    }
    CGFloat startHour = [[starttime substringToIndex:[starttime rangeOfString:@":"].location] floatValue];
    CGFloat startMinute = [[starttime substringFromIndex:[starttime rangeOfString:@":"].location+1] floatValue];
    CGFloat endHour = [[endtime substringToIndex:[endtime rangeOfString:@":"].location] floatValue];
    CGFloat endMinute = [[endtime substringFromIndex:[endtime rangeOfString:@":"].location+1] floatValue];
    if (endHour<12) {
        endHour = 24 + endHour;
    }
    NSInteger startTimeCount = startHour*60+startMinute;
    NSInteger endTimeCount = endHour*60+endMinute;
    NSInteger subTime = endTimeCount-startTimeCount;
    if (startHour>endHour && startHour>12) {
        subTime=24*60-startTimeCount+endTimeCount;
    }
    CGFloat meanTime=(subTime *1.0 /vertical)/60;
    NSMutableArray *ar = [[NSMutableArray alloc]init];
    for (int i=0; i<=vertical; i++) {
        CGFloat t = (startHour+startMinute/60) + i*meanTime;
        if (t>24) {
            t = t - 24;
        }
        CGFloat m = t - (int)t;
        if (m>0) {
            m = m*60;
        }
        t = (int)t;
        NSString *tstr = [NSString stringWithFormat:@"%.0f",t];
        if (t<10) {
            tstr = [NSString stringWithFormat:@"0%.0f",t];
        }
        NSString *mstr = [NSString stringWithFormat:@"%.0f",m];
        if (m<10) {
            mstr = [NSString stringWithFormat:@"0%.0f",m];
        }
        NSString *ts = [NSString stringWithFormat:@"%@:%@",tstr,mstr];
        [ar addObject:ts];
        ts = nil;
        tstr = nil;
        mstr = nil;
        
    }
    return  ar;
}
+(CGFloat)changeMinutesWithStartTime:(NSString*)starttime  MiddleTime:(NSString*)middletime EndTime:(NSString*)endtime Vertical:(int)vertical Type:(int)type{
    if (![starttime containsString:@":"] || ![middletime containsString:@":"] || ![endtime containsString:@":"]) {
        return 0;
    }
    CGFloat startHour = [[starttime substringToIndex:[starttime rangeOfString:@":"].location] floatValue];
    CGFloat startMinute = [[starttime substringFromIndex:[starttime rangeOfString:@":"].location+1] floatValue];
    CGFloat endHour = [[endtime substringToIndex:[endtime rangeOfString:@":"].location] floatValue];
    CGFloat endMinute = [[endtime substringFromIndex:[endtime rangeOfString:@":"].location+1] floatValue];
    
    CGFloat middleHour = 0;
    CGFloat middleMinute = 0;
    CGFloat middleNextHour = 0;
    CGFloat middleNextMinute = 0;
    NSString *middle;
    NSString *middleNext;
    if ([middletime rangeOfString:@"/"].location != NSNotFound) {
        middle = [middletime substringToIndex:[middletime rangeOfString:@"/"].location];
        middleNext = [middletime substringFromIndex:[middletime rangeOfString:@"/"].location+1];
    }else{
        middle = middletime;
        middleNext = middletime;
    }
    
    middleHour = [[middle substringToIndex:[middle rangeOfString:@":"].location] floatValue];
    middleMinute = [[middle substringFromIndex:[middle rangeOfString:@":"].location+1] floatValue];
    middleNextHour = [[middleNext substringToIndex:[middleNext rangeOfString:@":"].location] floatValue];
    middleNextMinute = [[middleNext substringFromIndex:[middleNext rangeOfString:@":"].location+1] floatValue];
    
    
    if (endHour<middleNextHour) {
        endHour = 24 + endHour;
    }
    if (middleHour<startHour) {
        middleHour = 24 + middleHour;
    }
    CGFloat upHours = ((middleHour+middleMinute/60) - (startHour+startMinute/60));
    CGFloat downHours = ((endHour+endMinute/60) - (middleNextHour+middleNextMinute/60));
    CGFloat upfen = upHours * 60;
    CGFloat downfen = downHours * 60;
    if (type<=0) {
        return upfen;
    }
    return  downfen;
}
+(NSString*)changeTimestampToCount:(double)time{
    int newInt = 0;
    NSString *danwei = @"";
    int result = [[NSDate date] timeIntervalSince1970]-time; // 相差多少秒
    
    if (result<60) {
        return @"刚刚";
    }
    if (result>60) {
        newInt = result/60;
        danwei = @"分钟";
    }
    if (result>60*60) {
        newInt = result/60/60;
        danwei = @"小时";
    }
    if (result>24*60*60) {
        newInt = result/24/60/60;
        danwei = @"天";
    }
    if (time<=0) {
        return @"很久以前";
    }
    
    return [NSString stringWithFormat:@"%d%@前",newInt,danwei];
}
+(NSString*)timeformat_monthDay:(double)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd HH:mm"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"time  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    NSLog(@"time =  %@",confromTimespStr);
    
    return confromTimespStr;
}
+(NSString*)timeformat:(double)time{
    NSString *str = @"";
    NSString *timeStr = [[[NSNumber alloc] initWithDouble:time] stringValue];
    if(timeStr.length > 10)
    {
        time = time / 1000;
    }
    timeStr = nil;
    NSDateComponents *com = [self getDateComponents:[NSDate dateWithTimeIntervalSince1970:time]];
    NSString *month = [NSString stringWithFormat:@"%ld",(long)com.month];
    if (com.month<10) {
        month = [NSString stringWithFormat:@"0%ld",(long)com.month];
    }
    NSString *day = [NSString stringWithFormat:@"%ld",(long)com.day];
    if (com.day<10) {
        day = [NSString stringWithFormat:@"0%ld",(long)com.day];
    }
    NSString *hour = [NSString stringWithFormat:@"%ld",(long)com.hour];
    if (com.hour<10) {
        hour = [NSString stringWithFormat:@"0%ld",(long)com.hour];
    }
    NSString *minute = [NSString stringWithFormat:@"%ld",(long)com.minute];
    if (com.minute<10) {
        minute = [NSString stringWithFormat:@"0%ld",(long)com.minute];
    }
    NSString *second = [NSString stringWithFormat:@"%ld",(long)com.second];
    if (com.second<10) {
        second = [NSString stringWithFormat:@"0%ld",(long)com.second];
    }
    str = [NSString stringWithFormat:@"%ld-%@-%@ %@:%@:%@",(long)com.year,month,day,hour,minute,second];
    return str;
}

+(NSString*)timeformat_hourstyle:(double)time{
    
    NSString *str = @"";
    NSDateComponents *com = [self getDateComponents:[NSDate dateWithTimeIntervalSince1970:time]];
    NSString *month = [NSString stringWithFormat:@"%ld",(long)com.month];
    if (com.month<10) {
        month = [NSString stringWithFormat:@"0%ld",(long)com.month];
    }
    NSString *day = [NSString stringWithFormat:@"%ld",(long)com.day];
    if (com.day<10) {
        day = [NSString stringWithFormat:@"0%ld",(long)com.day];
    }
    NSString *hour = [NSString stringWithFormat:@"%ld",(long)com.hour];
    if (com.hour<10) {
        hour = [NSString stringWithFormat:@"0%ld",(long)com.hour];
    }
    NSString *minute = [NSString stringWithFormat:@"%ld",(long)com.minute];
    if (com.minute<10) {
        minute = [NSString stringWithFormat:@"0%ld",(long)com.minute];
    }
    NSString *second = [NSString stringWithFormat:@"%ld",(long)com.second];
    if (com.second<10) {
        second = [NSString stringWithFormat:@"0%ld",(long)com.second];
    }
    str = [NSString stringWithFormat:@"%@:%@ %ld-%@-%@",hour,minute,(long)com.year,month,day];
    return str;
}

+(NSString*)timeFormat_ShortHourStyle:(double)time{
    
    NSString *str = @"";
    NSDateComponents *com = [self getDateComponents:[NSDate dateWithTimeIntervalSince1970:time]];
    NSString *month = [NSString stringWithFormat:@"%ld",(long)com.month];
    if (com.month<10) {
        month = [NSString stringWithFormat:@"0%ld",(long)com.month];
    }
    NSString *day = [NSString stringWithFormat:@"%ld",(long)com.day];
    if (com.day<10) {
        day = [NSString stringWithFormat:@"0%ld",(long)com.day];
    }
    NSString *hour = [NSString stringWithFormat:@"%ld",(long)com.hour];
    if (com.hour<10) {
        hour = [NSString stringWithFormat:@"0%ld",(long)com.hour];
    }
    NSString *minute = [NSString stringWithFormat:@"%ld",(long)com.minute];
    if (com.minute<10) {
        minute = [NSString stringWithFormat:@"0%ld",(long)com.minute];
    }
    NSString *second = [NSString stringWithFormat:@"%ld",(long)com.second];
    if (com.second<10) {
        second = [NSString stringWithFormat:@"0%ld",(long)com.second];
    }
    str = [NSString stringWithFormat:@"%@-%@ %@:%@",month,day,hour,minute];
    return str;
}


+(NSString*)timeformatLong:(double)time{
    NSString *str = @"";
    NSDateComponents *com = [self getDateComponents:[NSDate dateWithTimeIntervalSince1970:time]];
    NSString *month = [NSString stringWithFormat:@"%ld",com.month];
    if (com.month<10) {
        month = [NSString stringWithFormat:@"0%ld",com.month];
    }
    NSString *day = [NSString stringWithFormat:@"%ld",com.day];
    if (com.day<10) {
        day = [NSString stringWithFormat:@"0%ld",com.day];
    }
    NSString *hour = [NSString stringWithFormat:@"%ld",com.hour];
    if (com.hour<10) {
        hour = [NSString stringWithFormat:@"0%ld",com.hour];
    }
    NSString *minute = [NSString stringWithFormat:@"%ld",com.minute];
    if (com.minute<10) {
        minute = [NSString stringWithFormat:@"0%ld",com.minute];
    }
    NSString *second = [NSString stringWithFormat:@"%ld",com.second];
    if (com.second<10) {
        second = [NSString stringWithFormat:@"0%ld",com.second];
    }
    str = [NSString stringWithFormat:@"%ld年%@月%@日 %@:%@:%@",com.year,month,day,hour,minute,second];
    return str;
}
+(NSString*)timeforMin:(double)time{
    NSString *str = @"";
    NSDateComponents *com = [self getDateComponents:[NSDate dateWithTimeIntervalSince1970:time]];
    NSString *month = [NSString stringWithFormat:@"%ld",com.month];
    if (com.month<10) {
        month = [NSString stringWithFormat:@"0%ld",com.month];
    }
    NSString *day = [NSString stringWithFormat:@"%ld",com.day];
    if (com.day<10) {
        day = [NSString stringWithFormat:@"0%ld",com.day];
    }
    NSString *hour = [NSString stringWithFormat:@"%ld",com.hour];
    if (com.hour<10) {
        hour = [NSString stringWithFormat:@"0%ld",com.hour];
    }
    NSString *minute = [NSString stringWithFormat:@"%ld",com.minute];
    if (com.minute<10) {
        minute = [NSString stringWithFormat:@"0%ld",com.minute];
    }
    str = [NSString stringWithFormat:@"%ld.%@.%@ %@:%@",com.year,month,day,hour,minute];
    return str;
}
+(double)timeformat_shortTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *year = [strDate substringToIndex:4];
    
    NSString *newTime=[NSString stringWithFormat:@"%@-%@:00",year,time];
    NSDate *date = [dateFormatter dateFromString:newTime];
    
    double timep=[date timeIntervalSince1970];
    return timep;
}
+(double)timeformat_hourTime:(NSString *)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *day = [strDate substringToIndex:10];
    
    NSArray *timeArr=[time componentsSeparatedByString:@":"];
    if (timeArr.count>1) {
        int h = [timeArr[0] intValue];
        if (h<10) {
            NSString *hstr=[NSString stringWithFormat:@"%.2d",h];
            time=[time stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:hstr];
        }
    }
    NSString *newTime=[NSString stringWithFormat:@"%@ %@",day,time];
    NSDate *date = [dateFormatter dateFromString:newTime];
    
    double timep=[date timeIntervalSince1970];
    return timep;
}
+(double)startTimeSubWithStartTime:(NSString *)start firstP:(double)first {
    CGFloat sub = 0;
    double startT = [self timeformat_hourTime:start];
    if (startT-first>0) {
        startT=startT-60*60*24;
    }
    sub = first-startT;
    if (sub<0) {
        sub=0;
    }else{
        sub = startT<1 ? 0.5 : sub;
    }
    return sub;
}
+(NSDateComponents*)getDateComponents:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps;
    // 年月日获得
    comps =[calendar components:(NSCalendarUnitYear |
                                 NSCalendarUnitMonth |
                                 NSCalendarUnitDay |
                                 NSCalendarUnitHour |
                                 NSCalendarUnitMinute |
                                 NSCalendarUnitSecond |
                                 NSCalendarUnitWeekday |
                                 NSCalendarUnitWeekOfMonth |
                                 NSCalendarUnitWeekOfYear)
                       fromDate:date];
    return comps;
}
+(NSTimeInterval)compareWithTime:(NSDate*)timeOne TimeTow:(NSDate*)timeTow{
    NSTimeInterval time = [timeOne timeIntervalSince1970];
    double timestamp = time;
    
    NSTimeInterval time2 = [timeTow timeIntervalSince1970];
    double timestampTow = time2;
    
    double timeInterVal = timestamp - timestampTow;
    return timeInterVal;
}
+(NSString *)dayString:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [dateFormatter setTimeZone:timeZone];
    NSString *nowTime = [dateFormatter stringFromDate:date];
    return nowTime;
}
#pragma mark - common view
//版权Lab
+ (UIImageView *)copyrightViewWithF:(CGRect)frame{
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"copyrightIcon"]];
    imgv.frame=frame;
    return imgv;
}
+(void)drawLineAtSuperView:(UIView*)superView andTopOrDown:(int)type andHeight:(CGFloat)height andColor:(UIColor*)color{
    CGRect frame = CGRectMake(0, 0, superView.frame.size.width, height);
    if (type==1) {
        frame = CGRectMake(0, superView.frame.size.height-height, superView.frame.size.width, height);
    }
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    [superView addSubview:line];
    line = nil;
}
+(void)drawLineAtSuperView:(UIView*)superView andTopOrDown:(int)type andHeight:(CGFloat)height andColor:(UIColor*)color andFrame:(CGRect)frame{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    [superView addSubview:line];
    line = nil;
}
// 画虚线
+ (UIImage*)dottedImageWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint Color:(UIColor *)color Width:(int)width {
    //NSLog(@"draw start.....");
    CGRect rect = CGRectMake(0, startPoint.y, width, 1);
    UIGraphicsBeginImageContext(rect.size);
    //UIGraphicsBeginImageContextWithOptions(rect.size, YES, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, width);
    // 如果是虚线
    CGFloat lengths[] = {3,3};
    CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    const CGPoint point[] = {startPoint,endPoint};
    CGContextStrokeLineSegments(context, point, 2);  // 绘制
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark - common size
+(CGFloat)labelWithFontsize:(CGFloat )fsize text:(NSString *)text{
    UIFont *font=[UIFont systemFontOfSize:fsize];
    CGSize titleSize = [text sizeWithAttributes: @{NSFontAttributeName: font}];
    return titleSize.width;
}
+(CGFloat)labHeightWithFontsize:(CGFloat)fsize text:(NSString *)text{
    UIFont *font=[UIFont systemFontOfSize:fsize];
    CGSize titleSize = [text sizeWithAttributes: @{NSFontAttributeName: font}];
    return titleSize.height;
}
+(CGFloat)labHeightWithWidth:(CGFloat)labW fontsize:(CGFloat)fsize text:(NSString *)text{
    CGSize size    = [text boundingRectWithSize:CGSizeMake(labW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fsize]} context:nil].size;
    return size.height;
}
+(CGFloat)getContentWidth:(NSString *)text FontSize:(UIFont *)font {
    if (!font) {
        return 0;
    }
    CGSize titleSize = [text sizeWithAttributes: @{NSFontAttributeName: font}];
    return titleSize.width;
}
+(CGRect)viewFrameInWindow:(UIView *)subV {
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[subV convertRect: subV.bounds toView:window];
    return rect;
}
#pragma mark - common attrstring
//左右对齐
+(NSMutableAttributedString *)alignmentJustifiedAttr:(NSString *)str maxW:(CGFloat)maxW{
    CGFloat width=[self labelWithFontsize:15 text:str];
    NSInteger strlength=str.length;
    NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc]initWithString:str];
    CGFloat pading= (maxW - width)/(strlength - 1);
    if (strlength<=1) {
        strlength=1;
        pading=0;
    }
    [attrString addAttribute:NSKernAttributeName value:@(pading) range:NSMakeRange(0, strlength-1)];
    return attrString;
}
#pragma mark - imagepicker
+ (BOOL)canUseCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [LTAlertView alertMessage:@"检测不到相机设备"];
        return NO;
    }
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if (authStatus == AVAuthorizationStatusRestricted ||
        authStatus == AVAuthorizationStatusDenied) {
        [LTAlertView alertMessage:@"相机权限受限"];
        return NO;
    }
    return YES;
}
#pragma mark - NFC
+(void)NoticePostWithName:(NSString *)name obj:(NSDictionary *)userinfo{
    NSNotification *notification =[NSNotification notificationWithName:name object:nil userInfo:userinfo];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - request
#define kAPI_KEY_SALT @"htm_key_market_2099"
#define kAPI_Token @"6a066cff07860a54000cf04ea53ebfe3"

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
