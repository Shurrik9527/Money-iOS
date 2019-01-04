//
//  NewBuyView.m
//  Canary
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "NewBuyView.h"
#import "DataHundel.h"
#import "UICountingLabel.h"
#import "HcdDateTimePickerView.h"

#define TITLES @[@"市价单", @"挂单"]
#define TITLES2 @[@"买涨限价",@"买涨止损",@"买跌限价",@"买跌止损"]

#define buyUpDownBtnTag 3000
#define addSubBgH       35
#define kBtnWH 51
#define kPriceTipH 24
@interface NewBuyView ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    UILabel * codeLabel;
    UILabel * chinaLabel;
    UILabel * priceInLabel;
    UILabel * priceOutLabel;
    UIButton * button1;
    UIButton * button2;
    CGFloat vw;
    BuyType buyType;
    NSString * priceInTop;
    NSString * priceInDown;
    NSString * priceOutTop;
    NSString * priceOutDown;
    HcdDateTimePickerView * dateTimePickerView;

}
@property(copy,nonatomic)NSString * buyType;
@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,strong) UIButton *buyBtn;

@property (nonatomic,strong)UIView * buyUpDownView;
@property (nonatomic,strong) UIButton *upBtn;
@property (nonatomic,strong) UIButton *downBtn;
@property (nonatomic,assign) BOOL buyDown;
@property (nonatomic,assign) BOOL isHaveDian;
@property (nonatomic,assign)   double rang;
@property (nonatomic,copy)NSString * priceIn;//socket买入价
@property (nonatomic,copy)NSString *priceOut;//socket 卖出价
@property (nonatomic,strong)UILabel * fundLbael;//余额
@property (nonatomic,copy)NSString * buyOrSell;//买涨买跌传的参数
@property (nonatomic,copy)NSString * zhisun;
@property (nonatomic,copy)NSString * zhiying;
@property (nonatomic,copy)NSString * guadanTime;
@property (nonatomic,copy)NSString * guadanType;//挂单四个字段


//事价单
@property (nonatomic,strong) UIButton *numBtnSub;//手数 -
@property (nonatomic,strong) UITextField *numField;//手数Field
@property (nonatomic,strong) UIButton *numBtnAdd;//手数 +
@property (nonatomic,strong) UIButton *lossBtn;//是否选择止损
@property (nonatomic,strong) UILabel * limLassLabel;//止损提示
@property (nonatomic,strong) UIButton *lossBtnSub;//止损 -
@property (nonatomic,strong) UIButton *lossBtnAdd;//止损 +
@property (nonatomic,strong) UITextField *lossField;//止损Field
@property (nonatomic,strong) UIButton *profitBtn;//是否选择止盈
@property (nonatomic,strong) UIButton *profitBtnSub;//止盈 -
@property (nonatomic,strong) UITextField *profitField;//止盈Field
@property (nonatomic,strong) UIButton *profitBtnAdd;//止盈 +
@property (nonatomic,strong) UILabel * profitLabel;//止盈提示
@property (nonatomic,strong)UILabel * yuanLabel;//元
//挂单
@property (nonatomic,strong) UIButton * typeBt;//类型
@property (nonatomic,strong)UIButton * dataBt;
@property (nonatomic,strong) UIButton *priceSubBt;//买入限价-
@property (nonatomic,strong) UITextField *priceField;//限价field
@property (nonatomic,strong) UIButton *priceAddBt;//买入限价 +
@property (nonatomic,strong) UILabel * buyMessage;
@property (nonatomic,strong) UIButton *GnumBtnSub;//手数 -
@property (nonatomic,strong) UITextField *GnumField;//手数Field
@property (nonatomic,strong) UIButton *GnumBtnAdd;//手数 +
@property (nonatomic,strong) UIButton *GlossBtn;//是否选择止损
@property (nonatomic,strong) UILabel * GlimLassLabel;//止损提示
@property (nonatomic,strong) UIButton *GlossBtnSub;//止损 -
@property (nonatomic,strong) UITextField *GlossField;//止损Field
@property (nonatomic,strong) UIButton *GlossBtnAdd;//止损 +
@property (nonatomic,strong) UIButton *GprofitBtn;//是否选择止盈
@property (nonatomic,strong) UILabel * GprofitLabel;//止盈提示
@property (nonatomic,strong) UIButton *GprofitBtnSub;//止盈 -
@property (nonatomic,strong) UITextField *GprofitField;//止盈Field
@property (nonatomic,strong) UIButton *GprofitBtnAdd;//止盈 +

