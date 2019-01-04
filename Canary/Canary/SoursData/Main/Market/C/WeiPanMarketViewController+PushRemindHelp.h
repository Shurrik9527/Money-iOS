//
//  WeiPanMarketViewController+PushRemindHelp.h
//  ixit
//
//  Created by Brain on 2017/2/16.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "WeiPanMarketViewController.h"


@interface WeiPanMarketViewController (PushRemindHelp)
//设置弹层
-(void)configPopTable;
//辅助线开关
-(void)auxiliaryLineShow:(BOOL)isShow;
//功能说明
-(void)pushRemindInstructions;
//弹层触发事件
-(void)configActionWithIndex:(NSInteger)index;
#pragma mark - request
-(void)requestPushRemindConfig;
-(void)requestPushRemindList;
-(void)createRemindView;
-(void)createAddRemindView;
-(void)drawLine;
@end
