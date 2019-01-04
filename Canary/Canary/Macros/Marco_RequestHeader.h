//
//  Marco_RequestHeader.h
//  ixit
//
//  Created by litong on 16/9/7.
//  Copyright © 2016年 ixit. All rights reserved.
//

#ifndef RequestHeader_h
#define RequestHeader_h


////事件类型枚举
typedef enum : NSInteger
{
    ActionType_Hide=0,//隐藏
    ActionType_PushMarket,//跳转行情
    ActionType_PushWeb,//跳转网页
    ActionType_PushPosition,//跳转持仓
}ActionType;

//交易所类型枚举
typedef NS_ENUM(NSUInteger, ExchangeType) {
    Exchange_Normal = 0,
};





#pragma mark - 静态页面
//新的
//注册页面 - 用户协议
#define URL_UserAgreement        Static_DOMAIN@"product/agreement_user.html"
//实名认证 - 开户协议书
#define URL_RealNameAgreement        Static_DOMAIN@"product/agreement_openacc.html"
/** 一分钟了解 & 新手学堂 */
#define URL_Home_NewComer     Static_DOMAIN@"static/product/xsxt/"
//交易规则
#define URL_DealRule        URL_Home_NewComer
//关于我们
#define URL_AboutUS Static_DOMAIN@"product/about_us.html"




//老的
/** 我的 - 积分商城规则  */
#define URL_UserPointRule   Static_DOMAIN@"static/product/jifen/"
/** 统一密码各项条款 */
#define URL_UnifyPwdClause     Static_DOMAIN@"static/protocol/tymm_mz_protocol.html"
/** 哈贵交易规则 - 交易大厅左按钮 */
#define URL_HG_Rule     Static_DOMAIN@"static/rules/rules-hg.html"
/** 广交易规则 - 交易大厅左按钮 */
#define URL_GG_Rule     Static_DOMAIN@"static/rules/rules-gg.html"
/** 吉农交易规则 - 交易大厅左按钮 */
#define URL_JG_Rule     Static_DOMAIN@"static/know_weipan/jn.html"
#define URL_HN_Rule     Static_DOMAIN@"static/rules/rules-hn.html"
/** 直播时间表  */
#define URL_LiveDispatch     Static_DOMAIN@"static/live/dispatch.html"
/** 已休市 - 了解更多  */
#define URL_DealStopInfo     Static_DOMAIN@"static/rules/jywt/"
/** 优惠券 - 优惠券规则  */
#define URL_Quan_Rule     Static_DOMAIN@"static/product/xsxt/djq.html"
//一分钟了解八元操盘
#define URL_QuicklyKnow_BYCP    Static_DOMAIN@"weipan"
//一分钟了解微盘
#define URL_QuicklyKnow_WP       Static_DOMAIN@"static/know_weipan/"
//常见问题
#define URL_CommonQA    Static_DOMAIN@"static/faq/"
// 功能介绍
#define URL_FunctionIntro   @"http://mobile.viptzl.com/product/"
//推送提醒功能说明
#define URL_PushRemindInfo     @"http://static.8caopan.com/product/quotationReminder/"








#pragma mark - 启动配置合并

#define URL_Startup     MOBILE_DOMAIN@"news/api/startup/init/v3"
#define URL_CheckUpdate     MOBILE_DOMAIN@"news/app/version/check/ios"

#pragma mark - FXBTG
#pragma mark - FXBTG 交易相关列表
/** 历史持仓列表 */
#define URL_FXBTDealHistoryList     MOBILE_DOMAIN_FXBTG @"exchange/trade/history/list"
/** 产品列表 */
#define URL_FXBTGProductList   MOBILE_DOMAIN_FXBTG@"exchange/trade/product/list"
/** 单个产品详情 */
#define URL_FXBTGProductDetail   MOBILE_DOMAIN_FXBTG@"exchange/trade/product/get"

/** 平仓 */
#define URL_FXBTGClosePosition    MOBILE_DOMAIN_FXBTG @"exchange/trade/order/close"
/** 创建订单 */
#define URL_FXBTGOrderCreate    MOBILE_DOMAIN_FXBTG@"exchange/trade/order/create"
/** 修改订单*/
#define URL_FXBTGOrderSet   MOBILE_DOMAIN_FXBTG@"exchange/trade/order/update"
/**品种购买比率 */
#define URL_FXBTGBuyRate  MOBILE_DOMAIN_FXBTG @"exchange/trade/buyRate"
/** 持仓列表 */
#define URL_FXBTGHoldList  MOBILE_DOMAIN_FXBTG @"exchange/trade/holdPosition/list"

