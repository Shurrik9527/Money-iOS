//
//  OutInGodTableViewCell.m
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "OutInGodTableViewCell.h"

@implementation OutInGodTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatView];
    }
    return self;
}
-(void)creatView
{
    self.PayLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 40, 20)];
    self.PayLabel.font =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.PayLabel];
    
    self.dataLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, self.PayLabel.yh_ + 5, 200, 20)];
    self.dataLabel.font =[UIFont systemFontOfSize:14];
    self.dataLabel.textColor =[UIColor lightGrayColor];
    [self.contentView addSubview:self.dataLabel];
    
    self.priceLabel =[[UILabel alloc]init];
    self.priceLabel.frame = CGRectMake(Screen_width - 110, 10, 90, 20);
    self.priceLabel.font =[UIFont systemFontOfSize:14];
    self.priceLabel.textAlignment = 2;
    [self.contentView addSubview:self.priceLabel];
    
    self.messageLabel =[[UILabel alloc]init];
    self.messageLabel.frame =CGRectMake(Screen_width - 140, self.priceLabel.yh_ + 5, 120, 20);
    self.messageLabel.font =[UIFont systemFontOfSize:14];
    self.messageLabel.textAlignment = 2;
    self.messageLabel.textColor =[UIColor grayColor];
    [self.contentView addSubview:self.messageLabel];
    

    UIView * lineView1 =[[UIView alloc]initWithFrame:CGRectMake(0,60, Screen_width, 0.5)];
    lineView1.backgroundColor =LTLineColor;
    [self.contentView addSubview:lineView1];

    
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
