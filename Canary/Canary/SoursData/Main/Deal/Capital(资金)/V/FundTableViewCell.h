//
//  FundTableViewCell.h
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postionModel.h"
@interface FundTableViewCell : UITableViewCell
@property (nonatomic,strong)UIView * statView;
@property (nonatomic,strong)UILabel * typeLabel;
@property (nonatomic,strong)UILabel * symLabel;
@property (nonatomic,strong)UILabel * priceLabel;
@property (nonatomic,strong)UILabel * timeLabel;
- (void)getModel:(postionModel *)mode;
@end
