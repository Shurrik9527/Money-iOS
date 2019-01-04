//
//  BuyView.m
//  Canary
//
//  Created by litong on 2017/5/26.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BuyView.h"
#import "Quotation.h"
#import "WarningView.h"
#import "DataHundel.h"
#import "HMSegmentedControl.h"
#import "HcdDateTimePickerView.h"
#define kTabH           40
#define kFooterH        50
#define buyUpDownBtnTag 3000

@interface BuyView ()<UITextFieldDelegate,UIScrollViewDelegate>
{
    CGFloat vw;
    CGFloat midH;
    CGFloat addSubBgW;
    CGFloat contentW;
    CGFloat marginLevel;
    CGFloat equity;//净值
    CGFloat margin;//已用预付款
    HcdDateTimePickerView * dateTimePickerView;
    BOOL alertFlag;
    BOOL reqFlag;
    NSString * priceInTop;
    NSString * priceInDown;
    NSString * priceOutTop;
    NSString * priceOutDown;
}
@property (nonatomic,copy)NSString * priceIn;//socket买入价
@property (nonatomic,copy)NSString *priceOut;//socket 卖出价


@property (nonatomic,strong)HMSegmentedControl *segment;
@property (nonatomic,strong) UIScrollView *superScrollView;
@property (nonatomic,copy) NSString *availableAdvance;//可用预付款
@property (nonatomic,strong)UILabel * balanceLabel;//余额label
@property (nonatomic,strong)UILabel *lossDescribeLabel;//止损描述
@property (nonatomic,strong)UILabel * ProfitDescribLable;//止盈描述;
@property (nonatomic,strong)UIButton * RechargeButton;//充值按钮
@property (nonatomic,copy)NSString * buyOrSell;//买涨买跌传的参数
@property (nonatomic,strong)UIView * guadanbackView;//挂单选项卡背景

@property (nonatomic,assign) BuyType buyType;
@property (nonatomic,assign)   double rang;

@property (nonatomic,assign)BOOL isHaveDian;//是否有小数点

@property (nonatomic,assign) CGFloat curPrice;

@property (nonatomic,strong) UIView *tabView;
@property (nonatomic,strong) UILabel *nameLab;//产品名称
@property (nonatomic,strong) UILabel *closeMarkLab;//休市中

@property (nonatomic,strong) WarningView *warningView;//合约到期

@property (nonatomic,strong) UIView *midView;
@property (nonatomic,strong) UIView *buyUpDownView;//买涨买跌
@property (nonatomic,strong) UIButton *upBtn;
@property (nonatomic,strong) UIButton *downBtn;
@property (nonatomic,assign) BOOL buyDown;//YES:买跌

@property (nonatomic,strong) UIView *numView;//购买手数
@property (nonatomic,strong) UIButton *numBtnSub;//手数 -
@property (nonatomic,strong) UITextField *numField;//手数Field
@property (nonatomic,strong) UIButton *numBtnAdd;//手数 +
@property (nonatomic,strong) UILabel *numTipLab;//* 最小手数0.01手，最大可建仓手数：30手

@property (nonatomic,strong) UIView *grayView;
@property (nonatomic,strong) UILabel *earnTipLab;//每涨1个点，赚1美元

@property (nonatomic,strong) UIView *profitLossView;
@property (nonatomic,strong) UIButton *lossBtn;//是否选择止损
@property (nonatomic,strong) UIButton *lossBtnSub;//止损 -
@property (nonatomic,strong) UITextField *lossField;//止损Field
@property (nonatomic,assign) BOOL lossFieldEditing;//
@property (nonatomic,copy) NSString *editBeforeLoss;
@property (nonatomic,strong) UIButton *lossBtnAdd;//止损 +
@property (nonatomic,strong) UILabel *lossPriceTip;//止损价格与损失


@property (nonatomic,strong) UIButton *profitBtn;//是否选择止盈
@property (nonatomic,strong) UIButton *profitBtnSub;//止盈 -
@property (nonatomic,strong) UITextField *profitField;//止盈Field
@property (nonatomic,assign) BOOL profitFieldEditing;//
@property (nonatomic,copy) NSString *editBeforeProfit;
@property (nonatomic,strong) UIButton *profitBtnAdd;//止盈 +
@property (nonatomic,strong) UILabel *profitPriceTip;//止盈价格与收益


@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,strong) UILabel *advancesLab;//预付款
@property (nonatomic,strong) UIButton *buyBtn;//建仓
//--------挂单------------
@property (nonatomic,strong)UIView *  EntryOrderView;//挂单view
@property (nonatomic,strong) UIView *profitLossView1;
@property (nonatomic,strong)UIView * bugShouView;//购买手数
@property (nonatomic,strong) UITextField *guadanPriceField;//挂单价Field
@property (nonatomic,strong) UITextField *jiancnagField;//建仓
@property (nonatomic,strong)UIButton * dataButton;//日期按钮
@property (nonatomic,strong)UIButton *timeButton;//时间按钮
@property (nonatomic,strong) UIButton *lossButton;//是否选择止损
@property (nonatomic,strong) UIButton *profitButton;//是否选择止盈
@property (nonatomic,strong) UIButton *numBtnSuber;//手数 -
@property (nonatomic,strong) UIButton *numBtnAdder;//手数 +
@property (nonatomic,copy)NSString * guadanType;//挂单四个字段
@property (nonatomic,strong) UITextField *lossFielder;//止损Field
@property (nonatomic,strong) UITextField *profitFielder;//止盈Field
@property (nonatomic,copy)NSString * guadanTime;//挂单时间
@property (nonatomic,strong)UILabel * guadanPriceDes;//挂单价格描述
@property (nonatomic,strong) UILabel * lossLabel ;//止损提示
@property (nonatomic,strong) UILabel *profitLabel;//止盈提示


