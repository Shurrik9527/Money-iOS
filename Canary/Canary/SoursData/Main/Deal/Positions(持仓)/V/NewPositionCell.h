//
//  NewPositionCell.h
//  Canary
//
//  Created by jihaokeji on 2018/5/7.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postionModel.h"

@protocol SHFenleiCellDelegate <NSObject>
- (void)didQueRenBtn:(UIButton *)button atIndex:(NSInteger)index type:(NSString *)type;
@end

@interface NewPositionCell : UITableViewCell

@property (nonatomic, copy) void(^goodsViewTouchBlock)(UIButton *button,NSInteger index,NSString * type);

@property (nonatomic,assign)NSInteger index;
/**
 建仓类型
 */
@property (nonatomic,copy)NSString * typeStr;
/**
 挂单还是平仓
 */
@property (nonatomic,copy)NSString * String;

/**
 持仓数据模型
 */
@property (nonatomic, strong) postionModel * model;
/**
 头部view
 */
@property (nonatomic, strong) UIView * topView;
/**
 小蓝条
 */
@property (nonatomic, strong) UIImageView * lineImage;
/**
 持仓名称
 */
@property (nonatomic, strong) UILabel * nameLadel;
/**
 市价单
 */
@property (nonatomic, strong) UILabel * typeLadel;
/**
 买涨
 */
@property (nonatomic, strong) UILabel * zhangFuLadel;
/**
 小箭头
 */
@property (nonatomic, strong) UIImageView * arrowImage;
/**
 涨幅图标
 */
@property (nonatomic, strong) UIImageView * increaseImage;
/**
 建仓时间
 */
@property (nonatomic, strong) UILabel * timeLadel;
/**
 建仓价格
 */
@property (nonatomic, strong) UILabel * priceLadel;
/**
 平仓按钮
 */
@property (nonatomic, strong) UIButton * unwindButton;
/**
 平仓按钮点击代理
 */
@property(weak,nonatomic)id<SHFenleiCellDelegate>delegate;

@end
