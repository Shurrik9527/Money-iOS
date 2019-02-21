//
//  PutUpCell.m
//  Canary
//
//  Created by 孙武东 on 2019/2/18.
//  Copyright © 2019 litong. All rights reserved.
//

#import "PutUpCell.h"

@implementation PutUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)cancelAction:(UIButton *)sender {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}

- (void)setModel:(postionModel *)model{
    _model = model;
    
    if (model.ransactionType == 1) {
        self.lineLabel.backgroundColor =LTKLineRed;
        self.ransactionTypeLabel.text =[NSString stringWithFormat:@"%@%ld%@", @"买涨   ",(long)model.lot,@"手"];
        self.ransactionTypeLabel.textColor = LTRedColor;
        
    }else
    {
        self.lineLabel.backgroundColor =LTKLineGreen;
        self.ransactionTypeLabel.text =[NSString stringWithFormat:@"%@%ld%@", @"买跌   ",(long)model.lot,@"手"];
        self.ransactionTypeLabel.textColor = LTKLineGreen;
    }
    
    NSDecimalNumber *exponent = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", model.unitPrice]];
    NSDecimalNumber *commissionCharges = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", model.commissionCharges]];
//    NSDecimalNumber *unitPriceOne = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", model.unitPriceOne]];

    
    self.nameLabel.text = model.symbolName;
    self.guaPriceLabel.text = [NSString stringWithFormat:@"%@",model.entryOrdersPrice];
    self.timeLabel.text = @"";
    self.pointLabel.text = [NSString stringWithFormat:@"%@点",model.errorRange];
    self.unitPrice.text = [NSString stringWithFormat:@"%@美元",exponent];
    self.commissionLabel.text = [NSString stringWithFormat:@"%@美元",commissionCharges];
    self.y_label.text = model.stopProfitCount == 0 ? @"不限" : [NSString stringWithFormat:@"%f",model.stopProfitCount];
    self.s_Label.text = model.stopLossCount == 0 ? @"不限" : [NSString stringWithFormat:@"%f",model.stopLossCount];


    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
