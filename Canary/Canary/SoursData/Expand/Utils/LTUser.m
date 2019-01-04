//
//  LTUser.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LTUser.h"
#import "LTSocketConfig.h"
#import "GTMBase64.h"
#define kUserId @"userId"
#define UD_SetUserId(str)       [LTUser setUserId:str]

@implementation LTUser

//是否登录
+ (BOOL)hasLogin {
    NSString *userId = [NSUserDefaults objFoKey:kToken];
    return notemptyStr(userId);
}

/**  用户登录成功，保存用户数据
 dict ： 接口返回的字典
 */
+ (void)saveUser:(NSDictionary *)dict {
    
    NSString *userId = [dict stringFoKey:kUserId];
    NSString *nickName = [dict stringFoKey:kNickName];
    NSString *mobile = [dict stringFoKey:kMobile];
    NSString *avatar = [dict stringFoKey:kAvatar];
    NSString *token = [dict stringFoKey:kToken];
    
    
    UD_SetAvatar(avatar);
    UD_SetNickName(nickName);
    UD_SetUserId(userId);
    UD_SetMobile(mobile);
    [LTUser saveToken:token];
    
    NFC_PostName(NFC_CID);
    NFC_PostName(NFC_LocLogin);
}


+ (NSString *)userId {
    NSString *str = [UserDefaults objectForKey:kUserId];
    return str;
}
+ (void)setUserId:(NSString *)userId {
    [UserDefaults setObject:userId forKey:kUserId];
}

//退出登录、删除（用户登录成功保存的数据，token等）
+ (void)logout {
    [UserDefaults removeObjectForKey:kNickName];
    [UserDefaults removeObjectForKey:kMobile];
    [UserDefaults removeObjectForKey:PICID];
    [UserDefaults removeObjectForKey:INFOSTEP];
    [UserDefaults removeObjectForKey:MT4ID];
    [UserDefaults removeObjectForKey:TYPE];

    [LTUser delToken];
    
    //清除小视频飘窗地址
    [UserDefaults setObject:nil forKey:FloatingRtmpStreamKey];
    NFC_PostName(NFC_FloatingPlayRemove);
        
}


#pragma mark - NIM

+ (void)saveChatroomInfo:(NSDictionary *)dict {

    NSString *accId = [dict stringFoKey:@"accId"];
    NSString *name = [dict stringFoKey:@"name"];
    NSString *roomId = [dict stringFoKey:@"roomId"];
    NSString *token = [dict stringFoKey:@"token"];
    
    UD_SetObjForKey(accId, kChatroomAccId);
    UD_SetObjForKey(name, kChatroomName);
    UD_SetObjForKey(roomId, kChatroomId);
    UD_SetObjForKey(token, kChatroomToken);

}
+(void)saveCustomerInfo:(NSDictionary *)dict {
    NSString *customerAccid=[dict objectForKey:@"customerAccid"];
    NSString *customerToken=[dict objectForKey:@"customerToken"];
    NSString *staffAccid=[dict objectForKey:@"staffAccid"];
    NSString *staffName=[dict objectForKey:@"staffName"];
    
    UD_SetObjForKey(customerAccid, kCustomerAccid);
    UD_SetObjForKey(customerToken, kCustomerToken);
    UD_SetObjForKey(staffAccid, kStaffAccid);
    UD_SetObjForKey(staffName, kStaffName);
}
#pragma mark - token

//token过期时间
#define kTokenTimeOut   (6 * LIT_ONE_HOUR)

//tpye类型的token是否过期 本地 YES:过期
+ (BOOL)tokenTimeOut {
    NSDate *date = UD_TokenDate;
    if (date) {
        long long int oldMS = -[date timeIntervalSinceNow];
        return oldMS > kTokenTimeOut;
    }
    return YES;
}
+ (BOOL)tokenIsNull
{
    NSString *token = UD_Token;
    return  emptyStr(token);
}
//token存、取、删
+ (void)saveToken:(NSString *)token{
    if (notemptyStr(token)) {
        [LTUser delToken];
        [NSUserDefaults setObj:token foKey:kToken];
        [NSUserDefaults setObj:[NSDate date] foKey:kTokenDate];
    }
    
}
+ (NSString *)fxbtgToken {
    NSString *token = [UserDefaults stringForKey:kToken];
    return token;
}
+ (void)delToken {
    [NSUserDefaults removeObjFoKey:kToken];
    [NSUserDefaults removeObjFoKey:kTokenDate];
}
+ (BOOL)locHasToken {
    NSString *token = [UserDefaults stringForKey:kToken];
    BOOL hasToken = notemptyStr(token);
    return hasToken;
}

