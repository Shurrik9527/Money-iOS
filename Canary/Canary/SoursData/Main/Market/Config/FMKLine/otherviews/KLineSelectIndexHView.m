//
//  KLineSelectIndexHView.m
//  FMStock
//
//  Created by dangfm on 15/5/24.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "KLineSelectIndexHView.h"
#import "DaysChartModel.h"
#import "StockDish.h"
#import "QuotationDetailModel.h"
@interface KLineSelectIndexHView(){
    CGFloat pading;
    CGFloat p16;
    CGFloat fs;
}
@property(strong,nonatomic)NSArray *countrys;
@property(strong,nonatomic)NSArray *stars;
@property(strong,nonatomic)NSArray *types;
@property(strong,nonatomic)NSArray *typesName;
@property(strong,nonatomic)UIView *countryView;
@property(strong,nonatomic)UIView *starView;
@property(assign,nonatomic)CGFloat height;
@property(assign,nonatomic)CGFloat viewHeight;
@property(strong,nonatomic)UIButton *countryButton;
@property(strong,nonatomic)UIButton *starButton;
@property(copy,nonatomic)NSString *titlestring;
@property(strong,nonatomic)NSArray *mainIndexs;       // 主图指标
@property(strong,nonatomic)NSArray *secondIndex;      // 副图指标

@property(strong,nonatomic)UIButton *maskView;
@property(strong,nonatomic)UIView *priceViews;

@property(strong,nonatomic)UILabel *timelb;           // 时间
@property(strong,nonatomic)UILabel *NewPrice;         // 最新价
@property(strong,nonatomic)UILabel *changeProfit;     // 浮动点数
@property(strong,nonatomic)UILabel *changeRate;       // 涨跌幅

@property(strong,nonatomic)UILabel *openPrice;         //今开
@property(strong,nonatomic)UILabel *closePrice;        //昨收
@property(strong,nonatomic)UILabel *heightPrice;       //最高
@property(strong,nonatomic)UILabel *lowPrice;          //最低
@property(strong,nonatomic)UILabel *buyPrice;           //买价
@property(strong,nonatomic)UILabel *sellPrice;          //卖价

@property(strong,nonatomic)UILabel *openLab;         //今开
@property(strong,nonatomic)UILabel *closeLab;        //昨收
@property(strong,nonatomic)UILabel *heightLab;       //最高
@property(strong,nonatomic)UILabel *lowLab;          //最低
@property(strong,nonatomic)UILabel *buyLab;           //买价
@property(strong,nonatomic)UILabel *sellLab;          //卖价

//记录原始数据用于传入为空时显示
@property(copy,nonatomic)NSString *openStr;         //今开
@property(copy,nonatomic)NSString *closeStr;        //昨收
@property(copy,nonatomic)NSString *heightStr;       //最高
@property(copy,nonatomic)NSString *lowStr;          //最低
@property(copy,nonatomic)NSString *buyStr;          //买价
@property(copy,nonatomic)NSString *sellStr;         //卖价

@property(copy,nonatomic)NSString *dateStr;         //时间

@end
@implementation KLineSelectIndexHView
#pragma mark - init
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString*)title{
    if (self==[super initWithFrame:frame]) {
        _height = frame.size.height;
        _titlestring = title;
        _types = @[@"1",@"min5",@"min15",@"min30",@"min60",@"hr4",@"day"];
        _typesName = @[@"5分",@"15分",@"30分",@"1小时",@"4小时",@"日线"];
        _mainIndexs = @[@"SMA",@"EMA",@"BOLL"];
        _secondIndex = @[@"MACD",@"KDJ",@"RSI"];
        [self initViews];
    }
    return self;
}

