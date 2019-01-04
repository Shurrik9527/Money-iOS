//
//  WeiPanMarketViewController+PushRemindHelp.m
//  ixit
//
//  Created by Brain on 2017/2/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "WeiPanMarketViewController+PushRemindHelp.h"
#import "IntegralMo.h"

@implementation WeiPanMarketViewController (PushRemindHelp)
#pragma mark - initView
-(void)initMoreView{
    if (!self.morePopView) {
        self.morePopView=[[PopTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW_Lit, ScreenH_Lit)];
        [self.morePopView setTriangleCenterX:132];
        self.morePopView.hidden=YES;
        [self.view addSubview:self.morePopView];
        WS(ws);
        self.morePopView.clickCell=^(NSInteger index){
            [ws configActionWithIndex:index];
        };
    }
    self.morePopView.excode=self.excode;
    self.morePopView.code=self.code;
    self.morePopView.count=self.remindList.count;
    if(self.morePopView.hidden){
        [self.view bringSubviewToFront:self.morePopView];
        [self.morePopView showPop];
    }else{
        [self.morePopView hiddenPop];
    }
}
#pragma mark - action
//设置弹层
-(void)configPopTable{
    [self initMoreView];
}
//辅助线开关
-(void)auxiliaryLineShow:(BOOL)isShow{
    
    NSString *UMKey = isShow ? @"辅助线开启" : @"辅助线关闭";
    if(self.titler){
        UMengEventWithParameter(UM_MD_More_AuxiliaryLine, UMKey, self.titler);
    }
    
    NSInteger limit = 4;
    if ([self.remindConfigModel.limitSize isNotNull]) {
        limit = [self.remindConfigModel.limitSize integerValue];
    }
    [self.minutechart auxiliaryLineWithList:self.remindList isShow:isShow limitSize:limit];
    //持仓列表
    [self.minutechart positionLineWithList:self.holdList isShow:isShow];
}
//功能说明
-(void)pushRemindInstructions{
    [self pushWeb:URL_PushRemindInfo title:@"功能说明"];
}
//弹层触发事件
-(void)configActionWithIndex:(NSInteger)index{
    
    switch (index) {
        case 0:
        {
            if (![LTUser hasLogin]) {
                [self pushLocLogin];
                return;
            }
            UMengEvent(UM_MD_More_Remind);
            //行情提醒 1.获取该行情条数 2.展示pop
            [self requestPushRemindConfig];
        }
            break;
        case 1:
        {
            UMengEvent(UM_MD_More_FullScreen);
            NFC_PostName(NFC_WeipanRotation);//刷新横竖线
            [self changeViewDirection];
        }
            break;
        case 2:
        {
            if (![LTUser hasLogin]) {
                [self pushLocLogin];
                return;
            }
            //开启或关闭辅助线
            NSString *key = [NSString stringWithFormat:@"%@_%@_line",self.excode,self.code];
            if (UD_ObjForKey(key)) {
                BOOL flag = ![UD_ObjForKey(key) boolValue];
                UD_SetObjForKey([NSNumber numberWithBool:flag], key);
                [self auxiliaryLineShow:flag];
            }else{
                BOOL flag = YES;
                UD_SetObjForKey([NSNumber numberWithBool:flag], key);
                [self auxiliaryLineShow:flag];
            }
            
        }
            break;
        case 3:
        {
            UMengEvent(UM_MD_More_FunctionDesc);
            [self pushRemindInstructions];//跳转功能说明
        }
            break;
    
        default:
            break;
    }
}
-(void)drawLine{
    //开启或关闭辅助线
    NSString *key = [NSString stringWithFormat:@"%@_%@_line",self.excode,self.code];
    if (UD_ObjForKey(key)) {
        BOOL flag = [UD_ObjForKey(key) boolValue];
        [self auxiliaryLineShow:flag];
    }else {
        UD_SetObjForKey([NSNumber numberWithBool:YES], key);
        [self auxiliaryLineShow:YES];
    }
}
#pragma mark - request

//获取用户等级
- (void)reqUserPoint {
    WS(ws);
    [RequestCenter reqUserPoint:[[LTUser userVipLv] integerValue] finish:^(LTResponse *res) {
        if (res.success) {
            IntegralMo *mo = [IntegralMo objWithDict:res.resDict];
            NSInteger lv = [mo.levelNum integerValue];
            [mo saveLvAndRebateRate];
            if (lv < 2) {
                [LTAlertView alertTitle:@"需要Lv2及以上用户\n才能设置提醒" message:@"Lv2需要10000成长值，做单可以增加成长值" sureTitle:@"知道了" sureAction:nil];
            } else {
                //行情提醒 1.获取该行情条数 2.展示pop
                [ws requestPushRemindConfig];
            }
            
        }else{
            [ws.view showTip:res.message];
        }
    }];
}

//获取推送列表
-(void)requestPushRemindList {
    if (![LTUser hasLogin]) {
        return;
    }
    WS(ws);
    [RequestCenter reqReminderListWithCode:self.code finsh:^(LTResponse *res) {
        if (res.success) {
            NSArray *temp = [res.resArr copy];
            [ws.remindList removeAllObjects];
            ws.remindList = [NSMutableArray arrayWithArray:[PushRemindModel objsWithList:temp]];
            [ws.myRemindView reload:ws.remindList];
            [ws drawLine];//绘制辅助线
        }
    }];
}
//获取推送配置
- (void)requestPushRemindConfig {
    WS(ws);
    [RequestCenter reqReminderSettingWithCode:self.code finsh:^(LTResponse *res) {
        if (res.success) {
            ws.remindConfigModel = [PushRemindConfigModel objWithDict:res.resDict ];
            [ws.myRemindView showView:YES];
        } else {
            [ws.view showTip:res.message];
        }
    }];
}


#pragma mark - 行情提醒

- (void)createRemindView {
    if(!usePushRemind){
        return;
    }

    CGFloat remindY = NavBarTop_Lit + kLineChartHeaderViewHeight;
    self.myRemindView = [[MyRemind alloc] initWithTempH:remindY excode:self.excode code:self.code pName:self.titler];
    [self.view addSubview:self.myRemindView];
    self.myRemindView.hidden = YES;
    WS(ws);
    self.myRemindView.reqRemindListBlock = ^{
        [ws drawRemindLine];
    };
    self.myRemindView.goLoginBlock = ^{
        [ws pushLocLogin];
    };
    self.myRemindView.addRemindBlock = ^{
        [ws.addRemindView changeEditing:nil];
        [ws.addRemindView showView:YES];
    };
    self.myRemindView.editRemindBlock = ^(NSInteger row){
        [ws.addRemindView changeEditing:ws.remindList[row]];
        [ws.addRemindView showView:YES];
    };
}

- (void)createAddRemindView {
    CGFloat remindY = NavBarTop_Lit + kLineChartHeaderViewHeight;
    self.addRemindView = [[AddRemind alloc] initWithTempH:remindY excode:self.excode code:self.code pName:self.titler];
    [self.view addSubview:self.addRemindView];
    self.addRemindView.hidden = YES;
    WS(ws);
    self.addRemindView.addRemindShutBlock = ^{
//        [ws.myRemindView showView:YES];
    };
    self.addRemindView.reqRemindListBlock = ^{
        [ws drawRemindLine];
//        [ws.myRemindView showView:YES];
    };
}


//重新请求 画线
- (void)drawRemindLine {
    [self requestPushRemindList];
}


@end