#pragma mark - FXBTG 用户类
// 发送注册验证码
#define URL_LocRegisterSMS    MOBILE_DOMAIN@"user/info/register/send/sms"
// 新注册
#define URL_LocRegister     MOBILE_DOMAIN @"user/info/register"
// 新登录
#define URL_LocLogin    MOBILE_DOMAIN @"login"
//修改昵称
#define URL_UpdateUserName MOBILE_DOMAIN @"user/info/update/nickName"
//修改头像
#define URL_UpdateHeadImage MOBILE_DOMAIN @"user/info/update/avatar"
// 找回密码发送验证码 SMSType_ForgetLocPWD
#define URL_ForgetLocPwdSMS     MOBILE_DOMAIN@"/sendvcode"
//找回密码
#define URL_LocForgetPWD    MOBILE_DOMAIN @"user/info/retrieve/password"

#pragma mark - FXBTG 充值取现
/** 提现申请 */
#define URL_FXBTGCashOut     MOBILE_DOMAIN_FXBTG@"exchange/cashOut/insert"
/** 充值 */
#define URL_FXBTGRecharge     MOBILE_DOMAIN_FXBTG@"exchange/recharge/url"
/** 充值记录列表*/
#define URL_FXBTGRechargeList     MOBILE_DOMAIN_FXBTG@"exchange/recharge/list"
/** 提现记录列表 */
#define URL_FXBTGCashOutList     MOBILE_DOMAIN_FXBTG@"exchange/cashOut/list"

#pragma mark - FXBTG 直播室
//用户关注分析师列表
#define URL_FocusList      MOBILE_DOMAIN @"news/api/live/reminder/author/list"
//老师统计
#define URL_LiveAuthorInfo            MOBILE_DOMAIN@"news/api/live/author/info"
//首页&直播室banner
#define URL_BannerList  MOBILE_DOMAIN@"news/api/appcontent/activity/list"
//关注分析师取消
#define URL_AttentionAnalystCanale    MOBILE_DOMAIN@"news/api/live/reminder/author/cancel"
//直播室添加观看记录
#define URL_LiveWatchUserAdd            MOBILE_DOMAIN@"news/api/live/watch/user/add"
//聊天室禁用
#define URL_LiveDisable   MOBILE_DOMAIN@"news/api/netease/user/disable"
//聊天室关键词列表
#define URL_LiveKeyWordList   MOBILE_DOMAIN@"news/api/netease/user/keyword/list"
//聊天室是否允许发图接口
#define URL_LiveSendPicStatus   MOBILE_DOMAIN@"news/api/message/sendPicStatus"
// 直播列表V4
#define URL_LiveList            MOBILE_DOMAIN @"news/api/v4/liveVideo/list"

#pragma mark - FXBTG 行情定制
//推送提醒-增加
#define URL_PushRemindAdd MOBILE_DOMAIN @"news/api/quotes/reminder/add"
//推送提醒-修改
#define URL_PushRemindUpdate MOBILE_DOMAIN @"news/api/quotes/reminder/update"
//推送提醒-删除
#define URL_PushRemindDelete MOBILE_DOMAIN @"news/api/quotes/reminder/delete"
//推送提醒配置
#define URL_PushRemindConfig MOBILE_DOMAIN @"news/api/quotes/reminder/product/setting"
//推送提醒-查询
#define URL_PushRemindList MOBILE_DOMAIN @"news/api/quotes/reminder/list"

#pragma mark - FXBTG 新资讯
//检查用户资讯支持操作
#define URL_HomeNewsCheck   MOBILE_DOMAIN@"news/api/transaction/check"
//资讯列表
#define URL_HomeNewsList   MOBILE_DOMAIN@"news/api/transaction/opportunity/list"
//交易动态
#define URL_HomeNewest   MOBILE_DOMAIN@"news/api/transaction/newest"
//资讯支持利多利空操作
#define URL_HomeNewsOperation   MOBILE_DOMAIN@"news/api/transaction/operation/insert"