-(void)initViews {
    self.backgroundColor = LTTitleRGB;
    self.clipsToBounds = YES;
    //maskView按钮，用于实现类似tap的效果。缩回竖屏。
    _maskView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.w_,Screen_width)];
    _maskView.alpha = 0;
    _maskView.backgroundColor = LTTitleRGB;
    [_maskView addTarget:self action:@selector(clickMaskViewButtonBundle) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_maskView];
    _maskView.hidden = YES;
    
    UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.w_,_height)];
    h.tag = 10;
    h.backgroundColor = LTTitleRGB;
    [self addSubview:h];
    
    CGFloat fsize = 13;
    CGFloat bigSize = 30;
    p16=LTAutoW(16);
    pading=8;
    if (ScreenW_Lit==320) {
        pading=4;
        bigSize = 28;
        fsize = 12;
    }
    fs=fsize;
    // 初始化导航视图
    if (!_titler) {
        // 标题
        _titler=[self createLabWithFrame:CGRectMake(p16, 8, _titler.w_, _titler.h_) text:_titlestring fontSize:17];
        _titler.frame = CGRectMake(p16, 8, _titler.w_, _titler.h_);
        [h addSubview:_titler];
    }
    if (!_timelb) {
        CGRect frame=CGRectMake(p16, _titler.y_+_titler.h_+2, _timelb.w_+10, _timelb.h_);
        _timelb = [self createLabWithFrame:frame text:[LTUtils getNowTimeString] fontSize:12];
        _timelb.textColor = LTSubTitleRGB;
        _timelb.textAlignment=NSTextAlignmentLeft;
        _timelb.frame = CGRectMake(p16, _titler.y_+_titler.h_+2, _timelb.w_+10, _timelb.h_);
        [h addSubview:_timelb];
    }

    if (!_NewPrice) {
        CGRect frame=CGRectMake(_timelb.w_+_timelb.x_+pading+4, _timelb.h_+_timelb.y_-_NewPrice.h_, _NewPrice.w_, _NewPrice.h_);
        _NewPrice = [self createLabWithFrame:frame text:@"0.00" fontSize:bigSize];
        _NewPrice.frame=CGRectMake(_timelb.w_+_timelb.x_+pading+4, _timelb.h_+_timelb.y_-_NewPrice.h_, _NewPrice.w_, _NewPrice.h_);
        [h addSubview:_NewPrice];
    }
    if (!_changeProfit) {
        CGRect frame=CGRectMake(_NewPrice.w_+_NewPrice.x_+pading,_timelb.h_+_timelb.y_ - _changeProfit.h_, _changeProfit.w_, _changeProfit.h_);
        _changeProfit = [self createLabWithFrame:frame text:@"00.00" fontSize:fsize];
        _changeProfit.frame=CGRectMake(_NewPrice.w_+_NewPrice.x_+pading,_timelb.h_+_timelb.y_ - _changeProfit.h_, _changeProfit.w_, _changeProfit.h_);
        [h addSubview:_changeProfit];
    }
    if (!_changeRate) {
        CGRect frame=CGRectMake(_changeProfit.w_+_changeProfit.x_+pading,_changeProfit.y_, _changeRate.w_, _changeRate.h_);

        _changeRate = [self createLabWithFrame:frame text:@"00.00%" fontSize:fsize];
        _changeRate.frame=CGRectMake(_changeProfit.w_+_changeProfit.x_+pading,_changeProfit.y_, _changeRate.w_, _changeRate.h_);
        [h addSubview:_changeRate];
    }
    
    //切换竖屏按钮
    if (!_backButton)
    {
        //标题栏的返回键
        UIImage *back_imge=[UIImage imageNamed:@"nofullPlayViewIcon"];
        CGRect frame =CGRectMake(self.w_-back_imge.size.width-p16, 0, back_imge.size.width+p16, self.h_);
        _backButton=[self createBtnWithFrame:frame Image:back_imge];
        [_backButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
        [h addSubview:_backButton];
        [_backButton setTag:100];
        back_imge = nil;
    }
    
    NSArray *topTitles=@[@"买价:",@"最高:",@"今开:"];
    NSArray *bttomTitles=@[@"卖价:",@"最低:",@"昨收:"];
    NSString *pStr=@"0000.00";
    CGFloat labW = [LTUtils labelWithFontsize:fsize text:pStr];
    CGFloat labW1 = [LTUtils labelWithFontsize:fsize text:topTitles[0]];
    CGFloat labH = [LTUtils labHeightWithFontsize:fsize text:topTitles[0]];

    CGFloat x =_backButton.x_-labW;
    CGFloat ty = _height/2.0 -labH - 2;
    CGFloat by = _height/2.0+2;

    for (int i = 0; i<topTitles.count; i++) {
        NSString *topT=topTitles[i];
        NSString *bttomT=bttomTitles[i];
        NSInteger tag=i*10;
        CGRect fr1 = CGRectMake(x, ty, labW, labH);
        CGRect fr2 = CGRectMake(x, by, labW, labH);
        UILabel *lab1 = [self createLabWithFrame:fr1 text:pStr fontSize:fsize];
        UILabel *lab2 = [self createLabWithFrame:fr2 text:pStr fontSize:fsize];
        lab1.tag = 1+tag;
        lab2.tag = 2+tag;
        
        x-=labW;
        CGRect fr3 = CGRectMake(x, ty, labW1, labH);
        CGRect fr4 = CGRectMake(x, by, labW1, labH);
        UILabel *lab3 = [self createLabWithFrame:fr3 text:topT fontSize:fsize];
        UILabel *lab4 = [self createLabWithFrame:fr4 text:bttomT fontSize:fsize];
        lab3.tag = 3+tag;
        lab4.tag = 4+tag;
        x-=labW1;
        
        [h addSubview:lab1];
        [h addSubview:lab2];
        [h addSubview:lab3];
        [h addSubview:lab4];
    }
    _buyPrice=[self viewWithTag:1];
    _sellPrice=[self viewWithTag:2];
    _buyLab=[self viewWithTag:3];
    _sellLab=[self viewWithTag:4];

    _heightPrice=[self viewWithTag:11];
    _lowPrice=[self viewWithTag:12];
    _heightLab=[self viewWithTag:13];
    _lowLab=[self viewWithTag:14];

    _openPrice=[self viewWithTag:21];
    _closePrice=[self viewWithTag:22];
    _openLab=[self viewWithTag:23];
    _closeLab=[self viewWithTag:24];
    
//    //价格相关
//    //买价
//    if (!_buyPrice) {
//        CGRect frame = CGRectMake(_backButton.x_,_height/2-_closePrice.h_-2, _closePrice.w_, _closePrice.h_);
//        _buyPrice = [self createLabWithFrame:frame text:@"0000.00" fontSize:fsize];
//        _buyPrice.frame=CGRectMake(_backButton.x_-_buyPrice.w_,_height/2-_buyPrice.h_-2, _buyPrice.w_, _buyPrice.h_);
//        [h addSubview:_buyPrice];
//    }
//    
//
//
//    if (!_buyLab)
//    {
//        CGRect frame = CGRectMake(_buyLab.x_-pW,py, pW, pH);
//        _buyLab =  [self createLabWithFrame:frame text:@"买价：" fontSize:fsize];
//        _buyLab.textColor = LTSubTitleRGB;
//        _buyLab.frame=CGRectMake(_buyPrice.x_-_buyPrice.w_,py, pW, pH);
//        [h addSubview:_buyLab];
//    }
//    
//    
//    //昨收
//    if (!_closePrice) {
//        CGRect frame = CGRectMake(_backButton.x_-_closePrice.w_,py, pW, pH);
//        _closePrice = [self createLabWithFrame:frame text:@"0000.00" fontSize:fsize];
//        _closePrice.frame=CGRectMake(_backButton.x_-_closePrice.w_,py, pW, pH);
//        [h addSubview:_closePrice];
//    }
//    if (!_closeLab)
//    {
//        CGRect frame = CGRectMake(_closePrice.x_-_closeLab.w_,py, pW, pH);
//        _closeLab =  [self createLabWithFrame:frame text:@"昨收：" fontSize:fsize];
//        _closeLab.textColor = LTSubTitleRGB;
//        _closeLab.frame=CGRectMake(_closePrice.x_-_closeLab.w_,py, pW, pH);
//        [h addSubview:_closeLab];
//    }
//    
//    //今开
//    if (!_openPrice) {
//        CGRect frame = CGRectMake(_closeLab.x_-_openPrice.w_-p16,py, pW, pH);
//        _openPrice = [self createLabWithFrame:frame text:@"0000.00" fontSize:fsize];
//        _openPrice.frame=CGRectMake(_closeLab.x_-_openPrice.w_-p16,py, pW, pH);
//        [h addSubview:_openPrice];
//    }
//    if (!_openLab)
//    {
//        CGRect frame = CGRectMake(_openPrice.x_-_openLab.w_,py, pW, pH);
//        _openLab = [self createLabWithFrame:frame text:@"今开：" fontSize:fsize];
//        _openLab.textColor = LTSubTitleRGB;
//        _openLab.frame=CGRectMake(_openPrice.x_-_openLab.w_,py, pW, pH);
//        [h addSubview:_openLab];
//    }
//
//    
//    py=_height/2+2;
//    
//    //最低价
//    if (!_lowPrice)
//    {
//        CGRect frame = CGRectMake(_closePrice.x_,_height/2+2, _lowPrice.w_, _lowPrice.h_);
//        _lowPrice = [self createLabWithFrame:frame text:@"0000.00" fontSize:fsize];
//        _lowPrice.frame=CGRectMake(_closePrice.x_,_height/2+2, _lowPrice.w_, _lowPrice.h_);
//        [h addSubview:_lowPrice];
//    }
//    if (!_lowLab)
//    {
//        CGRect frame = CGRectMake(_closeLab.x_,_lowPrice.y_,_lowLab.w_, _lowLab.h_);
//        _lowLab = [self createLabWithFrame:frame text:@"最低：" fontSize:fsize];
//        _lowLab.textColor = LTSubTitleRGB;
//        _lowLab.frame=CGRectMake(_closeLab.x_,_lowPrice.y_,_lowLab.w_, _lowLab.h_);
//        [h addSubview:_lowLab];
//    }
//    
//    //最高
//    if (!_heightPrice)
//    {
//        CGRect frame = CGRectMake(_openPrice.x_,_lowLab.y_, _heightPrice.w_, _heightPrice.h_);
//        _heightPrice = [self createLabWithFrame:frame text:@"0000.00" fontSize:fsize];
//        _heightPrice.frame=CGRectMake(_openPrice.x_,_lowLab.y_, _heightPrice.w_, _heightPrice.h_);
//        [h addSubview:_heightPrice];
//    }
//    if (!_heightLab)
//    {
//        CGRect frame = CGRectMake(_openLab.x_,_heightPrice.y_,_heightLab.w_,_heightLab.h_);
//        _heightLab = [self createLabWithFrame:frame text:@"最高：" fontSize:fsize];
//        _heightLab.frame=CGRectMake(_openPrice.x_,_lowLab.y_, _heightPrice.w_, _heightPrice.h_);
//        _heightLab.textColor = LTSubTitleRGB;
//        _heightLab.frame=CGRectMake(_openLab.x_,_heightPrice.y_,_heightLab.w_,_heightLab.h_);
//        [h addSubview:_heightLab];
//    }
    
}
#pragma mark - create
-(void)createCountryViews{
    
    _countryView = [[UIView alloc] initWithFrame:CGRectMake(0, self.h_, self.w_, 100)];
    _countryView.backgroundColor = LTHEX(0x24273E);
//    [LTUtils drawLineAtSuperView:_countryView andTopOrDown:0 andHeight:0.5 andColor:LTColorHex(0x111111)];
    
    CGFloat x = 0;
    CGFloat y = 15;
    CGFloat w = (self.w_-_typesName.count*15-15)/_typesName.count;
    CGFloat h = 30;
    CGFloat p = 15;
    
    if (iPhone4) {
        w = (self.w_-_typesName.count*15)/_typesName.count+3;
        p = 10;
    }
    
    int i = 0;
    int j = 0;
    for (NSString *item in _typesName) {
        j = i;
        x = x + w;
        if ((x+w+p)>self.w_) {
            j = 0;
            x = 0;
            y = y + h + p;
        }
        if(j>0)x += p;
        if(j==0)x = p;
        
        // 选项框
        CGRect frame = CGRectMake(x, y, w, h);
        UIButton *bt = [self createBtnWithFrame:frame Image: [UIImage imageNamed:@"bianji"]];
        bt.tag = 0;
        [bt setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [bt setTitle:item forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont fontWithName:kFontName size:14];
        if (iPhone4) {
            bt.titleLabel.font = [UIFont fontWithName:kFontName size:12];
        }
        [bt addTarget:self action:@selector(clickButtonBundle:) forControlEvents:UIControlEventTouchUpInside];
        [_countryView addSubview:bt];
        
        bt = nil;
        i++;
    }
    _countryView.frame = CGRectMake(0, self.h_, self.w_, y+h+10);
    [self addSubview:_countryView];
    [self sendSubviewToBack:_countryView];
}

-(void)createMainIndexViews{
    _starView = [[UIView alloc] initWithFrame:CGRectMake(0, self.h_, self.w_, 100)];
    _starView.backgroundColor = LTHEX(0x24273E);
//    [LTUtils drawLineAtSuperView:_starView andTopOrDown:0 andHeight:0.5 andColor:LTColorHex(0x111111)];
    // 主图指标
    [self createLableWithSize:16 Color:0xFFFFFF Point:CGPointMake(10, 21) Text:@"主图指标:" SuperView:_starView];
    // 副图指标
    [self createLableWithSize:16 Color:0xFFFFFF Point:CGPointMake(10, 61) Text:@"副图指标:" SuperView:_starView];
    
    CGFloat left = 85;
    CGFloat x = left;
    CGFloat y = 15;
    CGFloat w = 80;
    CGFloat h = 30;
    int i = 0;
    int j = 0;
    for (NSString *item in _mainIndexs) {
        j = i;
        x = x + w;
        if ((x+w+15)>self.w_) {
            j = 0;
            x = 0;
            y = y + h + 15;
        }
        if(j>0)x += 15;
        if(j==0)x = left;
        
        // 选项框
        CGRect frame = CGRectMake(x, y, w, h);
        UIImage *img =  [UIImage imageNamed:@"bianji"];
        UIButton *bt = [self createBtnWithFrame:frame Image:img];
        bt.tag = 0;
        [bt setTitle:item forState:UIControlStateNormal];
        CGFloat textlen = [item sizeWithFont:bt.titleLabel.font].width;
        [bt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, w-10-img.size.width)];
        [bt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, w-10-img.size.width-5-textlen)];
        [bt addTarget:self action:@selector(clickMainIndexButtonBundle:) forControlEvents:UIControlEventTouchUpInside];
        [_starView addSubview:bt];
        
        bt = nil;
        img = nil;
        i++;
    }
    // 清除指标按钮
    
    UIImage *img= [UIImage imageNamed:@"icon_closed_pressed"] ;
    UIButton *_clearButton = [self createBtnWithFrame:CGRectMake(x+w+10, y, 100, h) Image:img];
    _clearButton.backgroundColor = LTClearColor;
    [_clearButton setTitle:@" 清除指标" forState:UIControlStateNormal];
    CGFloat textlen = [@" 清除指标" sizeWithFont:_clearButton.titleLabel.font].width;
    [_clearButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, w-15-textlen)];
    [_clearButton addTarget:self action:@selector(clickClearButtonBundle:) forControlEvents:UIControlEventTouchUpInside];
    [_starView addSubview:_clearButton];
    _clearButton=nil;
    
    i = 0;
    j = 0;
    y = y + h + 10;
    x = left;
    for (NSString *item in _secondIndex) {
        j = i;
        x = x + w;
        if ((x+w+15)>self.w_) {
            j = 0;
            x = 0;
            y = y + h + 15;
        }
        if(j>0)x += 15;
        if(j==0)x = left;
        
        // 选项框
        UIImage *img= [UIImage imageNamed:@"bianji"] ;
        UIButton *bt =[self createBtnWithFrame:CGRectMake(x, y, w, h) Image:img];
        bt.tag = 0;
        bt.backgroundColor = LTClearColor;
        [bt setTitle:item forState:UIControlStateNormal];
        CGFloat textlen = [item sizeWithFont:bt.titleLabel.font].width;
        [bt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, w-10-img.size.width)];
        [bt setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, w-10-img.size.width-5-textlen)];
        [bt addTarget:self action:@selector(clickSecondIndexButtonBundle:) forControlEvents:UIControlEventTouchUpInside];
        [_starView addSubview:bt];
        
        bt = nil;
        img = nil;
        i++;
    }

    _starView.frame = CGRectMake(0, self.h_, self.w_, y+h+10);
    [self addSubview:_starView];
    [self sendSubviewToBack:_starView];
}

