//
//  RequestCenter.m
//  Canary
//
//  Created by litong on 2017/5/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "RequestCenter.h"
#import <AdSupport/ASIdentifierManager.h>
#import "NetworkRequests.h"
@implementation RequestCenter

#pragma mark - FXBTG
#pragma mark - FXBTG 交易相关

/** 历史持仓列表
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/trade/history/list
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		用户token
 page	true	普通参数	Integer		第几页
 pageSize	true	普通参数	Integer		每页显示的条数
 */
+(void)reqDealHistoryListWithPage:(NSInteger)page pageSize:(NSInteger)pageSize finsh:(FinishBlock)block{
    NSString *api = URL_FXBTDealHistoryList;
    NSString *token = UD_Token;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @(page),@"page",
                          @(pageSize),@"pageSize",
                          UD_UserId,@"userId",
                          token,@"token",
                          nil];
    [LTRequest baseAuthGet:api parameters:dict finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 产品列表
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 */
+ (void)reqProductList:(FinishBlock)block {
    NSString *url = URL_FXBTGProductList;
    [LTRequest baseAuthGet:url parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 产品详情
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 code	true	普通参数	String		产品code
 */
+ (void)reqProductDetail:(NSString *)excode code:(NSString *)code finish:(FinishBlock)block {
    NSString *url = URL_FXBTGProductDetail;
    NSDictionary *dict = @{@"excode" : excode,@"code" : code};
    [LTRequest baseAuthGet:url parameters:dict finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 持仓列表
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/trade/holdPosition/list
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		用户token
 sourceId	false	普通参数	Integer		app来源
 market	false	普通参数	String		市场
 */
+ (void)reqHoldList:(FinishBlock)block {
    if (emptyStr(UD_UserId)) {
        return;
    }
    NSString *url = URL_FXBTGHoldList;
    NSDictionary *params = @{
                             @"userId" : UD_UserId,
                             @"token" : UD_Token,
                             @"market" : kAppMarket,
                             @"sourceId" : @(kAPPType)
                             };
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}
/** 平仓 
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/trade/order/close
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		用户token
 sourceId	false	普通参数	Integer		app来源
 market	true	普通参数	String		市场
 orderId		普通参数	String		订单ID
 */
+ (void)reqEXOrderCloseWithOrderId:(NSString *)orderId finish:(FinishBlock)block {
    
    NSString *url =  URL_FXBTGClosePosition;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            orderId,@"orderId",
                            @(kAPPType),@"sourceId",
                            kAppMarket,@"market",
                            UD_UserId,@"userId",
                            UD_Token,@"token",
                            nil];
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 创建订单
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/trade/order/create
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		用户token
 sourceId	false	普通参数	Integer		app来源
 market	false	普通参数	String		市场
 orderNumber	true	普通参数	BigDecimal		购买多少手
 productId	true	普通参数	String		产品代码
 type	true	普通参数	Integer		方向 1.跌 2.涨
 stopProfit	false	普通参数	BigDecimal		止盈
 stopLoss	false	普通参数	BigDecimal		止损
 */
+(void)reqCreateOrderWithParameter:(NSDictionary *)parameters finish:(FinishBlock)block {
    NSString *url = URL_FXBTGOrderCreate ;
    [LTRequest baseAuthGet:url parameters:parameters finish:^(LTResponse *res) {
        block(res);
    }];

}

/** 订单设置止盈、止损 
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/trade/order/update
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		用户token
 sourceId	false	普通参数	Integer		app来源
 market	false	普通参数	String		市场代码
 orderId	true	普通参数	String		订单ID
 stopProfit	true	普通参数	BigDecimal		止盈
 stopLoss	true	普通参数	BigDecimal		止损
 */
+ (void)reqSetProfitLossWithParameter:(NSMutableDictionary *)parameter finish:(FinishBlock)block {
    NSString *url = URL_FXBTGOrderSet;
    [LTRequest baseAuthGet:url parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 品种购买比率
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/trade/buyRate
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 code	 true	普通参数	String		商品code
 */
+ (void)reqBuyRateWithCode:(NSString *)code finish:(FinishBlock)block{
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:code,@"code", nil];
    [LTRequest baseAuthGet:URL_FXBTGBuyRate parameters:dic finish:^(LTResponse *res) {
        block(res);
    }];
}
#pragma mark - FXBTG 用户类
/** 发送注册验证码
 POST https://test-fxbtg.8caopan.com/user/info/register/send/sms
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 mobileNum	true	普通参数	String		手机号码
 */
+ (void)reqRegisterSMS:(NSString *)mobileNum finsh:(FinishBlock)block{
    NSDictionary * dic = @{@"loginName":mobileNum};
    NSString * stringUrl =[NSString stringWithFormat:@"%@%@",BaseUrl,@"/login/getCode"];

    [LTRequest basePost:stringUrl parameters:dic finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 新注册
 POST https://test-fxbtg.8caopan.com/user/info/register
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 mobileNum	true	普通参数	String		手机号码
 password	true	普通参数	String		密码，需要加密，加密算法和8元交易密码一直，key:5fjyU#Mvyfp[^CMx, iv:i%hRCnu~~.B#y+Y(
 code	true	普通参数	String		短信验证码，测试环境随便填
 market	true	普通参数	String		应用市场
 udid	false	普通参数	String		udid
 idfa	false	普通参数	String		idfa
 */
+ (void)reqRegisterWithMobile:(NSString *)mobileNum password:(NSString *)password code:(NSString *)code finsh:(FinishBlock)block{
    NSString *idfa = [DeviceInfo getIdfa];
    password = [password AES128Encrypt];
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 mobileNum,@"mobileNum",
                                 password,@"password",
                                 code,@"code",
                                 idfa,@"idfa", nil];
    [LTRequest baseAuthGet:URL_LocRegister parameters:dic finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 登录
 POST https://test-fxbtg.8caopan.com/user/info/login
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 mobileNum	true	普通参数	String		手机号码
 password	true	普通参数	String		密码，加密规则同注册的密码规则
 */
+ (void)reqLoginWithMobileNum:(NSString *)mobileNum password:(NSString *)password finsh:(FinishBlock)block{
    NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithObjectsAndKeys:mobileNum,@"username",password,@"password", nil];
    [LTRequest basePost:URL_LocLogin parameters:dic finish:^(LTResponse *res) {
        block(res);
    }];
}
/** 修改昵称 
 POST https://test-fxbtg.8caopan.com/user/info/update/nickName
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 nickName	true	普通参数	String		用户昵称
 */
+ (void)reqChangeNickname:(NSString *)name finsh:(FinishBlock)block {
    NSString *url = URL_UpdateUserName;
    NSString *userId = UD_UserId;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          name,@"nickName",
                          userId,@"userId",
                          [NSNumber numberWithInt:kAPPType],@"sourceId",
                          nil];
    
    [LTRequest baseAuthGet:url parameters:dict finish:^(LTResponse *res) {
        block(res);
    }];
}

/**  修改头像
 POST https://test-fxbtg.8caopan.com/user/info/update/avatar
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 file	true	普通参数	File		头像图片
*/
+ (void)reqChangeHeadImage:(NSString *)path finsh:(FinishBlock)block {
    NSString *uid = UD_UserId;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"userId", nil];
    NSString *url = URL_UpdateHeadImage;
    [LTRequest baseAuth:url parameters:dict imagePath:path finish:^(LTResponse *res) {
        block(res);
    }];
}
/**  找回密码短信
 POST https://test-fxbtg.8caopan.com/user/info/retrieve/password/send/sms
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 mobileNum	true	普通参数	String		手机号码
 sourceId true
 */
+ (void)reqForgetPassWordSMS:(NSString *)mobileNum finsh:(FinishBlock)block{
    NSDictionary *dict =@{@"mobile":mobileNum};
    NSString * urlString =[NSString stringWithFormat:@"%@%@",BasisUrl,@"/sendvcode"];
    [LTRequest baseAuthGet:urlString parameters:dict finish:^(LTResponse *res) {
        block(res);
    }];
}

/**  找回密码
 POST https://test-fxbtg.8caopan.com/user/info/retrieve/password
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 mobileNum	true	普通参数	String		手机号码
 password	true	普通参数	String		密码，加密规则 同 注册接口
 code	true	普通参数	String		短信验证码
 */
+ (void)reqForgetPassWord:(NSString *)mobileNum password:(NSString *)password code:(NSString *)code finsh:(FinishBlock)block{
    password = [password AES128Encrypt];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          mobileNum,@"mobileNum",
                          password,@"password",
                          code,@"code", nil];
    [LTRequest baseAuthGet:URL_LocForgetPWD parameters:dict finish:^(LTResponse *res) {
        block(res);
    }];
}
#pragma mark - FXBTG 充值取现
/**  提现申请
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/cashOut/insert
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		用户token
 sourceId	false	普通参数	Integer		app来源
 market	false	普通参数	String		市场
 bankId	true	普通参数	String		已绑定的银行卡 Id
 balance	 true	普通参数	String		出金额
 ipAddress	true	普通参数	String		客户 IP
 */
+ (void)reqCashOutWithParameter:(NSDictionary *)parameter finsh:(FinishBlock)block{
    [LTRequest baseAuthGet:URL_FXBTGCashOut parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/**  充值
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/recharge/url
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		用户token
 sourceId	false	普通参数	Integer		app来源
 market	false	普通参数	String		市场
 notifyUrl	false	普通参数	String
 */
+ (void)reqRechargeWithNotifyUrl:(NSString *)notifyUrl finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                          UD_UserId,@"userId",
                          UD_Token,@"token",
                          @(kAPPType),@"sourceId",
                          kAppMarket,@"market",
                          notifyUrl,@"notifyUrl",nil];

    [LTRequest baseAuthGet:URL_FXBTGRecharge parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}
/**  用户充值记录
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/recharge/list
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		用户token
 page	true	普通参数	Integer	1	当前页数
 pageSize	true	普通参数	Integer	10	每页条数
 */
+ (void)reqRechargeListWithPage:(NSInteger)page pageSize:(NSInteger)pageSize finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               UD_Token,@"token",
                               @(page),@"page",
                               @(pageSize),@"pageSize",nil];
    [LTRequest baseAuthGet:URL_FXBTGRechargeList parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/**  提现列表
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/cashOut/list
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		用户token
 sourceId	false	普通参数	Integer		app来源
 market	false	普通参数	String		市场
 page	 true	普通参数	Integer	1	当前页数
 pageSize	true	普通参数	Integer	10	每页记录数
 */
+ (void)reqCashOutListWithPage:(NSInteger)page pageSize:(NSInteger)pageSize finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               UD_Token,@"token",
                               @(kAPPType),@"sourceId",
                               kAppMarket,@"market",
                               @(page),@"page",
                               @(pageSize),@"pageSize",nil];
    
    [LTRequest baseAuthGet:URL_FXBTGCashOutList parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}
#pragma mark - FXBTG 行情定制
/**  推送提醒-增加
 POST https://test-fxbtg.8caopan.com/news/api/quotes/reminder/add
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 excode	true	普通参数	String		交易所编码
 code	true	普通参数	String		产品编码
 customizedProfit	true	普通参数	float		定制点位
 floatPoint	true	普通参数	float		浮动点位
 cycleType	true	普通参数	Int		过期类型（1，一天，2 一周）
 */
+ (void)reqReminderAddWithParameter:(NSDictionary *)parameter finsh:(FinishBlock)block{
    [LTRequest baseAuthGet:URL_PushRemindAdd parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}


/**  推送提醒-修改
 POST https://test-fxbtg.8caopan.com/news/api/quotes/reminder/update
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 excode	true	普通参数	String		交易所编码
 code	true	普通参数	String		产品编码
 customizedProfit	true	普通参数	float		定制点位
 floatPoint	true	普通参数	float		浮动点位
 cycleType	true	普通参数	Int		过期类型（1，一天，2 一周）
 id	true	普通参数	Long		编号
 */
+ (void)reqReminderUpdateWithParameter:(NSDictionary *)parameter finsh:(FinishBlock)block{
    [LTRequest baseAuthGet:URL_PushRemindUpdate parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/**  推送提醒-删除
 POST https://test-fxbtg.8caopan.com/news/api/quotes/reminder/delete
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	String		用户ID
 id	true	普通参数	String		id
 */
+ (void)reqReminderDeleteWithId:(NSString *)Id finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               Id,@"pid",
                               nil];
    [LTRequest baseAuthGet:URL_PushRemindDelete parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/**  推送提醒-配置
 POST https://test-fxbtg.8caopan.com/news/api/quotes/reminder/product/setting
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 excode	true	普通参数	String		交易所编号
 code	true	普通参数	String		产品编号
 */
+ (void)reqReminderSettingWithCode:(NSString *)code finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               @"FXBTG",@"excode",
                               code,@"code",
                               nil];
    [LTRequest baseAuthGet:URL_PushRemindConfig parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/**  推送提醒-查询
 POST https://test-fxbtg.8caopan.com/news/api/quotes/reminder/list
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 excode	true	普通参数	String		交易所编码
 code	true	普通参数	String		产品编码
 */
+ (void)reqReminderListWithCode:(NSString *)code finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               @"FXBTG",@"excode",
                               code,@"code",
                               nil];
    [LTRequest baseAuthGet:URL_PushRemindList parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

#pragma mark - FXBTG 资讯
/** 检查用户资讯支持操作
 POST https://test-fxbtg.8caopan.com/news/api/transaction/check
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 type	true	普通参数	Int		类型（1：资讯 2：文章）
 objectId	true	普通参数	Long		编号
 */
+ (void)reqTransactionCheckWithType:(NSNumber *)type objectId:(NSNumber *)objectId finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               type,@"type",
                               objectId,@"objectId",
                               nil];
    [LTRequest baseAuthGet:URL_HomeNewsCheck parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}
/** 资讯列表
 http://t.m.8caopan.com/news/api/transaction/opportunity/list/
 参数：auth、t、soucreId、
 userId、page、pageSize
 type： 1公告， 2早间布局， 3行情预演（带日历），4交易机会（专家解读），
 不填写表示所有
 informationAuthorId：分析师编号
 */
+ (void)reqNewsList:(NSNumber *)type authorId:(NSString *)authorId pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize finsh:(FinishBlock)block {
    NSString *api = URL_HomeNewsList;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @(pageNo),@"page",
                          @(pageSize),@"pageSize",
                          UD_UserId,@"userId",
                          type,@"type",
                          authorId,@"informationAuthorId",
                          nil];
    [LTRequest basePost:api parameters:dict cookie:nil encryptType:LTEncryptType_Auth finish:^(LTResponse *res) {
        block(res);
    }];
    
}
/** 新资讯-交易动态
 POST https://test-fxbtg.8caopan.com/news/api/transaction/newest
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 exchangeId	true	普通参数	int		交易所ID,0:代表所有交易所，1：广贵，2：哈贵，3：吉贵
 count	false	普通参数	int	10	查询记录条数，不填写则默认为10条记录
 */
+ (void)reqTransactionNewestWithCount:(NSInteger)count finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(count),@"count",
                               nil];
    [LTRequest baseAuthGet:URL_HomeNewest parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 资讯点利多or利空
 http://t.m.8caopan.com/news/api/transaction/operation/insert
 参数：auth、t、soucreId、
 userId、
 objectId（编号）、
 clickType（1利多2利空）、
 type  类型（1：资讯 2：文章）
 
 */
+ (void)reqNewOperation:(NSInteger)clickType objectId:(NSNumber *)objectId type:(NSInteger)type finsh:(FinishBlock)block {
    NSString *api = URL_HomeNewsOperation;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @(clickType),@"clickType",
                          objectId,@"objectId",
                          UD_UserId,@"userId",
                          @(type),@"type",
                          @(kAPPType),@"sourceId",
                          nil];
    [LTRequest basePost:api parameters:dict cookie:nil encryptType:LTEncryptType_Auth finish:^(LTResponse *res) {
        block(res);
    }];
}

#pragma mark - FXBTG 交易所用户相关接口

/** 登录交易所
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/user/login
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 password	true	普通参数	String		密码，加密规则同注册接口
 */
+ (void)reqEXLoginWithPassword:(NSString *)password finsh:(FinishBlock)block{
    NSString *pas=[password AES128Encrypt];
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                          UD_UserId,@"userId",
                          pas,@"password",
                          nil];
    [LTRequest baseAuthGet:URL_FXBTGLogin parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 账户信息
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/user/account/info
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		token信息
 */
+ (void)reqAccountInfo:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               UD_Token,@"token",
                               nil];
    [LTRequest baseAuthGet:URL_FXBTGAccountInfo parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 身份证正面识别
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/user/idCard/frontDist
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 file	true	普通参数	File		身份证正面图片
 token	true	普通参数	String		登录token
 */
+ (void)reqEXIDCardFrontDistWithFile:(NSString *)file finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               UD_Token,@"token",
                               nil];
    [LTRequest baseAuth:URL_FXBTGCardFrontDist parameters:parameter imagePath:file finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 身份证反面识别
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/user/idCard/backDist
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 file	true	普通参数	File		身份证正面图片
 token	true	普通参数	String		登录token
 */
+ (void)reqEXIDCardBackDistWithFile:(NSString *)file finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               UD_Token,@"token",
                               nil];
    [LTRequest baseAuth:URL_FXBTGCardBackDist parameters:parameter imagePath:file finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 提交实名认证
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/user/auth/submit
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		登录token
 name	true	普通参数	String		真实姓名
 idNo	true	普通参数	String		身份证号码
 sex	true	普通参数	String		性别
 expiresStart	true	普通参数	String		身份证有效开始
 expiresEnd	true	普通参数	String		身份证有效结束
 */
+ (void)reqEXAuthSubmitWithParameter:(NSDictionary *)parameter finsh:(FinishBlock)block{
    [LTRequest baseAuthGet:URL_FXBTGAuthSubmit parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 实名认证状态
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/user/auth/status
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		登录token
 */
+ (void)reqEXAuthStatus:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               UD_Token,@"token",
                               nil];
    [LTRequest baseAuthGet:URL_FXBTGAuthStatus parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 绑定银行卡
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/user/bind/card
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		用户登录token
 bankDepositId	true	普通参数	String		银行支行ID
 bankNo	true	普通参数	String		银行卡号
 province	true	普通参数	String		省份名称
 city	true	普通参数	String		城市名称
 bankName	true	普通参数	String		银行名称
 bankBranch	true	普通参数	String		支行名称
 */
+ (void)reqUserBindCard:(NSDictionary *)parameter finsh:(FinishBlock)block{
    [LTRequest baseAuthGet:URL_FXBTGBindCard parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 用户银行卡列表
 POST https://test-fxbtg.8caopan.com/app/fxbtg/exchange/user/bank/list
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 userId	true	普通参数	Long		用户ID
 token	true	普通参数	String		登录token
 */
+ (void)reqUserBindedBankList:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               UD_UserId,@"userId",
                               UD_Token,@"token",
                               nil];
    [LTRequest baseAuthGet:URL_FXBTGBindList parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

#pragma mark - FXBTG 省份、城市、银行、支行
/** 省份列表
 POST https://test-fxbtg.8caopan.com/app/fxbtg/dict/province/list
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 */
+ (void)reqProvinceList:(FinishBlock)block{
    [LTRequest baseAuthGet:URL_FXBTGProvinceList parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 城市列表
 POST https://test-fxbtg.8caopan.com/app/fxbtg/dict/city/list
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 provinceCode	true	普通参数	String		省份编码
 */
+ (void)reqCityList:(NSString *)provinceCode finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               provinceCode,@"provinceCode",
                               nil];
    [LTRequest baseAuthGet:URL_FXBTGCityList parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 银行列表
 POST https://test-fxbtg.8caopan.com/app/fxbtg/dict/bank/list
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 */
+ (void)reqBankList:(FinishBlock)block{
    [LTRequest baseAuthGet:URL_FXBTGBankList parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 支行列表
 POST https://test-fxbtg.8caopan.com/app/fxbtg/dict/branchBank/list
 参数：
 auth	true	普通参数	String		签名
 t	true	普通参数	Long		时间戳
 cityCode	true	普通参数	String		城市编码
 bankCode	true	普通参数	String		银行编码
 */
+ (void)reqBranchBankList:(NSString *)cityCode bankCode:(NSString *)bankCode finsh:(FinishBlock)block{
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:
                               cityCode,@"cityCode",
                               bankCode,@"bankCode",
                               nil];
    [LTRequest baseAuthGet:URL_FXBTGBranchBankList parameters:parameter finish:^(LTResponse *res) {
        block(res);
    }];

}
#pragma mark - Market
/** 请求k线接口
 */
+(void)getDaysChartAPIWithExCode:(NSString*)excode Code:(NSString*)code Type:(NSString*)type  finsh:(FinishBlock)block{
    NSString *url = [LTUtils hashUrlStringWithExcode:excode Code:code Type:type FontUrl:kAPI_Varieties_kline];
    [LTRequest baseOtherGet:url finish:^(LTResponse *res) {
        block(res);
    }];
}
/** 外盘分时图 */
+ (void)reqOuterTickChartWithExcode:(NSString*)excode code:(NSString*)code finsh:(FinishBlock)block {
    NSString *url = [LTUtils hashUrlStringWithExcode:excode Code:code Type:nil FontUrl:kAPI_Varieties_time];
    [LTRequest baseOtherGet:url finish:^(LTResponse *res) {
        block(res);
    }];
    
}

/** 根据codes取外盘数据 */
+(void)getCustomAPIWithCodes:(NSString*)codes finsh:(FinishBlock)block{
    NSString *url = [LTUtils hashUrlStringWithExcode:@"custom" Code:codes Type:nil FontUrl:kAPI_Varieties_custom];
    [LTRequest baseOtherGet:url finish:^(LTResponse *res) {
        block(res);
    }];

}
/* 分时线 v2 */
+ (void)requestTickChartWithExcode:(NSString *)excode code:(NSString *)code completion:(FinishBlock)block {
    NSString *params = [LTRequest encryptParams:
                        @{ @"excode" : excode,
                           @"code" : code}];
    NSString *url = [NSString stringWithFormat:@"%@?%@",URL_MinuteChart,params];
    
    [LTRequest baseGet:url parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];
}
/** K线
 type类型  10＝1分钟 2＝5分钟 3＝15分钟 4＝30分钟 5=1小时 6=日线 9=4小时
 http://q.8caopan.com/wp/quotation/v2/kChart?type=9&excode=HPME&code=XAG1&sourceId=10&t=1473391073078&auth=e19f7ad2ac8d98a082125f29183f62f6
 */
+ (void)requestKChartWithExcode:(NSString *)excode code:(NSString *)code type:(NSString*)type completion:(FinishBlock)block{
    NSString *params = [LTRequest encryptParams:
                        @{ @"excode" : excode,
                           @"code" : code,
                           @"type" : type}];
    NSString *url = [NSString stringWithFormat:@"%@?%@",URL_DayChart,params];
    [LTRequest baseGet:url parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];
}

/* 行情：银油等的详情 v2 */
+ (void)requestQuotationDetailWithCodes:(NSString *)codes completion:(FinishBlock)block{
    
    NSString *url = [NSString stringWithFormat:@"%@?codes=%@",URL_QuotationDetail,codes];
    NSString * urlStr  =@"https://q.8caopan.com//wp/quotation/v2/realTime?codes=FXBTG|USOIL";
    [LTRequest baseGet:urlStr parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];
}
+ (void)requestQuotationDetailV2WithCodes:(NSString *)codes completion:(FinishBlock)block{
    
    NSString *url = [NSString stringWithFormat:@"%@?codes=%@",URL_QuotationDetailV2,codes];
    [LTRequest baseGet:url parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];
    
}

//  请求品种列表   //requestMarketFx678Com
+(void)getVarietiesListWithEXCode:(NSString*)excode finsh:(FinishBlock)block {
    NSString *url = [LTRequest hashUrlStringWithExcode:excode Code:nil Type:nil FontUrl:kAPI_Varieties_List];
    [LTRequest baseOtherGet:url finish:^(id res) {
        block(res);
    }];
}
// 交易所行情列表
+ (void)reqQuotationListWithCodes:(NSString *)excode finsh:(FinishBlock)block{
    NSDictionary *dict = @{@"excode" : excode};
    NSString *url =  URL_QuotationList;
    [LTRequest basePost:url parameters:dict cookie:nil encryptType:LTEncryptType_Non finish:^(LTResponse *res) {
        block(res);
    }];
}
#pragma mark - 客户端信息收集接口
+ (void)reqCollectGTPushInfoWithCid:(NSString *)cid finsh:(FinishBlock)block{
    NSString *api = URL_GTInfo;
    
    NSString *version=[DeviceInfo appVersion];
    if (emptyStr(cid) || emptyStr(UD_UserId)) {
        return;
    }
    NSString *iphoneType = [LTUtils iphoneDeviceModel];
    NSString *iOSVer = [NSString stringWithFormat:@"%g",kSystemVersion];
    NSString *deviceInformation = [NSString stringWithFormat:@"%@ %@",iphoneType,iOSVer]
    ;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 cid,@"cid",
                                 UD_UserId,@"userId",
                                 version,@"version",
                                 deviceInformation,@"deviceInformation",
                                 nil];
    [LTRequest baseAuthGet:api parameters:dict finish:^(LTResponse *res) {
        block(res);
    }];    
}
#pragma mark - 启动

//启动请求服务器信息
+ (void)reqStartup:(FinishBlock)block {
    NSString *userIdProperty = @"";
    if ([LTUser hasLogin]) {
        userIdProperty = [NSString stringWithFormat:@"&userId=%@",UD_UserId];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@?deviceType=%d&sourceId=%d&versionNo=%d%@",URL_Startup,kDeviceType,kAPPType,RechargeAmountListVersion_JG,userIdProperty];
    [LTRequest baseGet:url parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];
}

#pragma mark - 检查更新

+ (void)checkAppVersion:(FinishBlock)block {
    NSString *url = URL_CheckUpdate;
    NSString *curVer = shortVersionString_();
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @(kAPPType),@"sourceId",
                            curVer,@"version",
                            nil];
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}

#pragma mark - 首页

/**  首页&直播室banner
 auth        true		String		签名
 t              true		Long		时间戳
 sourceId	true		Integer		APP 来源
 callType	true		Integer		哪个调用模块（1：首页，2：直播室）
 
 startPos	false		Integer     0       从第几条开始
 count      false	  	Integer     9       从哪条结束
 */
+ (void)reqBannerList:(NSInteger)callType finish:(FinishBlock)block {
    NSString *url = URL_BannerList;
    NSDictionary *params = @{
                             @"sourceId" : @(kAPPType),
                             @"device" : @(kDeviceType),
                             @"callType" : @(callType),
                             };
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}










//重要消息详情页广告
+ (void)reqNewsDetailAD:(FinishBlock)block {
    NSString *url = Home_NewsDetailAD;
    [LTRequest baseGet:url parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 盈利单排行榜
 http://t.m.8caopan.com/news/api/billboard/show/order/list?userId=140345&page=1&sourceId=10&t=1479100104110&auth=ef98045bc449faeacbdf712cca9fdd61
 */
+ (void)reqGainList:(NSInteger)pageNo completion:(FinishBlock)block {
    NSString *api = Home_GainList;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @(pageNo),@"page",
                          UD_UserId,@"userId",
                          nil];
    [LTRequest basePost:api parameters:dict cookie:nil encryptType:LTEncryptType_Auth finish:^(LTResponse *res) {
        block(res);
    }];
}


/** 盈利单详情
 */
+ (void)reqGainDetail:(NSString *)oid completion:(FinishBlock)block {
    NSString *api = Home_GainDetailList;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          oid,@"orderId",
                          nil];
    [LTRequest basePost:api parameters:dict cookie:nil encryptType:LTEncryptType_Auth finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 最新用户嗮单和我的排名
 http://t.m.8caopan.com/news/api/billboard/me/rank?userId=140345&sourceId=10&t=1479102283120&auth=c9b0600b1ef7161a8bf70ad8a28b6896
 */
+ (void)reqShowGainCompletion:(FinishBlock)block {
    NSString *api = Home_ShowGain;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          UD_UserId,@"userId",
                          nil];
    [LTRequest basePost:api parameters:dict cookie:nil encryptType:LTEncryptType_Auth finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 我的盈利单
 
 */
+ (void)reqMyGainCompletion:(FinishBlock)block {
    NSString *api = Home_MyGain;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          UD_UserId,@"userId",
                          nil];
    [LTRequest basePost:api parameters:dict cookie:nil encryptType:LTEncryptType_Auth finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 行情交易所信息列表
 http://t.m.8caopan.com/news/api/quotation/exchange/list
 */
+(void)reqMarketExchangeListFinish:(FinishBlock)block {
    NSString *api = ExchangesList;
    NSString *url = [NSString stringWithFormat:@"%@",api];
    [LTRequest baseGet:url parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];
}






/** 28 订单过夜费 */
+ (void)reqDeferredListWithOrderId:(NSString *)orderId finish:(FinishBlock)block {
    NSString *url = URL_JGDeferredList;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                         UD_UserId,@"userId",
                         orderId,@"orderId",
                         UD_Token,@"token",
                         nil];
    [LTRequest basePost:url parameters:params cookie:nil encryptType:LTEncryptType_Auth finish:^(LTResponse *res) {
        block(res);
    }];
}

#pragma mark - 行情

#pragma mark - 直播

/** 获取直播列表 */
+ (void)requestLiveList:(FinishBlock)block {
    NSString *url = URL_LiveList;
    [LTRequest baseAuthGet:url parameters:nil finish:^(LTResponse *res) {
        block(res);
    }];

}

//老师统计
+ (void)reqLiveAuthorInfo:(NSString *)authorId finish:(FinishBlock)block {
    NSString *url = URL_LiveAuthorInfo;
    NSDictionary *params = @{
                             @"authorId" : authorId,
                             };
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}

//直播室添加观看记录
+ (void)reqLiveWatchUserAdd:(NSString *)authorID finish:(FinishBlock)block {
    NSString *url = URL_LiveWatchUserAdd;
    NSDictionary *params = @{
                             @"authorId" : authorID,
                             @"userId" : UD_UserId,
                             };
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}


//直播室礼物列表接口
+ (void)reqLiveGifts:(NSInteger)page pageSize:(NSInteger)pageSize finish:(FinishBlock)block {
    NSString *url = URL_LiveGifts;
    NSDictionary *params = @{
                             @"userId" : UD_UserId,
                             @"page" : @(page),
                             @"pageSize" : @(pageSize),
                             };
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}

/**     直播室送礼物
 
 giftId	true	普通参数	Long		礼物ID
 authorId	true	普通参数	Long		老师ID
 channelId	true	普通参数	String		直播室ID
 roomId	true	普通参数	Long		聊天室ID
 */
+ (void)reqLiveGiftExchange:(NSDictionary *)dict finish:(FinishBlock)block {
    NSString *url = URL_LiveGiftExchange;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:dict];
    [params setValue:UD_UserId forKey:@"userId"];
    [params setValue:@(kAPPType) forKey:@"sourceId"];
    [params setValue:@(kDeviceType) forKey:@"deviceType"];
    [params setValue:IXIT_Channel_Name forKey:@"market"];
    
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}

//关注分析师列表
+ (void)reqAttentionAnalystList:(FinishBlock)block {
    NSString *url = URL_AttentionAnalystList;
    NSDictionary *params = @{
                             @"userId" : UD_UserId,
                             };
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}

//关注分析师(取消)
+ (void)reqAttentionAnalyst:(BOOL)attention authorId:(NSString *)authorId finish:(FinishBlock)block {
    NSString *url = attention ? URL_AttentionAnalyst : URL_AttentionAnalystCanale;
    NSDictionary *params = @{
                             @"authorId" : authorId,
                             @"userId" : UD_UserId,
                             };
    //    cancle userId  ->  reminderId
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}



#pragma mark - 聊天室

/** 获取房间id */
+ (void)requestRoomId:(FinishBlock)block {
    NSString *url = URL_ChatRoomId;
    NSString *uid = UD_UserId;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:uid,@"userId", nil];
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 聊天室禁止发图 */
+ (void)requestCheckSendPic:(NSString *)channelId chatRoomId:(NSString *)chatRoomId finish:(FinishBlock)block {
    NSString *url = URL_LiveSendPicStatus;
    NSDictionary *params = @{@"channelId":channelId,@"chatRoomId":chatRoomId};
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}


/** 叫单 */
+ (void)requesOutcryList:(NSInteger)page count:(NSInteger)count roomId:(NSString *)roomId completion:(FinishBlock)block {
    
    NSString *url = URL_OutcryList;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                         @(page),@"page",
                         @(count),@"count",
                         roomId,@"roomId",
                         nil];
    [LTRequest basePost:url parameters:params cookie:nil encryptType:LTEncryptType_Auth finish:^(LTResponse *res) {
        block(res);
    }];
}






#pragma mark 积分


//查看当前积分和等级
+ (void)reqUserPoint:(NSInteger)versionNo finish:(FinishBlock)block {
    
    NSString *url = URL_UserPoint;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            UD_UserId,@"userId",
                            @(versionNo),@"versionNo",
                            nil];
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];

}



/** 查看积分明细
 yearMonth :月份(yyyy-MM)
 status:状态:1=获取的积分，2=消费的积分
 */
+ (void)reqUserPointRecList:(NSInteger)pageNo pageSize:(NSInteger)pageSize yearMonth:(NSString *)yearMonth status:(NSInteger)status finish:(FinishBlock)block {
    
    NSString *url = URL_UserPointRecList;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            UD_UserId,@"userId",
                            yearMonth,@"yearMonth",
                            @(status),@"status",
                            @(pageNo),@"page",
                            @(pageSize),@"pageSize",
                            nil];
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}

//积分商品列表
+ (void)reqUserGiftList:(FinishBlock)block {
    NSString *url = URL_UserGiftList;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            UD_UserId,@"userId",
                            nil];
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 积分兑换
 giftId : 商品ID
 giftNum : 兑换数量
 sourceId : APP来源(10=八元)
 device : 设备类型：0=PC，1=安卓，2=iOS，3=微信
 market : 市场代码 （iOS不传）
 versionNo : 版本号
 */
+ (void)reqUserGiftChange:(NSString *)giftId giftNum:(NSInteger)giftNum versionNo:(NSInteger)versionNo finish:(FinishBlock)block {
    
    NSString *url = URL_UserGiftChange;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            UD_UserId,@"userId",
                            giftId,@"giftId",
                            @(giftNum),@"giftNum",
                            @(kAPPType),@"sourceId",
                            @(kDeviceType),@"device",
                            @(versionNo),@"versionNo",
                            nil];
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}


/** 积分兑换历史
 yearMonth :月份(yyyy-MM)
 */
+ (void)reqUserGiftChangeList:(NSInteger)pageNo pageSize:(NSInteger)pageSize yearMonth:(NSString *)yearMonth finish:(FinishBlock)block {
    
    NSString *url = URL_UserGiftChangeList;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            UD_UserId,@"userId",
                            yearMonth,@"yearMonth",
                            @(pageNo),@"page",
                            @(pageSize),@"pageSize",
                            nil];
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}
//特权卡详情
+ (void)reqUserGiftDetails:(NSString *)giftId finish:(FinishBlock)block{
    NSString *url = URL_UserGiftDetails;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            UD_UserId,@"userId",
                            giftId,@"giftId",
                            nil];
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}
+ (void)reqUserGiftHistoryDetails:(NSString *)historyRecId finish:(FinishBlock)block{
    NSString *url = URL_UserGiftHistoryDetails;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            historyRecId,@"historyRecId",
                            nil];
    [LTRequest baseAuthGet:url parameters:params finish:^(LTResponse *res) {
        block(res);
    }];
}


#pragma mark - 其他

/** 请求客服云信id接口 */
+ (void)reqServerInfo:(FinishBlock)block {
    NSString *url = URL_StaffAccid;
    NSString *userId = UD_UserId;
    NSString *UDID = [RequestCenter UDID_UMAN];
    NSString *idfa = [RequestCenter idfa];
    NSString *uid = UDID;
    if (![RequestCenter checkIdfa:UDID] || emptyStr(uid)) {
        uid = idfa;
        if (![RequestCenter checkIdfa:idfa] || emptyStr(uid)) {
            uid=@"";
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 uid,@"uid",nil];
    if (!emptyStr(userId)) {
        [dict setObject:userId forKey:@"userId"];
    }
    
    [LTRequest baseAuthGet:url parameters:dict finish:^(LTResponse *res) {
        block(res);
    }];
}

/** 请求聊天室id接口 */
+ (void)reqServerRoomInfo:(FinishBlock)block {
    NSString *url = URL_StaffRoomId;
    NSString *userId = UD_UserId;
    NSString *UDID = [RequestCenter UDID_UMAN];
    NSString *idfa = [RequestCenter idfa];
    NSString *uid = UDID;
    if (![RequestCenter checkIdfa:UDID] || emptyStr(uid)) {
        uid = idfa;
        if (![RequestCenter checkIdfa:idfa] || emptyStr(uid)) {
            uid=@"";
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 uid,@"uid",nil];
    if (!emptyStr(userId)) {
        [dict setObject:userId forKey:@"userId"];
    }
    
    [LTRequest baseAuthGet:url parameters:dict finish:^(LTResponse *res) {
        block(res);
    }];
}
//检查是否有效
+ (BOOL)checkIdfa:(NSString *)idfa {
    BOOL bl = [idfa contains:@"00000000-0000-0000-0000-000000000000"];
    return !bl;
}

// 获取广告标识符
+ (NSString*)idfa {
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSLog(@"adid:%@",adId);
    return adId;
}

//UDID_UMAN
+ (NSString*)UDID_UMAN {
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
        NSLog(@"deviceID == %@",deviceID);
    }
    return deviceID;
}

@end
