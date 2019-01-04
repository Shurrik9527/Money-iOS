//
//  WithdrawVCtrl.m
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "WithdrawVCtrl.h"
#import "BankCarkMO.h"
#import "SelectBankView.h"
#import "BindCardVCtrl.h"
#import "ManagerBankCardVC.h"
@interface WithdrawVCtrl ()<SelectBankViewDelegate>

@property (nonatomic,strong) NSArray *banks;
@property (nonatomic,strong) BankCarkMO *mo;
@property (nonatomic,strong) SelectBankView *selectBankView;

@property (nonatomic,strong) UILabel *copyrightLab;//公司版本
@property (nonatomic,strong) UIView *cashView;//提现baseview
@property (nonatomic,strong) UIView *selectView;

@property (nonatomic,strong) UIView *bankView;
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *detailLab;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *maxCashLab;
@property (nonatomic,strong) UITextField *cashField;
@property (nonatomic,strong) UILabel *rateLab;

@property (nonatomic,strong) UILabel *feeCashLab;

@property (nonatomic,strong) UIView *cashSuccessView;//提现成功view

@property (nonatomic,copy) NSString *balance;//	String	余额（美元，精确2位小数）
@property (nonatomic,assign) CGFloat usdCny;//	double	汇率

@end

@implementation WithdrawVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navTitle:@"出金" backType:BackType_PopVC rightTitle:@"管理银行卡"];
    self.mo = nil;
    
    [self createCopyrightView];//
    [self createCashView];
    
    [self reqAccountInfo];
    [self reqUserBankList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

#define kCopyrightLabH  26
#define kCopyrightLabMar  20
#define kCopyrightViewH  (kCopyrightLabH + 2*kCopyrightLabMar)
#define kCopyrightViewY (ScreenH_Lit - kCopyrightViewH)

- (void)createCopyrightView {
    UIView *copyrightView = [UIView lineFrame:CGRectMake(0, kCopyrightViewY, ScreenW_Lit, kCopyrightViewH) color:LTBgColor];
    [self.view addSubview:copyrightView];
    
    self.copyrightLab = [UILabel labRect:CGRectMake(0, kCopyrightLabMar, ScreenW_Lit, kCopyrightLabH) font:fontSiz(12) textColor:LTSubTitleColor];
    _copyrightLab.textAlignment = NSTextAlignmentCenter;
    [copyrightView addSubview:_copyrightLab];
    
    NSString *fx = @"FX";
    NSString *btg = @"BTG";
    NSString *coStr = [NSString stringWithFormat:@"@2002-2017 %@%@ Global 版权所有", fx, btg];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:coStr];
    NSRange fxRange = [coStr rangeOfString:fx];
    [ABStr addAttribute:NSForegroundColorAttributeName value:LTTitleColor range:fxRange];
    NSRange btgRange = [coStr rangeOfString:btg];
    [ABStr addAttribute:NSForegroundColorAttributeName value:LTKLineRed range:btgRange];
    _copyrightLab.attributedText = ABStr;
}

- (void)createCashView {
    self.cashView = [UIView lineFrame:CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - kCopyrightViewH - NavBarTop_Lit) color:LTBgColor];
    [self.view addSubview:_cashView];
    
    [self createSelectView];
    [self createBankView];
    [self createContentView];
    [self createOther];
}
#pragma mark - 跳转管理银行卡
-(void)rightAction{
    ManagerBankCardVC *ctrl = [[ManagerBankCardVC alloc] init];
    [self pushVC:ctrl];
}
#pragma mark 未绑定银行卡
- (void)createSelectView {
    CGFloat selectViewH = 44;
    self.selectView = [UIView lineFrame:CGRectMake(0, 0, ScreenW_Lit, selectViewH) color:LTWhiteColor];
    [_cashView addSubview:_selectView];
    [_selectView addSingeTap:@selector(showBankListView) target:self];
    
    CGFloat nextIVW = 7;
    CGFloat nextIVH = 11;
    UIImageView *nextIV = [[UIImageView alloc] init];
    nextIV.frame = CGRectMake(ScreenW_Lit - kLeftMar - nextIVW, (selectViewH - nextIVH)/2.0, nextIVW, nextIVH);
    nextIV.image = [UIImage imageNamed:@"next"];
    [_selectView addSubview:nextIV];

    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(kLeftMar, 0, kMidW - nextIVW, selectViewH);
    lab.text = @"请选择银行卡";
    lab.textColor = LTSubTitleColor;
    lab.font = fontSiz(15);
    [_selectView addSubview:lab];
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, selectViewH-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [_selectView addSubview:lineView];
    
}