@end

@implementation BuyView

- (instancetype)init {
    self = [super init];
    if (self) {
        equity=0;
        alertFlag=NO;
        reqFlag=NO;
        vw = kMidW;
        midH = kBuyViewH - kTabH - kFooterH;
        [self configContentH:kBuyViewH];
        [self initView];
    }
    return self;
}

- (void)initView {
    self.hidden = YES;
    self.contentView.backgroundColor = LTWhiteColor;
    
    [self createTabView];
    [self createMidView];
    [self createFooterView];
    [self creatGuaDian];
}
#pragma mark - 头部

- (void)createTabView {
    self.tabView = [UIView lineFrame:CGRectMake(0, 0, ScreenW_Lit, kTabH) color:LTWhiteColor];
    [self.contentView addSubview:_tabView];
    
    //产品名称
    self.nameLab = [self lab:CGRectMake((Screen_width -  _tabView.w_*0.8)/2, 0, _tabView.w_*0.8, kTabH) font:boldFontSiz(15) color:LTTitleColor];
    self.nameLab.textAlignment = NSTextAlignmentCenter;
    [_tabView addSubview:_nameLab];
    
    UIView *lineView = [UIView lineFrame:CGRectMake(0, kTabH-0.5, ScreenW_Lit, 0.5) color:LTLineColor];
    [_tabView addSubview:lineView];
}

#define TITLES @[@"市价单", @"挂单"]
#define TITLES2 @[@"买涨限价",@"买涨止损",@"买跌限价",@"买跌止损"]

#pragma mark - 中间部分
- (void)createMidView {
    self.segment =[[HMSegmentedControl alloc]initWithSectionTitles:TITLES];
    self.segment.frame = CGRectMake(0, _tabView.yh_, Screen_width, 40);
    self.segment.selectionIndicatorHeight =3.0f;
    self.segment.type =HMSegmentedControlTypeText;
    self.segment.selectionIndicatorColor = LTKLineRed;
    self.segment.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor blackColor] };
    [self.segment addTarget:self action:@selector(selectAction) forControlEvents:(UIControlEventValueChanged)];
    self.segment.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.contentView addSubview:self.segment];
    
    _superScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.segment.yh_ + 5, Screen_width, midH)];
    _superScrollView.delegate = self;
    _superScrollView.showsHorizontalScrollIndicator = NO;
    [_superScrollView setPagingEnabled:YES];
    _superScrollView.userInteractionEnabled = YES;
    [_superScrollView setContentSize:CGSizeMake(Screen_width*2,_superScrollView.frame.size.height)];
    _superScrollView.contentOffset = CGPointMake(0, 0);
    [self.contentView addSubview:_superScrollView];
    
    
    //市单view
    self.midView  = [[UIView alloc] init];
    _midView.frame = CGRectMake(0, 0, ScreenW_Lit, midH);
    [self.superScrollView addSubview:_midView];
    
    //挂单View
    self.EntryOrderView =[[UIView alloc]initWithFrame:CGRectMake(Screen_width, 0, ScreenH_Lit, midH)];
    [self.superScrollView addSubview:self.EntryOrderView];
    
    [self createUpDownView];
    [self createNumView];
    [self createGrayView];
    [self createProfitLossView];
}
#pragma mark - 底部布局
- (void)createFooterView {
    self.footerView = [UIView lineFrame:CGRectMake(0, self.contentView.h_ - kFooterH, self.contentView.w_, kFooterH) color:LTWhiteColor];
    [self.contentView addSubview:_footerView];
    
    CGFloat buyBtnW = ScreenW_Lit/3.0;
    CGFloat advancesLabW = kMidW - buyBtnW;
    self.advancesLab = [self lab:CGRectMake(kLeftMar, 0, advancesLabW, kFooterH) font:boldFontSiz(15) color:LTTitleColor];
    [_footerView addSubview:_advancesLab];
    
    self.buyBtn = [UIButton btnWithTarget:self action:@selector(buyAction) frame:CGRectMake(0, 0, Screen_width, kFooterH)];
    _buyBtn.titleLabel.font = boldFontSiz(16);
    [_buyBtn setTitle:@"下  单" forState:UIControlStateNormal];
    [_buyBtn setTitleColorNSH:LTWhiteColor];
    [_buyBtn setNormalBgColor:LTKLineRed];
    [_buyBtn setSelectedBgColor:LTKLineGreen];
    [_footerView addSubview:_buyBtn];
    
    UIView *lineView = [UIView lineFrame:CGRectMake(0, 0, ScreenW_Lit, 0.5) color:LTLineColor];
    [_footerView addSubview:lineView];
}


