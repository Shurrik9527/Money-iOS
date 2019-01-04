//
//  KLineSelectIndexHView.h
//  FMStock
//
//  Created by dangfm on 15/5/24.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuotationDetailModel.h"
@class DaysChartModel;
@class KLineSelectIndexHView;
@class StockDish;
typedef void (^UpdateSelfViewBlock)(KLineSelectIndexHView*view,CGFloat height);
typedef void (^ClickTypeButtonBlock)(KLineSelectIndexHView*view,NSArray*countrys,BOOL isSelected);
typedef void (^ClickIndexButtonBlock)(KLineSelectIndexHView*view,NSArray *stars,BOOL isSelected);
typedef void (^ClickReturnBackButtonBlock)(void);

@interface KLineSelectIndexHView : UIView

@property (nonatomic,retain) UILabel *titler;//标题

@property (nonatomic,retain) UIButton *backButton;
@property (nonatomic,copy) UpdateSelfViewBlock updateSelfViewBlock;
@property (nonatomic,copy) ClickTypeButtonBlock clickTypeButtonBlock;
@property (nonatomic,copy) ClickIndexButtonBlock clickIndexButtonBlock;
@property (nonatomic,copy) ClickReturnBackButtonBlock clickReturnBackButtonBlock;

-(instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title;
-(void)updateZoushiTitleWithType:(NSString*)type;
-(void)updatePriceViewsWithDatas:(DaysChartModel*)mchar;
-(void)updateTitlesPrice:(QuotationDetailModel *)dish;

@end