-(UILabel *)createLabWithFrame:(CGRect)frame
                          text:(NSString *)text
                      fontSize:(NSInteger)fsize
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = LTClearColor;
    label.font = autoFontSiz(fsize);
    label.textColor = LTWhiteColor;
    label.text = text;
    label.frame=frame;
    [label sizeToFit];
    return label;
}
-(CGPoint)createLableWithSize:(CGFloat)size Color:(int)colorhex Point:(CGPoint)point Text:(NSString*)text SuperView:(UIView *)view{
    UILabel *l = [[UILabel alloc] init];
    l.text = text;
    l.textColor = LTColorHex(colorhex);
    l.font = [UIFont fontWithName:kFontBoldName size:size];
    l.frame = CGRectMake(point.x, point.y, self.w_-point.x, 0);
    l.numberOfLines = 0;
    if (text) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:l.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [l.text length])];
        l.attributedText = attributedString;
    }
    
    [l sizeToFit];
    [view addSubview:l];
    CGPoint p = CGPointMake(l.x_+l.w_, l.y_);
    l = nil;
    return p;
}

-(UIButton *)createBtnWithFrame:(CGRect)frame
                          Image:(UIImage *)image
{
    //标题栏的返回键
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    btn.backgroundColor=[UIColor clearColor];
    [btn setImage:image forState:UIControlStateNormal];
    return btn;
}
#pragma mark - update
//更新价格
-(void)updateTitlesPrice:(QuotationDetailModel *)dish {
    if (dish) {
        if(dish.updown.floatValue<=0)
        {
            _changeProfit.text=[LTUtils priceFormat:dish.updown];
            dish.updownrate=[dish.updownrate replacStr:@"%" withStr:@""];
            _changeRate.text = [NSString stringWithFormat:@"%@%%",dish.updownrate];
        }
        else
        {
            _changeProfit.text=[NSString stringWithFormat:@"+%@",[LTUtils priceFormat:dish.updown]] ;
            dish.updownrate=[dish.updownrate replacStr:@"%" withStr:@""];
            _changeRate.text = [NSString stringWithFormat:@"+%@%%",dish.updownrate];
        }
        _NewPrice.text = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.sell.floatValue];
        _timelb.text = [LTUtils timeformat:[dish.quotetime floatValue]];
        
        [_NewPrice sizeToFit];
        [_changeProfit sizeToFit];
        [_changeRate sizeToFit];
        [_timelb sizeToFit];
        
        _timelb.frame = CGRectMake(p16, _timelb.y_, _timelb.w_, _timelb.h_);
        _NewPrice.frame=CGRectMake(_timelb.w_+_timelb.x_+pading+4, _timelb.h_+_timelb.y_-_NewPrice.h_, _NewPrice.w_, _NewPrice.h_);
        _changeProfit.frame = CGRectMake(_NewPrice.w_+_NewPrice.x_+pading, _changeProfit.y_, _changeProfit.w_, _changeProfit.h_);
        _changeRate.frame = CGRectMake(_changeProfit.w_+_changeProfit.x_+pading, _changeProfit.y_, _changeRate.w_, _changeRate.h_);
    }

    UIColor *color=LTKLineGreen;
    if ([dish.updownrate floatValue]>=0) {
        color = LTKLineRed;
    }
    _changeRate.textColor = _NewPrice.textColor = color;
    _changeProfit.textColor = _NewPrice.textColor = color;
    _NewPrice.textColor = _NewPrice.textColor = color;
    NSString *openPriceStr = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.open.floatValue];
    NSString *closePriceStr = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.lastclose.floatValue];
    NSString *heightPriceStr =[LTUtils decimalPriceWithCode:dish.code floatValue:dish.high.floatValue];
    NSString *lowPriceStr = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.low.floatValue];
    NSString *buyPriceStr = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.buy.floatValue];
    NSString *sellPriceStr = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.sell.floatValue];

    _openStr=openPriceStr;
    _closeStr=closePriceStr;
    _heightStr=heightPriceStr;
    _lowStr=lowPriceStr;
    _buyStr=buyPriceStr;
    _sellStr=sellPriceStr;
    
    _dateStr=_timelb.text;
    
    [self refreshView:dish];
}
//更新priceview显示
-(void)updatePriceViewsWithDatas:(DaysChartModel*)mchar {
    _closeLab.text=@"收盘：";
    _openLab.text=@"开盘：";
    
    [self refreshView:mchar];
}
-(void)updateZoushiTitleWithType:(NSString*)type{
    NSInteger index = [_types indexOfObject:type];
    index ++;
    if (index>_countryView.subviews.count) {
        return;
    }
    UIButton *item = (UIButton*)[_countryView.subviews objectAtIndex:index];
    // 设置勾选
    UIImage *img =  [UIImage imageNamed:@"bianji_gou"];
//    img = [LTUtils imageWithTintColor:LTColorHex(0x999999) blendMode:kCGBlendModeDestinationIn WithImageObject:img];
    [item setImage:img forState:UIControlStateNormal];
    item.tag = 1;
    [_countryButton setTitle:item.titleLabel.text forState:UIControlStateNormal];
    img = nil;
}