#pragma mark - FXBTG 交易所用户相关接口
/** 登录 */
#define URL_FXBTGLogin     MOBILE_DOMAIN_FXBTG@"exchange/user/login"
/** 账户信息,包含帐号余额，红包余额，红包有效期 */
#define URL_FXBTGAccountInfo     MOBILE_DOMAIN_FXBTG@"exchange/user/account/info"
/** 身份证正面识别*/
#define URL_FXBTGCardFrontDist     MOBILE_DOMAIN_FXBTG@"exchange/user/idCard/frontDist"
/** 身份证反面识别 */
#define URL_FXBTGCardBackDist     MOBILE_DOMAIN_FXBTG@"exchange/user/idCard/backDist"
/** 提交实名认证 */
#define URL_FXBTGAuthSubmit     MOBILE_DOMAIN_FXBTG@"exchange/user/auth/submit"
/** 实名认证状态 */
#define URL_FXBTGAuthStatus     MOBILE_DOMAIN_FXBTG@"exchange/user/auth/status"
/** 绑定银行卡 */
#define URL_FXBTGBindCard     MOBILE_DOMAIN_FXBTG@"exchange/user/bind/card"

/** 用户银行卡列表 */
#define URL_FXBTGBindList     MOBILE_DOMAIN_FXBTG@"exchange/user/bank/list"

#pragma mark - FXBTG 省份、城市、银行、支行
/** 省份列表 */
#define URL_FXBTGProvinceList     MOBILE_DOMAIN_FXBTG@"dict/province/list"
/** 城市列表 */
#define URL_FXBTGCityList     MOBILE_DOMAIN_FXBTG@"dict/city/list"
/** 银行列表 */
#define URL_FXBTGBankList     MOBILE_DOMAIN_FXBTG@"dict/bank/list"
/** 支行列表 */
#define URL_FXBTGBranchBankList     MOBILE_DOMAIN_FXBTG@"dict/branchBank/list"



#pragma mark - other old method

/** 1检查是否注册 */
#define URL_GGCheckIsRegister   MOBILE_DOMAIN@"gg/user/v3/check/exchange"
#define URL_HGCheckIsRegister   MOBILE_DOMAIN_FXBTG@"hg/user/v3/check/exchange"
#define URL_JGCheckIsRegister    MOBILE_DOMAIN_FXBTG@"exchange/user/register/check"
#define URL_HNCheckIsRegister   MOBILE_DOMAIN_FXBTG@"exchange/user/register/check"

/** 2注册 */
#define URL_GGRegister     MOBILE_DOMAIN@"gg/user/v3/register"
#define URL_HGRegister     MOBILE_DOMAIN_FXBTG@"hg/user/v3/register"
#define URL_JGRegister     MOBILE_DOMAIN_FXBTG@"exchange/user/register"
#define URL_HNRegister     MOBILE_DOMAIN_FXBTG@"exchange/user/register"


/** 4找回密码发送短信 */
#define URL_GGResetPwdSMS     MOBILE_DOMAIN@"gg/user/v3/resetPwd/sms"
#define URL_HGResetPwdSMS     MOBILE_DOMAIN_FXBTG@"hg/user/v3/resetPwd/sms"
#define URL_JGResetPwdSMS     MOBILE_DOMAIN_FXBTG@"exchange/user/resetPwd/sms"
#define URL_HNResetPwdSMS     MOBILE_DOMAIN_FXBTG@"exchange/user/resetPwd/sms"

/** 5重置密码 */
#define URL_GGResetPwd     MOBILE_DOMAIN@"gg/user/v3/resetPwd"
#define URL_HGResetPwd     MOBILE_DOMAIN_FXBTG@"hg/user/v3/resetPwd"
#define URL_JGResetPwd     MOBILE_DOMAIN_FXBTG@"exchange/user/resetPwd"
#define URL_HNResetPwd     MOBILE_DOMAIN_FXBTG@"exchange/user/resetPwd"

/** 12银行卡列表 */

#define URL_GGBindList    MOBILE_DOMAIN@"gg/user/v3/bank/name/list"
#define URL_HGBindList     MOBILE_DOMAIN_FXBTG@"hg/user/v3/bank/name/list"
#define URL_HNBindList     MOBILE_DOMAIN_FXBTG@"exchange/cashOut/bank/list"

