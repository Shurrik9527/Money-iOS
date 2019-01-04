//
//  WeiPanKChartNavigationView.h
//  ixit
//
//  Created by yu on 15/8/29.
//  Copyright (c) 2015年 ixit. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

#define kLineChart_nav_height 36
#define kLineChart_nav_fontSize 15
#define kLineChart_nav_HBackgroundColor LTColorHex(0xEEEEEE)
@class WeiPanKChartNavigationView;

typedef void (^ClickNavButtonBlock)(WeiPanKChartNavigationView *nav,NSString* typestr);

@interface WeiPanKChartNavigationView : BaseTableViewCell
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,assign) BOOL isFinish;
@property (nonatomic,copy) ClickNavButtonBlock clickNavButtonBlock;
-(void)updateHighlightsButtonsWithType:(NSString*)type;
-(void)updateOtherButtonText:(NSString*)str;
-(void)updateViews:(CGRect)frame;
@end
