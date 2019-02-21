//
//  Macro_String.h
//  ixit
//
//  Created by litong on 16/9/18.
//  Copyright © 2016年 ixit. All rights reserved.
//

#ifndef Macro_String_h
#define Macro_String_h


#pragma mark - 遗留

#define MNID_KEY @"mnId"
#define HAS_WEIPAN_NOTIFY_KEY @"hasWeiPanNotify"

#pragma mark - 常用字符串

#define MarketExchangeListKey @"MarketExchangeListKey"

//聊天室公告
#define AnnouncementStr @"聊天室内禁止发QQ、微信、手机号等联系方式和广告，请大家一起维护聊天室的环境，感谢。"
//设置交易密码弹框提示语
#define kStr_SetPassTitle(Ex) [NSString stringWithFormat:@"请设置%@交易密码",Ex]
#define kStr_SetPassMsg @"注意：哈贵、广贵、吉农所账户独立，\n需单独设置交易密码。"
#define kStr_SetPassSureTitle @"设置"

//未注册交易所弹框提示
#define kStr_LoginTitle @"请设置交易密码"
#define kStr_LoginMsg @"为保障您的资金安全，\n输入交易密码后可查看交易信息"
#define kStr_LoginSureTitle @"输入密码"

//登录超时弹框
#define kStr_ReLoginTitle @"请输入交易密码"
#define kStr_AutoLogout    @"为保障您的资金安全，\n交易大厅6小时自动注销"
#define kStr_ReLoginSureTitle @"重新输入"

//多端登录超时弹框
#define kStr_OtherLoginTitle @"您的账号在别处登录"
#define kStr_OtherAutoLogout    @"如非本人操作，则密码可能已泄露，\n建议修改密码"
#define kStr_OtherLoginSureTitle @"重新登录"


#define kStr_NotBuy @"您当前没有购买产品\n快去交易吧!"

#define kStr_CanNotDeal @"由于政策原因\n该功能仅限中国大陆使用"

#define JudgeUserCanUseDeal  if (!UD_CanDeal) { [LTAlertView alertTitle:kStr_CanNotDeal]; return; }

#pragma mark 错误代码
#define kErrorCode_00013    @"00013"        //多端登录！
#define kErrorCode_00007    @"00007"        //访问TOKEN过期！
#define kErrorCode_30005    @"30005"       //token空
#define kEC_NetError    @"404"        //网络错误，没有网络

#pragma mark - 通知方法
//发送通知
#define   NFC_PostName(name) [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil]
//添加通知
#define   NFC_AddObserver(Name,Selct)  [[NSNotificationCenter defaultCenter] addObserver:self selector:Selct name:Name object:nil]
//移除通知
#define   NFC_RemoveObserver(Name)  [[NSNotificationCenter defaultCenter] removeObserver:self name:Name object:nil]
//移除所有通知
#define   NFC_RemoveAllObserver [[NSNotificationCenter defaultCenter] removeObserver:self]


#pragma mark - 通知名称

#define NFC_ReceiveGift        @"NFC_ReceiveGift"
#define NFC_ShowSendGift    @"NFC_ShowSendGift"
#define NFC_ShowLiveQuestionV    @"NFC_ShowLiveQuestionV"


#define NFC_FloatingPlayShow   @"NFC_FloatingPlayShow"
#define NFC_FloatingPlayHide   @"NFC_FloatingPlayHide"
#define NFC_FloatingPlayRemove   @"NFC_FloatingPlayRemove"

#define NFC_HideDeal @"NFC_HideDeal"//隐藏交易
//浮动视频 Rtmp流地址
#define FloatingRtmpStreamKey   @"FloatingRtmpStreamKey"

#define NFCPost_FloatingPlayShow   NFC_PostName(NFC_FloatingPlayShow)
#define NFCPost_FloatingPlayHide   NFC_PostName(NFC_FloatingPlayHide)
#define NFCPost_FloatingPlayRemove   NFC_PostName(NFC_FloatingPlayRemove)