#pragma mark 已经绑定银行卡

- (void)createBankView {
    CGFloat h = 60;
    self.bankView = [UIView lineFrame:CGRectMake(0, 0, ScreenW_Lit, h) color:LTWhiteColor];
    self.bankView.hidden = YES;
    [_cashView addSubview:_bankView];
    [_bankView addSingeTap:@selector(showBankListView) target:self];
    
    CGFloat iconX = 16;
    CGFloat iconIVWH = 30;
    self.iconIV = [[UIImageView alloc] init];
    _iconIV.frame = CGRectMake(iconX, (h - iconIVWH)/2.0, iconIVWH, iconIVWH);
    _iconIV.contentMode = UIViewContentModeScaleAspectFit;
    [_bankView addSubview:_iconIV];
    
    CGFloat labH = 23;
    CGFloat labW = ScreenW_Lit*0.6;
    CGFloat labY = (h - 2*labH)*0.5;
    self.titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(_iconIV.xw_ + iconX, labY, labW, labH);
    _titleLab.font = fontSiz(15);
    _titleLab.textColor = LTTitleColor;
    [_bankView addSubview:_titleLab];
    
    
    self.detailLab = [[UILabel alloc] init];
    _detailLab.frame = CGRectMake(_titleLab.x_, _titleLab.yh_, labW, labH);
    _detailLab.font = fontSiz(15);
    _detailLab.textColor = LTSubTitleColor;
    [_bankView addSubview:_detailLab];
    
    CGFloat nextIVW = 7;
    CGFloat nextIVH = 11;
    UIImageView *nextIV = [[UIImageView alloc] init];
    nextIV.frame = CGRectMake(ScreenW_Lit - kLeftMar - nextIVW, (h - nextIVH)/2.0, nextIVW, nextIVH);
    nextIV.image = [UIImage imageNamed:@"next"];
    [_bankView addSubview:nextIV];
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, h-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [_bankView addSubview:lineView];
}

#pragma mark 显示银行卡列表

- (void)showBankListView {
    if (!_selectBankView) {
        _selectBankView = [[SelectBankView alloc] init];
        _selectBankView.delegate = self;
        [self.view addSubview:_selectBankView];
    }
    
    [_cashField resignFirstResponder];
    [_selectBankView configBanks:_banks];
    [_selectBankView showView:YES];
}

#pragma mark SelectBankViewDelegate

- (void)pushBindCard {
    [_selectBankView showView:NO];
    BindCardVCtrl *ctrl = [[BindCardVCtrl alloc] init];
    [self pushVC:ctrl];
}
- (void)selectedBank:(BankCarkMO *)mo {
    [_selectBankView showView:NO];
    _mo = mo;
    [self configBanks];
}

#pragma mark 提现金额