#pragma mark - actions
-(NSArray*)arraySelectedCountry{
    
    NSMutableArray *countrys = [NSMutableArray new];
    for (UIButton *bt in _countryView.subviews) {
        if (bt.tag==1) {
            NSInteger index = [_countryView.subviews indexOfObject:bt];
            index --;
            [countrys addObject:[_types objectAtIndex:index]];
        }
    }
    return countrys;
}
-(NSArray*)arraySelectedMainIndex{
    NSMutableArray *countrys = [NSMutableArray new];
    for (UIButton *bt in _starView.subviews) {
        if (bt.tag==1) {
            NSInteger index = [_starView.subviews indexOfObject:bt];
            if (index>2 && index<6) {
                NSInteger i = index - 3;
                [countrys addObject:[_mainIndexs objectAtIndex:i]];
            }
            
        }
    }
    return countrys;
}

-(NSArray*)arraySelectedSecondIndex{
    NSMutableArray *countrys = [NSMutableArray new];
    for (UIButton *bt in _starView.subviews) {
        if (bt.tag==1) {
            NSInteger index = [_starView.subviews indexOfObject:bt];
            if (index>6) {
                NSInteger i = index - 7;
                [countrys addObject:[_secondIndex objectAtIndex:i]];
            }
            
        }
    }
    return countrys;
}

