//
//  CapitalVC.m
//  Canary
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "CapitalVC.h"
#import "HMSegmentedControl.h"
#import "FundListVC.h"
#import "UICountingLabel.h"
#import "OutGodViewController.h"
#import "InGodViewController.h"
#import "WebView.h"
#import "TiXianVC.h"
#import "WithdrawVCtrl.h"
#define HeadVH 150
@interface CapitalVC ()<UIScrollViewDelegate>
@property (nonatomic,strong)UICountingLabel * fundLbael;
@property (nonatomic,strong)UICountingLabel * accLabel;
@property (nonatomic,strong)HMSegmentedControl * segment;
@property (nonatomic,strong) UIScrollView *superScrollView;
@end

@implementation CapitalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSNotificationCenter * Center = [NSNotificationCenter defaultCenter];
    [Center addObserver:self selector:@selector(NotificationCenterCommunication:) name:NFC_LocLogin object:nil];
    [self creatHeadView];
    [self getNetData];
    
}
-(void)creatHeadView
{
    UIView * headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, HeadVH)];
    headerView.backgroundColor = LTColorHex(0x393B50);
    [self.view addSubview:headerView];
    
    UILabel * label =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 30)];
    label.font =[UIFont systemFontOfSize:19];
    label.textColor =[UIColor whiteColor];
    label.text = @"账户余额(元):";
    [headerView addSubview:label];

    if (!_fundLbael) {
    _fundLbael =[[UICountingLabel alloc]initWithFrame:CGRectMake(label.xw_ + 10 , 10, 180, 30)];
    _fundLbael.font =[UIFont systemFontOfSize:19];
    _fundLbael.method = UILabelCountingMethodLinear;
    _fundLbael.format = @"%.2f";
    [_fundLbael countFrom:0.00 to:12433.23 withDuration:0.4];
    _fundLbael.textAlignment = NSTextAlignmentLeft;
    _fundLbael.textColor =[UIColor whiteColor];
    [headerView addSubview:_fundLbael];
    }
    
    UILabel * label1 =[[UILabel alloc]initWithFrame:CGRectMake(10, label.yh_ + 10, 150, 30)];
    label1.font =[UIFont systemFontOfSize:19];
    label1.textColor =[UIColor whiteColor];
    label1.text = @"可用保证金(元):";
    [headerView addSubview:label1];
    
    if (!_accLabel) {
        _accLabel =[[UICountingLabel alloc]initWithFrame:CGRectMake(label1.xw_ + 10 , label.yh_ + 10, 180, 30)];
        _accLabel.font =[UIFont systemFontOfSize:19];
        _accLabel.method = UILabelCountingMethodLinear;
        _accLabel.format = @"%.2f";
        _accLabel.textAlignment = NSTextAlignmentLeft;
        _accLabel.textColor =[UIColor whiteColor];
        [headerView addSubview:_accLabel];
    }
    
    
    UIButton *RechargeBt =[UIButton buttonWithType:(UIButtonTypeCustom)];
    [RechargeBt setTitle:@"充值" forState:(UIControlStateNormal)];
    RechargeBt.frame = CGRectMake(10, label1.yh_ + 18, (Screen_width - 30)/2, 40);
    RechargeBt.titleLabel.font =[UIFont systemFontOfSize:13];
    CGColorSpaceRef cmykSpace = CGColorSpaceCreateDeviceCMYK();
    CGFloat cmykValue[] = {0, 0, 0, 0, 0};
    CGColorRef colorCMYK = CGColorCreate(cmykSpace, cmykValue);
    CGColorSpaceRelease(cmykSpace);
    RechargeBt.layer.cornerRadius = 5.0;
    RechargeBt.layer.borderColor = colorCMYK;
    RechargeBt.layer.borderWidth = 1.0f;
    RechargeBt.backgroundColor =BlueLineColor;
    [RechargeBt addTarget:self action:@selector(rechanergeAction) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView addSubview:RechargeBt];
    
    UIButton *desBt =[UIButton buttonWithType:(UIButtonTypeCustom)];
    [desBt setTitle:@"提现" forState:(UIControlStateNormal)];
    desBt.frame = CGRectMake(RechargeBt.xw_ + 10, label1.yh_ + 18, (Screen_width - 30)/2, 40);
    desBt.titleLabel.font =[UIFont systemFontOfSize:13];
    desBt.layer.cornerRadius = 5.0;
    desBt.layer.borderColor = colorCMYK;
    desBt.layer.borderWidth = 1.0f;
    desBt.backgroundColor =[UIColor lightGrayColor];
    [desBt addTarget:self action:@selector(desBtAction) forControlEvents:(UIControlEventTouchUpInside)];
    [headerView addSubview:desBt];
    
    NSArray * subjectsMArr = @[@"交易记录", @"出金记录",@"入金记录"];
    self.segment =[[HMSegmentedControl alloc]initWithSectionTitles:subjectsMArr];
    self.segment.frame =  CGRectMake(0, headerView.yh_, self.w_, 40);
    self.segment.selectionIndicatorHeight =3.0f;
    self.segment.backgroundColor =LTBgColor;
    self.segment.type =HMSegmentedControlTypeText;
    self.segment.selectedTitleTextAttributes =@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]};
    self.segment.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor] };
    self.segment.selectionIndicatorColor =BlueLineColor;
    [self.segment addTarget:self action:@selector(selectAction) forControlEvents:(UIControlEventValueChanged)];
    self.segment.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.view addSubview:self.segment];
    
    CGFloat y = self.segment.yh_;
    CGFloat h = ScreenH_Lit - y  - HeadVH -15;
    CGRect frame = CGRectMake(0, y, self.w_, h);
    _superScrollView =[[UIScrollView alloc]initWithFrame:frame];
    _superScrollView.delegate = self;
    _superScrollView.showsHorizontalScrollIndicator = NO;
    _superScrollView.bounces=NO;
    [_superScrollView setPagingEnabled:YES];
    _superScrollView.userInteractionEnabled = YES;
    [_superScrollView setContentSize:CGSizeMake(Screen_width*3,h)];
    _superScrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_superScrollView];
    
    FundListVC * fundList =[[FundListVC alloc]init];
    fundList.view.frame = CGRectMake(0, 0, Screen_width, h);
    [self addChildViewController:fundList];
    [self.superScrollView addSubview:fundList.view];
    
    OutGodViewController * outVC =[[OutGodViewController alloc]init];
    outVC.view.frame = CGRectMake(Screen_width, 0, Screen_width, h);
    [self addChildViewController:outVC];
    [self.superScrollView addSubview:outVC.view];
    
    InGodViewController * inVC =[[InGodViewController alloc]init];
    inVC.view.frame = CGRectMake(Screen_width * 2, 0, Screen_width, h);
    [self addChildViewController:inVC];
    [self.superScrollView addSubview:inVC.view];
}
-(void)selectAction
{
    if (_segment.selectedSegmentIndex == 0) {
        _superScrollView.contentOffset = CGPointMake(0, 0);
    }else if (_segment.selectedSegmentIndex == 1)
    {
        _superScrollView.contentOffset = CGPointMake(Screen_width, 0);
    }else
    {
        _superScrollView.contentOffset = CGPointMake(Screen_width * 2, 0);
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.superScrollView.bounds.origin.x == 0){
        self.segment.selectedSegmentIndex = 0;
    }else if (self.superScrollView.bounds.origin.x == Screen_width) {
        self.segment.selectedSegmentIndex = 1;
    }else if (self.superScrollView.bounds.origin.x == Screen_width * 2)
    {
        self.segment.selectedSegmentIndex = 2;
    }
}
-(void)getNetData
{
    if (notemptyStr([NSUserDefaults objFoKey:MT4ID])) {
        [self showLoadingView];
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/user/extened"];
    NSDictionary * dic = @{@"mt4id":[NSUserDefaults objFoKey:MT4ID]};
    [[NetworkRequests sharedInstance]GET:urlString dict:dic succeed:^(id data) {
        if ([[data objectForKey:@"code"]integerValue] == 0) {
            NSDictionary * dic = [data objectForKey:@"dataObject"];
            NSString * yue = [dic objectForKey:@"balance"];
            NSString * bao =[dic objectForKey:@"margin_free"];
            [self.fundLbael countFrom:0.00 to:yue.doubleValue  withDuration:0.4];
            [self.accLabel countFrom:0.00 to:bao.doubleValue withDuration:0.4];
            [self hideLoadingView];
        }
    } failure:^(NSError *error) {
        [self hideLoadingView];
    }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)clickAction
{
    
}
//充值
-(void)rechanergeAction
{
    WebView * webView =[[WebView alloc]init];
    webView.state = 1;
    [self presentVC:webView];
}
//提现
-(void)desBtAction
{
    TiXianVC * vc  =[[TiXianVC alloc]init];
    [self presentVC:vc];
}

/** 通知回调*/
- (void)NotificationCenterCommunication:(NSNotification*)sender{
    NSLog(@"调用了");
    [self getNetData];
}

/** 注销通知*/
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NFC_LocLogin object:nil];
}
@end