/** 9获取用户银行卡列表 */
#define URL_GGUserBindList    MOBILE_DOMAIN@"gg/user/v3/bank/list"
#define URL_HGUserBindList   MOBILE_DOMAIN_FXBTG@"hg/user/v3/bank/list"
#define URL_JGUserBindList     MOBILE_DOMAIN_FXBTG@"exchange/user/bankList"
#define URL_HNUserBindList     MOBILE_DOMAIN_FXBTG@"exchange/user/bankList"

/**  提现手续费 */
#define URL_JGCashOutFee     MOBILE_DOMAIN_FXBTG@"exchange/cashOut/fee"
#define URL_HNCashOutFee     MOBILE_DOMAIN_FXBTG@"exchange/cashOut/fee"

#define Home_NewsDetailAD   MOBILE_DOMAIN@"news/app/important/detail/ad"
#define Home_GainList   MOBILE_DOMAIN@"news/api/billboard/show/order/list"
#define Home_GainDetailList   MOBILE_DOMAIN@"news/board/profit/rate/order"
#define Home_ShowGain   MOBILE_DOMAIN@"news/api/billboard/me/rank"
#define Home_MyGain   MOBILE_DOMAIN@"news/api/billboard/profit/order/list"

//直播室礼物列表接口
#define URL_LiveGifts            MOBILE_DOMAIN@"user/gift/liveGift/list"
//直播室送礼物
#define URL_LiveGiftExchange MOBILE_DOMAIN@"user/gift/liveGift/exchange"

//关注分析师列表
#define URL_AttentionAnalystList    MOBILE_DOMAIN@"news/api/live/reminder/author/list"
//关注分析师
#define URL_AttentionAnalyst    MOBILE_DOMAIN@"news/api/live/reminder/author/addorupdate"
// 叫单
#define URL_OutcryList        MOBILE_DOMAIN@"news/api/qutcry/v3/list"
//获取聊天室id
#define URL_ChatRoomId     MOBILE_DOMAIN@"thirdParty/netEase/get/roomId"








// 重置登录密码验证码 SMSType_ResetLocPWD
#define SMS_ResetLocPWD  MOBILE_DOMAIN_FXBTG@"user/info/initPassport/send/sms"

//交易所列表
#define URL_ExchangeList      MOBILE_DOMAIN@"app/exchange/list"

#pragma mark  3合1
/** 用户交易所注册、绑定情况 */
#define URL_EXCheckIsBind   MOBILE_DOMAIN@"app/user/account/exchange/list"
/** 批量检查交易所密码是否正确 */
#define URL_EXCheckAllPwd   MOBILE_DOMAIN@"app/user/account/check/exchange/password/batch"
/** 设置统一交易密码 */
#define URL_SetEXUnifyPwd   MOBILE_DOMAIN@"app/user/account/unify/pwd/set"
/** 统一交易密码登录 */
#define URL_EXUnifyLogin   MOBILE_DOMAIN@"app/user/account/unify/login"
/** 修改统一密码短信 */
#define URL_EXUnifyPwdSMS   MOBILE_DOMAIN@"app/user/account/unify/resetPwd/sms"
/** 重置统一交易密码 */
#define URL_EXUnifyResetPwd   MOBILE_DOMAIN@"app/user/account/unify/resetPwd"
/** 交易所信息列表 */
#define ExchangesList    MOBILE_DOMAIN@"news/api/fxbtg/quotation/exchange/list"

/** 22充值金额列表*/
#define URL_RechargeAmountList   MOBILE_DOMAIN@"app/exchange/recharge/type/list/v3"
#define RechargeAmountListVersion_GG   5
#define RechargeAmountListVersion_HG   5
#define RechargeAmountListVersion_JG   5
#define RechargeAmountListVersion_HN   5

/** 23点芯支付 */
#define URL_JGRechargeDotPay     MOBILE_DOMAIN_FXBTG@"exchange/recharge/dotPay/pay"
#define URL_HNRechargeDotPay     MOBILE_DOMAIN_FXBTG@"exchange/recharge/dotPay/pay"


/** 24点芯支付 支付结果验证 */
#define URL_JGRechargeDotPayVerify     MOBILE_DOMAIN_FXBTG@"exchange/recharge/dotPay/verify"
#define URL_HNRechargeDotPayVerify     MOBILE_DOMAIN_FXBTG@"exchange/recharge/dotPay/verify"


