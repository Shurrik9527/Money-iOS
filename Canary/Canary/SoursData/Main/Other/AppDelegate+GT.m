//
//  AppDelegate+GT.m
//  Canary
//
//  Created by Brain on 2017/6/3.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "AppDelegate+GT.h"
#import "GTMessageHelper.h"
#import "DeviceInfo.h"
#import "PopDealMsgV.h"
#import "LTAlertSheetView.h"
#import "MoneyRecordVCtrl.h"
@implementation AppDelegate (GT)
-(void)configGT{
    // [ GTSdk ]：是否允许APP后台运行
    [GeTuiSdk runBackgroundEnable:YES];
    
    // [ GTSdk ]：是否运行电子围栏Lbs功能和是否SDK主动请求用户定位
    [GeTuiSdk lbsLocationEnable:YES andUserVerify:YES];
    
    // [ GTSdk ]：自定义渠道
    [GeTuiSdk setChannelId:@"FXBTG-AppStore"];
    NSLog(@"kGtAppId = %@",kGtAppId);
    NSLog(@"kGtAppKey = %@",kGtAppKey);
    NSLog(@"kGtAppSecret = %@",kGtAppSecret);
    NFC_AddObserver(NFC_CID, @selector(collectGTInfo));//收集个推信息
    // [ GTSdk ]：使用APPID/APPKEY/APPSECRENT创建个推实例
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    NFC_AddObserver(NFC_RemindPop, @selector(showRemindPop));//添加全局pop push view
    NFC_AddObserver(NFC_DealMsgPop, @selector(showDealMsgPop));//添加全局pop push view

}
- (void)collectGTInfo {
    NSString *cid = [UserDefaults objectForKey:GTClientIdKey];
    if ([LTUser hasLogin] && notemptyStr(cid)) {
        [RequestCenter reqCollectGTPushInfoWithCid:cid finsh:^(LTResponse *res) {
            if (res.success) {
                NSLog(@"collectGTInfo success");
            }
        }];
    }
}
#pragma mark - GeTuiSdkDelegate

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    // [4-EXT-1]: 个推SDK已注册，返回clientId
    NSLog(@"\n>>[GTSdk RegisterClient]:%@\n\n", clientId);
    [UserDefaults setObject:clientId forKey:GTClientIdKey];
    [self collectGTInfo];
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>[GTSdk error]:%@\n\n", [error localizedDescription]);
}


