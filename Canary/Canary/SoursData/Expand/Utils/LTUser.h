//
//  LTUser.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark - app启动参数保存

#define kActivityShowKey                @"kActivityShowKey" //活动按钮是否显示
#define kActivityWebTitleKey            @"kActivityWebTitleKey" //活动标题
#define kActivityImgActionUrlKey     @"kActivityImgActionUrlKey" //活动url
#define kActivityImgUrlKey               @"kActivityImgUrlKey" //活动按钮图片

#define kLaunchImageWaitSec     3
#define kLaunchImageURLKey     @"kLaunchImageURLKey" //启动图URL
#define kLaunchLinkURLKey       @"kLaunchLinkURLKey" //点击启动图跳转到URL
#define kLaunchViewShowedKey  @"kLaunchViewShowedKey" //是否显示启动图
#define kLaunchLinkTitleKey  @"kLaunchLinkTitleKey" //启动图广告title

#define kSocketHostKey  @"quotation.moamarkets.com" //长链接ip
#define kSocketPortKey   @"1234"   //长链接端口
#define kSocketTokenKey @"kSocketTokenKey" //秘钥
#define kSocketDecodeTokenKey @"kSocketDecodeTokenKey" //解密秘钥

#define kShowImage @"kShowImage" //是否显示广告启动图

#define kHomeImageUrl @"kHomeImageUrl" //首页广告url
#define kHomeImageLink @"kHomeImageLink" //首页广告链接
#define kHomeImageLinkTitle @"kHomeImageLinkTitle" //首页广告链接标题
#define kShowHomeImage @"kShowHomeImage" //是否显示广告首页

#define kGameUrl @"kGameUrl"             //大赛URL入口,带userId
#define kGameUrlSimple @"kGameUrlSimple"        //大赛URL入口
#define kRecommendAppUrl @"kRecommendAppUrl" //推荐应用url
#define hasRecommendAppUrl @"hasRecommendAppUrl" //是否有推荐应用url

#define EnableDeal @"EnableDeal" //能否交易
#define kDealBlowingPop @"kDealBlowingPop"  //是否提示过爆仓警告
//客服信息
#define kCustomerAccid @"customerAccid"
#define kCustomerToken @"customerToken"
#define kStaffAccid @"staffAccid"
#define kStaffName @"staffName"
//聊天室信息
#define kChatroomAccId @"customerAccid"
#define kChatroomName @"kChatroomName"
#define kChatroomId @"kChatroomId"
#define kChatroomToken @"kChatroomToken"


//用户信息
#define kAvatar @"avatar"
#define kNickName @"nickName"
#define kMobile @"mobile"
#define kToken @"token"
#define kLastMobile @"lastMobileNum"
#define MT4ID @"mt4id"
#define TYPE @"type"
#define INFOSTEP @"infoFillStep"
#define MARKLIST @"markList"
#define PICID @"photoID"
#define kLoginUrl @"loginUrl"
#define kLoginRedirectUrl @"loginRedirectUrl"
#define kDeviceTokenKey  @"deviceToken"
#define kAuthorization  @"Authorization"


@interface LTUser : NSObject


#define UD_NickName             [NSUserDefaults objFoKey:kNickName]
#define UD_SetNickName(str)    [NSUserDefaults setObj:str foKey:kNickName]

#define UD_Avatar                   [NSUserDefaults objFoKey:kAvatar]
#define UD_SetAvatar(str)    [NSUserDefaults setObj:str foKey:kAvatar]

#define UD_Mobile                    [NSUserDefaults objFoKey:kMobile]
#define UD_SetMobile(str)    [NSUserDefaults setObj:str foKey:kMobile]

//是否登录
+ (BOOL)hasLogin;
+ (void)saveUser:(NSDictionary *)dict;
+ (NSString *)userId;
#define UD_UserId                   [LTUser userId]
#define UD_ChatRoomUserKey     \
        [NSString stringWithFormat:@"%@_isChatUser",UD_UserId]
//退出登录、删除（用户登录成功保存的数据，token等）
+ (void)logout;


#pragma mark - 秘钥

#define KAppEncryptKey  [LTUser encryptKey]
+ (NSString *)encryptKey;

#pragma mark - token
//token key
//token value
#define UD_Token    \
    [NSUserDefaults objFoKey:kToken]
//token date key
#define kTokenDate    @"token_date_fxbtg"
//token date value
#define UD_TokenDate   \
    [NSUserDefaults objFoKey:kTokenDate]
//token save date
#define UD_SetTokenDate     \
    [NSUserDefaults setObj:[NSDate date] foKey:kTokenDate]
#define UD_EnableDeal    [[NSUserDefaults objFoKey:EnableDeal] isEqualToString:@"1"]

//IDCard dist status 1：认证失败，2：资料未认证，3：认证中，4：认证成功
#define kCardDistStatus    [NSString stringWithFormat:@"CardDistStatus_%@",UD_Mobile]
#define UD_SetCardDistStatus(status)     \
        [UserDefaults setInteger:status forKey:kCardDistStatus]
#define UD_CardDistStatus     \
        [UserDefaults integerForKey:kCardDistStatus]


/**  tpye类型的token是否过期 本地
 *    YES:过期        NO:没过期
 */
+ (BOOL)tokenTimeOut;

/**  tpye类型的token是否过期 本地
 *    YES:过期        NO:没过期
 */
+ (BOOL)tokenIsNull;


/** 根据ExchangeType  存、取、删 token */
+ (void)saveToken:(NSString *)token;
+ (NSString *)fxbtgToken;
+ (BOOL)locHasToken;
+ (BOOL)hideDeal;


#pragma mark - NIM
/** 聊天室信息 */
+ (void)saveChatroomInfo:(NSDictionary *)dict;
/** 客服信息 */
+(void)saveCustomerInfo:(NSDictionary *)dict;

#define kUserInChinaKey @"kUserInChinaKey"
#define UD_CanDeal  [LTUser canDeal]
+ (BOOL)canDeal;


#pragma mark  用户vip等级及折扣
+ (void)setUserVipLv:(NSNumber *)lv;
+ (NSNumber *)userVipLv;
+ (NSString *)userVipLvKey;
+ (void)setUserVipLvDiscount:(NSString *)discount;
+ (NSString *)userVipLvDiscount;
+ (NSString *)userVipLvDiscountKey;



#pragma mark 启动请求配置参数
+ (void)reqStartup;
+ (NSString *)homeProductListString;
+ (NSArray *)homeProductListSimple;

#pragma mark 检查更新
#pragma mark - 审核隐藏
+ (BOOL)appIsNormal;
+ (void)setAppIsNormal:(BOOL)bl;
//YES：正常    NO：受限
#define UD_AppIsNormal            [LTUser appIsNormal]
#define UD_SetAppIsNormal(bl)  [LTUser setAppIsNormal:bl]
+ (void)checkUpdate;




@end
