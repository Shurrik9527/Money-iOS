//
//  BuyingSellingCell.h
//  Canary
//
//  Created by 孙武东 on 2019/1/2.
//  Copyright © 2019 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuySellingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BuyingSellingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhangfuLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhangfulvLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;

@property (weak, nonatomic) IBOutlet UILabel *lineOne;
@property (weak, nonatomic) IBOutlet UILabel *countOne;
@property (weak, nonatomic) IBOutlet UILabel *priceOne;
@property (weak, nonatomic) IBOutlet UILabel *unitOne;

@property (weak, nonatomic) IBOutlet UILabel *lineTwo;
@property (weak, nonatomic) IBOutlet UILabel *countTwp;
@property (weak, nonatomic) IBOutlet UILabel *priceTwo;
@property (weak, nonatomic) IBOutlet UILabel *unitTwo;

@property (weak, nonatomic) IBOutlet UILabel *lineThree;
@property (weak, nonatomic) IBOutlet UILabel *countThree;
@property (weak, nonatomic) IBOutlet UILabel *priceThree;
@property (weak, nonatomic) IBOutlet UILabel *unitThree;

@property (nonatomic, strong)dispatch_block_t guaDanAction;
@property (nonatomic, strong)dispatch_block_t buyUpAction;
@property (nonatomic, strong)dispatch_block_t buyDownAction;

@property (nonatomic, strong)BuySellingModel *model;

@end

NS_ASSUME_NONNULL_END
