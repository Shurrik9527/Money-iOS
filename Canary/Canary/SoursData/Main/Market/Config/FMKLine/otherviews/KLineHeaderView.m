//
//  KLineHeaderView.m
//  FMStock
//
//  Created by dangfm on 15/5/3.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "KLineHeaderView.h"
#import "Masonry.h"
#import "DataHundel.h"
@interface KLineHeaderView()<CAAnimationDelegate>
{
    CABasicAnimation *animation;
    NSMutableArray *imgArr;
    BOOL startAnimation;
}
@property(strong,nonatomic)UILabel * closeTxt;//收仓
@property(strong,nonatomic)UILabel * lowTxt;//最低
@property(strong,nonatomic)UILabel * startTxt;//今开
@property(strong,nonatomic)UILabel * heighTxt;//最高
@property(strong,nonatomic)UILabel * outTxt;//卖价
@property(strong,nonatomic)UILabel * inTxt;//买价

@end

@implementation KLineHeaderView

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];
        startAnimation=NO;
    }
    return self;
}
-(void)initViews
{
    self.backgroundColor = LTColorHexString(TitleHex);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    startAnimation=YES;
    CGFloat x = LTAutoW(16);
    CGFloat y = 0;
    CGFloat w = self.w_/7;
    CGFloat h = kLineChartHeaderViewHeight / 3;
    CGRect frame = CGRectMake(x, y, 0.5*Screen_width, 1.4*h);
    UIFont *font = boldFontSiz(28);
    if (Screen_width==320) {
        font =  boldFontSiz(24);
    }
    // 当前价格
    if (!_price) {
        _price = [[UICountingLabel alloc] initWithFrame:frame];
        _price.method = UILabelCountingMethodLinear;
        _price.format = @"%.2f";
        _price.font=font;
        [self addSubview:_price];
        _price.textAlignment = NSTextAlignmentLeft;
    }
    
    font = autoFontSiz(15);
    if (Screen_width==320) {
        font =  autoFontSiz(12);
    }
    // 涨跌额
    if (!_change) {
        w = 2*w;
        frame = CGRectMake(x, y+32, w-15, h);
        _change = [self createLabelWithFrame:frame Title:@"-0.00" Color:LTWhiteColor Font:autoFontSiz(15)];
        _change.textAlignment = NSTextAlignmentLeft;
        [_change mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(LTAutoW(16));//使左边等于self.view的左边，间距为0
            make.top.equalTo(self.mas_top).offset(36);//使顶部与self.view的间距为0
        }];
    }
    // 涨跌幅
    if (!_changerate) {
        frame = CGRectMake(x+56, y+32, w, h);
        _changerate = [self createLabelWithFrame:frame Title:@"+0.00%" Color:LTWhiteColor Font:autoFontSiz(15)];
        _changerate.textAlignment = NSTextAlignmentLeft;
        [_changerate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.change.mas_centerY);
            make.left.equalTo(self.change.mas_right).offset(4);
            make.height.equalTo(self.change);
        }];
    }
    font = autoFontSiz(12);
    // 时间
    if (!_time) {
        frame = CGRectMake(x, y+32+h, 2*w-15, h);
        _time = [self createLabelWithFrame:frame Title:@"" Color:LTColorHexString(SubTitleHex) Font:font];
        _time.textAlignment = NSTextAlignmentLeft;
    }
    //动画
    if (!_refreshAnimationImg) {
        _refreshAnimationImg=[[UIImageView alloc]init];
        _refreshAnimationImg.frame=CGRectMake(Screen_width, kLineChartHeaderViewHeight-3,Screen_width , 3);
        _refreshAnimationImg.image=[UIImage imageNamed:@"refreshImg.jpg"];
        [self addSubview:_refreshAnimationImg];
        [self startAnimation];
    }

    font = fontSiz(LTAutoW(midFontSize));
    UIFont * numFont= [UIFont systemFontOfSize:LTAutoW(15)];
    h=24;
    CGFloat width = 56;
    CGFloat width1 = 40;
    width=[LTUtils getContentWidth:@"0000.00" FontSize:numFont];
    width1=[LTUtils getContentWidth:@"今开：" FontSize:font];
    CGFloat leftx1 = Screen_width-width-LTAutoW(16);
    CGFloat leftx = leftx1-width1;

    // 昨收
    if (!_close_price) {
        frame = CGRectMake(leftx1, 10, width, h);
        _close_price = [self createLabelWithFrame:frame Title:@"0.00" Color:LTWhiteColor Font:numFont];
        _close_price.textAlignment=NSTextAlignmentRight;
        
        frame = CGRectMake(leftx, 10, width1, h);
        _closeTxt = [self createLabelWithFrame:frame Title:@"昨收：" Color:LTColorHexString(SubTitleHex) Font:font];
        _closeTxt.textAlignment=NSTextAlignmentRight;

    }
    // 最低
    if (!_low_price) {
        frame = CGRectMake(leftx1, 10+h, width, h);
        _low_price = [self createLabelWithFrame:frame Title:@"0.00" Color:LTWhiteColor Font:numFont];
        _low_price.textAlignment=NSTextAlignmentRight;

        frame = CGRectMake(leftx, 10+h, width1, h);
        _lowTxt = [self createLabelWithFrame:frame Title:@"最低：" Color:LTColorHexString(SubTitleHex) Font:font];
        _lowTxt.textAlignment=NSTextAlignmentRight;
    }
    
    leftx1 = leftx-width-2;
    leftx = leftx1-width1;

    // 开盘
    if (!_open_price) {
        frame = CGRectMake(leftx1, 10, width, h);
        _open_price = [self createLabelWithFrame:frame Title:@"0.00" Color:LTWhiteColor Font:numFont];
        _open_price.textAlignment=NSTextAlignmentRight;

        frame = CGRectMake(leftx, 10, width1, h);
        _startTxt = [self createLabelWithFrame:frame Title:@"今开: " Color:LTColorHexString(SubTitleHex) Font:font];
        _startTxt.textAlignment=NSTextAlignmentRight;
    }
    
    // 最高
    if (!_heigt_price) {
        frame = CGRectMake(leftx1, 10+h, width, h);
        _heigt_price = [self createLabelWithFrame:frame Title:@"0.00" Color:LTWhiteColor Font:numFont];
        _heigt_price.textAlignment=NSTextAlignmentRight;

        
        frame = CGRectMake(leftx,10+h, width1, h);
        _heighTxt = [self createLabelWithFrame:frame Title:@"最高:  " Color:LTColorHexString(SubTitleHex) Font:font];
        _heighTxt.textAlignment=NSTextAlignmentRight;

    }
}
//更新行情长连接的数据
-(void)upDataHeaderPrice:(SocketModel*)socketModle
{
    if (socketModle) {
    [self startAnimation];
    CGFloat oldPrice = _close_price.text.floatValue;
    CGFloat newPrice = socketModle.buy_in.floatValue;
    [_price countFrom:_price.text.floatValue to:socketModle.buy_in.floatValue withDuration:0.4];
        //时差显示加五个小时
//    NSString * timeStr =[NSString stringWithFormat:@"%@ %@",socketModle.dataStr, socketModle.timeStr];
//    long long  haomiao_=  [DataHundel getZiFuChuan:timeStr];
    long long  haomiao_=  [socketModle.marketTime.time longLongValue];
//    long long lastTime = haomiao_  +( 5 * 60 * 60 * 1000);
    NSNumber *longlongNumber = [NSNumber numberWithLongLong:haomiao_];
    NSString *longlongStr = [longlongNumber stringValue];
    _time.text =[DataHundel convertime:longlongStr];
        
    if (newPrice != oldPrice && oldPrice > 0) {
        float changerate = newPrice - oldPrice;
        float  gains =changerate/oldPrice * 100;
        if (changerate  > 0) {
            _change.textColor = LTKLineRed;
            _changerate.textColor = LTKLineRed;
            _price.textColor = LTKLineRed;
            
        }else
        {
            _change.textColor = LTKLineGreen;
            _changerate.textColor = LTKLineGreen;
            _price.textColor = LTKLineGreen;
        }
        _change.text = [NSString stringWithFormat:@"%.3f",changerate];
        _changerate.text = [NSString stringWithFormat:@"%@%%",[NSString stringWithFormat:@"%.2f ",gains]];
    }
    }
 }

