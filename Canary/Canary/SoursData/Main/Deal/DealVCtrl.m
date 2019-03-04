//
//  DealVCtrl.m
//  Canary
//
//  Created by litong on 2017/5/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "DealVCtrl.h"

#import "DealHeadV.h"
#import "DealHeadShortV.h"
#import "LiveScrollView.h"
#import "FundVCtrl.h"
#import "ProductVCtrl.h"
#import "MyGainDetailView.h"
#import "RechargeVCtrl.h"
#import "WithdrawVCtrl.h"
#import "ManagerBankCardVC.h"
#import "DealHistoryVCtrl.h"
#import "MoneyRecordVCtrl.h"

#import "PositionsVC.h"
#import "CapitalVC.h"
#import "HMSegmentedControl.h"
#import "BuyingSellingVC.h"
#import "PutupVC.h"

@interface DealVCtrl ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIButton * ruleBtn;//规则按钮
@property (nonatomic,strong) UIButton * customerBtn;//客服按钮
@property (nonatomic,strong) HMSegmentedControl * segment;

@property(strong,nonatomic)UIView * dealHead;
@property(strong,nonatomic) DealHeadV * dealLongV;
@property(strong,nonatomic) DealHeadShortV * dealShortV;

@property (nonatomic,strong) UIScrollView *superScrollView;

@property (nonatomic,strong) ProductVCtrl *productVC;
@property(assign,nonatomic)NSInteger index;
@property (nonatomic,strong) PositionsVC * positionVC;
@property (nonatomic,strong) CapitalVC * capitalVC;
@property (nonatomic,strong) BuyingSellingVC * buyingSellingVC;
@property (nonatomic,strong) PutupVC * putupVC;
@end

@implementation DealVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createHead];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    [self createSegmentView];
    [self createScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"进入页面");
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"离开页面");
}

#pragma mark - DealHead

- (void)createHead {
    CGRect frame =CGRectMake(0, NavBarTop_Lit, ScreenW_Lit,DealHeadVH);
    _dealHead=[[UIView alloc]init];
    _dealHead.frame=frame;
    _dealHead.backgroundColor=NavHeadBgCoror;
    [self.view addSubview:_dealHead];

    frame.origin.y=0;
}
#pragma mark - NavBar
- (void)configNavBar {
//    [self navTitle:@"交易" backType:BackType_Non rightImgName:@"live_btn_service"];
    [self navTitle:@"交易"];
//    [self addLeftImageBtn:@"navIcon_tip"];
}

- (void)leftAction {
    NSString *url = URL_DealRule;
    [self pushWeb:url title:@"交易规则"];
}
#pragma mark - Segment
static CGFloat segmentViewH = 40;

- (void)createSegmentView {
    NSArray * arr = @[@"持仓",@"资金"];
//    NSArray * arr = @[@"买卖",@"持仓",@"挂单",@"资金"];

    self.segment =[[HMSegmentedControl alloc]initWithSectionTitles:arr];
    self.segment.frame =  CGRectMake(0, _dealHead.yh_, self.w_, segmentViewH);
    self.segment.selectionIndicatorHeight =3.0f;
    self.segment.backgroundColor =NavHeadBgCoror;
    self.segment.type =HMSegmentedControlTypeText;
    self.segment.selectedTitleTextAttributes =@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.segment.titleTextAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor lightGrayColor] };
    self.segment.selectionIndicatorColor =BlueLineColor;
    [self.segment addTarget:self action:@selector(selectAction) forControlEvents:(UIControlEventValueChanged)];
    self.segment.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segment.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    [self.view addSubview:self.segment];
}

- (void)createScrollView {
    CGFloat y = self.segment.yh_;
    CGFloat h = ScreenH_Lit - y - TabBarH_Lit ;
    CGRect frame = CGRectMake(0, y, self.w_, h);
    _superScrollView =[[UIScrollView alloc]initWithFrame:frame];
    _superScrollView.delegate = self;
    _superScrollView.showsHorizontalScrollIndicator = NO;
    [_superScrollView setPagingEnabled:YES];
    _superScrollView.userInteractionEnabled = YES;
    [_superScrollView setContentSize:CGSizeMake(Screen_width * 2,h)];
    _superScrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_superScrollView];
    
    // 买卖
//    self.buyingSellingVC =[[BuyingSellingVC alloc]init];
//    self.buyingSellingVC.view.frame = CGRectMake(0, 0, Screen_width, h);
//    [self addChildViewController:self.buyingSellingVC];
//    [self.superScrollView addSubview:self.buyingSellingVC.view];
    
    // 持仓
    self.positionVC =[[PositionsVC alloc]init];
    self.positionVC.view.frame = CGRectMake(Screen_width * 0, 0, Screen_width, h);
    [self addChildViewController:self.positionVC];
    [self.superScrollView addSubview:self.positionVC.view];
    
    // 挂单
//    self.putupVC =[[PutupVC alloc]init];
//    self.putupVC.view.frame = CGRectMake(Screen_width * 2 ,0, Screen_width,h);
//    [self addChildViewController:self.putupVC];
//    [self.superScrollView addSubview:self.putupVC.view];
    
    // 资金
    self.capitalVC =[[CapitalVC alloc]init];
    self.capitalVC.view.frame = CGRectMake(Screen_width * 1,0, Screen_width,h);
    [self addChildViewController:self.capitalVC];
    [self.superScrollView addSubview:self.capitalVC.view];

    
}

#pragma mark - SegmentViewDelegate
-(void)selectAction
{
    _superScrollView.contentOffset = CGPointMake(Screen_width * _segment.selectedSegmentIndex, 0);

    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    self.segment.selectedSegmentIndex = self.superScrollView.bounds.origin.x/ Screen_width;
    
//    if (self.superScrollView.bounds.origin.x == 0){
//        self.segment.selectedSegmentIndex = 0;
//    }else if (self.superScrollView.bounds.origin.x == Screen_width) {
//        ;
//    }
}


@end
