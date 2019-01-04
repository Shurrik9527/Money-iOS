//
//  DesTableViewCell.m
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "DesTableViewCell.h"

@implementation DesTableViewCell
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
    self.nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 100, 30)];
    self.nameLabel.font =[UIFont systemFontOfSize:14];
    self.nameLabel.textAlignment = 2;
    [self.contentView addSubview:self.nameLabel];
    
    self.desLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.xw_ + 25, 10, 210, 30)];
    self.desLabel.font =[UIFont systemFontOfSize:14];
    self.desLabel.numberOfLines = 0;
    self.desLabel.textColor =[UIColor lightGrayColor];
    self.desLabel.textAlignment = 0;
    [self.contentView addSubview:self.desLabel];
    
    UIView * lineView1 =[[UIView alloc]initWithFrame:CGRectMake(0,50, Screen_width, 0.5)];
    lineView1.backgroundColor =LTLineColor;
    [self.contentView addSubview:lineView1];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