#pragma mark - animation refresh
-(void)startAnimation {
    animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    animation.fromValue = @(Screen_width);
    animation.toValue = @(-Screen_width);
    animation.duration = 1;
    animation.repeatCount=1;
    animation.delegate=self;
    [_refreshAnimationImg.layer addAnimation:animation forKey:@"basic"];
    animation=nil;
}

-(void)animationStop {
    [_refreshAnimationImg.layer removeAllAnimations];
    startAnimation=NO;
}
#pragma mark - utils
-(UILabel*)createLabelWithFrame:(CGRect)frame Title:(NSString*)title Color:(UIColor*)color Font:(UIFont*)font{
    UILabel *l = [[UILabel alloc] initWithFrame:frame];
    l.backgroundColor = LTClearColor;
    l.textColor = color;
    l.text = title;
    l.font = font;
    l.textAlignment = NSTextAlignmentLeft;
    [self addSubview:l];
    return l;
}
-(void)dealloc{
    _price = nil;
    _changerate = nil;
    _change = nil;
    _time = nil;
  //  _in_price = nil;
//    _out_price = nil;
    _open_price = nil;
    _close_price = nil;
    _heigt_price = nil;
    _low_price = nil;
    _refreshAnimationImg=nil;
    animation=nil;
}
@end