/** 28 订单过夜费*/
#define URL_JGDeferredList     MOBILE_DOMAIN_FXBTG@"exchange/trade/deferred/list"
#define URL_HNDeferredList     MOBILE_DOMAIN_FXBTG@"exchange/trade/deferred/list"



/** 31  银联充值 */
#define URL_GGRecharge     MOBILE_DOMAIN @"gg/user/v3/recharge/cash"
#define URL_HGRecharge     MOBILE_DOMAIN_FXBTG@"hg/user/v3/recharge/cash"
#define URL_JGRecharge      MOBILE_DOMAIN_FXBTG@"exchange/recharge/nowUnion/pay"
#define URL_HNRecharge      MOBILE_DOMAIN_FXBTG@"exchange/recharge/nowUnion/pay"


#define RechargeWX_HG       MOBILE_DOMAIN_FXBTG @"hg/user/v3/wxp/type"
/**  哈贵微信支付结果验证 */
#define URL_RechargeWXPayVerify  MOBILE_DOMAIN_FXBTG @"hg/user/v3/wx/checkResult"

/**  哈贵支付宝支付 */
#define URL_RechargeAlipay_HG     MOBILE_DOMAIN_FXBTG @"hg/user/v4/recharge/alipay"


#pragma mark - 微信支付

/**  哈贵民生微信支付 */
#define URL_MinshengWXPay_HG  MOBILE_DOMAIN_FXBTG @"hg/user/v4/wechatPay/minsheng"

#pragma mark 京东支付

#pragma mark 广贵
//京东快捷支付
#define URL_JDRecharge_GG     MOBILE_DOMAIN@"gg/user/v3/jdPay"
//京东快捷支付-是否绑定
#define URL_JDRechargeCheckBind_GG     MOBILE_DOMAIN@"gg/user/v3/jdPay/check/bind"
//京东快捷支付-银行列表
#define URL_JDRechargeBankList_GG     MOBILE_DOMAIN@"gg/user/v3/jdPay/bankName/list"
//京东快捷支付-绑定签约银行卡
#define URL_JDRechargeBindBankCard_GG     MOBILE_DOMAIN@"gg/user/v3/jdPay/sign"

#pragma mark 哈贵
//京东快捷支付
#define URL_JDRecharge_HG     MOBILE_DOMAIN_FXBTG@"hg/user/v4/jdPay"
//京东快捷支付-是否绑定
#define URL_JDRechargeCheckBind_HG     MOBILE_DOMAIN_FXBTG@"hg/user/v4/jdPay/check/bind"
//京东快捷支付-银行列表
#define URL_JDRechargeBankList_HG     MOBILE_DOMAIN_FXBTG@"hg/user/v4/jdPay/bankName/list"
//京东快捷支付-绑定签约银行卡
#define URL_JDRechargeBindBankCard_HG     MOBILE_DOMAIN_FXBTG@"hg/user/v4/jdPay/sign"

#pragma mark 吉农
//京东快捷支付
#define URL_JDRecharge_JG     MOBILE_DOMAIN_FXBTG@"exchange/recharge/jdPay"
#define URL_JDRecharge_HN     MOBILE_DOMAIN_FXBTG@"exchange/recharge/jdPay"

//京东快捷支付-是否绑定
#define URL_JDRechargeCheckBind_JG     MOBILE_DOMAIN_FXBTG@"exchange/recharge/jdPay/check/bind"
#define URL_JDRechargeCheckBind_HN     MOBILE_DOMAIN_FXBTG@"exchange/recharge/jdPay/check/bind"

//京东快捷支付-银行列表
#define URL_JDRechargeBankList_JG     MOBILE_DOMAIN_FXBTG@"exchange/recharge/jdPay/bankName/list"
#define URL_JDRechargeBankList_HN     MOBILE_DOMAIN_FXBTG@"exchange/recharge/jdPay/bankName/list"
//京东快捷支付-绑定签约银行卡
#define URL_JDRechargeBindBankCard_JG     MOBILE_DOMAIN_FXBTG@"exchange/recharge/jdPay/sign"
#define URL_JDRechargeBindBankCard_HN     MOBILE_DOMAIN_FXBTG@"exchange/recharge/jdPay/sign"
//支付宝扫码支付
#define URL_RechargeAlipayScan_JG     MOBILE_DOMAIN_FXBTG@"exchange/recharge/alipay/scan"
#define URL_RechargeAlipayScan_HN     MOBILE_DOMAIN_FXBTG@"exchange/recharge/alipay/scan"





