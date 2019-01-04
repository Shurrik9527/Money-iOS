//
//  WeiPanPriceView.m
//  ixit
//
//  Created by Brain on 16/8/1.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "WeiPanPriceView.h"

@implementation WeiPanPriceView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame])
    {
        self.frame=frame;
        self.backgroundColor=KlineNavViewBG;
        _leftPading=8;
        _topPading=6;
        _width=self.frame.size.width;
        _height=self.frame.size.height;
        self.layer.cornerRadius=3;
        self.layer.masksToBounds=YES;
        [self initContinerViews];
    }
    return self;
}
-(void)initContinerViews
{
    //时间
    _timeLab=[[UILabel alloc]init];
    _timeLab.frame=CGRectMake(_leftPading, _topPading, _width, 13);
    _timeLab.backgroundColor=[UIColor clearColor];
    _timeLab.text=@"01-01 00:00";
    _timeLab.textAlignment=NSTextAlignmentLeft;
    _timeLab.numberOfLines=0;
    _timeLab.textColor=LTSubTitleRGB;
    _timeLab.font=[UIFont systemFontOfSize:10];
    [self addSubview:_timeLab];
    [_timeLab sizeToFit];
    
    //开盘
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(_leftPading, CGRectGetMaxY(_timeLab.frame)+_topPading/2, 1/3.0*_width, 24);
    label.backgroundColor=[UIColor clearColor];
    label.text=@"开盘:";
    label.textAlignment=NSTextAlignmentLeft;
    label.numberOfLines=0;
    label.textColor=LTSubTitleRGB;
    label.font=[UIFont systemFontOfSize:12];
    label.tag=100;
    [self addSubview:label];
    [label sizeToFit];
    
    _openPriceLab=[[UILabel alloc]init];
    _openPriceLab.frame=CGRectMake(1/3.0*_width-_leftPading, label.frame.origin.y, 2/3.0*_width, 24);
    _openPriceLab.backgroundColor=[UIColor clearColor];
    _openPriceLab.text=@"0000.00";
    _openPriceLab.textAlignment=NSTextAlignmentRight;
    _openPriceLab.numberOfLines=1;
    _openPriceLab.textColor=LTWhiteColor;
    _openPriceLab.font=[UIFont systemFontOfSize:12];
    [self addSubview:_openPriceLab];
    [_openPriceLab sizeToFit];
    
    //收盘
    UILabel *label1=[[UILabel alloc]init];
    label1.frame=CGRectMake(_leftPading, CGRectGetMaxY(_openPriceLab.frame)+_topPading/2, 1/3.0*_width, 24);
    label1.backgroundColor=[UIColor clearColor];
    label1.text=@"收盘:";
    label1.textAlignment=NSTextAlignmentLeft;
    label1.numberOfLines=0;
    label1.textColor=LTSubTitleRGB;
    label1.font=[UIFont systemFontOfSize:12];
    label1.tag=101;
    [self addSubview:label1];
    [label1 sizeToFit];
    
    _closePriceLab=[[UILabel alloc]init];
    _closePriceLab.backgroundColor=[UIColor clearColor];
    _closePriceLab.text=@"0000.00";
    _closePriceLab.textAlignment=NSTextAlignmentRight;
    _closePriceLab.numberOfLines=0;
    _closePriceLab.textColor=LTWhiteColor;
    _closePriceLab.font=[UIFont systemFontOfSize:12];
    [self addSubview:_closePriceLab];
    [_closePriceLab sizeToFit];
    _closePriceLab.frame=CGRectMake(_width-_leftPading-_closePriceLab.frame.size.width, label1.frame.origin.y, _closePriceLab.frame.size.width, _closePriceLab.frame.size.height);

    
    //最高
    UILabel *label2=[[UILabel alloc]init];
    label2.frame=CGRectMake(_leftPading, CGRectGetMaxY(_closePriceLab.frame)+_topPading/2, 1/3.0*_width, 24);
    label2.backgroundColor=[UIColor clearColor];
    label2.text=@"最高:";
    label2.textAlignment=NSTextAlignmentLeft;
    label2.numberOfLines=0;
    label2.textColor=LTSubTitleRGB;
    label2.font=[UIFont systemFontOfSize:12];
    label2.tag=102;
    [self addSubview:label2];
    [label2 sizeToFit];
    
    _highPriceLab=[[UILabel alloc]init];
    _highPriceLab.backgroundColor=[UIColor clearColor];
    _highPriceLab.text=@"0000.00";
    _highPriceLab.textAlignment=NSTextAlignmentRight;
    _highPriceLab.numberOfLines=0;
    _highPriceLab.textColor=LTKLineRed;
    _highPriceLab.font=[UIFont systemFontOfSize:12];
    [self addSubview:_highPriceLab];
    [_highPriceLab sizeToFit];
    _highPriceLab.frame=CGRectMake(_width-_leftPading-_highPriceLab.frame.size.width, label2.frame.origin.y, _highPriceLab.frame.size.width, _highPriceLab.frame.size.height);

    //最低
    UILabel *label3=[[UILabel alloc]init];
    label3.frame=CGRectMake(_leftPading, CGRectGetMaxY(_highPriceLab.frame)+_topPading/2, 1/3.0*_width, 24);
    label3.backgroundColor=[UIColor clearColor];
    label3.text=@"最低:";
    label3.textAlignment=NSTextAlignmentLeft;
    label3.numberOfLines=1;
    label3.textColor=LTSubTitleRGB;
    label3.font=[UIFont systemFontOfSize:12];
    label3.tag=103;
    [self addSubview:label3];
    [label3 sizeToFit];
    
    _lowPriceLab=[[UILabel alloc]init];
    _lowPriceLab.backgroundColor=[UIColor clearColor];
    _lowPriceLab.text=@"0000.00";
    _lowPriceLab.textAlignment=NSTextAlignmentRight;
    _lowPriceLab.numberOfLines=1;
    _lowPriceLab.textColor=LTKLineGreen;
    _lowPriceLab.font=[UIFont systemFontOfSize:12];
    [self addSubview:_lowPriceLab];
    [_lowPriceLab sizeToFit];
    _lowPriceLab.frame=CGRectMake(_width-_leftPading-_lowPriceLab.frame.size.width, label3.frame.origin.y, _lowPriceLab.frame.size.width, _lowPriceLab.frame.size.height);

    
    //涨幅
    UILabel *label4=[[UILabel alloc]init];
    label4.frame=CGRectMake(_leftPading, CGRectGetMaxY(_lowPriceLab.frame)+_topPading/2, 1/3.0*_width, 24);
    label4.backgroundColor=[UIColor clearColor];
    label4.text=@"涨跌:";
    label4.textAlignment=NSTextAlignmentLeft;
    label4.numberOfLines=1;
    label4.textColor=LTSubTitleRGB;
    label4.font=[UIFont systemFontOfSize:12];
    label4.tag=104;
    [self addSubview:label4];
    [label4 sizeToFit];
    
    _profitPriceLab=[[UILabel alloc]init];
    _profitPriceLab.backgroundColor=[UIColor clearColor];
    _profitPriceLab.text=@"0000.00";
    _profitPriceLab.textAlignment=NSTextAlignmentRight;
    _profitPriceLab.numberOfLines=1;
    _profitPriceLab.textColor=LTWhiteColor;
    _profitPriceLab.font=[UIFont systemFontOfSize:12];
    [self addSubview:_profitPriceLab];
    [_profitPriceLab sizeToFit];
    _profitPriceLab.frame=CGRectMake(_width-_leftPading-_profitPriceLab.frame.size.width, label4.frame.origin.y, _profitPriceLab.frame.size.width, _profitPriceLab.frame.size.height);

    
    //涨跌幅
    UILabel *label5=[[UILabel alloc]init];
    label5.frame=CGRectMake(_leftPading, CGRectGetMaxY(_profitPriceLab.frame)+_topPading/2, 1/3.0*_width, 24);
    label5.backgroundColor=[UIColor clearColor];
    label5.text=@"涨幅";
    label5.textAlignment=NSTextAlignmentLeft;
    label5.numberOfLines=0;
    label5.textColor=LTSubTitleRGB;
    label5.font=[UIFont systemFontOfSize:12];
    label5.tag=105;
    [self addSubview:label5];
    [label5 sizeToFit];
    
    _profitRatePriceLab=[[UILabel alloc]init];
    _profitRatePriceLab.backgroundColor=[UIColor clearColor];
    _profitRatePriceLab.text=@"0000.00";
    _profitRatePriceLab.textAlignment=NSTextAlignmentRight;
    _profitRatePriceLab.numberOfLines=1;
    _profitRatePriceLab.textColor=LTWhiteColor;
    _profitRatePriceLab.font=[UIFont systemFontOfSize:12];
    [self addSubview:_profitRatePriceLab];
    [_profitRatePriceLab sizeToFit];
    _profitRatePriceLab.frame=CGRectMake(_width-_leftPading-_profitRatePriceLab.frame.size.width, label5.frame.origin.y, _profitRatePriceLab.frame.size.width, _profitRatePriceLab.frame.size.height);


}
-(void)configPriceInfoWithModel:(DaysChartModel *)model
{
    //时间
    _timeLab.text=[LTUtils timeformat_monthDay:model.time.integerValue];
    [_timeLab sizeToFit];
    _timeLab.frame=CGRectMake(_timeLab.frame.origin.x, _timeLab.frame.origin.y, _width, 13);
    
    //开盘
    _openPriceLab.text=[NSString stringWithFormat:@"%g",model.openPrice.floatValue];
    [_openPriceLab sizeToFit];
    _openPriceLab.frame=CGRectMake(_width-_leftPading-_openPriceLab.frame.size.width, CGRectGetMaxY(_timeLab.frame)+_topPading/2, _openPriceLab.frame.size.width, _openPriceLab.frame.size.height);
    
    //收盘
    _closePriceLab.text=[NSString stringWithFormat:@"%g",model.closePrice.floatValue];;
    [_closePriceLab sizeToFit];
    _closePriceLab.frame=CGRectMake(0, CGRectGetMaxY(_openPriceLab.frame)+_topPading/2, _width-_leftPading, _closePriceLab.frame.size.height);

    //最高
    _highPriceLab.text=[NSString stringWithFormat:@"%g",model.heightPrice.floatValue];
    _highPriceLab.textColor=LTKLineRed;
    [_highPriceLab sizeToFit];
    _highPriceLab.frame=CGRectMake(0, CGRectGetMaxY(_closePriceLab.frame)+_topPading/2, _width-_leftPading, _highPriceLab.frame.size.height);


    //最低
    _lowPriceLab.text=[NSString stringWithFormat:@"%g",model.lowPrice.floatValue];
    [_lowPriceLab sizeToFit];
    _lowPriceLab.frame=CGRectMake(0, CGRectGetMaxY(_highPriceLab.frame)+_topPading/2,_width-_leftPading, _lowPriceLab.frame.size.height);

    //涨跌
    CGFloat profit=model.closePrice.floatValue-model.openPrice.floatValue;
    _profitPriceLab.text=[NSString stringWithFormat:@"%.2f",profit];
    [_profitPriceLab sizeToFit];
    _profitPriceLab.frame=CGRectMake(0, CGRectGetMaxY(_lowPriceLab.frame)+_topPading/2, _width-_leftPading, _profitPriceLab.frame.size.height);


    //涨幅
    CGFloat profitRate=profit/model.openPrice.floatValue*100;
    _profitRatePriceLab.text=[NSString stringWithFormat:@"%.2f%%",profitRate];
    [_profitRatePriceLab sizeToFit];
    _profitRatePriceLab.frame=CGRectMake(0, CGRectGetMaxY(_profitPriceLab.frame)+_topPading/2, _width-_leftPading, _profitRatePriceLab.frame.size.height);

    if (profit>=0)
    {
        _profitPriceLab.textColor=LTKLineRed;
        _profitRatePriceLab.textColor=LTKLineRed;
    }
    else
    {
        _profitPriceLab.textColor=LTKLineGreen;
        _profitRatePriceLab.textColor=LTKLineGreen;
    }
    if (model.openPrice>model.closePrice)
    {
        _openPriceLab.textColor=LTKLineGreen;
    }
    else
    {
        _openPriceLab.textColor=LTKLineRed;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
