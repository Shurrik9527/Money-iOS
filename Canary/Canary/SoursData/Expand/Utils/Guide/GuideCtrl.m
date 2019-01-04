//
//  GuideCtrl.m
//  Canary
//
//  Created by litong on 2017/5/5.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "GuideCtrl.h"

#define kGuidePage  3

//0不使用   1使用
#define UseGuidePageControl         0

@interface GuideCtrl ()<UIScrollViewDelegate>

@property (nonatomic,copy) GuideShutBlock shutBlock;
@property (nonatomic,copy) GuideRegisterBlock registerBlock;
@property (nonatomic,strong) UIScrollView *scView;
#if UseGuidePageControl
@property (nonatomic,strong) UIPageControl *pageControl;
#else
#endif

@property (nonatomic,strong) UIButton *goHome;
@property (nonatomic,strong) UIButton *goRegister ;

@end

@implementation GuideCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createScView];
    [self createPageControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createScView {
    self.scView = [[UIScrollView alloc] init];
    _scView.frame = [[UIScreen mainScreen] bounds];
    _scView.delegate = self;
    _scView.backgroundColor = [UIColor whiteColor];
    _scView.showsVerticalScrollIndicator = NO;
    _scView.showsHorizontalScrollIndicator = NO;
    _scView.pagingEnabled = YES;
//    _scView.bounces = NO;
    [self.view addSubview:_scView];
    
    NSInteger count = kGuidePage;
    _scView.contentSize = CGSizeMake(_scView.w_ * count, _scView.h_);
    
    NSString *imgNamePre = [self imgPre];
    for (NSInteger i = 0; i < count; i ++) {
        UIImageView *iv = [[UIImageView alloc] init];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%li.jpg",imgNamePre,(long)i]];
        iv.frame = CGRectMake(_scView.w_ * i, 0, _scView.w_, _scView.h_);
        [_scView addSubview:iv];
        
        if (i == (count-1)) {
//            iv.userInteractionEnabled = YES;
//            [iv addSubview:self.goHome];
//            [iv addSubview:self.goRegister];
            iv.userInteractionEnabled = YES;

            [iv addSingeTap:@selector(shutAction) target:self];
        }
    }
    
}

- (void)createPageControl {
#if UseGuidePageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, ScreenH_Lit - LTAutoW(40), ScreenW_Lit, 12)];
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = LTRGBA(199, 199, 199, 0.8);
    _pageControl.currentPageIndicatorTintColor = LTRGBA(248, 248, 248, 1);
    _pageControl.defersCurrentPageDisplay = YES;
    _pageControl.numberOfPages = kGuidePage;
    [self.view addSubview:_pageControl];
    
    [self.view bringSubviewToFront:_pageControl];
#else
#endif
}


#pragma mark - action

//进入首页
- (void)shutAction {
    [GuideCtrl setShowed:YES];
    self.shutBlock ? self.shutBlock() : nil;
}

//注册
- (void)registerAction {
    [GuideCtrl setShowed:YES];
    self.registerBlock ? self.registerBlock() : nil;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
#if UseGuidePageControl
    NSInteger curPage = scrollView.contentOffset.x / scrollView.w_;
    _pageControl.currentPage = curPage;
#else
#endif
    
}

// 滑动视图，当手指离开屏幕那一霎那，调用该方法。一次有效滑动，只执行一次。
// decelerate,指代，当我们手指离开那一瞬后，视图是否还将继续向前滚动（一段距离），经过测试，decelerate=YES
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat x = scrollView.contentOffset.x;
    BOOL leaveView = x >= (kGuidePage - 1 + 0.1)*ScreenW_Lit;
    NSLog(@"xxx == %f",x);
    NSLog(@"leaveView == %d",leaveView);
    if (leaveView) {
        [self shutAction];
    }
}

#pragma mark - utils


- (UIButton *)goHome {
    if (!_goHome) {
        UIButton *goHome = [[UIButton alloc] initWithFrame:[self intoHomeBtnFrame]];
        [goHome addTarget:self action:@selector(shutAction) forControlEvents:UIControlEventTouchUpInside];
        _goHome = goHome;
        goHome = nil;
    }
    return _goHome;
}

- (UIButton *)goRegister {
    if (!_goRegister) {
        UIButton *goRegister = [[UIButton alloc] initWithFrame:[self registerBtnFrame]];
        [goRegister addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        _goRegister = goRegister;
        goRegister = nil;
    }
    return _goRegister;
}


- (NSString *)imgPre {
    CGFloat sh = ScreenH_Lit;
    if (sh == 480) {
        return @"guid_4_";
    } else if (sh == 568) {
        return @"guid_5_";
    } else if (sh == 667) {
        return @"guid_6_";
    } else {
        return @"guid_6p_";
    }
}

- (CGRect)registerBtnFrame {
    CGFloat sh = ScreenH_Lit;
    if (sh == 480) {
        CGFloat x = 200/2.0;
        CGFloat y = 364/2.0;
        CGFloat w = 234/2.0;
        CGFloat h = 95/2.0;
        return CGRectMake(x, y, w, h);
    } else if (sh == 568) {
        CGFloat x = 206/2.0;
        CGFloat y = 450/2.0;
        CGFloat w = 242/2.0;
        CGFloat h = 106/2.0;
        return CGRectMake(x, y, w, h);
    } else if (sh == 667) {
        CGFloat x = 242/2.0;
        CGFloat y = 534/2.0;
        CGFloat w = 280/2.0;
        CGFloat h = 120/2.0;
        return CGRectMake(x, y, w, h);
    } else {
        CGFloat x = 400/3.0;
        CGFloat y = 880/3.0;
        CGFloat w = 470/3.0;
        CGFloat h = 200/3.0;
        return CGRectMake(x, y, w, h);
    }
}

- (CGRect)intoHomeBtnFrame {
    CGFloat sh = ScreenH_Lit;
    if (sh == 480) {
        CGFloat x = 218/2.0;
        CGFloat y = 512/2.0;
        CGFloat w = 234/2.0;
        CGFloat h = 95/2.0;
        return CGRectMake(x, y, w, h);
    } else if (sh == 568) {
        CGFloat x = 206/2.0;
        CGFloat y = 590/2.0;
        CGFloat w = 242/2.0;
        CGFloat h = 106/2.0;
        return CGRectMake(x, y, w, h);
    } else if (sh == 667) {
        CGFloat x = 242/2.0;
        CGFloat y = 690/2.0;
        CGFloat w = 280/2.0;
        CGFloat h = 120/2.0;
        return CGRectMake(x, y, w, h);
    } else {
        CGFloat x = 400/3.0;
        CGFloat y = 1160/3.0;
        CGFloat w = 470/3.0;
        CGFloat h = 200/3.0;
        return CGRectMake(x, y, w, h);
    }
}




#pragma mark - 外部

+ (GuideCtrl *)showGuideShutBlock:(GuideShutBlock)shutBlock registerBlock:(GuideRegisterBlock)registerBlock {
    GuideCtrl *ctrl = [[GuideCtrl alloc] init];
    ctrl.shutBlock = shutBlock;
    ctrl.registerBlock = registerBlock;
    return ctrl;
}

+ (BOOL)showed {
    BOOL show = [[NSUserDefaults standardUserDefaults] boolForKey:kStr_GuideShowed];
    return show;
}
+ (void)setShowed:(BOOL)show {
    [[NSUserDefaults standardUserDefaults] setBool:show forKey:kStr_GuideShowed];
}

@end