+ (BOOL)hideDeal{
    BOOL flag = NO;
    if (notemptyStr(UD_ObjForKey(EnableDeal))) {
        if (!UD_EnableDeal) {
            flag=YES;
        }
    }
    return flag;
}




+ (BOOL)canDeal {
    if ([LTUtils noHide]) {
        return YES;
    } else {
        BOOL userInChina = [UserDefaults boolForKey:kUserInChinaKey];
        return userInChina;
    }
}

#pragma mark  用户vip等级及折扣
+ (void)setUserVipLv:(NSNumber *)lv {
    if (![LTUser hasLogin]) {
        return;
    }
    [UserDefaults setObject:lv forKey:[LTUser userVipLvKey]];
}
+ (NSNumber *)userVipLv {
    if (![LTUser hasLogin]) {
        return @(0);
    }
    NSNumber *lv = [UserDefaults objectForKey:[LTUser userVipLvKey]];
    return lv;
}
+ (NSString *)userVipLvKey {
    NSString *userId = UD_UserId;
    if (notemptyStr(userId)) {
        return [NSString stringWithFormat:@"userVipLvKey%@",userId];
    }
    return nil;
}

+ (void)setUserVipLvDiscount:(NSString *)discount {
    [UserDefaults setObject:discount forKey:[LTUser userVipLvDiscountKey]];
}
+ (NSString *)userVipLvDiscount {
    NSString *discount = [UserDefaults objectForKey:[LTUser userVipLvDiscountKey]];
    return discount;
}
+ (NSString *)userVipLvDiscountKey {
    NSString *userId = UD_UserId;
    if (notemptyStr(userId)) {
        return [NSString stringWithFormat:@"userVipLvDiscountKey%@",userId];
    }
    return nil;
}



#pragma mark 启动请求配置参数&保存


+ (NSString *)AES128DecryptSocketToken {
    NSString *str = [UserDefaults objectForKey:kSocketTokenKey];
    NSData *keyData = [GTMBase64 decodeString:str];
    NSString *keyBase64DecodeString = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
    NSString *keyAES128Decrypt = [keyBase64DecodeString AES128Decrypt];
    [UserDefaults setObject:keyAES128Decrypt forKey:kSocketDecodeTokenKey];
    return keyAES128Decrypt;
}

#define KAppEncryptKey  [LTUser encryptKey]
+ (NSString *)encryptKey  {
    NSString *keyAES128Decrypt = [UserDefaults objectForKey:kSocketDecodeTokenKey];
    if (!keyAES128Decrypt) {
        return [LTUser AES128DecryptSocketToken];
    }
    return keyAES128Decrypt;
}

+ (void)saveStartUpData:(NSDictionary *)dict {
    if (!dict) {
        return;
    }
    
    //长连接
    NSString *ip = [dict stringFoKey:@"ip"];
    NSString *port = [dict stringFoKey:@"port"];
    NSString *k = [dict stringFoKey:@"k"];
    UD_SetObjForKey(ip, kSocketHostKey);
    UD_SetObjForKey(port, kSocketPortKey);
    UD_SetObjForKey(k, kSocketTokenKey);
    [LTUser AES128DecryptSocketToken];
    
    //启动广告图
    BOOL showImage = [dict boolFoKey:@"showImage"];
    UD_SetObjForKey(@(showImage), kShowImage);
    
    //首页广告图
    NSString *image = [dict stringFoKey:@"image"];//首页广告图片
    NSString *link = [dict stringFoKey:@"link"];//广告链接地址
    NSString *linkTitle = [dict stringFoKey:@"title"];//广告链接标题
    BOOL show = [dict boolFoKey:@"show"];//是否显示首页广告
    UD_SetObjForKey(image, kHomeImageUrl);
    UD_SetObjForKey(link, kHomeImageLink);
    UD_SetObjForKey(linkTitle, kHomeImageLinkTitle);
    UD_SetObjForKey(@(show), kShowHomeImage);
    
    //应用推荐地址
    NSString *recommendAppUrl = [dict stringFoKey:@"recommendAppUrl"];
    UD_SetObjForKey(recommendAppUrl, kRecommendAppUrl);
    BOOL hasAppUrl = notemptyStr(UD_ObjForKey(kRecommendAppUrl));
    UD_SetObjForKey(@(hasAppUrl), hasRecommendAppUrl);
    
    //大赛地址
    NSString *gameUrl = [dict stringFoKey:@"gameUrl"];
    UD_SetObjForKey(gameUrl, kGameUrlSimple);
    
    [self saveGameUrl];
}

