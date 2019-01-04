//
//  PostionCell.m
//  Canary
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "PostionCell.h"
#import "DataHundel.h"
#import "MarketModel.h"
#import "NetworkRequests.h"
@implementation PostionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];

    }
    return self;
}
-(void)initView
{
    UIView * headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, 40)];
    headerView.backgroundColor =LTBgColor;
    [self.contentView addSubview:headerView];
    
    self.sycnLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 120, 40)];
    self.sycnLabel.textColor =[UIColor grayColor];
    self.sycnLabel.backgroundColor = [UIColor redColor];
    self.sycnLabel.font =[UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.sycnLabel];
    
    UIImageView * imageRight =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
    imageRight.frame =CGRectMake(Screen_width - 30, 10, 20, 20);
    [self.contentView addSubview:imageRight];
    
    _priceinLabel =[[UILabel alloc]initWithFrame:CGRectMake(Screen_width/2 - 10, 5, 90, 30)];
    _priceinLabel.textColor = LTKLineRed;
    _priceinLabel.font =[UIFont systemFontOfSize:16];
    [self.contentView addSubview:_priceinLabel];
    
    _priceOutLabel =[[UILabel alloc]initWithFrame:CGRectMake(_priceinLabel.xw_ + 5, 10, 90, 20)];
    _priceOutLabel.textColor = LTKLineGreen;
    _priceOutLabel.font =[UIFont systemFontOfSize:16];
    [self.contentView addSubview:_priceOutLabel];
    
    self.rangLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, headerView.yh_ + 5, 120, 30)];
    self.rangLabel.textColor = LTRedColor;
    self.rangLabel.font =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.rangLabel];
    
    self.rangPriceLabel =[[UILabel alloc]initWithFrame:CGRectMake(Screen_width - 110, headerView.yh_ + 5, 100, 30)];
    self.rangPriceLabel.textAlignment = 2;
    self.rangPriceLabel.textColor = LTRedColor;
    self.rangPriceLabel.font =[UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.rangPriceLabel];
    
    UIView * line =[[UIView alloc]initWithFrame:CGRectMake(0, self.rangPriceLabel.yh_ + 5, Screen_width, 0.5)];
    line.backgroundColor =LTBgColor;
    [self.contentView addSubview:line];
    
    self.positionPriceLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, line.yh_ + 5, 110, 30)];
    self.positionPriceLabel.font =[UIFont systemFontOfSize:14];
    self.positionPriceLabel.textColor =[UIColor lightGrayColor];
    [self.contentView addSubview:self.positionPriceLabel];
    
    self.positionTimeLabel =[[UILabel alloc]initWithFrame:CGRectMake(Screen_width/2 - 10, line.yh_ + 5, 180, 30)];
    self.positionTimeLabel.font =[UIFont systemFontOfSize:11];
    self.positionTimeLabel.textColor =[UIColor lightGrayColor];
    [self.contentView addSubview:self.positionTimeLabel];
    
    UIView * footView =[[UIView alloc]initWithFrame:CGRectMake(0, self.positionTimeLabel.yh_+ 5, Screen_width, 40)];
    footView.backgroundColor =LTBgColor;
    [self.contentView addSubview:footView];
    
    
    UILabel * aLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 32, 30)];
    aLabel.font =[UIFont systemFontOfSize:12];
    aLabel.text = @"止损:";
    [footView addSubview:aLabel];
    
    _zhixunLabel =[[UILabel alloc]initWithFrame:CGRectMake(aLabel.xw_, 5, 50, 30)];
    _zhixunLabel.font =[UIFont systemFontOfSize:12];
    _zhixunLabel.textColor =BlueLineColor;
    [footView addSubview:_zhixunLabel];
    
    UILabel * bLabel =[[UILabel alloc]initWithFrame:CGRectMake(_zhixunLabel.xw_, 5, 42, 30)];
    bLabel.font =[UIFont systemFontOfSize:12];
    bLabel.text = @" /止盈:";
    [footView addSubview:bLabel];
    
    _zhiyingLabel =[[UILabel alloc]initWithFrame:CGRectMake(bLabel.xw_, 5, 55, 30)];
    _zhiyingLabel.font =[UIFont systemFontOfSize:12];
    _zhiyingLabel.textColor =BlueLineColor;
    [footView addSubview:_zhiyingLabel];
    
    self.typeLabel =[[UILabel alloc]initWithFrame:CGRectMake(Screen_width/2 - 10, 5, 60, 30)];
    self.typeLabel.font = [UIFont systemFontOfSize:14];
    self.typeLabel.textColor =BlueLineColor;
    [footView addSubview:self.typeLabel];
    
    self.pingcangBt =[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.pingcangBt.backgroundColor =BlueLineColor;
    self.pingcangBt.frame = CGRectMake(Screen_width - 60, 5,40, 30);
    [self.pingcangBt addTarget:self action:@selector(clickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    self.pingcangBt.titleLabel.font =[UIFont systemFontOfSize:14];
    [footView addSubview:self.pingcangBt];
}

-(void)upData:(postionModel*)model index:(NSInteger)index
{
    _index = index;
    NSInteger a =model.volume.doubleValue * 100;
    NSString * vlume =[NSString stringWithFormat:@"%ld",a];
    self.rangPriceLabel.text = [NSString stringWithFormat:@"%@%@",model.profit,@"$"];
    _zhixunLabel.text =model.sl;
    _zhiyingLabel.text = model.tp;
    NSMutableArray  * markArray =[NSMutableArray arrayWithArray:[DataHundel shareDataHundle].marketArrat];
    self.positionPriceLabel.text = [NSString stringWithFormat:@"%@%@",@"建仓价:" ,model.open_price];
    self.positionTimeLabel.text = [NSString stringWithFormat:@"%@%@",@"建仓时间: ",[DataHundel convertime:model.open_time]];
    if (markArray.count > 0 ) {
    for (MarketModel * marketModel in markArray) {
        if ([marketModel.symbol isEqualToString:model.symbol]) {
            self.sycnLabel.text = marketModel.symbol_cn;
        }
        
    }
    }
    
     self.typeStr = model.cmd;
    if ([_typeStr isEqualToString:@"BUY"] || [_typeStr isEqualToString:@"SELL"]) {
        self.typeLabel.text = @"市价单";
        self.String = @"CLOSE";
        [self.pingcangBt setTitle:@"平仓" forState:(UIControlStateNormal)];

        if ([_typeStr isEqualToString:@"BUY"]) {
            self.rangLabel.text =[NSString stringWithFormat:@"%@%@", @"买涨   ",vlume];
            self.rangLabel.textColor = LTRedColor;
        }else
        {
            self.rangLabel.text =[NSString stringWithFormat:@"%@%@", @"买跌   ",vlume];
            self.rangLabel.textColor = LTGreenColor;
        }
    }else
    {
        self.String = @"DELETE";
        self.typeLabel.text = @"挂  单";
        [self.pingcangBt setTitle:@"撤销" forState:(UIControlStateNormal)];
        if ([_typeStr isEqualToString:@"BUY_LIMIT"] ||[_typeStr isEqualToString:@"BUY_STOP"] ) {
            self.rangLabel.text =[NSString stringWithFormat:@"%@%@", @"买涨   ",vlume];
            self.rangLabel.textColor = LTRedColor;
        }else
        {
            self.rangLabel.text =[NSString stringWithFormat:@"%@%@", @"买跌   ",vlume];
            self.rangLabel.textColor = LTGreenColor;
        }
    }
    self.dictionary = @{@"server":[NSUserDefaults objFoKey:TYPE],@"mt4id":[NSUserDefaults objFoKey:MT4ID],@"type":self.String,@"ticket":model.ticket,@"symbol":model.symbol,@"volume":vlume};
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)clickAction:(id)sender
{
    // 之前声明好的代理
    if ([self.delegate respondsToSelector:@selector(didQueRenBtn: atIndex:)]) {
        [self.delegate didQueRenBtn:sender atIndex:_index type:self.String];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
