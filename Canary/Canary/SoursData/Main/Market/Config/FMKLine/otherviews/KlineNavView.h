//
//  KlineNavView.h
//  FMStock
//
//  Created by dangfm on 15/5/3.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

#define kLineChart_nav_height 36
#define kLineChart_nav_fontSize 15
#define kLineChart_nav_HBackgroundColor LTColorHex(0xEEEEEE)
@class KlineNavView;

typedef void (^ClickNavButtonBlock)(KlineNavView *nav,NSString* typestr);

@interface KlineNavView : BaseTableViewCell
@property (nonatomic,retain) NSArray *types;
@property (nonatomic,assign) BOOL isFinish;
@property (nonatomic,copy) ClickNavButtonBlock clickNavButtonBlock;
-(void)updateHighlightsButtonsWithType:(NSString*)type;
-(void)updateOtherButtonText:(NSString*)str;
-(void)updateViews:(CGRect)frame;
@end
