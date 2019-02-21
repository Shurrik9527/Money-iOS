//
//  CashCouponCell.m
//  Canary
//
//  Created by 孙武东 on 2019/1/5.
//  Copyright © 2019 litong. All rights reserved.
//

#import "CashCouponCell.h"

@implementation CashCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rightBtn.layer.borderWidth = 1;
    self.rightBtn.layer.borderColor = [UIColor colorFromHexString:@"1C94F8"].CGColor;
    self.rightBtn.layer.cornerRadius = 3;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)rightBtnAction:(id)sender {
    
    if (self.rightBtnBlock) {
        self.rightBtnBlock();
    }
    
}

@end
