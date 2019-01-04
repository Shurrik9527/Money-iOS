//
//  UMeng_Marco.h
//  ixit
//
//  Created by litong on 16/9/13.
//  Copyright © 2016年 ixit. All rights reserved.
//

#ifndef UMeng_Marco_h
#define UMeng_Marco_h

#import <UMMobClick/MobClick.h>

/* -------- -------- -------- -------- --------       统计方法        -------- -------- -------- -------- --------  */

#define  UMengEvent(str)  [MobClick event:str]
#define  UMengEventWithParameter(str,key,value) [MobClick event:str attributes:@{key:value}]

/* -------- -------- -------- -------- --------       统计字段        -------- -------- -------- -------- --------  */

#define kline_cycle_horizontal  @"kline_cycle_horizontal" //3_0版本开始,横屏时，每个K线周期的点击次数

#define kline_cycle_vertical    @"kline_cycle_vertical" //3_0版本开始竖屏时，每个K线周期的点击

#define kline_type_vertical @"kline_type_vertical" //旧版本(v3之前)，每种指标的点击次数，不分横竖屏



#define findpwd_success @"findpwd_success" //找回密码成功统计(分渠道)

#define kline_type_horizontal   @"kline_type_horizontal" //横屏时，每种指标的点击次数


#define login_success   @"login_success" //登录成功事件统计(分渠道)

#define page_CreateByCash_setProfit @"page_CreateByCash_setProfit" //现金建仓页面设置止盈止损

#define page_CreateByQuan_setProfit @"page_CreateByQuan_setProfit" //使用代金券页面设置止盈止损

#define page_UserSetting    @"page_UserSetting" //用户中心

#define page_cashin @"page_cashin" //充值页面点击金额(仅点击)

#define page_chatRoom   @"page_chatRoom" //直播室按钮的点击

#define page_holdorder_setprofit    @"page_holdorder_setprofit" //持仓页面设置止盈止损

#define page_home   @"page_home" //首页的按钮事件

#define page_home_news_detail   @"page_home_news_detail" //首页重要消息的详情页

#define page_home_news_item_click   @"page_home_news_item_click" //首页重要消息每篇文章的点击

#define page_home_rank_item_click   @"page_home_rank_item_click" //首页排行榜每个item点击

#define page_index_live @"page_index_live" //首页直播页面的点击事件

#define page_main_tab   @"page_main_tab" //首页各tab页的点击数

#define page_market @"page_market" //行情的点击事件

#define page_market_product_click   @"page_market_product_click" //行情页每个品种的点击

#define page_market_tab_source  @"page_market_tab_source" //行情页每个交易所

#define page_me @"page_me" //我的页面事件统计

#define page_product_detail @"page_product_detail" //品种详情页面的事件统计

#define page_quickClose @"page_quickClose" //快速平仓dialog

#define page_quickCreate    @"page_quickCreate" //快速建仓dialog里面的点击

#define page_share  @"page_share" //分享有礼页面的点击事件

#define page_share_step1_share_success  @"page_share_step1_share_success" //分享有礼页面分享成功(第一步)

#define page_share_step2_getQuan_success    @"page_share_step2_getQuan_success" //分享有礼页面获得代金券
#define web_share_click  @"web_share_click" //webview页面分享按钮点击(第一步)
#define web_share_success  @"web_share_success" //webview页面分享成功(第二步)

#define page_trade  @"page_trade" //交易大厅的按钮事件

#define page_trade_createOrder  @"page_trade_createOrder" //建仓页面的点击事件

#define page_trade_createOrder_share    @"page_trade_createOrder_share" //建仓页面分享拿券的点击

#define page_trade_money    @"page_trade_money" //交易的资金页面的点击事件

#define page_trade_orderhold    @"page_trade_orderhold" //持仓页面按钮的点击

#define page_tradelist_buy_down @"page_tradelist_buy_down" //交易产品列表买跌的点击

#define page_tradelist_buy_down_v4  @"page_tradelist_buy_down_v4" //交易大厅买跌的点击，3_0_2统计错了，3_0_2之后的使用新的

#define page_tradelist_buy_up   @"page_tradelist_buy_up" //交易产品列表买涨的点击

#define page_tradelist_buy_up_v4    @"page_tradelist_buy_up_v4" //交易大厅买涨点击，3_0_2统计错了，3_0_2之后使用新的

#define page_tradelist_item     @"page_tradelist_item" //交易产品列表每个品种的点击

#define page_voucher    @"page_voucher" 
//代金券页面的按钮点击

#define register_success    @"register_success" 
//注册成功事件统计(分渠道)

#define v3_kline_type_horizontal    @"v3_kline_type_horizontal"
//3_0版本开始，横屏的时候，点击各种指标的统计

#define v3_kline_type_vertical  @"v3_kline_type_vertical" 
//3_0版本开始，竖屏的时候，点击各种指标的统计

#define v3_page_product_detail  @"v3_page_product_detail"
//3_0版本以后产品详情页的点击



#pragma mark - 行情

#pragma mark 行情详情

#define UM_MarketDetail_More  @"UM_MarketDetail_More" //更多（...）点击
#define UM_MD_More_Remind  @"UM_MD_More_Remind" //行情提醒
#define UM_MD_More_FullScreen  @"UM_MD_More_FullScreen" //全屏
#define UM_MD_More_AuxiliaryLine  @"UM_MD_More_AuxiliaryLine"//辅助线开启/关闭
#define UM_MD_More_FunctionDesc  @"UM_MD_More_FunctionDesc"//功能说明
#define UM_MarketDetail_Live  @"UM_MarketDetail_Live"//直播按钮
#define UM_MarketDetail_Buy  @"UM_MarketDetail_Buy"//买涨/买跌
#define UM_MarketDetail_Sell  @"UM_MarketDetail_Sell"//确认平仓
#define UM_MarketDetail_SuccessBuy  @"UM_MarketDetail_SuccessBuy"//K线图中实际建仓数量
#define UM_MarketDetail_SuccessSell  @"UM_MarketDetail_SuccessSell"//K线图中实际平仓数量
#define UM_MD_SetQuotationRemind  @"UM_MD_SetQuotationRemind" //行情提醒每日新建数量


#pragma mark - 我的

#define UM_My_IntegralMall  @"UM_My_IntegralMall" //积分商城

#define UM_My_IM_Rules  @"UM_My_IM_Rules" //积分商城_积分规则
#define UM_My_IM_Banner  @"UM_My_IM_Banner" //积分商城_Banner
#define UM_My_IM_CheckDetails  @"UM_My_IM_CheckDetails" //积分商城_查看明细
#define UM_My_IM_ExchangeHistory  @"UM_My_IM_ExchangeHistory" //积分商城_兑换历史
#define UM_My_IM_ExchangeQuan  @"UM_My_IM_ExchangeQuan" //积分商城_兑换券

#define UM_My_TaskCenter  @"UM_My_TaskCenter" //任务中心
#define UM_Home_TaskCenter_Tip_Cancle  @"UM_Home_TaskCenter_Tip_Cancle" //首页任务中心提示_我知道了
#define UM_Home_TaskCenter_Tip_Sure  @"UM_Home_TaskCenter_Tip_Sure" //首页任务中心提示_去任务中心
#define UM_My_TC_Banner  @"UM_My_TC_Banner" //任务中心_Banner
#define UM_My_TC_DoTask  @"UM_My_TC_DoTask" //任务中心_做任务

#define UM_My_OnlineServer  @"UM_My_OnlineServer" //在线客服
#define UM_My_Setting  @"UM_My_Setting" //设置



#endif /* UMeng_Marco_h */
