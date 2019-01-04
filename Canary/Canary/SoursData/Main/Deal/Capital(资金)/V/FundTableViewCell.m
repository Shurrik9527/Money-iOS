//
//  FundTableViewCell.m
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "FundTableViewCell.h"
#import "MarketModel.h"
#import "DataHundel.h"
@implementation FundTableViewCell

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
    self.statView =[[UIView alloc]initWithFrame:CGRectMake(0, 10, 3, 25)];
    [self.contentView addSubview:self.statView];
    
    self.typeLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.statView.xw_ + 10, 10, 100, 25)];
    self.typeLabel.font =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.typeLabel];
    
    self.symLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.typeLabel.xw_ + 5, 10, 160, 25)];
    self.symLabel.font =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.symLabel];


    UIImageView * imageRight =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
    imageRight.frame =CGRectMake(Screen_width - 30, 22.5, 15, 15);
    [self.contentView addSubview:imageRight];
    
    self.timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(self.statView.xw_ + 10, self.symLabel.yh_ + 5, 200, 25)];
    self.timeLabel.font =[UIFont systemFontOfSize:13];
    self.timeLabel.textColor =[UIColor lightGrayColor];
    [self.contentView addSubview:self.timeLabel];
    
    self.priceLabel =[[UILabel alloc]initWithFrame:CGRectMake(Screen_width - 100, 20, 60, 20)];
    self.priceLabel.font =[UIFont systemFontOfSize:13];
    self.priceLabel.textColor =[UIColor lightGrayColor];
    self.priceLabel.textAlignment = 2;
    [self.contentView addSubview:self.priceLabel];
    
    UIView * lineView1 =[[UIView alloc]initWithFrame:CGRectMake(0,self.timeLabel.yh_, Screen_width, 0.5)];
    lineView1.backgroundColor =LTLineColor;
    [self.contentView addSubview:lineView1];
}
-(void)getModel:(postionModel *)mode
{
//    NSInteger a =mode.volume.doubleValue * 100;
//    NSString * vlume =[NSString stringWithFormat:@"%ld",a];
    if ([mode.cmd isEqualToString:@"BUY"]) {
        self.statView.backgroundColor =LTKLineRed;
        self.typeLabel.text =[NSString stringWithFormat:@"%@%@%@", @"买涨   ",mode.volume,@"手"];
        self.typeLabel.textColor = LTRedColor;

    }else
    {
        self.statView.backgroundColor =LTKLineGreen;
        self.typeLabel.text =[NSString stringWithFormat:@"%@%@%@", @"买跌   ",mode.volume,@"手"];
        self.typeLabel.textColor = LTKLineGreen;
    }
    NSMutableArray  * markArray =[NSMutableArray arrayWithArray:[DataHundel shareDataHundle].marketArrat];
    if (markArray.count > 0 ) {
        for (MarketModel * marketModel in markArray) {
            if ([marketModel.symbol isEqualToString:mode.symbol]) {
                self.symLabel.text = marketModel.symbol_cn;
            }
        }
    }
    self.timeLabel.text = [NSString stringWithFormat:@"%@%@",@"建仓时间: ",[DataHundel convertime:mode.open_time]];
    if (mode.profit.floatValue > 0) {
        self.priceLabel.textColor =LTKLineRed;
        self.priceLabel.text = [NSString stringWithFormat:@"%.2f%@",mode.profit.doubleValue,@"$"];
    }else
    {
        self.priceLabel.textColor =LTKLineGreen;
        self.priceLabel.text = [NSString stringWithFormat:@"%.2f%@",mode.profit.doubleValue,@"$"];
    }
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