-(void)clickButtonBundle:(UIButton*)sender{
    BOOL iselected = NO;
    [self clearZoushiButtonsBackground];
    [self updateZoushiTitleWithType:[_types objectAtIndex:[_countryView.subviews indexOfObject:sender]-1]];
    if (self.clickTypeButtonBlock) {
        self.clickTypeButtonBlock(self,[self arraySelectedCountry],iselected);
    }
    
    [self performSelector:@selector(clickMaskViewButtonBundle) withObject:nil afterDelay:0.3];
}

-(void)clickMainIndexButtonBundle:(UIButton*)sender{
    BOOL iselected = NO;
    [self clearIndexButtonsBackground:0];
    UIImage *img =  [UIImage imageNamed:@"bianji_gou"];
//    img = [LTUtils imageWithTintColor:LTColorHex(0x999999) blendMode:kCGBlendModeDestinationIn WithImageObject:img];
    if (sender.tag==1) {
        img =  [UIImage imageNamed:@"bianji"];
        sender.tag = 0;
        iselected = NO;
    }else{
        sender.tag = 1;
        iselected = YES;
    }
    [sender setImage:img forState:UIControlStateNormal];
 
    if (self.clickIndexButtonBlock) {
        self.clickIndexButtonBlock(self,[self arraySelectedMainIndex],iselected);
    }
    [self performSelector:@selector(clickMaskViewButtonBundle) withObject:nil afterDelay:0.3];
}

