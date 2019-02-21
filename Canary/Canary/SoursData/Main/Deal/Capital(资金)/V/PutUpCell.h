//
//  PutUpCell.h
//  Canary
//
//  Created by 孙武东 on 2019/2/18.
//  Copyright © 2019 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "postionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PutUpCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UILabel *ransactionTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lotLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *guaPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitPrice;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;
@property (weak, nonatomic) IBOutlet UILabel *y_label;
@property (weak, nonatomic) IBOutlet UILabel *s_Label;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong)dispatch_block_t cancelBlock;

@property (nonatomic, strong)postionModel *model;

@end

NS_ASSUME_NONNULL_END
