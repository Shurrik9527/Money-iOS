//
//  PostionCell.h
//  Canary
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postionModel.h"
#import "SocketModel.h"
typedef void(^BlockButton)();
@protocol SHFenleiCellDelegate <NSObject>
- (void)didQueRenBtn:(UIButton *)button atIndex:(NSInteger)index type:(NSString *)type;
@end
@interface PostionCell : UITableViewCell
@property (nonatomic ,strong)UILabel * sycnLabel;
@property (nonatomic,strong)UILabel * priceinLabel;
@property (nonatomic,strong)UILabel * priceOutLabel;
@property (nonatomic,strong)UILabel * rangLabel;
@property (nonatomic,strong)UILabel * rangPriceLabel;
@property (nonatomic,strong)UILabel * positionPriceLabel;
@property (nonatomic,strong)UILabel * positionTimeLabel;
@property (nonatomic,strong)UILabel * zhixunLabel;
@property (nonatomic,strong)UILabel * zhiyingLabel;
@property (nonatomic,strong)UILabel * typeLabel;
@property (nonatomic,strong)UIButton * pingcangBt;
@property (nonatomic,assign)BlockButton  clickFinish;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,copy)NSString * typeStr;//建仓类型
@property (nonatomic,copy)NSString * String;//挂单还是平仓
@property (nonatomic,strong) NSDictionary * dictionary;
@property(weak,nonatomic)id<SHFenleiCellDelegate>delegate;
-(void)upData:(postionModel*)model index:(NSInteger)index;
@end
