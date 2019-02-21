//
//  CashCouponCell.h
//  Canary
//
//  Created by 孙武东 on 2019/1/5.
//  Copyright © 2019 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CashCouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic, strong)dispatch_block_t rightBtnBlock;
@end

NS_ASSUME_NONNULL_END
