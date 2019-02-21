//
//  MeAssetsView.m
//  Canary
//
//  Created by 孙武东 on 2019/1/5.
//  Copyright © 2019 litong. All rights reserved.
//

#import "MeAssetsView.h"

@interface MeAssetsView()
@property (weak, nonatomic) IBOutlet UILabel *jingZiChanLabel;
@property (weak, nonatomic) IBOutlet UILabel *daiJinCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuDongLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuELable;

@end

@implementation MeAssetsView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.jingZiChanLabel.text = [NSString stringWithFormat:@"%.3f",10.0];
//    self.daiJinCountLabel.text = @"1";
//    self.fuDongLabel.text = @"10000";
//    self.yuELable.text = @"100000";
    
}

- (IBAction)daiJinAction:(UIButton *)sender {
    if (self.selectActionBlock) {
        self.selectActionBlock(0);
    }
}

- (IBAction)fudongAction:(UIButton *)sender {
    if (self.selectActionBlock) {
        self.selectActionBlock(1);
    }
}

- (IBAction)chongZhi:(UIButton *)sender {
    if (self.selectActionBlock) {
        self.selectActionBlock(2);
    }
}

@end