#pragma mark - socket   传过来的数据
-(void)addCode :(NSString *)code code_cn:(NSString *)code_cn prcieIn:(NSString*)priceI  priceOut:(NSString *)priceOut
{
    self.nameLab.text = [NSString stringWithFormat:@"%@%@%@%@   %@",code_cn,code,@"  ",priceI,priceOut];
    self.priceIn = priceI;
    self.priceOut = priceOut;
    double priceInValue =priceI.doubleValue;
    double priceOutValue = priceOut.doubleValue;
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
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    priceInTop =[NSString stringWithFormat:percentage,priceInValue - 40 *   self.rang];
    priceInDown =[NSString stringWithFormat:percentage,priceInValue + 40 *   self.rang];
    priceOutTop =[NSString stringWithFormat:percentage,priceOutValue + 40*  self.rang];
    priceOutDown =[NSString stringWithFormat:percentage,priceOutValue - 40*  self.rang];
    if (_buyDown == NO) {
    self.lossDescribeLabel.text =[NSString stringWithFormat:@"%@%@",@"止损价格不能高于  :",priceInTop];
    self.ProfitDescribLable.text =[NSString stringWithFormat:@"%@%@",@"止盈价格不能低于  :",priceInDown];
    }else
    {
        self.lossDescribeLabel.text =[NSString stringWithFormat:@"%@%@",@"止损价格不能低于  :",priceOutTop];
        self.ProfitDescribLable.text =[NSString stringWithFormat:@"%@%@",@"止盈价格不能高于  :",priceOutDown];
    }
}

-(void)selectAction
{
    if (_segment.selectedSegmentIndex == 0) {
        _superScrollView.contentOffset = CGPointMake(0, 0);
        [_buyBtn setTitle:@"下  单" forState:UIControlStateNormal];
        
    }else if (_segment.selectedSegmentIndex == 1)
    {
        _superScrollView.contentOffset = CGPointMake(Screen_width, 0);
        [_buyBtn setTitle:@"挂  单" forState:UIControlStateNormal];

    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
        if (self.superScrollView.bounds.origin.x == 0){
                self.segment.selectedSegmentIndex = 0;
        }else if (self.superScrollView.bounds.origin.x == Screen_width) {
                self.segment.selectedSegmentIndex = 1;
        }
}

#pragma mark - 买涨买跌
- (void)createUpDownView {
    self.buyUpDownView = [[UIView alloc] init];
    _buyUpDownView.frame = CGRectMake(kLeftMar, 5, vw, 34);
    [_midView addSubview:_buyUpDownView];
    
    self.upBtn = [self upDownbtn:0 guadan:NO];
    [_buyUpDownView addSubview:_upBtn];
    
    self.downBtn = [self upDownbtn:1 guadan:NO];
    [_buyUpDownView addSubview:_downBtn];
    
  //  ----------------------挂单---------------------

    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:TITLES2];
    segmentedControl.frame =CGRectMake(kLeftMar, 5, vw, 34);
    segmentedControl.tintColor =LTKLineRed;
    segmentedControl.selectedSegmentIndex = 0;
    self.guadanType =@"BUY_LIMIT";
    [segmentedControl addTarget:self action:@selector(segmentChange:) forControlEvents:(UIControlEventValueChanged)];
    [self.EntryOrderView addSubview:segmentedControl];

}
-(void)segmentChange:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:
            self.guadanType =@"BUY_LIMIT";
            _guadanPriceDes.text = @"*不能高于当前买入价-40个点";
            _lossLabel.text = @"止损价格不能高于: 挂单价-40个点";
            self.profitLabel.text = @"止盈价格不能低于: 挂单价+40个点";

            break;
        case 1:
            self.guadanType = @"BUY_STOP";
            _guadanPriceDes.text = @"*不能低于当前买入价+40个点";
            _lossLabel.text = @"止损价格不能高于: 挂单价-40个点";
            self.profitLabel.text = @"止盈价格不能低于: 挂单价+40个点";
            break;
        case 2:
            self.guadanType = @"SELL_LIMIT";
            _guadanPriceDes.text = @"*不能低于当前卖出价+40个点";
            _lossLabel.text = @"止损价格不能低于: 挂单价+40个点";
            self.profitLabel.text = @"止盈价格不能高于: 挂单价-40个点";


            break;
        case 3:
            self.guadanType = @"SELL_STOP";
            _guadanPriceDes.text = @"*不能高于当前卖出价-40个点";
            _lossLabel.text = @"止损价格不能低于: 挂单价+40个点";
            self.profitLabel.text = @"止盈价格不能高于: 挂单价-40个点";



            break;
        
        default:
            break;
    }
}
//选买涨or跌
- (void)selBuyUpOrDownAction:(UIButton *)sender {
    self.buyDown = sender.tag > buyUpDownBtnTag;
    _buyType = _buyDown ? BuyType_Down : BuyType_Up;
    BOOL profitbl = _lossBtn.selected;
    _profitBtnSub.selected = profitbl;
    _profitBtnSub.enabled = profitbl;
    _profitBtnAdd.selected = profitbl;
    _profitBtnAdd.enabled = profitbl;
    
    BOOL lossbl = _lossBtn.selected;
    _lossBtnSub.selected = lossbl;
    _lossBtnSub.enabled = lossbl;
    _lossBtnAdd.selected = lossbl;
    _lossBtnAdd.enabled = lossbl;
    
    [self configBuyType];
}

#pragma mark - 建仓手数
#define kNumBtnTag 20000
#define addSubBgH       35