- (void)createContentView {
    CGFloat h = 118;
    self.contentView = [UIView lineFrame:CGRectMake(0, self.selectView.yh_, ScreenW_Lit, h) color:LTWhiteColor];
    [_cashView addSubview:_contentView];
    
    UILabel *titLab = [UILabel labRect:CGRectMake(kLeftMar, 15, 62, 15) font:boldFontSiz(15) textColor:LTTitleColor text:@"提取金额"];
    [_contentView addSubview:titLab];
    
    CGFloat maxCashLabX = titLab.xw_ +21;
    self.maxCashLab = [UILabel labRect:CGRectMake(maxCashLabX, titLab.y_, ScreenW_Lit - maxCashLabX - kLeftMar, 15) font:fontSiz(12) textColor:LTSubTitleColor];
    [_contentView addSubview:_maxCashLab];
    
    NSString *maxCash = @"0";
    NSString *str = [NSString stringWithFormat:@"(可提取 %@ 美元)", maxCash];
    NSRange range = [str rangeOfString:maxCash];
    NSAttributedString *abstr = [str ABStrColor:LTKLineRed range:range];
    _maxCashLab.attributedText = abstr;
    
    UIFont *cashLabFont = boldFontSiz(23);
    UILabel *cashUnitLab = [UILabel labRect:CGRectMake(kLeftMar, titLab.yh_+22, 23, 23) font:cashLabFont textColor:LTTitleColor text:@"$"];
    [_contentView addSubview:cashUnitLab];
    
    CGFloat cashFieldX = cashUnitLab.xw_;
    self.cashField = [UITextField fieldRect:CGRectMake(cashFieldX, cashUnitLab.y_+1, ScreenW_Lit - cashFieldX, cashUnitLab.h_) font:cashLabFont textColor:LTTitleColor place:@"0.00" placeColor:LTTitleColor];
    _cashField.inputAccessoryView = [self addToolbar];
    _cashField.keyboardType = UIKeyboardTypeDecimalPad;
    [_cashField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    [_contentView addSubview:_cashField];
    
    
    
    UIView *rateView = [UIView lineFrame:CGRectMake(0, cashUnitLab.yh_ + 14, ScreenW_Lit, 28) color:LTWhiteColor];
    [_contentView addSubview:rateView];
    
    
    
    self.rateLab = [UILabel labRect:CGRectMake(kLeftMar, 0, kMidW, rateView.h_) font:autoFontSiz(10) textColor:LTSubTitleColor];
    [rateView addSubview:_rateLab];
    
    NSString *rateTip = @"当前汇率：美元：人民币 = 1：6.94，折合人民币￥0.00元";
    _rateLab.text = rateTip;
    
    UIView *line = [UIView lineFrame:CGRectMake(0, 0, ScreenW_Lit, 0.5) color:LTLineColor];
    [rateView addSubview:line];
    
}

#pragma mark 提示&提交按钮

- (void)createOther {
    self.feeCashLab = [UILabel labRect:CGRectMake(kLeftMar, _contentView.yh_ + 71, kMidW, 34) font:fontSiz(12) textColor:LTSubTitleColor];
    _feeCashLab.textAlignment = NSTextAlignmentCenter;
    [_cashView addSubview:_feeCashLab];
    
    NSString *num = @"2";
    NSString *feeTip = [NSString stringWithFormat:@"当月前%@笔免手续费，超出后每笔收取20美元手续费",num];
    NSRange range = [feeTip rangeOfString:num];
    NSAttributedString *abstr = [feeTip ABStrColor:LTKLineRed range:range];
    _feeCashLab.attributedText = abstr;
    
    UIButton *sureBtn = [UIButton commitBlueBtn:self action:@selector(sureAction) y:_feeCashLab.yh_+12 text:@"提交"];
    [_cashView addSubview:sureBtn];
    
}


#pragma mark 提现成功显示
- (void)createCashSuccessView {
    self.cashSuccessView = [UIView lineFrame:CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, ScreenH_Lit - kCopyrightViewH - NavBarTop_Lit) color:LTBgColor];
    [self.view addSubview:_cashSuccessView];
    
    CGFloat ivwh = 90;
    UIImageView *iv = [[UIImageView alloc] init];
    iv.frame = CGRectMake((ScreenW_Lit - ivwh)*0.5, 78, ivwh, ivwh);
    iv.image = [UIImage imageNamed:@"cashSuccess"];
    [_cashSuccessView addSubview:iv];
    
    UILabel *lab = [UILabel labRect:CGRectMake(0, iv.yh_ + 39, ScreenW_Lit, 24) font:boldFontSiz(20) textColor:LTTitleColor text:@"出金申请已提交成功！"];
    lab.textAlignment = NSTextAlignmentCenter;
    [_cashSuccessView addSubview:lab];
    
    CGFloat subx = 46;
    UIFont *subfont = fontSiz(15);
    UILabel *subLab = [UILabel labRect:CGRectMake(subx, lab.yh_ + 12, ScreenW_Lit-2*subx, 70) font:subfont textColor:LTSubTitleColor];
    subLab.numberOfLines = 0;
    [_cashSuccessView addSubview:subLab];
    
    NSString *subStr = @"提交出金申请后1个工作日内受理，受理前不可建仓。资金将在自扣款之日起1-2个工作日到账，具体取决于中转银行的受理时间";
    NSMutableAttributedString *abstr = (NSMutableAttributedString *)[subStr ABSpacing:3 font:subfont];
    NSRange range1 = [subStr rangeOfString:@"受理前不可建仓。"];
    [abstr addAttribute:NSForegroundColorAttributeName value:LTKLineRed range:range1];
    subLab.attributedText = abstr;
}



