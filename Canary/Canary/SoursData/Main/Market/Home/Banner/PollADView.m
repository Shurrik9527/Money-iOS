//
//  PollADView.m
//  ixit
//
//  Created by litong on 2016/11/8.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "PollADView.h"
#import "UIImageView+WebCache.h"
#import "UIView+LTGesture.h"

//static NSInteger kBtnTag = 1120;

static CGFloat kPollADViewH = 130;

@interface PollADView ()<UIScrollViewDelegate>
{
    
    NSInteger tmpPage;
    NSInteger curPage;
    NSInteger allPage;
}

@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *datas;
@property (nonatomic,strong) NSTimer *myTimer;

@end

@implementation PollADView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        allPage = 0;
        [self createView];
    }
    return self;
}

- (void)createView {
    _scView = [[UIScrollView alloc] init];
    _scView.frame = CGRectMake(0, 0, self.w_, self.h_);
    _scView.delegate = self;
    _scView.showsHorizontalScrollIndicator = NO;
    _scView.pagingEnabled = YES;
    [self addSubview:_scView];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.h_-12-6, self.w_, 6)];
    _pageControl.currentPage = curPage;
    _pageControl.pageIndicatorTintColor = LTColorHexA(0x000000,0.3);
    _pageControl.currentPageIndicatorTintColor = LTWhiteColor;
    _pageControl.defersCurrentPageDisplay = YES;
    [self addSubview:_pageControl];
    
    [_scView addSingeTap:@selector(clickImage) target:self];
    
}



#pragma mark - action

- (void)clickImage {
    UMengEventWithParameter(page_home, @"loopImageView_tabIndex", @(curPage));
    id mo = _datas[curPage];
    _clickPollADView ? _clickPollADView(mo) : nil;
}

- (void)beginAutoScroll {
    tmpPage++;
    if (tmpPage >= allPage+1) {
        tmpPage = 1;
        [self setContentOffsetX:0];
        [self scrollRectToVisibleX:ScreenW_Lit];
        curPage = _scView.contentOffset.x/ScreenW_Lit;
        _pageControl.currentPage = curPage;
    } else {
        [self scrollRectToVisibleX:tmpPage*ScreenW_Lit];
        curPage = _scView.contentOffset.x/ScreenW_Lit;
        _pageControl.currentPage = curPage;
    }
    [self start];
}


- (void)beginAutoScroll0 {
    CGPoint point = _scView.contentOffset;
    if (point.x == ScreenW_Lit*allPage) {
        [self setContentOffsetX:0];
        [self scrollRectToVisibleX:ScreenW_Lit];
        curPage = _scView.contentOffset.x/ScreenW_Lit;
        _pageControl.currentPage = curPage;
    } else {
        [self scrollRectToVisibleX:point.x + ScreenW_Lit];
        curPage = _scView.contentOffset.x/ScreenW_Lit;
        _pageControl.currentPage = curPage;
    }
    
    [self start];
}

#pragma mark UIScrollerViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        tmpPage = allPage;
        [self setContentOffsetX:ScreenW_Lit*(allPage)];
    }  else if (scrollView.contentOffset.x == ScreenW_Lit*(allPage+1)) {
        tmpPage = 1;
        [self setContentOffsetX:ScreenW_Lit];
    }
    curPage = scrollView.contentOffset.x/ScreenW_Lit-1;
    _pageControl.currentPage = curPage;
    tmpPage = curPage + 1;
    [self start];
}

#pragma mark - utils

- (void)configBegainData {
    [self setContentOffsetX:ScreenW_Lit];
    curPage = 0;
    tmpPage = 1;
    _pageControl.currentPage = curPage;
}

- (void)setContentOffsetX:(CGFloat)x  {
    [_scView setContentOffset:CGPointMake(x, 0) animated:NO];
}

- (void)scrollRectToVisibleX:(CGFloat)x {
    [_scView scrollRectToVisible:CGRectMake(x, 0, ScreenW_Lit, _scView.h_) animated:YES];
}

- (void)addDatasToView {
    allPage = _datas.count;
    
    CGFloat h = [PollADView viewH];
    CGFloat w = self.w_;
    _scView.contentSize = CGSizeMake((allPage+2) * w, h);
    _pageControl.numberOfPages = allPage;
    
    NSInteger i = 0;
    
    for (id mo in _datas) {
        [self addImageViewWithObj:mo idx:i];
        i++;
    }
    
    [self addImageViewWithObj:_datas[0] idx:allPage];
    [self addImageViewWithObj:_datas[(allPage-1)] idx:-1];
    
    [self configBegainData];
}

- (void)addImageViewWithObj:(id)mo idx:(NSInteger)idx {
    NSString *imgUrl = @"";
    if ([mo isKindOfClass:[PollADModel class]]) {
        PollADModel *item = (PollADModel *)mo;
        imgUrl = item.imgAddress;
    } else if ([mo isKindOfClass:[TaskHeadMo class]]) {
        TaskHeadMo *item = (TaskHeadMo *)mo;
        imgUrl = item.pic;
    }
    CGFloat i = idx + 1;
    CGFloat h = [PollADView viewH];
    CGFloat w = self.w_;
    UIImageView *iv = [[UIImageView alloc] init];
    iv.frame = CGRectMake(i * w, 0, w, h);
    [iv sd_setImageWithURL:[imgUrl toURL] placeholderImage:[UIImage imageNamed:@"InviteFriends"]];
    iv.userInteractionEnabled = YES;
    [_scView addSubview:iv];
}

#pragma mark - 外部

- (void)refDatas:(NSArray *)datas {
    NSInteger count = datas.count;
    if (count <= 0) {
        return;
    }
    _datas = datas;
    for (UIView *view in _scView.subviews) {
        if (![view isKindOfClass:[UIPageControl class]]) {
            [view removeFromSuperview];
        }
    }
    [self addDatasToView];
    [self start];
    
    if (_datas.count > 1) {
        _scView.bounces = YES;
        _pageControl.hidden = NO;
    } else {
        _scView.bounces = NO;
        _pageControl.hidden = YES;
    }
}

//- (void)start {
//    [self stop];
//    if (_datas && _datas.count > 1) {
//        if (!self.myTimer) {
//            WS(ws);
//            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:ws selector:@selector(beginAutoScroll) userInfo:nil repeats:YES];
//        }
//    }
//}
//- (void)stop {
//    if (self.myTimer) {
//        [self.myTimer setFireDate:[NSDate distantFuture]];
//        [self.myTimer invalidate];
//        self.myTimer = nil;
//    }
//}

- (void)start {
    [self stop];
    if (_datas && _datas.count > 1) {
        [self performSelector:@selector(beginAutoScroll) withObject:nil afterDelay:3.0];
    }
}
- (void)stop {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginAutoScroll) object:nil];
}



//750*260
+ (CGFloat)viewH {
//    CGFloat h = (260/750.0)*ScreenW_Lit;
    CGFloat h = LTAutoW(kPollADViewH);
    return h;
}








@end