- (void)createNumView{
    CGFloat numViewY = _buyUpDownView.yh_ + 12;
    CGFloat numViewH = 70;
    CGFloat kleft = 17;
    contentW = self.w_ - 2*kleft;
    CGFloat titW = 0.345*contentW;
    addSubBgW = 0.655 *contentW;
    
    self.numView = [[UIView alloc] init];
    _numView.frame = CGRectMake(0, numViewY, self.w_, numViewH);
    [_midView addSubview:_numView];
    
    UILabel *titLab = [self lab:CGRectMake(kleft, 0, titW, addSubBgH) font:boldFontSiz(15) color:LTTitleColor];
    titLab.text = @"建仓手数";
    [_numView addSubview:titLab];
    
    CGRect rect = CGRectMake(self.w_ - kleft - addSubBgW, 0, addSubBgW, addSubBgH);
    UIImageView *numIV = [self addSubBgIV:rect];
    [_numView addSubview:numIV];
    
    _numBtnSub = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(numSubActon)];
    _numBtnSub.selected = YES;
    [numIV addSubview:_numBtnSub];
    
    CGRect numFieldRect = CGRectMake(_numBtnSub.xw_, 0, addSubBgW - 2*addSubBgH, addSubBgH);
    //手数输入框
    _numField = [self field:numFieldRect placeholder:@""];
    [numIV addSubview:_numField];
    
    _numBtnAdd = [self addBtn:CGRectMake(addSubBgW - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(numAddActon)];
    _numBtnAdd.selected = YES;
    [numIV addSubview:_numBtnAdd];
    
    UIView *numLabView = [[UIView alloc] init];
    numLabView.frame = CGRectMake(numIV.x_, numIV.yh_ + 11.5, numIV.w_, 25);
    [_numView addSubview:numLabView];
    
    _numTipLab = [self lab:CGRectMake(numLabView.x_, _numField.yh_ + 5, numLabView.w_+kLeftMar, 29) font:autoFontSiz(11) color:LTSubTitleColor];
    NSString *numTip =@" * 最小手数0.01手，最大可建仓手数:20手";
    _numTipLab.text = numTip;
    [_numView addSubview:_numTipLab];
    
    
}
#pragma mark - 手数
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

- (void)createGrayView {
    self.grayView = [UIView lineFrame:CGRectMake(0, _numView.yh_, self.w_, 24) color:LTBgColor];
    [_midView addSubview:_grayView];
}

#pragma mark - 止盈止损

