//
//  WeiPanPriceView.h
//  ixit
//
//  Created by Brain on 16/8/1.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DaysChartModel.h"

@interface WeiPanPriceView : UIView
//时间
@property(strong,nonatomic) UILabel *timeLab;
//开盘
@property(strong,nonatomic) UILabel *openPriceLab;
//收盘
@property(strong,nonatomic) UILabel *closePriceLab;
//最高
@property(strong,nonatomic) UILabel *highPriceLab;
//最低
@property(strong,nonatomic) UILabel *lowPriceLab;
//涨跌
@property(strong,nonatomic) UILabel *profitPriceLab;
//涨跌幅
@property(strong,nonatomic) UILabel *profitRatePriceLab;
//竖直间距
@property(assign,nonatomic)CGFloat topPading;
//左间距
@property(assign,nonatomic)CGFloat leftPading;
//width
@property(assign,nonatomic)CGFloat width;
//height
@property(assign,nonatomic)CGFloat height;
-(void)configPriceInfoWithModel:(DaysChartModel *)model;
@end
