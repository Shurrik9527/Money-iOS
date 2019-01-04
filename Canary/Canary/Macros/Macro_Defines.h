//
//  Macro_String.h
//  ixit
//
//  Created by litong on 16/9/18.
//  Copyright © 2016年 ixit. All rights reserved.
//

#ifndef FMStock_Defines_h
#define FMStock_Defines_h

#pragma mark -
#pragma mark - 发布相关 -
/**
 ************** 正式发布 以下都修改为1 **************
 **/

/* 是否正式发布  1:正式版本   0:测试版本 */
#define IXIT_RELEASE                      1

/* IP地址  1:正式地址   0:测试地址 */
#define IXIT_CONN_RELEASE            1

/* 渠道    1:AppStore 0:OtherStore */
#define  Channel_IsAppStore              1

/**
 *************************************************
 **/

#define isTest    0


#if IXIT_CONN_RELEASE

        #define MOBILE_DOMAIN            @"http://47.91.164.170/"
        #define MOBILE_DOMAIN_FXBTG     MOBILE_DOMAIN @"app/fxbtg/"
        #define Market_DOMAIN               @"https://q.8caopan.com/"
        #define Static_DOMAIN                 @"https://fxbtg-static.18panda.com/"

#else

    #define MOBILE_DOMAIN            @"https://test-fxbtg.8caopan.com/"
    #define MOBILE_DOMAIN_FXBTG     MOBILE_DOMAIN @"app/fxbtg/"
    #define Market_DOMAIN               @"https://q.8caopan.com/"
    #define Static_DOMAIN                 @"https://fxbtg-static.18panda.com/"

#endif



#if IXIT_RELEASE

        #define IMAppKey        @"d1541c2a06b1f01232261b9b3bbe82c2"
        #define IMCerName      @"disiospush"

        //个推推送
        #define kGtAppId @"rw3iCkl0Fl8dYwRfFXwE06"
        #define kGtAppKey @"eRyJVYzf6tABXelp3iiqyA"
        #define kGtAppSecret @"a1IUMF0OlDALRUh16WcgxA"
        //视频第3期
        #define useThreeLive         0
        //使用浮动视频窗口
        #define useFloatingLive       1
        //使用推送提醒
        #define usePushRemind      1
        //测试数据  发布的时候  1
        #define removeTestData        1
        //是否跳转非测试环境聊天室
        #define NoTestLive  1
        #define TestLiveRoomId @"4562098"

#else

        #define IMAppKey         @"29dac8fefad692e96ce15b29432f11c9"
        #define IMCerName       @"deviospush"

        //个推推送
        #define kGtAppId @"zRua6OtyBHA9USHK3QIyI"
        #define kGtAppKey @"Oo1KtouS9o96H1NzmQZqm1"
        #define kGtAppSecret @"858jHO1Mwa5YbJVZ2zU3R"

        //视频第3期
        #define useThreeLive         0
        //使用浮动视频窗口
        #define useFloatingLive       1
        //使用推送提醒
        #define usePushRemind      1
        //测试数据  发布的时候  1
        #define removeTestData        1
        //是否跳转非测试环境聊天室
        #define NoTestLive  1
        #define TestLiveRoomId @"8201166"
#endif
//去掉聊天室发布图片
#define removeMoreBtn       0

#if Channel_IsAppStore
    #define IXIT_Channel_Name            @"AppStore"
    #define IXIT_MARKET_CODE             @"10"
#else
    #define IXIT_Channel_Name            @"OtherStore"
    #define IXIT_MARKET_CODE             @"20"
#endif






#pragma mark -  可能修改的常量
#pragma mark -
#define kAppMarket @"AppStore"
#define kAPPType                    10  //sourceId
#define kDeviceType                2  //deviceType
//#define kRefreshTime                1      //轮询刷新时间 单位秒
#define kStartPageNum             1
#define kPageSize                     10

#define kLeftMar    16.f    //左边距
#define kMidW   (ScreenW_Lit - 2*kLeftMar)

#pragma mark - Key & ID
#pragma mark -

#define APPCONFIG_APPID     @"1097388746"


// 友盟统计
#define kUmeng_appkey   @"593f8239f5ade47c4b000ebf"

//友盟分享
#define UMeng_wechatAppID @"wx44778e56d2b57080"
#define UMeng_wechatAppSecret @"505085f5c970dc36bab046e5377f6295"
//QQ
#define QQAppId @"1105166863"
#define QQAppKey @"rnyn39UPnHfSARwx"

//个推ID
#define GTClientIdKey @"GTClientIdKey"

//#define QQ_SERVICE_NUMBER_KEY @"qqServiceNumber"    //客服QQ 的key
//#define GO_QQ_URL @"mqqwpa://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web&web_src=b.qq.com"

//#define kCompany_Tel    \
//(kAPPType == 9  ? @"4008-755-100" : \
//kAPPType == 10 ? @"4008-622-103" : \
//kAPPType == 11 ? @"4008-755-100" : \
//kAPPType == 12 ? @"4008-755-100" : @"")

// 应用内打开协议名 用于推送处理
//#define kUrlActionType (kAPPType == 4 ? @"touzile" : @"")
#define kUrlActionType  @"touzile"



//---------------------------------------------------------------------------------------------------------------------
#pragma mark - NIM
#define NTES_USE_CLEAR_BAR - (BOOL)useClearBar{return YES;}

#define NTES_FORBID_INTERACTIVE_POP - (BOOL)forbidInteractivePop{return YES;}

#endif
