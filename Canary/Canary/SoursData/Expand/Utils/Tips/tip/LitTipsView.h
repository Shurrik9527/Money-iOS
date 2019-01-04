//
//  LitTipsView.h
//  ixit
//
//  Created by litong on 16/10/12.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSTimeInterval autoHideTimeInterval = 2;

static NSInteger fontSize = 17.f;
static NSInteger leftMar = 35.f;
static NSInteger topMar = 18.f;

@interface LitTipsView : UIView

@property (nonatomic,strong) UILabel *msgLable;
@property (nonatomic,assign) BOOL showed;//YES:显示  NO:隐藏

+ (instancetype)sharedInstance;

#pragma mark - keywindow show

+ (void)showTips:(NSString *)tip afterHide:(NSInteger)afterHide;
+ (void)showTips:(NSString *)tip;
+ (void)hideTips;



@end
