//
//  WeiPanKChartFooterView.h
//  ixit
//
//  Created by yu on 15/8/30.
//  Copyright (c) 2015年 ixit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeiPanKChartFooterView;
typedef void (^ClickFooterButtonsBlock)(UIButton*bt);

@interface WeiPanKChartFooterView : UIView

@property(nonatomic,copy) ClickFooterButtonsBlock clickFooterButtonsBlock;
//是否显示跳转订单的btn
-(void)showCreateOrderBtnWithBool:(BOOL)isShow;


@end
