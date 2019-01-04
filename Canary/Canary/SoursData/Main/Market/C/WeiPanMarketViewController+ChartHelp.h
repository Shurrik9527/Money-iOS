//
//  WeiPanMarketViewController+ChartHelp.h
//  ixit
//
//  Created by Brain on 2016/11/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "WeiPanMarketViewController.h"

@interface WeiPanMarketViewController (ChartHelp)
-(void)createMinuteChart;
-(void)createDaysChart;
-(void)updateMinuteChart;
-(void)updateMinuteViewForSocket;
-(void)updateDaysChart;
-(void)updateDaysViewForSocket;
-(void)removeChart;
@end