#define NFC_AppDidEnterBackground   @"NFC_AppDidEnterBackground"
#define NFC_AppWillEnterForeground   @"NFC_AppWillEnterForeground"


#define NFC_RegExchangeSuccess @"NFC_RegExchangeSuccess"    //注册交易所成功
#define NFC_LocLogin @"NFC_LocLogin"                       //登陆后发的通知
#define NFC_LocLogout @"NFC_LocLogout"                     //注销后发的通知
#define NFC_ChangeHeadImgSuccess @"NFC_ChangeHeadImgSuccess"   //用户更换头像成功
#define NFC_ChangeNickNameSuccess @"NFC_ChangeNickNameSuccess"   //用户修改昵称成功

#define NFC_DealHeadRefresh @"NFC_DealHeadRefresh"//刷新交易头
#define NFC_WeipanRotation @"NFC_WeipanRotation"//K线分时图切换横竖屏
#define NFC_PushHomeView @"NFC_PushHomeView"//跳转首页
#define NFC_PushLogin @"NFC_PushLogin"//跳转登录
#define NFC_PushMarket @"NFC_PushMarket"//跳转看盘
#define NFC_Tost @"NFC_Tost"//tost

#define NFC_PushPosition @"NFC_PushPosition" //发送转换到持仓通知
#define NFC_PushProductList @"NFC_PushProductList"
#define NFC_PushRecharge @"NFC_PushRecharge"
#define NFC_ReloadHold @"NFC_ReloadHold"//唤醒持仓
#define NFC_ReloadProfit @"NFC_ReloadProfit"                       //刷新i盈利

#define NFC_RechargeSuccess @"NFC_RechargeSuccess"
#define NFC_ChangeToProductListView @"NFC_ChangeToProductListView"
#define NFC_ChangeToFundView  @"NFC_NFC_ChangeToFundView"
#define NFC_ChangeLaunchImage @"NFC_ChangeLaunchImage"
#define NFC_JG_WXPay_Success @"NFC_JG_WXPay_Success"
#define NFC_HG_WXPay_Success @"NFC_HG_WXPay_Success"
#define NFC_ShowRedEnvelopesMask @"showRedEnvelopesMask"
#define NFC_SocketUpdateQuotations      @"NFC_SocketUpdateQuotations"
#define NFC_SocketUpdateQuotationsFailure      @"NFC_SocketUpdateQuotationsFailure"
#define NFC_PushToChatVC @"NFC_PushToChatVC"
#define NFC_ClickQuotationBtn @"NFC_ClickQuotationBtn"


#define NFC_LivePlay @"NFC_LivePlay"                       //唤醒播放器通知
#define NFC_LiveShowKeyBoard @"NFC_LiveShowKeyBoard"
#define NFC_LiveHideKeyBoard  @"NFC_LiveHideKeyBoard"
#define NFC_LivePeronAdd  @"NFC_LivePeronAdd"
#define NFC_LivePeronSub  @"NFC_LivePeronSub"


#define NFC_ShareGainSuccess  @"NFC_ShareGainSuccess" //晒单成功

#define NFC_IMPushURL @"NFC_IMPushURL"  //IM客服提示问题跳转
#define NFC_ReloadReplayCell @"NFC_ReloadReplayCell"//IM客服提示问题重置cell

//个推
#define NFC_CID @"NFC_CID"//收到cid推送
#define NFC_RemindPop @"NFC_RemindPop"//收到消息提醒推送弹出视图
#define NFC_ReloadRemind @"NFC_ReloadRemind"//收到消息提醒推送刷新数据
#define NFC_DealMsgPop @"NFC_DealMsgPop"//收到平仓消息提醒推送弹出视图

#define NFC_LiveNoticeMsg @"NFC_LiveNoticeMsg"//直播室收到的消息



#endif /* Macro_String_h */