-(void)clickSecondIndexButtonBundle:(UIButton*)sender{
    BOOL iselected = NO;
    [self clearIndexButtonsBackground:1];
    UIImage *img =  [UIImage imageNamed:@"bianji_gou"];
//    img = [LTUtils imageWithTintColor:LTColorHex(0x999999) blendMode:kCGBlendModeDestinationIn WithImageObject:img];
    if (sender.tag==1) {
        img =  [UIImage imageNamed:@"bianji"];
        sender.tag = 0;
        iselected = NO;
    }else{
        sender.tag = 1;
        iselected = YES;
    }
    [sender setImage:img forState:UIControlStateNormal];
    
    if (self.clickIndexButtonBlock) {
        self.clickIndexButtonBlock(self,[self arraySelectedSecondIndex],iselected);
    }
    
    [self performSelector:@selector(clickMaskViewButtonBundle) withObject:nil afterDelay:0.3];
    
}


-(void)clickClearButtonBundle:(UIButton*)sender{
    [self clearIndexButtonsBackground:0];
    if (self.clickIndexButtonBlock) {
        self.clickIndexButtonBlock(self,nil,NO);
    }
    [self performSelector:@selector(clickMaskViewButtonBundle) withObject:nil afterDelay:0.3];
}
-(void)clickCountryButton:(UIButton*)bt{
    
    __block CGFloat h = _viewHeight;
    __block UIView *view;
    __block CGFloat starAlpha = 0;
    __block CGFloat countryAlpha = 0;
    
    if (![bt.titleLabel.text isEqualToString:@"指标"]) {
        _countryView.hidden = NO;
        _viewHeight = _height + _countryView.h_;
        _starButton.tag = 0;
        view = _countryView;
        countryAlpha = 1;
        starAlpha = 0;
        
    }else{
        _starView.hidden = NO;
        _viewHeight = _height + _starView.h_;
        _countryButton.tag = 0;
        view = _starView;
        countryAlpha = 0;
        starAlpha = 1;
    }
    // 伸展标志
    if (bt.tag==0) {
        bt.tag = 1;
        h = Screen_width;
        _maskView.hidden = NO;
    }else{
        h = _height;
        bt.tag = 0;
        _maskView.hidden = YES;
    }
    [self sendSubviewToBack:_maskView];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.countryView.alpha = countryAlpha;
        self.starView.alpha = starAlpha;
        self.maskView.alpha = 0.1;
    } completion:^(BOOL iscomplate){
        // 慢慢显示星级
        [UIView animateWithDuration:0.5 animations:^{
            view.alpha = 1;
        } completion:^(BOOL iscomplate){
            // 动画
            [UIView animateWithDuration:0.3 animations:^{
                self.frame = CGRectMake(self.x_, self.y_, self.w_, h);
            } completion:^(BOOL iscomplate){
                
            }];
        }];
        
    }];
    
    if (self.updateSelfViewBlock) {
        self.updateSelfViewBlock(self,h);
    }
    
}