#define kBtnWH 51
#define kPriceTipH 24
- (void)createProfitLossView {
    self.profitLossView = [[UIView alloc] init];
    _profitLossView.frame = CGRectMake(0, _grayView.yh_, self.w_, 139);
    [_midView addSubview:_profitLossView];
    
    //是否选择止损
    CGFloat tm = 13;
    CGFloat lossBtnY = tm + (addSubBgH - kBtnWH)/2.0;
    _lossBtn = [UIButton btnWithTarget:self action:@selector(lossBtnAction) frame:CGRectMake(kLeftMar-tm, lossBtnY, kBtnWH, kBtnWH)];
    [_lossBtn setNorImageName:@"icon_select_gray"];
    [_lossBtn setSelImageName:@"icon_select_blue"];
    [_profitLossView addSubview:_lossBtn];
    
    //'止损价格'
    CGFloat labx = _lossBtn.xw_-6;
    CGFloat labw = contentW - addSubBgW - kBtnWH + tm + 8;
    UILabel *lLab = [self lab:CGRectMake(labx, tm, labw, addSubBgH) font:boldFontSiz(15) color:LTTitleColor];
    lLab.text = @"止损价格";
    [_profitLossView addSubview:lLab];
    
    //止损背景
    CGRect lossrect = CGRectMake(self.w_ - kLeftMar - addSubBgW, tm, addSubBgW, addSubBgH);
    UIImageView *lossIV = [self addSubBgIV:lossrect];
    [_profitLossView addSubview:lossIV];
    
    //止损 -
    _lossBtnSub = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(lossSubActon)];
    [lossIV addSubview:_lossBtnSub];
    
    //止损Field
    CGRect numFieldRect = CGRectMake(_lossBtnSub.xw_, 0, addSubBgW - 2*addSubBgH, addSubBgH);
    _lossField = [self field:numFieldRect placeholder:@"请设置止损价格"];
    [_lossField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [lossIV addSubview:_lossField];
    
    //止损 +
    _lossBtnAdd = [self addBtn:CGRectMake(addSubBgW - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(lossAddActon)];
    [lossIV addSubview:_lossBtnAdd];
    
    //止损价格与损失
    _lossPriceTip = [self lab:CGRectMake(lossIV.x_, lossIV.yh_, lossIV.w_, kPriceTipH) font:fontSiz(11) color:LTTitleColor];
    _lossPriceTip.hidden = YES;
    [_profitLossView addSubview:_lossPriceTip];
    
    //是否选择止盈
    CGFloat plabY = lLab.yh_ + kPriceTipH;
    CGFloat profitBtnY = plabY + (addSubBgH - kBtnWH)/2.0;
    _profitBtn = [UIButton btnWithTarget:self action:@selector(profitBtnAction) frame:CGRectMake(_lossBtn.x_, profitBtnY, kBtnWH, kBtnWH)];
    [_profitBtn setNorImageName:@"icon_select_gray"];
    [_profitBtn setSelImageName:@"icon_select_blue"];
    [_profitLossView addSubview:_profitBtn];
    
    //止盈价格
    UILabel *pLab = [self lab:CGRectMake(labx, plabY, labw, addSubBgH) font:boldFontSiz(15) color:LTTitleColor];
    pLab.text = @"止盈价格";
    [_profitLossView addSubview:pLab];
    
    //止盈背景
    CGRect prect = CGRectMake(self.w_ - kLeftMar - addSubBgW, plabY, addSubBgW, addSubBgH);
    UIImageView *pIV = [self addSubBgIV:prect];
    [_profitLossView addSubview:pIV];
    
    //止盈 -
    _profitBtnSub = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(profitSubActon)];
    [pIV addSubview:_profitBtnSub];
    
    //止盈Field
    CGRect pFieldRect = CGRectMake(_profitBtnSub.xw_, 0, addSubBgW - 2*addSubBgH, addSubBgH);
    _profitField = [self field:pFieldRect placeholder:@"请设置止盈价格"];
    [_profitField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [pIV addSubview:_profitField];
    
    //止盈 +
    _profitBtnAdd = [self addBtn:CGRectMake(addSubBgW - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(profitAddActon)];
    [pIV addSubview:_profitBtnAdd];
    
    _balanceLabel =[self lab:CGRectMake(7 , self.profitLossView.yh_, 100, 25) font:boldFontSiz(15) color:LTBlackColor];
    _balanceLabel.text = @"余额 :    元";
    [_midView addSubview:_balanceLabel];
    
    _RechargeButton =[UIButton buttonWithType:(UIButtonTypeCustom)];
    _RechargeButton.frame = CGRectMake(labx + 60, self.profitLossView.yh_, 40, 25);
    [_RechargeButton setTitle:@"充值" forState:(UIControlStateNormal)];
    [_RechargeButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _RechargeButton.titleLabel.font = fontSiz(midFontSize);
    [_midView addSubview:_RechargeButton];
    
  //止盈止损提示
    self.lossDescribeLabel =[self lab:CGRectMake(lossIV.frame.origin.x, lossIV.yh_ , 200, 25) font:fontSiz(11) color:LTSubTitleColor];
    [_profitLossView addSubview:self.lossDescribeLabel];
    
    self.ProfitDescribLable =[self lab:CGRectMake(lossIV.frame.origin.x, pIV.yh_ +5, 200, 25) font:fontSiz(11) color:LTSubTitleColor];
    [_profitLossView addSubview:self.ProfitDescribLable];
    
    _lossBtnAdd.selected = NO;
    _lossBtnSub.selected = NO;
    _lossBtnAdd.enabled = NO;
    _lossBtnSub.enabled = NO;
    _lossField.enabled = NO;
    
    _profitBtnAdd.selected = NO;
    _profitBtnSub.selected = NO;
    _profitBtnAdd.enabled = NO;
    _profitBtnSub.enabled = NO;
    _profitField.enabled = NO;
}

#pragma mark 止损
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
    _lossPriceTip.hidden = !selected;
    _lossButton.selected = selected;
    if (selected) { //选中
        if (_buyDown == NO) {
        _lossField.text = priceInTop;
        _lossFielder.text = priceInTop;
        }else
        {
        _lossField.text = priceOutTop;
        _lossFielder.text = priceOutTop;
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
-(void)lossSubActon1{
    CGFloat minMovePoint =  self.rang;
    CGFloat lossf = [_lossField.text floatValue];
    lossf -= minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *loss = [NSString stringWithFormat:percentage,lossf];
    _lossFielder.text = loss;
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
- (void)lossAddActon1 {
    CGFloat minMovePoint =   self.rang;
    CGFloat lossf = [_lossField.text floatValue];
    lossf += minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *loss = [NSString stringWithFormat:percentage,lossf];
    _lossFielder.text = loss;
}
#pragma mark 止盈
//勾选止盈
- (void)profitBtnAction {
    BOOL bl = !_profitBtn.selected;
    [self profitBtnSelected:bl];
}

- (void)profitBtnSelected:(BOOL)selected {
    _profitBtn.selected = selected;
    _profitBtnAdd.selected = selected;
    _profitBtnSub.selected = selected;
    _profitBtnAdd.enabled = selected;
    _profitBtnSub.enabled = selected;
    _profitField.enabled = selected;
    _profitPriceTip.hidden = !selected;
    _profitButton.selected = selected;
//    if (_guadanPriceField.text.length <= 0) {
//        [self showMyMessage:@"请先输入挂单价"];
//        return;
//    }
    if (selected) { //选中
        if (_buyDown == NO) {
            _profitField.text =_priceIn;
            _profitFielder.text =_priceOut;
        }else
        {
            _profitField.text =_priceIn;
            _profitFielder.text =_priceOut;
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

- (void)profitSubActon1 {
    CGFloat minMovePoint =self.rang;
    CGFloat profilef = [_profitField.text floatValue];
    profilef -= minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *profile =[NSString stringWithFormat:percentage,profilef];
    _profitFielder.text = profile;
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
- (void)profitAddActon1 {
    CGFloat minMovePoint = self.rang;
    CGFloat profilef = [_profitField.text floatValue];
    profilef += minMovePoint;
    NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",self.dataly],@"f"];
    NSString *profile = [NSString stringWithFormat:percentage,profilef];
    _profitFielder.text = profile;
}

#pragma mark -
#pragma mark - 修改数据
//买涨买跌
- (void)configBuyType {
    _downBtn.selected = _buyDown;
    _upBtn.selected = !_buyDown;
    _buyBtn.selected = _buyDown;
    
    if (_lossBtn.selected) {
        NSString *loss =@"买涨";
        _lossField.text = loss;
    }
    
    if (_profitBtn.selected) {
        NSString *profile =@"买跌";
        _profitField.text = profile;
    }
    
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
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidChange:(UITextField *)textField  {
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isEqual:_numField]&&string.length >0) {
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
        }
        else
        {
            return YES;
        }
    }
    return YES;
}
-(void)showMyMessage:(NSString*)aInfo {
    if (aInfo.length > 0) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
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
            [self showMyMessage:@"亲，建仓最小手数是20 !"];
            [self configNumData:NO];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}
- (void)yMove:(CGFloat)btm {
    CGFloat kh = 252;//
    CGFloat oy = kh - btm + 30;
    WS(ws);
    [UIView animateWithDuration:0.2 animations:^{
        [ws setOY:-oy];
    }];
}

- (void)yZeroMove {
    WS(ws);
    [UIView animateWithDuration:0.2 animations:^{
        [ws setOY:0];
    }];
}

#pragma mark - utils
- (UILabel *)lab:(CGRect)frame font:(UIFont *)font color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.font = font;
    lab.textColor = color;
    return lab;
}

- (UIButton *)upDownbtn:(NSInteger)idx  guadan:(BOOL)guadan{
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(selBuyUpOrDownAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = buyUpDownBtnTag + idx;
    

    UIImage *norImg= nil;
    UIImage *selImg = nil;
    CGFloat x = 0;
    CGFloat w = _buyUpDownView.w_*0.5;
    if (idx == 0) {
        norImg = [UIImage imageNamed:@"buy_tabBg_LeftGrey"];
        selImg = [UIImage imageNamed:@"buy_tabBg_LeftRed"];
        x = 0;
    } else {
        norImg = [UIImage imageNamed:@"buy_tabBg_RightGrey"];
        selImg = [UIImage imageNamed:@"buy_tabBg_RightGreen"];
        x = w-1;
    }
        btn.frame = CGRectMake(x, 0, w, _buyUpDownView.h_);

  
    [btn setNorBGImage:norImg];
    [btn setSelBGImage:selImg];
    [btn setHigBGImage:selImg];
    btn.titleLabel.font = [UIFont boldFontOfSize:15.f];
    return btn;
}

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

- (UIImageView *)addSubBgIV:(CGRect)rect {
    UIImageView *iv = [[UIImageView alloc] initWithFrame:rect];
    UIImage *img = [[UIImage imageNamed:@"numbg"] stretchMiddle];
    iv.image = img;
    iv.userInteractionEnabled = YES;
    return iv;
}

- (UIButton *)subBtn:(CGRect)rect action:(SEL)action {
    UIButton *btn = [UIButton btnWithTarget:self action:action frame:rect];
    [btn setNorImageName:@"icon_sub_gray"];
    [btn setSelImageName:@"icon_sub_blue"];
    [btn setHigImageName:@"icon_sub_blue"];
    return btn;
}

- (UIButton *)addBtn:(CGRect)rect action:(SEL)action {
    UIButton *btn = [UIButton btnWithTarget:self action:action frame:rect];
    [btn setNorImageName:@"icon_add_gray"];
    [btn setSelImageName:@"icon_add_blue"];
    [btn setHigImageName:@"icon_add_blue"];
    return btn;
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
    [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
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
    _lossFieldEditing = NO;
    _profitFieldEditing = NO;
    ShutAllKeyboard;
}



#pragma mark -
#pragma mark - 外部

- (void)showView:(BOOL)show {
    [super showView:show];
    if (show) {
        _numField.text = @"0.01";
        [self configNumData:YES];
        [self lossBtnSelected:NO];
        [self profitBtnSelected:NO];
    } else {
        [self textFieldDone];
    }
}

- (void) buyType:(BuyType)buyType {
    if (buyType != BuyType_Non) {
        self.buyType = buyType;
        if (_buyType == BuyType_Down) {
            _buyDown = YES;
        }
        else if (_buyType == BuyType_Up) {
            _buyDown = NO;
        }
    }

    [self configMo];
    
    if (buyType != BuyType_Non) {
        [self configBuyType];
    }
    
}


//-----------挂单------------------
-(void)creatGuaDian
{
    CGFloat numViewH = 70;
    CGFloat kleft = 17;
    contentW = self.w_ - 2*kleft;
    CGFloat titW = 0.345*contentW;
    addSubBgW = 0.655 *contentW;
    
    self.bugShouView = [[UIView alloc] init];
    self.bugShouView.frame = CGRectMake(0, numViewH, self.w_, numViewH);
    [self.EntryOrderView addSubview:self.bugShouView];
    
    UILabel *titLab = [self lab:CGRectMake(kleft, 0, titW, addSubBgH) font:boldFontSiz(15) color:LTTitleColor];
    titLab.text = @"挂单价";
    [self.bugShouView addSubview:titLab];
    
    CGRect rect = CGRectMake(self.w_ - kleft - addSubBgW, 0, addSubBgW, addSubBgH);
    UIImageView *numIV = [self addSubBgIV:rect];
    [self.bugShouView addSubview:numIV];
    
    _numBtnSuber = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(numSubActon1)];
    _numBtnSuber.selected = YES;
    [numIV addSubview:_numBtnSuber];
    
    CGRect numFieldRect = CGRectMake(_numBtnSuber.xw_, 0, addSubBgW - 2*addSubBgH, addSubBgH);
    _guadanPriceField = [self field:numFieldRect placeholder:@"请输入挂单价格"];
    [numIV addSubview:_guadanPriceField];
    
    _numBtnAdder = [self addBtn:CGRectMake(addSubBgW - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(numAddActon1)];
    _numBtnAdder.selected = YES;
    [numIV addSubview:_numBtnAdder];
    
    //挂单价描述
    _guadanPriceDes =[self lab:CGRectMake(numIV.frame.origin.x, numIV.yh_ +5, 200, 29) font:autoFontSiz(11) color:LTSubTitleColor];
    _guadanPriceDes.text = @"*要低于当前买入价- 40个点";
    [self.bugShouView addSubview:_guadanPriceDes];
    
    UIView *numLabView = [[UIView alloc] init];
    numLabView.frame = CGRectMake(numIV.x_, numIV.yh_ + 11.5, numIV.w_, 25);
    [self.bugShouView addSubview:numLabView];
    
    UILabel *titLab1 = [self lab:CGRectMake(kleft, _guadanPriceDes.yh_ + 10, titW, addSubBgH) font:boldFontSiz(15) color:LTTitleColor];
    titLab1.text = @"建仓手数";
    [self.bugShouView addSubview:titLab1];
    
    
    CGRect rect1 = CGRectMake(self.w_ - kleft - addSubBgW, _guadanPriceDes.yh_ + 10, addSubBgW, addSubBgH);
    UIImageView *numIV2 = [self addSubBgIV:rect1];
    [self.bugShouView addSubview:numIV2];
    
    UIButton * subBtn = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(numSubActon1)];
    subBtn.selected = YES;
    [numIV2 addSubview:subBtn];
    
    CGRect numFieldRect1 = CGRectMake(_numBtnSub.xw_, 0, addSubBgW - 2*addSubBgH, addSubBgH);
    _jiancnagField = [self field:numFieldRect1 placeholder:@""];
    _jiancnagField.text = @"0.01";
    [numIV2 addSubview:_jiancnagField];
    
    UIButton * addBtn = [self addBtn:CGRectMake(addSubBgW - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(numAddActon1)];
    addBtn.selected = YES;
    [numIV2 addSubview:addBtn];

    _numTipLab = [self lab:CGRectMake(numLabView.x_, numIV2.yh_ + 5, numLabView.w_+kLeftMar, 29) font:autoFontSiz(11) color:LTSubTitleColor];
    NSString *numTip =@" * 最小手数0.01手，最大可建仓手数:20手";
    _numTipLab.text = numTip;
    [_bugShouView addSubview:_numTipLab];
    
    
    self.grayView = [UIView lineFrame:CGRectMake(0, numIV2.yh_ +40, self.w_, 24) color:LTBgColor];
    [_bugShouView addSubview:_grayView];

    self.profitLossView1 = [[UIView alloc] init];
    self.profitLossView1.userInteractionEnabled = YES;
    _profitLossView1.frame = CGRectMake(0, _grayView.yh_ +60, self.w_, 139);
    [_EntryOrderView addSubview:_profitLossView1];

        //是否选择止损
        CGFloat tm = 13;
        CGFloat lossBtnY = tm + (addSubBgH - kBtnWH)/2.0;
        self.lossButton = [UIButton btnWithTarget:self action:@selector(lossBtnAction1) frame:CGRectMake(kLeftMar-tm, lossBtnY, kBtnWH, kBtnWH)];
        [ self.lossButton setNorImageName:@"icon_select_gray"];
        [ self.lossButton setSelImageName:@"icon_select_blue"];
        [self.profitLossView1 addSubview:  self.lossButton];

        //'止损价格'
        CGFloat labx = _lossBtn.xw_-6;
        CGFloat labw = contentW - addSubBgW - kBtnWH + tm + 8;
        UILabel *lLab = [self lab:CGRectMake(labx, tm, labw, addSubBgH) font:boldFontSiz(15) color:LTTitleColor];
        lLab.text = @"止损价格";
        [self.profitLossView1 addSubview:lLab];

        //止损背景
        CGRect lossrect = CGRectMake(self.w_ - kLeftMar - addSubBgW, tm, addSubBgW, addSubBgH);
        UIImageView *lossIV = [self addSubBgIV:lossrect];
    lossIV.userInteractionEnabled = YES;
        [self.profitLossView1 addSubview:lossIV];

        //止损 -
        UIButton *lossBtnSuber  = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(lossSubActon1)];
        [lossIV addSubview:lossBtnSuber];

        //止损Field
        CGRect numFieldRect3 = CGRectMake(_lossBtnSub.xw_, 0, addSubBgW - 2*addSubBgH, addSubBgH);
        _lossFielder = [self field:numFieldRect3 placeholder:@"请设置止损价格"];
        [lossIV addSubview:_lossFielder];

        //止损 +
       UIButton *lossBtnAdded= [self addBtn:CGRectMake(addSubBgW - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(lossAddActon1)];
        [lossIV addSubview:lossBtnAdded];

        //止损价格与损失
        _lossPriceTip = [self lab:CGRectMake(lossIV.x_, lossIV.yh_, lossIV.w_, kPriceTipH) font:fontSiz(11) color:LTTitleColor];
        _lossPriceTip.hidden = YES;
        [self.profitLossView1 addSubview:_lossPriceTip];

        //是否选择止盈
        CGFloat plabY = lLab.yh_ + kPriceTipH;
        CGFloat profitBtnY = plabY + (addSubBgH - kBtnWH)/2.0;
        self.profitButton = [UIButton btnWithTarget:self action:@selector(profitBtnAction1) frame:CGRectMake(  self.lossButton.x_, profitBtnY, kBtnWH, kBtnWH)];
        [self.profitButton setNorImageName:@"icon_select_gray"];
        [self.profitButton setSelImageName:@"icon_select_blue"];
        [self.profitLossView1 addSubview:self.profitButton];

        //止盈价格
        UILabel *pLab = [self lab:CGRectMake(labx, plabY, labw, addSubBgH) font:boldFontSiz(15) color:LTTitleColor];
        pLab.text = @"止盈价格";
        [self.profitLossView1 addSubview:pLab];

        //止盈背景
        CGRect prect = CGRectMake(self.w_ - kLeftMar - addSubBgW, plabY, addSubBgW, addSubBgH);
        UIImageView *pIV = [self addSubBgIV:prect];
        [self.profitLossView1 addSubview:pIV];

        //止盈 -
        UIButton *profitBtnSubbtn = [self subBtn:CGRectMake(0, 0, addSubBgH, addSubBgH) action:@selector(profitSubActon1)];
        [pIV addSubview:profitBtnSubbtn];

        //止盈Field
        CGRect pFieldRect = CGRectMake(_profitBtnSub.xw_, 0, addSubBgW - 2*addSubBgH, addSubBgH);
        _profitFielder = [self field:pFieldRect placeholder:@"请设置止盈价格"];
        [_profitFielder addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [pIV addSubview:_profitFielder];

        //止盈 +
        UIButton * profitBtnAddBtn= [self addBtn:CGRectMake(addSubBgW - addSubBgH, 0, addSubBgH, addSubBgH) action:@selector(profitAddActon1)];
        [pIV addSubview:profitBtnAddBtn];

    //到期时间
    UILabel *pLabDate = [self lab:CGRectMake(labx, pIV.yh_ + 25, labw, addSubBgH) font:boldFontSiz(15) color:LTTitleColor];
    pLabDate.text = @"到期时间";
    [self.profitLossView1 addSubview:pLabDate];
    
    
    
    self.dataButton =[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.dataButton.frame =CGRectMake(self.w_ - kLeftMar - addSubBgW, self.profitLossView1.yh_ +5,200, 35) ;
    [self.dataButton addTarget:self action:@selector(dataTimeClick) forControlEvents:(UIControlEventTouchUpInside)];
    self.dataButton.backgroundColor =[UIColor grayColor];
    self.dataButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.dataButton setTitle:@"选择日期时间" forState:(UIControlStateNormal)];
    [self.EntryOrderView addSubview:self.dataButton];
    
    
   //     止盈止损提示
    self.lossLabel =[self lab:CGRectMake(lossIV.frame.origin.x, lossIV.yh_ , 200, 25) font:fontSiz(11) color:LTSubTitleColor];
    _lossLabel.text = @"止损价格不能高于: 挂单价-40个点";
    [self.profitLossView1 addSubview:_lossLabel];

   self.profitLabel =[self lab:CGRectMake(lossIV.frame.origin.x, pIV.yh_ +5, 200, 25) font:fontSiz(11) color:LTSubTitleColor];
    self.profitLabel.text = @"止盈价格不能低于: 挂单价+40个点";
    [self.profitLossView1 addSubview:self.profitLabel];

}
//选择日期
-(void)dataTimeClick
{
    
    WS(ws);
    dateTimePickerView = [[HcdDateTimePickerView alloc] initWithDatePickerMode:DatePickerDateTimeMode defaultDateTime:[[NSDate alloc]initWithTimeIntervalSinceNow:1000]];
    dateTimePickerView.topViewColor = [UIColor greenColor];
    dateTimePickerView.buttonTitleColor = [UIColor redColor];
    [dateTimePickerView setMinYear:1999];
    [dateTimePickerView setMaxYear:2018];
    dateTimePickerView.title = @"挂单日期";
    dateTimePickerView.titleColor = [UIColor whiteColor];
    dateTimePickerView.clickedOkBtn = ^(NSString * datetimeStr){
        [ws.dataButton setTitle:datetimeStr forState:(UIControlStateNormal)];
        long long dateTime =[DataHundel getZiFuChuan:datetimeStr];
        NSNumber *longlongNumber = [NSNumber numberWithLongLong:dateTime];
        NSString *longlongStr = [longlongNumber stringValue];
        self.guadanTime =[DataHundel ConvertStrToTime:longlongStr];
    };
    if (dateTimePickerView) {
        [AppKeyWindow addSubview:dateTimePickerView];
        [dateTimePickerView showHcdDateTimePicker];
    }
}
//勾选止盈
- (void)profitBtnAction1 {
    BOOL bl = !_profitButton.selected;
    [self profitBtnSelected:bl];
}
//勾选止损
- (void)lossBtnAction1 {
    BOOL bl = !_lossButton.selected;
    [self lossBtnSelected:bl];
}
#pragma  建仓网络请求
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
        NSDictionary * dic = @{@"server":[NSUserDefaults objFoKey:TYPE],@"mt4id":[NSUserDefaults objFoKey:MT4ID],@"symbol":self.code,@"type":self.buyOrSell,@"volume":@"1",@"sl":_lossField.text,@"tp":_profitField.text,@"price":@"0"};
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
        NSDictionary * dictionary = @{@"server":[NSUserDefaults objFoKey:TYPE],@"mt4id":[NSUserDefaults objFoKey:MT4ID],@"symbol":self.code,@"type":self.guadanType,@"volume":@"1",@"sl":_lossFielder.text,@"tp":_profitFielder.text,@"price":_guadanPriceField.text,@"expiredDate":self.guadanTime};
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
- (void)dealloc {
    NFC_RemoveObserver(NFC_DealHeadRefresh);
}

@end