#pragma mark - req

- (void)reqUserBankList {
    WS(ws);
    [RequestCenter reqUserBindedBankList:^(LTResponse *res) {
        if (res.success) {
            NSArray *banks = [BankCarkMO objsWithList:res.resArr];
            ws.banks = nil;
            ws.banks = [NSArray arrayWithArray:banks];
            if (_banks.count > 0) {
                ws.mo = _banks[0];
            }
            [ws configBanks];
        } else {
            [ws.view showTip:res.message];
        }
    }];
}

- (void)sureAction {

    if (!_mo) {
        [self.view showTip:@"请选择银行卡"];
        return;
    }
    
    NSString *balance = _cashField.text;//出金额
    if ([balance floatValue] <= 0) {
        [self.view showTip:@"请选输入提现金额"];
        return;
    }
    
    NSString *bankId = _mo.bankId;//已绑定的银行卡 Id
    NSString *ipAddress = @"";//客户 IP
    
    NSDictionary *dict = @{
//                           @"sourceId" : @(kAPPType),
                               @"market" : kAppMarket,
                               @"bankId" : bankId,
                               @"balance" : balance,
                               @"userId" : UD_UserId,
                               @"token" : UD_Token,
                               @"ipAddress" : ipAddress,
                           };
    WS(ws);
    [RequestCenter reqCashOutWithParameter:dict finsh:^(LTResponse *res) {
        if (res.success) {
            [ws commitSuccess];
        } else {
            [ws.view showTip:res.message];
        }
    }];
    
}

- (void)commitSuccess {
    [self createCashSuccessView];
}

//            balance	String	余额（美元，精确2位小数）
//            usdCny	double	汇率
- (void)reqAccountInfo {
    WS(ws);
    [RequestCenter reqAccountInfo:^(LTResponse *res) {
        if (res.success) {
            NSDictionary *dict = [res.resDict copy];
            [ws configPrice:dict];
        }
    }];
}

- (void)configPrice:(NSDictionary *)dict {
    self.balance = [dict stringFoKey:@"balance"];
    self.usdCny = [dict floatFoKey:@"usdCny"];
    
    NSString *maxCash = _balance;
    NSString *str = [NSString stringWithFormat:@"(可提取 %@ 美元)", maxCash];
    NSRange range = [str rangeOfString:maxCash];
    NSAttributedString *abstr = [str ABStrColor:LTKLineRed range:range];
    _maxCashLab.attributedText = abstr;
}

- (void)textFieldDidChange:(UITextField *)textField {
    NSString *str = textField.text;
    CGFloat strf = [str floatValue];
    CGFloat pricef = strf * _usdCny;
    NSString *price = [LTUtils decimal2PWithFormat:pricef];
    NSString *rateTip = [NSString stringWithFormat:@"当前汇率：美元：人民币 = 1：%.2f，折合人民币￥%@元", _usdCny , price];
    _rateLab.text = rateTip;
}






#pragma mark - utils

- (void)configBanks {
    if (_mo) {
        self.selectView.hidden = YES;
        self.bankView.hidden = NO;
        [_iconIV lt_setImageWithURL:_mo.icon];
        _titleLab.text = _mo.bankName;
        _detailLab.text = [NSString stringWithFormat:@"尾号：%@",[_mo end4BankNO]];
        [self.contentView setOY:self.bankView.yh_];
        
    } else {
        self.selectView.hidden = NO;
        self.bankView.hidden = YES;
        [self.contentView setOY:self.selectView.yh_];
    }
}

- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = LTBgColor;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}

- (void)textFieldDone {
    ShutAllKeyboard;
}




@end