-(void)clickMaskViewButtonBundle{
    // 收起
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(self.x_, self.y_, self.w_, self.height);
    } completion:^(BOOL iscomplate){
        self.countryButton.tag = 0;
        self.starButton.tag = 0;
    }];
}

-(void)clearZoushiButtonsBackground{
    for (UIButton *item in _countryView.subviews) {
        if ([[item class] isSubclassOfClass:[UIButton class]]) {
            [item setImage: [UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
            item.tag = 0;
        }
    }
}

-(void)clearIndexButtonsBackground:(int)type{
    for (UIButton *item in _starView.subviews) {
        if ([[item class] isSubclassOfClass:[UIButton class]]) {
            
            if ([_mainIndexs indexOfObject:item.titleLabel.text]!=NSNotFound && type==0) {
                [item setImage: [UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
                item.tag = 0;
            }
            if ([_secondIndex indexOfObject:item.titleLabel.text]!=NSNotFound && type==1) {
                [item setImage: [UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
                item.tag = 0;
            }
            
        }
    }
}

/**
 *  刷新价格以及时间label
 */

-(void)refreshView:(id)mo {
    NSString *timeStr =@"";
    NSString *openPriceStr = @"";
    NSString *closePriceStr = @"";
    NSString *heightPriceStr = @"";
    NSString *lowPriceStr = @"";
    NSString *buyPriceStr =@"";
    NSString *sellPriceStr = @"";
    
    CGFloat w = _buyPrice.w_;
    if ([mo isKindOfClass:[QuotationDetailModel class]]) {
        QuotationDetailModel *dish = mo;
        timeStr = [LTUtils timeformat:[dish.time floatValue]];
        openPriceStr = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.open.floatValue];
        closePriceStr = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.lastclose.floatValue];
        heightPriceStr =[LTUtils decimalPriceWithCode:dish.code floatValue:dish.high.floatValue];
        lowPriceStr = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.low.floatValue];
        buyPriceStr = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.buy.floatValue];
        sellPriceStr = [LTUtils decimalPriceWithCode:dish.code floatValue:dish.sell.floatValue];
        w = [LTUtils labelWithFontsize:fs text:openPriceStr]+2;
    }else if([mo isKindOfClass:[DaysChartModel class]]){
        DaysChartModel *mchar = mo;
        timeStr = [LTUtils timeformat:[mchar.time floatValue]];
        openPriceStr = [LTUtils priceFormat:mchar.openPrice];
        closePriceStr = [LTUtils priceFormat:mchar.closePrice];
        heightPriceStr = [LTUtils priceFormat:mchar.heightPrice];
        lowPriceStr = [LTUtils priceFormat:mchar.lowPrice];
        w = [LTUtils labelWithFontsize:fs text:openPriceStr]+4;
    }
    
    //时间刷新
    if (timeStr.length>0 && ![timeStr containsString:@"1970"]) {
        _timelb.text=timeStr;
    } else {
        _timelb.text=_dateStr;
    }
    [_timelb sizeToFit];
    _timelb.frame=CGRectMake(_timelb.x_, _timelb.y_, _timelb.w_, _timelb.h_);
    
    //买价
    if (buyPriceStr.length>0 && buyPriceStr.floatValue>0) {
        _buyPrice.text=buyPriceStr;
    } else {
        _buyPrice.text=_buyStr;
    }
    [_buyPrice sizeToFit];
    _buyPrice.frame=CGRectMake(_backButton.x_-w,_height/2-_buyPrice.h_-2, w, _buyPrice.h_);
    
    CGFloat x = _buyPrice.x_;
    CGFloat y = _buyPrice.y_;
    CGFloat h = _buyPrice.h_;
    [_buyLab sizeToFit];
    CGFloat w1 = _buyLab.w_;
    _buyLab.frame=CGRectMake(x-w1,y, w1, h);
    
    //最高
    if (heightPriceStr.length>0 && heightPriceStr.floatValue>0) {
        _heightPrice.text=heightPriceStr;
    }
    else {
        _heightPrice.text=_openStr;
    }
    _heightPrice.frame=CGRectMake(_buyLab.x_-w-pading,y, w, h);
    _heightLab.frame=CGRectMake(_heightPrice.x_-w1,y, w1, h);

    //开盘
    if (openPriceStr.length>0 && openPriceStr.floatValue>0) {
        _openPrice.text=openPriceStr;
    } else {
        _openPrice.text=_openStr;
    }
    _openPrice.frame=CGRectMake(_heightLab.x_-w-pading,y, w, h);
    _openLab.frame=CGRectMake(_openPrice.x_-w1,y, w1, h);

    y=_height/2+2;
    //卖价
    if (sellPriceStr.length>0 && sellPriceStr.floatValue>0) {
        _sellPrice.text=sellPriceStr;
    } else {
        _sellPrice.text=_sellStr;
    }
    _sellPrice.frame=CGRectMake(_buyPrice.x_,y, w, h);
    _sellLab.frame=CGRectMake(_buyLab.x_,y, w1, h);

    //最低
    if (lowPriceStr.length>0 && lowPriceStr.floatValue>0) {
        _lowPrice.text=lowPriceStr;
    }
    else {
        _lowPrice.text=_openStr;
    }
    _lowPrice.frame=CGRectMake(_heightPrice.x_,y, w, h);
    _lowLab.frame=CGRectMake(_heightLab.x_,y, w1, h);

    //收盘
    if (closePriceStr.length>0 && closePriceStr.floatValue>0) {
        _closePrice.text=closePriceStr;
    } else {
        _closePrice.text=_closeStr;
    }
    _closePrice.frame=CGRectMake(_openPrice.x_,y, w, h);
    _closeLab.frame=CGRectMake(_openLab.x_,y, w1, h);
}

-(void)returnBack
{
    if (self.clickReturnBackButtonBlock) {
        self.clickReturnBackButtonBlock();
    }
}
@end