#pragma mark - 其他

//首页盈利率排行榜
#define RateListURL MOBILE_DOMAIN @"news/board/profit/rate/list"
//盈利率订单查询v2
#define RateOrderURL MOBILE_DOMAIN @"news/board/profit/rate/order"

//首页banner
#define URL_BannerList0   MOBILE_DOMAIN @"news/activity/list?sourceId=%d"



// 获取重要消息V2
#define STRATEGY_LIST MOBILE_DOMAIN @"news/portal/important/list"
#define STRATEGY_LIST_DETAIL MOBILE_DOMAIN @"news/portal/important/%@"

#define FINANCE_PREDICTION_LIST MOBILE_DOMAIN @"news/predict/list?date=%@"

// V2 category 详情
#define URL_CategoryDetail  MOBILE_DOMAIN@"news/category/"
#define URL_SessionID       MOBILE_DOMAIN@"user/micro/generate/session/%@"


#pragma mark - 广贵&哈贵

//代金劵列表
#define URL_GGCouponList    MOBILE_DOMAIN_FXBTG@"gg/user/v3/voucher/list"
#define URL_HGCouponList    MOBILE_DOMAIN_FXBTG@"hg/user/v3/voucher/list"
#define URL_JGCouponList     MOBILE_DOMAIN_FXBTG@"exchange/trade/voucher/list"
#define URL_HNCouponList     MOBILE_DOMAIN_FXBTG@"exchange/trade/voucher/list"

//收支列表
#define BalanceList_HG  MOBILE_DOMAIN_FXBTG @"hg/user/v3/balance/list"
#define BalanceList_GG  MOBILE_DOMAIN_FXBTG@"gg/user/v3/balance/list"


// 产品列表 V3
#define kProductListDomian_GG @"gg/exchange/v3/product/list"
#define kProductListDomian_HG @"hg/exchange/v3/product/list"



#pragma mark - 新首页



#pragma mark - 行情

//行情详情
#define URL_QuotationDetail MOBILE_DOMAIN @"app/fxbtg/quotation/realTime"
#define URL_QuotationDetailV2 Market_DOMAIN @"wp/quotation/v2/realTime"

//分时线
#define URL_TickChart       Market_DOMAIN @"app/fxbtg/quotation/tickChart?&qid="
//分时线V2
#define URL_MinuteChart      Market_DOMAIN @"wp/quotation/v3/tickChart"
#define URL_DayChart        Market_DOMAIN @"wp/quotation/v2/kChart"
//交易所行情列表
#define URL_QuotationList Market_DOMAIN @"news/api/fxbtg/quotation/fexchange/list"


#pragma mark - 视频直播


//聊天室id
#define URL_StaffRoomId   MOBILE_DOMAIN@"app/user/netease/user/get/roomId"
//客服云信id
#define URL_StaffAccid   MOBILE_DOMAIN@"news/api/helpline/clickV2"

//聊天室注册昵称
#define URL_RegistChatroomNickName MOBILE_DOMAIN@"app/user/netease/user/update/name"


#pragma mark - 积分

//查看当前积分和等级
#define URL_UserPoint     MOBILE_DOMAIN @"user/point/select"
//查看积分明细
#define URL_UserPointRecList     MOBILE_DOMAIN @"user/point/rec/list"
//积分商品列表
#define URL_UserGiftList     MOBILE_DOMAIN @"user/gift/list"

//积分兑换
#define URL_UserGiftChange     MOBILE_DOMAIN @"user/gift/exchange"
//积分兑换历史
#define URL_UserGiftChangeList     MOBILE_DOMAIN @"user/gift/exchange/list"
//特权卡详情
#define URL_UserGiftDetails     MOBILE_DOMAIN @"user/gift/detail"
//特权卡历史
#define URL_UserGiftHistoryDetails MOBILE_DOMAIN@"user/gift/history/detail"




#pragma mark 邀请好友赚积分


