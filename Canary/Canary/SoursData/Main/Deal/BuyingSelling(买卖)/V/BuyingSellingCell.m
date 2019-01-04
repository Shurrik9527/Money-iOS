//
//  BuyingSellingCell.m
//  Canary
//
//  Created by 孙武东 on 2019/1/2.
//  Copyright © 2019 litong. All rights reserved.
//

#import "BuyingSellingCell.h"

@implementation BuyingSellingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1:)];
    [self.viewOne addGestureRecognizer:tap1];
 
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2:)];
    [self.viewTwo addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3:)];
    [self.viewThree addGestureRecognizer:tap3];
    
    self.viewOne.layer.borderWidth = 1;
    self.viewOne.layer.borderColor = [UIColor colorFromHexString:@"f2f2f2"].CGColor;
    self.viewTwo.layer.borderWidth = 1;
    self.viewTwo.layer.borderColor = [UIColor colorFromHexString:@"f2f2f2"].CGColor;
    self.viewThree.layer.borderWidth = 1;
    self.viewThree.layer.borderColor = [UIColor colorFromHexString:@"f2f2f2"].CGColor;
    self.viewOne.layer.cornerRadius = 3;
    self.viewTwo.layer.cornerRadius = 3;
    self.viewThree.layer.cornerRadius = 3;

    [self changesButton:0];

    // Initialization code
}

- (void)tap1:(UITapGestureRecognizer *)tap{
    [self changesButton:0];
}

- (void)tap2:(UITapGestureRecognizer *)tap{
    [self changesButton:1];

}

- (void)tap3:(UITapGestureRecognizer *)tap{
    [self changesButton:2];

}

- (void)changesButton:(NSInteger)index{
    
    self.viewOne.backgroundColor = index == 0 ? [UIColor colorFromHexString:@"eceff1"] : [UIColor whiteColor];
    self.lineOne.hidden = index == 0 ? NO : YES;

    self.viewTwo.backgroundColor = index == 1 ? [UIColor colorFromHexString:@"eceff1"] : [UIColor whiteColor];
    self.lineTwo.hidden = index == 1 ? NO : YES;
    
    self.viewThree.backgroundColor = index == 2 ? [UIColor colorFromHexString:@"eceff1"] : [UIColor whiteColor];
    self.lineThree.hidden = index == 2 ? NO : YES;
}

- (IBAction)guaDanAction:(UIButton *)sender {
    if (self.guaDanAction) {
        self.guaDanAction();
    }
}

- (IBAction)buyUp:(UIButton *)sender {
    if (self.buyUpAction) {
        self.buyUpAction();
    }
}

- (IBAction)buyDown:(UIButton *)sender {
    if (self.buyDownAction) {
        self.buyDownAction();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