+ (void)saveGameUrl {
    NSString *gameUrl = UD_ObjForKey(kGameUrlSimple);
    NSString *userId = UD_UserId;
    if (notemptyStr(gameUrl) && notemptyStr(userId)) {
        NSString *gameUrlFull = [NSString stringWithFormat:@"%@?userId=%@",gameUrl,userId];;
        UD_SetObjForKey(gameUrlFull, kGameUrl);
    }
}


#pragma mark 启动配置接口合并

#define HomeProductListKey @"HomeProductListKey"

// http://m.8caopan.com/news/api/startup/init/v3?sourceId=10
+ (void)reqStartup {
    [RequestCenter reqStartup:^(LTResponse *res) {
        if (res.success) {
            NSDictionary *dic = res.resDict;
            
            //首页产品列表
            NSString *ps = [dic stringFoKey:@"productList"];
            [LTUser saveExchangeCodes:ps];
            
            
            
            //全局活动按钮
            NSDictionary *activityDict = [dic dictionaryFoKey:@"indexActivity"];
            BOOL activityShow = [activityDict boolFoKey:@"show"];
            NSString *activityImgUrl = [activityDict stringFoKey:@"imgUrl"];
            NSString *activityImgActionUrl = [activityDict stringFoKey:@"url"];
            NSString *activityWebTitle = [activityDict stringFoKey:@"bntName"];
            [UserDefaults setBool:activityShow forKey:kActivityShowKey];
            [UserDefaults setObject:activityImgUrl forKey:kActivityImgUrlKey];
            [UserDefaults setObject:activityImgActionUrl forKey:kActivityImgActionUrlKey];
            [UserDefaults setObject:activityWebTitle forKey:kActivityWebTitleKey];
            

            //启动配置：长连接、是否显示启动广告图、首页广告图、应用推荐地址、大赛地址
            NSDictionary *configDict = [dic dictionaryFoKey:@"config"];
            [LTUser saveStartUpData:configDict];
            
            //Enable weipan
            NSString * ios_version = [dic stringFoKey:@"ios_version"];
            if (notemptyStr(ios_version)) {
                NSLog(@"ios_version=%@",ios_version);
                NSString *version = [DeviceInfo appVersion];
                if ([version isEqualToString:ios_version]) {
                    UD_SetObjForKey(@"0", EnableDeal);
                }else{
                    UD_SetObjForKey(@"1", EnableDeal);
                }
                NFC_PostName(NFC_HideDeal);
            }
            
            //启动广告图
            NSDictionary *startUpDic = [dic dictionaryFoKey:@"ios_startup_image"];
            NSString *iphoneTypeStr = [LTUtils iphoneType];
            NSString *imgStr = [startUpDic stringFoKey:iphoneTypeStr];
            NSString *linkURL=[startUpDic stringFoKey:@"link"];
            NSString *adTitle =[startUpDic stringFoKey:@"text"];
            UD_SetObjForKey(imgStr, kLaunchImageURLKey);
            UD_SetObjForKey(linkURL, kLaunchLinkURLKey);
            UD_SetObjForKey(adTitle, kLaunchLinkTitleKey);
        }
    }];
}


+ (void)saveExchangeCodes:(NSString *)ps {
    [UserDefaults setObject:ps forKey:HomeProductListKey];
}

+ (NSString *)homeProductListString {
    NSString *str = [UserDefaults objectForKey:HomeProductListKey];
    return str;
}

+ (NSArray *)homeProductListSimple {
    NSString *str = [LTUser homeProductListString];
    NSArray *codes = [str splitWithStr:@","];
    return [NSArray arrayWithArray:codes];
}




#pragma mark - 审核隐藏

#define kAppIsNormal @"kAppIsNormal"
+ (BOOL)appIsNormal {
    BOOL bl = [UserDefaults boolForKey:kAppIsNormal];
    return bl;
}
+ (void)setAppIsNormal:(BOOL)bl {
    [UserDefaults setObject:@(bl) forKey:kAppIsNormal];
}

+ (void)checkUpdate {
    if (UD_AppIsNormal) {
        [RequestCenter checkAppVersion:^(LTResponse *res) {
            if (res.success) {
                NSDictionary *dict = [res.resDict copy];
                NSString *version = [dict stringFoKey:@"version"];
                NSString *content = [dict stringFoKey:@"content"];
                [UserDefaults setObject:version forKey:newestVersionKey];
                [LTAlertView alertAppUpdate:version content:content];
            } else {
                [UserDefaults setObject:bundleShortVersionString() forKey:newestVersionKey];
            }

        }];

    }
}




@end
