//
//  KLineHeaderView.h
//  FMStock
//
//  Created by dangfm on 15/5/3.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "StockDish.h"
#import "QuotationDetailModel.h"
#import "UICountingLabel.h"
#import "SocketModel.h"

#define kLineChartHeaderViewHeight 87
#define kLineChartFooterViewHeight 52

@interface KLineHeaderView : BaseTableViewCell

@property (nonatomic,retain) UICountingLabel *price;
@property (nonatomic,retain) UILabel *change;
@property (nonatomic,retain) UILabel *changerate;
@property (nonatomic,retain) UILabel *time;

//@property (nonatomic,retain) UILabel *in_price;//买价
//@property (nonatomic,retain) UILabel *out_price;//卖价

@property (nonatomic,retain) UILabel *open_price;
@property (nonatomic,retain) UILabel *close_price;
@property (nonatomic,retain) UILabel *heigt_price;
@property (nonatomic,retain) UILabel *low_price;

@property (nonatomic,retain) UIImageView *refreshAnimationImg;//刷新动画

-(void)upDataHeaderPrice:(SocketModel*)socketModle;

-(void)startAnimation;
-(void)animationStop;
@end