@end
@implementation NewBuyView
-(instancetype)init
{
    self =[super init];
    if (self) {
        [self configContentH:kBuyViewH];
        self.contentView.backgroundColor = LTWhiteColor;
        self.hidden = YES;
        [self initView];
        [self getNetData];
    }
    return self;
}
#pragma mark - 创建界面
-(void)initView
{
    UIView * headerView  =[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 40)];
    headerView.backgroundColor =LTBgColor;
    [self.contentView addSubview:headerView];
    
    codeLabel =[[DataHundel shareDataHundle]createLabWithFrame:CGRectMake(self.contentView.w_/7, 5, 70, 30) text:nil fontsize:17];
    codeLabel.textColor =  HEXStrColor(@"#24273e");
    codeLabel.textAlignment = 2;
    [self.contentView addSubview:codeLabel];
    chinaLabel =[[DataHundel shareDataHundle]createLabWithFrame:CGRectMake(codeLabel.xw_, 5,80, 30) text:nil fontsize:12];
    chinaLabel.textAlignment = 0;
    chinaLabel.textColor =  HEXStrColor(@"#24273e");
    [self.contentView addSubview:chinaLabel];
    priceInLabel =[[DataHundel shareDataHundle]createLabWithFrame:CGRectMake(chinaLabel.xw_ , 5, 70, 30) text:nil fontsize:17];
    [self.contentView addSubview:priceInLabel];
    priceOutLabel = [[DataHundel shareDataHundle]createLabWithFrame:CGRectMake(priceInLabel.xw_ , 5, 70, 30) text:nil fontsize:17];
    [self.contentView addSubview:priceOutLabel];
    
    
    button1 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"市价单-激活"] forState:(UIControlStateSelected)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"市价单-未激活"] forState:(UIControlStateNormal)];
    [button1 addTarget:self action:@selector(selectIconButton1:) forControlEvents:(UIControlEventTouchUpInside)];
    button1.selected = YES;
    button1.frame = CGRectMake(10, headerView.yh_ + 10,( self.contentView.w_ - 20)/2, 45);
    [self.contentView addSubview:button1];
    
    button2 = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"挂单-未激活"] forState:(UIControlStateNormal)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"挂单-激活"] forState:(UIControlStateSelected)];
    [button2 addTarget:self action:@selector(selectIconButton2:) forControlEvents:(UIControlEventTouchUpInside)];
    button2.selected = NO;
    button2.frame = CGRectMake(button1.xw_, headerView.yh_ + 10,( self.contentView.w_ - 20)/2, 45);
    [self.contentView addSubview:button2];
    
    _superScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, button1.yh_ + 5 , Screen_width,  kBuyViewH - 105 - kFooterH)];
    _superScrollView.contentOffset = CGPointMake(0, 0);
    [_superScrollView setContentSize:CGSizeMake(Screen_width * 2, _superScrollView.h_)];
    _superScrollView.delegate = self;
    _superScrollView.showsHorizontalScrollIndicator = NO;
    [_superScrollView setPagingEnabled:YES];
    _superScrollView.userInteractionEnabled = YES;
    [self.contentView addSubview:_superScrollView];
    
    self.buyBtn = [UIButton btnWithTarget:self action:@selector(buyAction) frame:CGRectMake(10, _superScrollView.yh_ - 10, Screen_width - 20, kFooterH)];
    _buyBtn.titleLabel.font = boldFontSiz(16);
    _buyBtn.layer.cornerRadius = kFooterH/2;
    [_buyBtn.layer setMasksToBounds:YES];
    [_buyBtn setTitle:@"下  单" forState:UIControlStateNormal];
    [_buyBtn setTitleColorNSH:LTWhiteColor];
    [_buyBtn setNormalBgColor:[UIColor colorFromHexString:@"#4877e6"]];
    [self.contentView addSubview:_buyBtn];
    [self creatShiJiaDan];
    [self creatGuaDan];
}
-(void)creatShiJiaDan
{
    CGFloat kleft = 15;
    UIView * SView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW_Lit, _superScrollView.h_)];
    [_superScrollView addSubview:SView];
    
    _buyUpDownView = [[UIView alloc] init];
    _buyUpDownView.frame = CGRectMake(10, 5, ScreenW_Lit - 20, 40);
    [SView addSubview:_buyUpDownView];
    
    self.upBtn = [self upDownbtn:0 guadan:NO];
    [_buyUpDownView addSubview:_upBtn];
    
    self.downBtn = [self upDownbtn:1 guadan:NO];
    [_buyUpDownView addSubview:_downBtn];
    
    UILabel *titLab1 = [self lab:CGRectMake(kleft, self.upBtn.yh_ + 15, 70, 30) font:boldFontSiz(15) color:LTTitleColor];
    titLab1.text = @"建仓手数";
    [SView addSubview:titLab1];
    
    UIView * vouView =[[UIView alloc]initWithFrame:CGRectMake(_superScrollView.w_ - self.downBtn.w_ - 10- 20,self.upBtn.yh_ + 15, self.downBtn.w_ + 20, 30)];
    [SView addSubview:vouView];
    
    _numBtnSub = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(numSubActon)];
    _numBtnSub.selected = YES;
    [vouView addSubview:_numBtnSub];
    
    CGRect numFieldRect = CGRectMake(_numBtnSub.xw_, 0, vouView.w_ - 2*addSubBgH, addSubBgH);
    //手数输入框
    _numField = [self field:numFieldRect placeholder:@""];
    [vouView addSubview:_numField];
    
    _numBtnAdd = [self addBtn:CGRectMake(vouView.w_ - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(numAddActon)];
    _numBtnAdd.selected = YES;
    [vouView addSubview:_numBtnAdd];
    
    UILabel * numTipLab = [self lab:CGRectMake(_superScrollView.w_ - self.downBtn.w_ - 10- 20, vouView.yh_ + 5,self.downBtn.w_ + 20, 39) font:autoFontSiz(10) color:LTSubTitleColor];
    NSString *numTip =@" * 最小手数0.01手，最大可建仓手数:20手";
    numTipLab.numberOfLines = 0;
    numTipLab.text = numTip;
    [SView addSubview:numTipLab];
    
    UIView * grayView = [UIView lineFrame:CGRectMake(0, numTipLab.yh_ +5, self.w_, 24) color:LTBgColor];
    [SView addSubview:grayView];
    
    //是否选择止损
    _lossBtn = [UIButton btnWithTarget:self action:@selector(lossBtnAction) frame:CGRectMake(10, grayView.yh_  + 14.5, kBtnWH, kBtnWH)];
    [_lossBtn setNorImageName:@"icon_select_gray"];
    [_lossBtn setSelImageName:@"icon_select_blue"];
    [SView addSubview:_lossBtn];
    
    //'止损价格'
    UILabel *lLab = [self lab:CGRectMake(_lossBtn.xw_, grayView.yh_ + 10, 100, 27) font:boldFontSiz(15) color:LTTitleColor];
    lLab.text = @"止损价格";
    [SView addSubview:lLab];
    
    //止损描述
    _limLassLabel =[self lab:CGRectMake(_lossBtn.xw_, lLab.yh_, 110, 25) font:autoFontSiz(10) color:LTSubTitleColor];
    [SView addSubview:_limLassLabel];
    
    //止损背景
    UIView * lossView =[[UIView alloc]initWithFrame:CGRectMake(_superScrollView.w_ - self.downBtn.w_ - 10- 20,grayView.yh_  + 14.5, self.downBtn.w_ + 20, 30)];
    [SView addSubview:lossView];
    
    //止损 -
    _lossBtnSub = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(lossSubActon)];
    [lossView addSubview:_lossBtnSub];
    
    //止损Field
    CGRect FieldRect = CGRectMake(_lossBtnSub.xw_, 0, lossView.w_ - 2*addSubBgH, addSubBgH);
    _lossField = [self field:FieldRect placeholder:@"未设置止损价格"];
    _lossField.delegate = self;
    [_lossField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [lossView addSubview:_lossField];
    
    //止损 +
    _lossBtnAdd = [self addBtn:CGRectMake(lossView.w_ - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(lossAddActon)];
    [lossView addSubview:_lossBtnAdd];
    
    
    //是否选择止盈
    _profitBtn = [UIButton btnWithTarget:self action:@selector(profitBtnAction) frame:CGRectMake(10, _lossBtn.yh_  + 14.5, kBtnWH, kBtnWH)];
    [_profitBtn setNorImageName:@"icon_select_gray"];
    [_profitBtn setSelImageName:@"icon_select_blue"];
    [SView addSubview:_profitBtn];
    
    //止盈价格
    UILabel *pLab = [self lab:CGRectMake(_lossBtn.xw_, _lossBtn.yh_ + 10, 100, 27) font:boldFontSiz(15) color:LTTitleColor];
    pLab.text = @"止盈价格";
    [SView addSubview:pLab];
    
    //止盈描述
    _profitLabel =[self lab:CGRectMake(_lossBtn.xw_, pLab.yh_, 110, 25) font:autoFontSiz(10) color:LTSubTitleColor];
    [SView addSubview:_profitLabel];
    
    //止盈背景
    UIView * profitView =[[UIView alloc]initWithFrame:CGRectMake(_superScrollView.w_ - self.downBtn.w_ - 10- 20,_limLassLabel.yh_  + 14.5, self.downBtn.w_ + 20, 30)];
    [SView addSubview:profitView];
    
    //止盈 -
    _profitBtnSub = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(profitSubActon)];
    [profitView addSubview:_profitBtnSub];
    
    //止盈Field
    CGRect pFieldRect = CGRectMake(_profitBtnSub.xw_, 0, profitView.w_ - 2*addSubBgH, addSubBgH);
    _profitField = [self field:pFieldRect placeholder:@"未设置止盈价格"];
    [_profitField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [profitView addSubview:_profitField];
    
    //止盈 +
    _profitBtnAdd = [self addBtn:CGRectMake(profitView.w_ - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(profitAddActon)];
    [profitView addSubview:_profitBtnAdd];
    
    UILabel * balancelabel =[self lab:CGRectMake(10, SView.yh_ - 60, 50, 30) font:[UIFont systemFontOfSize:15] color:LTTitleColor];
    balancelabel.text= @"余额";
    [SView addSubview:balancelabel];
    
    if (!_fundLbael) {
        _fundLbael =[[UILabel alloc]initWithFrame:CGRectMake(balancelabel.xw_ + 10, SView.yh_ - 60, 250, 30)];
        _fundLbael.font =[UIFont systemFontOfSize:15];
        _fundLbael.textAlignment = NSTextAlignmentLeft;
        _fundLbael.textColor =[UIColor colorFromHexString:@"#4877e6"];
        [SView addSubview:_fundLbael];
    }
    
    UIButton * Recharge = [UIButton buttonWithType:(UIButtonTypeCustom)];
    Recharge.frame = CGRectMake(SView.w_ - 50,  SView.yh_ - 60, 40, 30);
    [Recharge setTitle:@"充值" forState:(UIControlStateNormal)];
    Recharge.titleLabel.font =[UIFont systemFontOfSize:15];
    [Recharge setTitleColor:[UIColor colorFromHexString:@"#4877e6"] forState:(UIControlStateNormal)];
    [Recharge addTarget:self action:@selector(rechangeAction) forControlEvents:(UIControlEventTouchUpInside)];
    [SView addSubview:Recharge];
    
    
}
#pragma mark- 市价单止损点击事件
//勾选止损
- (void)lossBtnAction {
    BOOL bl = !_lossBtn.selected;
    [self lossBtnSelected:bl];
}
- (void)lossBtnSelected:(BOOL)selected {
    _lossBtn.selected = selected;
    _lossBtnAdd.selected = selected;
    _lossBtnSub.selected = selected;
    _lossBtnAdd.enabled = selected;
    _lossBtnSub.enabled = selected;
    _lossField.enabled = selected;
    if (selected) { //选中
        if (_buyDown == NO) {
            _lossField.text = priceInTop;
        }else
        {
            _lossField.text = priceOutTop;
        }
    } else {
        _lossField.text = nil;
    }
}
//止损 -
- (void)lossSubActon {
    CGFloat minMovePoint =  self.rang;
    CGFloat lossf = [_lossField.text floatValue];
    lossf -= minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *loss = [NSString stringWithFormat:percentage,lossf];
    _lossField.text = loss;
}
//止损 +
- (void)lossAddActon {
    CGFloat minMovePoint =   self.rang;
    CGFloat lossf = [_lossField.text floatValue];
    lossf += minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *loss = [NSString stringWithFormat:percentage,lossf];
    _lossField.text = loss;
}
#pragma mark 止盈
//勾选止盈
- (void)profitBtnAction {
    BOOL bl = !_profitBtn.selected;
    [self profitBtnSelected:bl];
}
//勾选止盈
- (void)profitBtnSelected:(BOOL)selected {
    _profitBtn.selected = selected;
    _profitBtnAdd.selected = selected;
    _profitBtnSub.selected = selected;
    _profitBtnAdd.enabled = selected;
    _profitBtnSub.enabled = selected;
    _profitField.enabled = selected;
    if (selected) { //选中
        if (_buyDown == NO) {
            _profitField.text =priceInDown;
        }else
        {
            _profitField.text =priceOutDown;
        }
    } else {
        _profitField.text = nil;
    }
}
//止盈 -
- (void)profitSubActon {
    CGFloat minMovePoint =self.rang;
    CGFloat profilef = [_profitField.text floatValue];
    profilef -= minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *profile =[NSString stringWithFormat:percentage,profilef];
    _profitField.text = profile;
}
//止盈 +
- (void)profitAddActon {
    CGFloat minMovePoint = self.rang;
    CGFloat profilef = [_profitField.text floatValue];
    profilef += minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *profile = [NSString stringWithFormat:percentage,profilef];
    _profitField.text = profile;
}
#pragma mark - 手数点击事件
//购买手数 -
- (void)numSubActon {
    double addSubNumOneUnit = 0.01;
    double numf = [_numField.text doubleValue];
    numf -= addSubNumOneUnit;
    _numField.text = [NSString stringWithFormat:@"%.2f",numf];
    [self configNumData:YES];
}
//购买手数 +
- (void)numAddActon {
    double addSubNumOneUnit =0.01;
    double numf = [_numField.text doubleValue];
    numf += addSubNumOneUnit;
    _numField.text = [NSString stringWithFormat:@"%.2f",numf];
    [self configNumData:YES];
}
//购买手数 校验 填充数据
- (void)configNumData:(BOOL)check {
    CGFloat minSl =0.01;
    CGFloat numf = [_numField.text floatValue];
    if (numf <= minSl) {
        if (check) {
            numf = minSl;
        }
        _numBtnSub.selected = NO;
        _numBtnSub.enabled = NO;
    } else {
        _numBtnSub.selected = YES;
        _numBtnSub.enabled = YES;

    }
    
    CGFloat maxSl =20;
    if (numf >= maxSl) {
        if (check) {
            numf = maxSl;
        }
        _numBtnAdd.selected = NO;
        _numBtnAdd.enabled = NO;

    } else {
        _numBtnAdd.selected = YES;
        _numBtnAdd.enabled = YES;

    }
}


-(void)creatGuaDan
{
    UIView *GView =[[UIView alloc]initWithFrame:CGRectMake(_superScrollView.w_, 0, ScreenW_Lit, _superScrollView.h_)];
    [self.superScrollView addSubview:GView];
    
    UILabel *titLab1 = [self lab:CGRectMake(10, 10, 70, 30) font:boldFontSiz(15) color:LTTitleColor];
    titLab1.text = @"挂单类型";
    [GView addSubview:titLab1];
    
    UIView * typeView =[[UIView alloc]initWithFrame:CGRectMake(GView.w_ - 100, 10, 100, 30)];
    [GView addSubview:typeView];
    
    self.typeBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.typeBt.frame = CGRectMake(0, 0, 70, 30);
    [self.typeBt setTitle:@"买入限价" forState:UIControlStateNormal];
    [self.typeBt addTarget:self action:@selector(typeBtAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.typeBt.titleLabel.font = boldFontSiz(15);
    [self.typeBt setTitleColor:LTTitleColor forState:(UIControlStateNormal)];
    [typeView addSubview:self.typeBt];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(self.typeBt.xw_, 5, 20, 20)];
    image.image =[UIImage imageNamed:@"down-1"];
    [typeView addSubview:image];
    
    UILabel *titLab2 = [self lab:CGRectMake(10, titLab1.yh_ + 10, 70, 30) font:boldFontSiz(15) color:LTTitleColor];
    titLab2.text = @"买入限价";
    [GView addSubview:titLab2];
    
    UIView * view1 =[[UIView alloc]initWithFrame:CGRectMake(_superScrollView.w_ - self.downBtn.w_ - 10- 20,typeView.yh_ + 15, self.downBtn.w_ + 20, 30)];
    [GView addSubview:view1];
    
    _priceSubBt = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(GnumSubActon)];
    _priceSubBt.selected = YES;
    [view1 addSubview:_priceSubBt];
    
    CGRect numFieldRect = CGRectMake(_numBtnSub.xw_, 0, view1.w_ - 2*addSubBgH, addSubBgH);
    _priceField = [self field:numFieldRect placeholder:@"请输入挂单价"];
    [view1 addSubview:_priceField];
    
    _priceAddBt = [self addBtn:CGRectMake(view1.w_ - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(GnumAddActon)];
    _priceAddBt.selected = YES;
    [view1 addSubview:_priceAddBt];
    
    //止盈描述
    _buyMessage =[self lab:CGRectMake(GView.w_ - 200, view1.yh_ + 5, 190, 25) font:autoFontSiz(10) color:LTSubTitleColor];
    _buyMessage.textAlignment = 2;
    [GView addSubview:_buyMessage];
    
    UILabel *titLab3 = [self lab:CGRectMake(10, _buyMessage.yh_ + 10, 70, 30) font:boldFontSiz(15) color:LTTitleColor];
    titLab3.text = @"建仓手数";
    [GView addSubview:titLab3];
    
    UIView * view2 =[[UIView alloc]initWithFrame:CGRectMake(_superScrollView.w_ - self.downBtn.w_ - 10- 20,_buyMessage.yh_, self.downBtn.w_ + 20, 30)];
    [GView addSubview:view2];
    
    _GnumBtnSub = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(GuanumSubActon)];
    _GnumBtnSub.selected = YES;
    [view2 addSubview:_GnumBtnSub];
    
    CGRect numFieldRect2 = CGRectMake(_numBtnSub.xw_, 0, view2.w_ - 2*addSubBgH, addSubBgH);
    _GnumField = [self field:numFieldRect2 placeholder:@""];
    [view2 addSubview:_GnumField];
    
    _GnumBtnAdd = [self addBtn:CGRectMake(view2.w_ - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(GuanumAddActon)];
    _GnumBtnAdd.selected = YES;
    [view2 addSubview:_GnumBtnAdd];
    
    UILabel * numTipLab = [self lab:CGRectMake(_superScrollView.w_ - self.downBtn.w_ - 10- 20, view2.yh_ + 5,self.downBtn.w_ + 20, 39) font:autoFontSiz(10) color:LTSubTitleColor];
    NSString *numTip =@" * 最小手数0.01手，最大可建仓手数:20手";
    numTipLab.numberOfLines = 0;
    numTipLab.text = numTip;
    [GView addSubview:numTipLab];
    
    UILabel *titLab4 = [self lab:CGRectMake(10, numTipLab.yh_ + 10, 70, 30) font:boldFontSiz(15) color:LTTitleColor];
    titLab4.text = @"有效期";
    [GView addSubview:titLab4];
    
    UIView * timeView =[[UIView alloc]initWithFrame:CGRectMake(GView.w_ - 170, numTipLab.yh_ + 10, 170, 30)];
    [GView addSubview:timeView];
    
    UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7.5, 15, 15)];
    image1.image =[UIImage imageNamed:@"日历"];
    [timeView addSubview:image1];
    
    self.dataBt = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.dataBt.frame = CGRectMake(image1.w_, 0, 120, 30);
    [self.dataBt setTitle:@"点击选择日期" forState:UIControlStateNormal];
    [self.dataBt addTarget:self action:@selector(dataBtAction) forControlEvents:(UIControlEventTouchUpInside)];
    self.dataBt.titleLabel.font = [UIFont systemFontOfSize:11];
    [self.dataBt setTitleColor:LTSubTitleColor forState:(UIControlStateNormal)];
    [timeView addSubview:self.dataBt];
    
    UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.dataBt.xw_, 5, 20, 20)];
    image2.image =[UIImage imageNamed:@"down-1"];
    [timeView addSubview:image2];
    
    UIView * grayView = [UIView lineFrame:CGRectMake(0, timeView.yh_ +5, self.w_, 24) color:LTBgColor];
    [GView addSubview:grayView];
   
    
    //是否选择止损
    _GlossBtn = [UIButton btnWithTarget:self action:@selector(GlossBtnAction) frame:CGRectMake(10, grayView.yh_  + 14.5, kBtnWH, kBtnWH)];
    [_GlossBtn setNorImageName:@"icon_select_gray"];
    [_GlossBtn setSelImageName:@"icon_select_blue"];
    [GView addSubview:_GlossBtn];
    
    //'止损价格'
    UILabel *lLab = [self lab:CGRectMake(_lossBtn.xw_, grayView.yh_ + 10, 100, 27) font:boldFontSiz(15) color:LTTitleColor];
    lLab.text = @"止损价格";
    [GView addSubview:lLab];
    
    //止损描述
    _GlimLassLabel =[self lab:CGRectMake(_lossBtn.xw_, lLab.yh_, 120, 25) font:autoFontSiz(10) color:LTSubTitleColor];
    [GView addSubview:_GlimLassLabel];
    
    //止损背景
    UIView * lossView =[[UIView alloc]initWithFrame:CGRectMake(_superScrollView.w_ - self.downBtn.w_ - 10- 20,grayView.yh_  + 14.5, self.downBtn.w_ + 20, 30)];
    [GView addSubview:lossView];
    
    //止损 -
    _GlossBtnSub = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(GlossSubActon)];
    [lossView addSubview:_GlossBtnSub];
    
    //止损Field
    CGRect FieldRect = CGRectMake(_GlossBtnSub.xw_, 0, lossView.w_ - 2*addSubBgH, addSubBgH);
    _GlossField = [self field:FieldRect placeholder:@"未设置止损价格"];
    _GlossField.delegate = self;
    [_GlossField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [lossView addSubview:_GlossField];
    
    //止损 +
    _GlossBtnAdd = [self addBtn:CGRectMake(lossView.w_ - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(GlossAddActon)];
    [lossView addSubview:_GlossBtnAdd];
    
    
    //是否选择止盈
    _GprofitBtn = [UIButton btnWithTarget:self action:@selector(GprofitBtnAction) frame:CGRectMake(10, _GlossBtn.yh_  + 14.5, kBtnWH, kBtnWH)];
    [_GprofitBtn setNorImageName:@"icon_select_gray"];
    [_GprofitBtn setSelImageName:@"icon_select_blue"];
    [GView addSubview:_GprofitBtn];
    
    //止盈价格
    UILabel *pLab = [self lab:CGRectMake(_GlossBtn.xw_, _GlossBtn.yh_ + 10, 100, 27) font:boldFontSiz(15) color:LTTitleColor];
    pLab.text = @"止盈价格";
    [GView addSubview:pLab];
    
    //止盈描述
    _GprofitLabel =[self lab:CGRectMake(_GlossBtn.xw_, pLab.yh_, 120, 25) font:autoFontSiz(10) color:LTSubTitleColor];
    [GView addSubview:_GprofitLabel];
    
    //止盈背景
    UIView * profitView =[[UIView alloc]initWithFrame:CGRectMake(_superScrollView.w_ - self.downBtn.w_ - 10- 20,_GlimLassLabel.yh_  + 14.5, self.downBtn.w_ + 20, 30)];
    [GView addSubview:profitView];
    
    //止盈 -
    _GprofitBtnSub = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(GprofitSubActon)];
    [profitView addSubview:_GprofitBtnSub];
    
    //止盈Field
    CGRect pFieldRect = CGRectMake(_GprofitBtnSub.xw_, 0, profitView.w_ - 2*addSubBgH, addSubBgH);
    _GprofitField = [self field:pFieldRect placeholder:@"未设置止盈价格"];
    [_GprofitField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [profitView addSubview:_GprofitField];
    
    //止盈 +
    _GprofitBtnAdd = [self addBtn:CGRectMake(profitView.w_ - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(GprofitAddActon)];
    [profitView addSubview:_GprofitBtnAdd];
    
    self.guadanType =@"BUY_LIMIT";
    self.buyMessage.text = @"<=当前买入价-40个点";
    self.GlimLassLabel.text = @"<=挂单价-40个点";
    self.GprofitLabel.text = @">=挂单价+40个点";
}
#pragma mark- 挂单止损点击事件
//勾选止损
- (void)GlossBtnAction {
    BOOL bl = !_GlossBtn.selected;
    [self GlossBtnSelected:bl];
}
- (void)GlossBtnSelected:(BOOL)selected {
    _GlossBtn.selected = selected;
    _GlossBtnAdd.selected = selected;
    _GlossBtnSub.selected = selected;
    _GlossBtnAdd.enabled = selected;
    _GlossBtnSub.enabled = selected;
    _GlossField.enabled = selected;
    if (selected) { //选中
        if (_buyDown == NO) {
            _GlossField.text = priceInTop;
        }else
        {
            _GlossField.text = priceOutTop;
        }
    } else {
        _GlossField.text = nil;
    }
}
//止损 -
- (void)GlossSubActon {
    CGFloat minMovePoint =  self.rang;
    CGFloat lossf = [_GlossField.text floatValue];
    lossf -= minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *loss = [NSString stringWithFormat:percentage,lossf];
    _GlossField.text = loss;
}
//止损 +
- (void)GlossAddActon {
    CGFloat minMovePoint =   self.rang;
    CGFloat lossf = [_GlossField.text floatValue];
    lossf += minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *loss = [NSString stringWithFormat:percentage,lossf];
    _GlossField.text = loss;
}
#pragma mark 止盈
//勾选止盈
- (void)GprofitBtnAction {
    BOOL bl = !_GprofitBtn.selected;
    [self GprofitBtnSelected:bl];
}
//勾选止盈
- (void)GprofitBtnSelected:(BOOL)selected {
    _GprofitBtn.selected = selected;
    _GprofitBtnAdd.selected = selected;
    _GprofitBtnSub.selected = selected;
    _GprofitBtnAdd.enabled = selected;
    _GprofitBtnSub.enabled = selected;
    _GprofitField.enabled = selected;
    if (selected) { //选中
        if (_buyDown == NO) {
            _GprofitField.text =priceInDown;
        }else
        {
            _GprofitField.text =priceOutDown;
        }
    } else {
        _GprofitField.text = nil;
    }
}
//止盈 -
- (void)GprofitSubActon {
    CGFloat minMovePoint =self.rang;
    CGFloat profilef = [_GprofitField.text floatValue];
    profilef -= minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *profile =[NSString stringWithFormat:percentage,profilef];
    _GprofitField.text = profile;
}
//止盈 +
- (void)GprofitAddActon {
    CGFloat minMovePoint = self.rang;
    CGFloat profilef = [_GprofitField.text floatValue];
    profilef += minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *profile = [NSString stringWithFormat:percentage,profilef];
    _GprofitField.text = profile;
}
#pragma mark - 挂单事件
//挂单价-
- (void)GnumSubActon {
    CGFloat minMovePoint =  self.rang;
    CGFloat lossf = [_priceField.text floatValue];
    lossf -= minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *loss = [NSString stringWithFormat:percentage,lossf];
    _priceField.text = loss;
}
//挂单价 +
- (void)GnumAddActon {
    CGFloat minMovePoint =   self.rang;
    CGFloat lossf = [_priceField.text floatValue];
    lossf += minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *loss = [NSString stringWithFormat:percentage,lossf];
    _priceField.text = loss;
}
//手数-
- (void)GuanumSubActon {
    double addSubNumOneUnit = 0.01;
    double numf = [_GnumField.text doubleValue];
    numf -= addSubNumOneUnit;
    _GnumField.text = [NSString stringWithFormat:@"%.2f",numf];
    [self GconfigNumData:YES];
}
//手数 +
- (void)GuanumAddActon {
    double addSubNumOneUnit =0.01;
    double numf = [_GnumField.text doubleValue];
    numf += addSubNumOneUnit;
    _GnumField.text = [NSString stringWithFormat:@"%.2f",numf];
    [self GconfigNumData:YES];
}

//购买手数 校验 填充数据
- (void)GconfigNumData:(BOOL)check {
    CGFloat minSl =0.01;
    CGFloat numf = [_GnumField.text floatValue];
    if (numf <= minSl) {
        if (check) {
            numf = minSl;
        }
        _GnumBtnSub.selected = NO;
        _GnumBtnSub.enabled = NO;
    } else {
        _GnumBtnSub.selected = YES;
        _GnumBtnSub.enabled = YES;
        
    }
    
    CGFloat maxSl =20;
    if (numf >= maxSl) {
        if (check) {
            numf = maxSl;
        }
        _GnumBtnAdd.selected = NO;
        _GnumBtnAdd.enabled = NO;
        
    } else {
        _GnumBtnAdd.selected = YES;
        _GnumBtnAdd.enabled = YES;
    }
}
//textfield已经编辑
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isEqual:_numField]) {
        if (textField.text.floatValue <= 0.01) {
            textField.text = @"0.01";
            [self showMyMessage:@"亲，建仓最小手数是0.01 !"];
            [self configNumData:YES];
        }else if (textField.text.floatValue >= 20)
        {
            textField.text = @"20";
            [self showMyMessage:@"亲，建仓最大手数是20 !"];
            [self configNumData:NO];
        }
    }else if ([textField isEqual:_GnumField])
    {
        if (textField.text.floatValue <= 0.01) {
            textField.text = @"0.01";
            [self showMyMessage:@"亲，建仓最小手数是0.01 !"];
            [self GconfigNumData:YES];
        }else if (textField.text.floatValue >= 20)
        {
            textField.text = @"20";
            [self showMyMessage:@"亲，建仓最大手数是20 !"];
            [self GconfigNumData:NO];
        }
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _lossField &&_lossBtn.selected == NO) {
        return NO;
    }else if (textField == _lossField && _profitBtn.selected )
    {
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:_numField]||[textField isEqual:_GnumField]) {
        if ([textField.text rangeOfString:@"."].location == NSNotFound)
        {
            _isHaveDian = NO;
        }
        if ([string length] > 0)
        {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
            {
                //首字母不能为0和小数点
                if([textField.text length] == 0)
                {
                    if(single == '.')
                    {
                        [self showMyMessage:@"亲，第一个数字不能为小数点!"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                if ([textField.text length] ==1) {
                    if (single == '0')
                    {
                        
                        [self showMyMessage:@"亲，第二个数字不能为0!"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                //输入的字符是否是小数点
                if (single == '.')
                {
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian = YES;
                        return YES;
                    }else{
                        [self showMyMessage:@"亲，您已经输入过小数点了!"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }else{
                    
                    if (_isHaveDian) {//存在小数点
                        //判断小数点的位数
                        NSRange ran = [textField.text rangeOfString:@"."];
                        if (range.location - ran.location <= 2) {
                            
                            return YES;
                            
                        }else{
                            
                            [self showMyMessage:@"亲，您最多输入两位小数!"];
                            return NO;
                        }
                    }else{
                        
                        return YES;
                    }
                }
                
            }else{//输入的数据格式不正确
                
                [self showMyMessage:@"亲，您输入的格式不正确!"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }else
        {
            return YES;
        }
    }
    else if ([textField isEqual:_lossField]||[textField isEqual:_profitField]||[textField isEqual:_priceField])
    {
        if ([textField.text rangeOfString:@"."].location == NSNotFound)
        {
            _isHaveDian = NO;
        }
        if ([string length] > 0)
        {
            unichar single = [string characterAtIndex:0];//当前输入的字符
            if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
            {
                //首字母不能为0和小数点
                if([textField.text length] == 0)
                {
                    if(single == '.')
                    {
                        [self showMyMessage:@"亲，第一个数字不能为小数点!"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
                //输入的字符是否是小数点
                if (single == '.')
                {
                    if(!_isHaveDian)//text中还没有小数点
                    {
                        _isHaveDian = YES;
                        return YES;
                    }else{
                        [self showMyMessage:@"亲，您已经输入过小数点了!"];
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }
            else{//输入的数据格式不正确
                [self showMyMessage:@"亲，您输入的格式不正确!"];
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                return NO;
            }
        }
    }
    return YES;
}
#pragma mark - 按钮和scrollerView联动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.superScrollView.bounds.origin.x == 0){
        button1.selected = YES;
        button2.selected = NO;
        [_buyBtn setTitle:@"下  单" forState:UIControlStateNormal];
    }else if (self.superScrollView.bounds.origin.x == Screen_width) {
        button2.selected = YES;
        button1.selected = NO;
        [_buyBtn setTitle:@"提  交" forState:UIControlStateNormal];
    }
}
- (void)selectIconButton1:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        button2.selected = NO;
        _superScrollView.contentOffset = CGPointMake(0, 0);
        [_buyBtn setTitle:@"下  单" forState:UIControlStateNormal];
    }
    else{
        button2.selected = YES;
        
    }
}
- (void)selectIconButton2:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected == YES){
        button1.selected = NO;
        _superScrollView.contentOffset = CGPointMake(Screen_width, 0);
        [_buyBtn setTitle:@"提  交" forState:UIControlStateNormal];
    }
    else{
        button1.selected = YES;
    }
}

- (UIButton *)upDownbtn:(NSInteger)idx  guadan:(BOOL)guadan{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(selBuyUpOrDownAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = buyUpDownBtnTag + idx;
    
    UIImage *norImg= nil;
    UIImage *selImg = nil;
    CGFloat x = 0;
    CGFloat w =_buyUpDownView.w_/2;
    if (idx == 0) {
        norImg = [UIImage imageNamed:@"buy_tabBg_LeftGrey"];
        selImg = [UIImage imageNamed:@"buy_tabBg_LeftRed"];
        x = 0;
    } else {
        norImg = [UIImage imageNamed:@"buy_tabBg_RightGrey"];
        selImg = [UIImage imageNamed:@"buy_tabBg_RightGreen"];
        x = w-1;
    }
    btn.frame = CGRectMake(x, 0, w, 40);
    [btn setNorBGImage:norImg];
    [btn setSelBGImage:selImg];
    [btn setHigBGImage:selImg];
    btn.titleLabel.font = [UIFont boldFontOfSize:15.f];
    return btn;
}


#pragma mark - Socket传的数据
-(void)addCode :(NSString *)code code_cn:(NSString *)code_cn prcieIn:(NSString*)priceI  priceOut:(NSString *)priceOut
{
    if (self.change > 0) {
        priceInLabel.textColor = LTKLineRed;
        priceOutLabel.textColor = LTKLineRed;
    }else
    {
        priceInLabel.textColor = LTKLineGreen;
        priceOutLabel.textColor = LTKLineGreen;
    }
    chinaLabel.text = code_cn;
    codeLabel.text = code;
    //  NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    priceInLabel.text = priceI;
    priceOutLabel.text =priceOut;
    switch (self.dataly) {
        case 1:
            self.rang = 0.1;
            break;
        case 2:
            self.rang = 0.01;
            break;
        case 3:
            self.rang =0.001;
            break;
        case 4:
            self.rang = 0.0001;
            break;
        case 5:
            self.rang = 0.00001;
            break;
        default:
            break;
    }
    double priceInValue =priceI.doubleValue;
    double priceOutValue = priceOut.doubleValue;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    priceInTop =[NSString stringWithFormat:percentage,priceInValue - 40 *   self.rang];
    priceInDown =[NSString stringWithFormat:percentage,priceInValue + 40 *   self.rang];
    priceOutTop =[NSString stringWithFormat:percentage,priceOutValue + 40*  self.rang];
    priceOutDown =[NSString stringWithFormat:percentage,priceOutValue - 40*  self.rang];
    if (_buyDown == NO) {
        _limLassLabel.text =[NSString stringWithFormat:@"%@ %@",@"止损价格<=",priceInTop];
        _profitLabel.text = [NSString stringWithFormat:@"%@ %@",@"止盈价格>=",priceInDown];
    }else
    {
        _limLassLabel.text =[NSString stringWithFormat:@"%@ %@",@"止损价格>=",priceOutTop];
        _profitLabel.text = [NSString stringWithFormat:@"%@ %@",@"止盈价格<=",priceOutDown];
    }
    
}
//选买涨or跌
- (void)selBuyUpOrDownAction:(UIButton *)sender {
    self.buyDown = sender.tag > buyUpDownBtnTag;
    buyType = _buyDown ? BuyType_Down : BuyType_Up;
    [self configBuyType];
}
//买涨买跌
- (void)configBuyType {
    _downBtn.selected = _buyDown;
    _upBtn.selected = !_buyDown;
    _buyBtn.selected = _buyDown;
}
- (void) buyType:(BuyType)buyType {
    if (buyType != BuyType_Non) {
        buyType = buyType;
        if (buyType == BuyType_Down) {
            _buyDown = YES;
        }
        else if (buyType == BuyType_Up) {
            _buyDown = NO;
        }
    }
    [self configMo];
    if (buyType != BuyType_Non) {
        [self configBuyType];
    }
}
- (void)showView:(BOOL)show {
    [super showView:show];
    if (show) {
        _numField.text = @"0.01";
        _GnumField.text = @"0.01";
        [self configNumData:YES];
        [self GconfigNumData:YES];
        
        [self lossBtnSelected:NO];
        [self profitBtnSelected:NO];
        [self GlossBtnSelected:NO];
        [self GprofitBtnSelected:NO];
        button1.selected = YES;
        button2.selected = NO;
        _superScrollView.contentOffset = CGPointMake(0, 0);

    } else {
        [self textFieldDone];
    }
}
-(void)dataBtAction
{
    
    WS(ws);
    dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateTimeMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    dateTimePickerView.topViewColor =[UIColor colorFromHexString:@"#4877e6"];
    dateTimePickerView.buttonTitleColor = [UIColor whiteColor];
    [dateTimePickerView setMinYear:1999];
    [dateTimePickerView setMaxYear:2018];
    dateTimePickerView.title = @"挂单日期";
    dateTimePickerView.titleColor = [UIColor whiteColor];
    dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        [ws.dataBt setTitle:datetimeStr forState:(UIControlStateNormal)];
        long long dateTime =[DataHundel getZiFuChuan:datetimeStr];
        NSNumber *longlongNumber = [NSNumber numberWithLongLong:dateTime];
        NSString *longlongStr = [longlongNumber stringValue];
        ws.guadanTime =[DataHundel ConvertStrToTime:longlongStr];
    };
    if (dateTimePickerView) {
        [AppKeyWindow addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
}
-(void)typeBtAction
{
#define TITLES2 @[@"买涨限价",@"买涨止损",@"买跌限价",@"买跌止损"]
    WS(ws);
    //显示弹出框列表选择
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"买入限价"
                                                                   message:@"请选择类型"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"买涨限价" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             ws.guadanType =@"BUY_LIMIT";
                                                             ws.buyMessage.text = @"<=当前买入价-40个点";
                                                             ws.GlimLassLabel.text = @"<=挂单价-40个点";
                                                             ws.GprofitLabel.text = @">=挂单价+40个点";
                  
                                                         }];
    UIAlertAction* deleteAction = [UIAlertAction actionWithTitle:@"买涨止损" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             ws.guadanType =@"BUY_STOP";
                                                             ws.buyMessage.text = @">=当前买入价+40个点";
                                                             ws.GlimLassLabel.text = @"<=挂单价-40个点";
                                                             ws.GprofitLabel.text = @">=挂单价+40个点";
                                                         }];
    UIAlertAction* saveAction = [UIAlertAction actionWithTitle:@"买跌限价" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           ws.guadanType =@"SELL_LIMIT";
                                                           ws.buyMessage.text = @"*>=当前买出价+40个点";
                                                           ws.GlimLassLabel.text = @">=挂单价+40个点";
                                                           ws.GprofitLabel.text = @"<=挂单价-40个点";
                                                       }];
    UIAlertAction* myAction = [UIAlertAction actionWithTitle:@"买跌止损" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           ws.guadanType =@"SELL_STOP";
                                                           ws.buyMessage.text = @"*<=当前买出价-40个点";
                                                           ws.GlimLassLabel.text = @">=挂单价+40个点";
                                                           ws.GprofitLabel.text = @"<=挂单价-40个点";
                                                       }];
    [alert addAction:saveAction];
    [alert addAction:cancelAction];
    [alert addAction:deleteAction];
    [alert addAction:myAction];
    [[self viewController] presentViewController:alert animated:YES completion:nil];
}
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
- (void)configMo {
    //买涨、买跌
    NSString *upstr =@"买涨";
    NSAttributedString *upNorABStr = [self ABString:upstr bigColor:LTTitleColor bigFont:autoFontSiz(15) color:LTColorHex(0x999999) font:fontSiz(10) range:NSMakeRange(3, 0)];
    NSAttributedString *upSelABStr = [self ABString:upstr bigColor:LTWhiteColor bigFont:boldFontSiz(15) color:LTWhiteColor font:fontSiz(10) range:NSMakeRange(3,0)];
    [_upBtn setAttributedTitle:upNorABStr forState:UIControlStateNormal];
    [_upBtn setAttributedTitle:upSelABStr forState:UIControlStateSelected];
    [_upBtn setAttributedTitle:upSelABStr forState:UIControlStateHighlighted];
    
    NSString *downstr = @"买跌";
    NSAttributedString *downNorABStr = [self ABString:downstr bigColor:LTTitleColor bigFont:fontSiz(15) color:LTColorHex(0x999999) font:fontSiz(10) range:NSMakeRange(3, 0)];
    NSAttributedString *downSelABStr = [self ABString:downstr bigColor:LTWhiteColor bigFont:boldFontSiz(15) color:LTWhiteColor font:autoFontSiz(10) range:NSMakeRange(3, 0)];
    [_downBtn setAttributedTitle:downNorABStr forState:UIControlStateNormal];
    [_downBtn setAttributedTitle:downSelABStr forState:UIControlStateSelected];
    [_downBtn setAttributedTitle:downSelABStr forState:UIControlStateHighlighted];
    
    
    //手数校验
    [self configNumData:NO];
    [self GconfigNumData:NO];
}
#pragma mark - 网络请求
-(void)getNetData
{
    if (notemptyStr([NSUserDefaults objFoKey:MT4ID])) {
        NSString * urlString = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/user/extened"];
        NSDictionary * dic = @{@"mt4id":[NSUserDefaults objFoKey:MT4ID]};
        [[NetworkRequests sharedInstance]GET:urlString dict:dic succeed:^(id data) {
            if ([[data objectForKey:@"code"]integerValue] == 0) {
                NSDictionary * dic = [data objectForKey:@"dataObject"];
                NSString * yue = [dic objectForKey:@"balance"];
                NSString * string = [NSString stringWithFormat:@"%@%@",yue,@"元"];
                NSMutableAttributedString *attrDescribeStr = [[NSMutableAttributedString alloc] initWithString:string];
                [attrDescribeStr addAttribute:NSForegroundColorAttributeName
                                        value:[UIColor blackColor]
                                        range:[string rangeOfString:@"元"]];
                self.fundLbael.attributedText = attrDescribeStr;
            }
        } failure:^(NSError *error) {
            
        }];
    }
}
//建仓
-(void)buyAction
{
        if (_buyDown) {
            self.buyOrSell = @"SELL";
        }else
        {
            self.buyOrSell =@"BUY";
        }
        NSString * urlString = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/trading/execute"];
        if ([self.buyBtn.titleLabel.text isEqualToString:@"下  单"]) {
            if (emptyStr(_lossField.text)) {
                _zhisun = @"0";
            }else
            {
                _zhisun = _lossField.text;
            }
            if (emptyStr(_profitField.text)) {
                _zhiying = @"0";
            }else
            {
                _zhiying =_profitField.text;

            }
            NSDictionary * dic = @{@"server":[NSUserDefaults objFoKey:TYPE],@"mt4id":[NSUserDefaults objFoKey:MT4ID],@"symbol":self.code,@"type":self.buyOrSell,@"volume":@"1",@"sl":_zhisun,@"tp":_zhiying,@"price":@"0"};
            [[NetworkRequests sharedInstance]POST:urlString dict:dic succeed:^(id data) {
                if ([[data objectForKey:@"code"]integerValue]  == 0) {
                    self.buyFinish();
                }
                if ([[data objectForKey:@"code"]integerValue] == 210) {
                    [self showMyMessage:[data objectForKey:@"已休市"]];
                }
            } failure:^(NSError *error) {
                
            }];
        }else
        {
            if (emptyStr(_GlossField.text)) {
                _zhisun = @"0";
            }else
            {
                _zhisun = _GlossField.text;
            }
            if (emptyStr(_GprofitField.text)) {
                _zhiying = @"0";
            }else
            {
                _zhiying =_GprofitField.text;
                
            }
            if (emptyStr(self.guadanTime)) {
                [self showMyMessage:@"请选择时间"];
                return;
            }
            NSDictionary * dictionary = @{@"server":[NSUserDefaults objFoKey:TYPE],@"mt4id":[NSUserDefaults objFoKey:MT4ID],@"symbol":self.code,@"type":self.guadanType,@"volume":@"1",@"sl":_zhisun,@"tp":_zhiying,@"price":_priceField.text,@"expiredDate":self.guadanTime};
            [[NetworkRequests sharedInstance]POST:urlString dict:dictionary succeed:^(id data) {
                if ([[data objectForKey:@"code"]integerValue]  == 0) {
                    self.buyFinish();
                }
                else   if ([[data objectForKey:@"code"]integerValue] == 210) {
                    [self showMyMessage:[data objectForKey:@"已休市"]];
                }else
                {
                    [self showMyMessage:@"挂单失败"];
                }
            } failure:^(NSError *error) {

            }];
            
        }
    
}
//---------------------Tool------------------
- (NSMutableAttributedString *)ABString:(NSString *)str
                               bigColor:(UIColor *)bigColor bigFont:(UIFont *)bigFont
                                  color:(UIColor *)color font:(UIFont *)font range:(NSRange)range {
    
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc]initWithString:str];
    [ABStr setAttributes:@{NSForegroundColorAttributeName:bigColor,
                           NSFontAttributeName:bigFont}
                   range:NSMakeRange(0, 2)];
    [ABStr setAttributes:@{NSForegroundColorAttributeName:color,
                           NSFontAttributeName:font}
                   range:range];
    return ABStr;
}
- (UILabel *)lab:(CGRect)frame font:(UIFont *)font color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.font = font;
    lab.textColor = color;
    return lab;
}
- (UITextField *)field:(CGRect)rect placeholder:(NSString *)placeholder {
    UIFont *font = fontSiz(15);
    UIFont *pFont = fontSiz(11);
    UITextField *field = [[UITextField alloc] initWithFrame:rect];
    field.font = font;
    field.textColor = LTTitleColor;
    field.textAlignment = NSTextAlignmentCenter;
    field.keyboardType = UIKeyboardTypeDecimalPad;
    field.delegate = self;
    field.inputAccessoryView = [self addToolbar];
    NSAttributedString *attrString = [placeholder ABStrFont:font placeholderFont:pFont color:LTSubTitleColor];
    field.attributedPlaceholder = attrString;
    
    return field;
}
- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = LTBgColor;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}
- (void)textFieldDone {
    [self yZeroMove];
    ShutAllKeyboard;
}
- (void)yZeroMove {
    WS(ws);
    [UIView animateWithDuration:0.2 animations:^{
        [ws setOY:0];
    }];
}
- (UIButton *)subBtn:(CGRect)rect action:(SEL)action {
    UIButton *btn = [UIButton btnWithTarget:self action:action frame:rect];
    [btn setNorImageName:@"-N"];
    [btn setSelImageName:@"-Y"];
    [btn setHigImageName:@"-Y"];
    return btn;
}

- (UIButton *)addBtn:(CGRect)rect action:(SEL)action {
    UIButton *btn = [UIButton btnWithTarget:self action:action frame:rect];
    [btn setNorImageName:@"+N"];
    [btn setSelImageName:@"+Y"];
    [btn setHigImageName:@"+Y"];
    return btn;
}
-(void)showMyMessage:(NSString*)aInfo {
    if (aInfo.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}
- (void)textFieldDidChange:(UITextField *)textField  {
    
}
-(void)rechangeAction
{
    self.prensentBlock();
}
@end