/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    //    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = @"";
    if (payloadData) {
        payloadMsg = [[NSString alloc]initWithData:payloadData encoding:NSUTF8StringEncoding];
    }
    
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NFC_PostName(@"Msg");
    NSLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);
    NSDictionary *user = [payloadMsg jsonStringToDictonary];
    if (user &&[self isNotRemoteDic:user]) {
        NSString *sendType = [user stringFoKey:@"sendType"];
        if (notemptyStr(sendType)) {
            switch (sendType.integerValue) {
                case 1:
                    [GTMessageHelper showCustomAlertViewWithUserInfo:user];
                    break;
                case 2: {//行情提醒
                    [self configRemindModelWithDic:user];
                }
                    break;
                case 3: {//直播室notice
//                    NSNotification *notice=[[NSNotification alloc]initWithName:NFC_LiveNoticeMsg object:nil userInfo:user];
//                    [[NSNotificationCenter defaultCenter]postNotification:notice];
                }
                    break;
                case 4: {//平仓提醒
                    self.dealMsgDic=user;
                    [self showDealMsgPop];
                }
                    break;
                case 5: {//实名认证
//                    [self cerAlert:user];
                }
                    break;
                case 6: {//出金推送
                    [self withdrawAlert:user];
                }
                    break;
                case 7: {//账户风险提示(半小时只推送一个次)
                    [self alertWarmingSheet:user];
                }
                    break;
                default:
                    break;
            }

        }
    }
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>[GTSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 通知SDK运行状态
    NSLog(@"\n>>[GTSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>[GTSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    NSLog(@"\n>>[GTSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}
#pragma mark - cheeckRemote
-(BOOL)isNotRemoteDic:(NSDictionary *)dic{
    NSString *remoteBody=[dic objectForKey:@"body"];
    NSLog(@"remoteBody = %@",remoteBody);
    NSString *sendType = [dic stringFoKey:@"sendType"];
    if (sendType.integerValue<2) {
        return NO;
    }
    return YES;
}
#pragma mark - action
//实名认证
-(void)cerAlert:(NSDictionary *)data{
    if (data) {
        NSDictionary *dataDic=[data objectForKey:@"data"];
        NSString *title=[dataDic objectForKey:@"title"];
        if(!notemptyStr(title)){
            title=nil;
        }
        NSString *msg=[dataDic objectForKey:@"message"];
        NSString *sureTitle=@"入金";
        NSString *cancleTitle=@"关闭";
        NSNumber *type = [dataDic objectForKey:@"type"];
        WS(ws);
        void (^sureAction)()=^{
            [AppDelegate selectTabBarIndex:TabBarType_Deal];
            NFC_PostName(NFC_PushProductList);
        };
        if ([type integerValue]==2) {
            sureTitle=@"重新提交";
            cancleTitle=@"取消";
            sureAction=^{
                [ws.rootNavCtrl pushCertVC];
            };
        }
        [LTAlertView alertTitle:title message:msg sureTitle:sureTitle sureAction:sureAction cancelTitle:cancleTitle];
    }
}
//出入金
-(void)withdrawAlert:(NSDictionary *)data{
    /*
     {"body":"流水号为14969897325549801518的出金申请失败，原因:拒绝用户出金","data":{"logNo":"14969897325549801518","mark":"拒绝用户出金","type":3},"sendType":6,"title":"出金状态提醒"}
     //撤销
     {"body":"流水号为14969897325549801518的出金申请失败，原因:撤销用户出金","data":{"logNo":"14969897325549801518","mark":"撤销用户出金","type":4},"sendType":6,"title":"出金状态提醒"}
     //受理
     {"body":"您的出金申请正在受理，流水号:14969897325549801518,申请额度$25.00","data":{"amountUSD":25.00,"logNo":"14969897325549801518","mark":"撤销用户出金","type":1},"sendType":6,"title":"出金状态提醒"}
     //通过
     {"body":"流水号为:14969897325549801518的出金申请已成功，申请金额$30.00,手续$20.00费实际金额￥205.13，到账时间取决于银行","data":{"amountUSD":30.00,"charge":20.00,"factMoney":205.13,"logNo":"14969897325549801518","mark":"通过","type":2},"sendType":6,"title":"出金状态提醒"}
     */
    if (data) {
        NSDictionary *dataDic=[data objectForKey:@"data"];
        NSString *title=[data stringFoKey:@"title"];
        NSString *msg=[data stringFoKey:@"body"];
        
        NSString *sureTitle=@"查看详情";
        NSString *cancleTitle=@"关闭";
        NSInteger type = [[dataDic objectForKey:@"type"] integerValue];
        
        switch (type) {
            case 1://出金受理
            {
                title=@"出金受理中";
                sureTitle=nil;
                cancleTitle=@"我知道了";
            }
                break;
            case 2://出金成功
            {
                title=@"出金成功";
                sureTitle=nil;
                cancleTitle=@"我知道了";
            }
                break;
            default:
                title=@"出金失败";
                break;
        }
        
        WS(ws);
        [LTAlertView alertTitle:title message:msg sureTitle:sureTitle sureAction:^{
            MoneyRecordVCtrl *ctrl = [[MoneyRecordVCtrl alloc] init];
            [ws.rootNavCtrl pushVC:ctrl];
        } cancelTitle:cancleTitle];
    }
}
//爆仓警告框
-(void)alertWarmingSheet:(NSDictionary *)data{
    /*{
        "body":"您的预付款比例为-1235.35%,接近100%爆仓线！入境或平仓,减免爆仓风险。",
        "data":{"timeOutTxt":"六小时内不会再次提醒"},
        "sendType":7,
        "title":"仓位预警"
     }
     */
    NSDictionary *dataDic=[data objectForKey:@"data"];
    NSString *title=[data objectForKey:@"title"];
    NSString *body=[data objectForKey:@"body"];
    NSString *sub=[dataDic objectForKey:@"timeOutTxt"];

    CGRect rect = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - NavBarTop_Lit);
    LTAlertSheetView *sheet=[[LTAlertSheetView alloc] initWithFrame:rect];
    [AppKeyWindow addSubview:sheet];
    [sheet configContentView:title msg:body subMsg:sub mos:@[@"查看持仓",@"去入金"]];
    WS(ws);
    sheet.alertSheetBlock = ^(NSInteger idx){
        if (idx == 0) {//跳转持仓
            [ws.rootNavCtrl popToRootVC];
            [AppDelegate selectTabBarIndex:2];
            NFC_PostName(NFC_PushPosition);
        } else {//去入金
            NFC_PostName(NFC_PushRecharge);
        }
    };
    [sheet configCancleTitle:@"知道了"];
    [sheet showView:YES];

}
@end