//获取红包数量接口
#define URL_UPIVoucherNum     MOBILE_DOMAIN @"user/point/invite/getVoucherNum"
//获取活动入口信息
#define URL_UPIActivityInfo     MOBILE_DOMAIN @"user/point/invite/getActivityInfo"
//分享页面数据接口
#define URL_UPIShareVoucher     MOBILE_DOMAIN @"user/point/invite/select/jsonp"
//分享领取红包接口
#define URL_UPIGetVoucher     MOBILE_DOMAIN @"user/point/invite/get/jsonp"
//分享领取红包发送验证码接口
#define URL_UPISendSms     MOBILE_DOMAIN @"user/point/invite/sendSms/jsonp"


#pragma mark - 任务中心

/** 任务列表 */
#define URL_TaskList     MOBILE_DOMAIN@"user/task/select"
/** 题目列表 */
#define URL_TaskQuestionList     MOBILE_DOMAIN@"user/task/question/list"
/** 完成答题提交接口*/
#define URL_TaskQuestionsave     MOBILE_DOMAIN@"user/task/question/save"

#pragma mark - 消息中心

/** 消息列表 */
#define URL_MsgList     MOBILE_DOMAIN@"news/api/user/message/list"
/** 未读消息总条数 */
#define URL_MsgUnreadCount     MOBILE_DOMAIN@"news/api/user/message/unread/count"
/** 消息已读*/
#define URL_MsgRead     MOBILE_DOMAIN@"news/api/user/message/read"
/** 消息全部已读*/
#define URL_MsgReadAll     MOBILE_DOMAIN@"news/api/user/message/all/read"


#pragma mark - 用户

//检测是否初始化密码
#define URL_LocCheckInitPWD     MOBILE_DOMAIN @"user/info/check/mobile"
// 初始化密码
#define URL_LocInitPWD      MOBILE_DOMAIN @"user/info/initPassport"
//用户通知
#define URL_NotifyList             MOBILE_DOMAIN @"user/micro/notify/list"
#define URL_NotifyLastList      MOBILE_DOMAIN @"user/micro/notify/lastList"

#pragma mark - 公用

//APP启动闪屏
#define URL_StartImages     MOBILE_DOMAIN@"news/enable/startup/image/ios"
// 收集idfa
#define URL_IDFA        MOBILE_DOMAIN@"user/info/device/startup/code"
// 收集个推启动设备用户信息
#define URL_GTInfo       MOBILE_DOMAIN@"app/getui/user/version/information"

//启动配置信息
#define URL_StartConfig   MOBILE_DOMAIN@"news/app/startup/v3/config"
//版本隐藏
#define URL_iOSHide  MOBILE_DOMAIN@"news/api/appContent/enable/ios/newVersion/"
// 省份列表
#define URL_ProvinceList    MOBILE_DOMAIN@"dict/province/list"
// 城市列表
#define URL_CityList            MOBILE_DOMAIN@"dict/city/list"



//获取分享URL
#define ShareURL MOBILE_DOMAIN @"user/activity/get/share/url"
//分享成功 V2 送哈贵卷
#define ShareURLSuccess MOBILE_DOMAIN @"user/activity/hg/share/success"
//晒单分享活动
#define ShareActivityURL MOBILE_DOMAIN @"user/activity/order/share/show"
//晒单分享V2
#define ShareActivitySuccessV2 MOBILE_DOMAIN@"user/activity/order/share/show/success"
// 推送资讯接口
#define URL_PushNewsDetail(id) [NSString stringWithFormat:@"http://mobile.viptzl.com/news/%@", id]

#pragma mark - 常量URL地址
#pragma mark -
// 新闻详情
#define URL_NewsDetail(code) [NSString stringWithFormat:@"%@news/%@/", MOBILE_DOMAIN, code]

//接口地址
#define kURL(...) [@"http://" stringByAppendingString:__VA_ARGS__]
// 名家专栏
#define URL_ProfessionalDetail(id) kURL([NSString stringWithFormat:@"/news/professional/%@", id])

// 品种列表
#define kAPI_Varieties_List @"http://htmmarket.fx678.com/list.php?excode="
// 品种的数据查询
#define kAPI_Varieties_custom @"http://htmmarket.fx678.com/custom.php?excode="
// 分时图
#define kAPI_Varieties_time @"http://htmmarket.fx678.com/time.php?excode="
// k线图
#define kAPI_Varieties_kline @"http://htmmarket.fx678.com/kline.php?excode="



#endif /* RequestHeader_h */




