//
//  ViewController.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ViewController.h"
#import "HomeVCtrl.h"
#import "MarketVCtrl.h"
#import "DealVCtrl.h"
#import "MineVCtrl.h"
#import "LTSocketServe.h"

@interface ViewController ()

@property (nonatomic, strong) BaseVCtrl * currentCtrl;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) NSArray * tabTitles;
@property (nonatomic, strong) NSArray * tabInfos;
@property (nonatomic, strong) NSArray * tabIcons;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTabBar];
    [self configControllers];
    
    [LTSocketServe connectSocket];
    [LTSocketServe sendRTCAll];
    NFC_AddObserver(NFC_HideDeal, @selector(reloadTabBar));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - init

- (void)configTabBar {
    if (!self.footer) {
        
        _tabTitles = [NSArray arrayWithObjects:@"首页", @"行情", @"交易", @"我的", nil];
#if useNewYearTheme
        _tabIcons = @[@"NY_0-0", @"NY_1-0", @"NY_2-0",  @"NY_3-0", ];
#else
        _tabIcons = @[ @"0-0", @"1-0", @"2-0",  @"3-0" ];
#endif
//        NSLog(@"UD_EnableDeal =%@",UD_ObjForKey(EnableDeal));
        if ([LTUser hideDeal]) {
            _tabTitles = [NSArray arrayWithObjects:@"首页", @"行情", @"我的", nil];
            _tabIcons = @[ @"0-0", @"1-0",  @"3-0" ];
        }
        NSLog(@"=============== %f",kBottomBarHeight);
        // 底部导航栏
        self.footer =
        [[TabBarView alloc] initWithFrame:CGRectMake(0, ScreenH_Lit - TabBarH_Lit - kBottomBarHeight,ScreenW_Lit, TabBarH_Lit + kBottomBarHeight)
                                   titles:_tabTitles
                                    Icons:_tabIcons
                                   target:self];
        self.footer.backgroundColor = TabBarBgCoror;
        [self.view addSubview:self.footer];
    }
}

- (void)configControllers {
    
    //首页
    HomeVCtrl *homeVCtrl = [[HomeVCtrl alloc] init];
    [self addChildViewController:homeVCtrl];
    
    //行情
    MarketVCtrl *marketVCtrl = [[MarketVCtrl alloc] init];
    [self addChildViewController:marketVCtrl];
    
    //交易
    DealVCtrl *dealVC = [[DealVCtrl alloc] init];
    [self addChildViewController:dealVC];

    
    //视频
//    LiveVCtrl *liveCtrl = [[LiveVCtrl alloc] init];
//    [self addChildViewController:liveCtrl];
    
    //我的
    MineVCtrl *mineVCtrl = [[MineVCtrl alloc] init];
    [self addChildViewController:mineVCtrl];
    
    // 当前controller
    _currentCtrl = homeVCtrl;
    CGFloat h = Screen_height - NavBarH_Lit;
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h)];
    
    _contentView.backgroundColor = LTColorHex(0xFFFFFF);
    [_contentView addSubview:_currentCtrl.view];
    _currentCtrl.view.frame = _contentView.bounds;
    [self.view addSubview:_contentView];
    
    [self selectTabBarType:TabBarType_Home];
}

-(void)reloadTabBar {
    [self.footer removeFromSuperview];
    self.footer=nil;
    [self configTabBar];
    if ([LTUser hideDeal]) {
        for (int i = 0; i<self.childViewControllers.count; i++) {
            if ([self.childViewControllers[i] isKindOfClass:[DealVCtrl class]]) {
                [self.childViewControllers[i] removeFromParentViewController];
            }
        }
    }
}
#pragma mark - action

- (void)selectTabBarType:(TabBarType)type {
    _tabBarType = type;

    if (_tabBarType >= self.childViewControllers.count) {
        return;
    }
    
    BaseVCtrl *vc = [self.childViewControllers objectAtIndex:_tabBarType];
    vc.footer = self.footer;
    vc.view.frame = _contentView.bounds;
    [self.view bringSubviewToFront:self.footer];
    
    if ([_currentCtrl isEqual:vc]) {
        return;
    }
    
    [_contentView addSubview:vc.view];

    WS(ws);
    __weak typeof(vc) wvc = vc;
    [UIView animateWithDuration:0.3 animations:^{
        wvc.view.frame = CGRectMake(0, wvc.view.y_, wvc.view.w_, wvc.view.h_);
    } completion:^(BOOL finished) {
        [ws.currentCtrl.view removeFromSuperview];
        ws.currentCtrl = wvc;
    }];
    
    [self.footer changeTextColorWithCurrentIndex:_tabBarType];
}

- (void)pushReg {
    NSLog(@"pushReg");
}

- (void)clickTabButtonAction:(UIButton *)button {
    NSInteger tag = button.tag;
//    NSArray *vc = [self childViewControllers];
    
    if([self.tabTitles[tag] isEqualToString:@"交易"]) {
        if (![LTUser hideDeal]) {
            BOOL locHasLogin = [self checkLocHasLogin:@"登录后才能操作"];
            if (!locHasLogin) {
                return;
            }
        }
    }
    [self selectTabBarType:tag];
}

#pragma mark - 
- (void)themeChanged {
    [super themeChanged];
    
    self.footer.backgroundColor = LTColorHex(0xf6f6f6);
    [self.footer changeTextColorWithCurrentIndex:(int) [self.childViewControllers indexOfObject:_currentCtrl]];
}


@end
