//
//  LiveScrollView.m
//  ixit
//
//  Created by litong on 16/10/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "LiveScrollView.h"
#import "OutcryVCtrl.h"
#import "ChartroomVCtrl.h"

static NSInteger kViewTag = 1000;

@interface LiveScrollView()<UIScrollViewDelegate>

@end

@implementation LiveScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.delegate = self;
    }
    return self;
}

#pragma mark - 外部调用

- (void)setPageNum:(NSInteger)pageNum {
    _pageNum = pageNum;
    self.contentSize = CGSizeMake(self.w_*_pageNum, self.h_);
}
- (void)setView:(UIView *)view toIndex:(NSInteger)idx {
    UIView *oldView = [self viewWithTag:(idx + kViewTag)];
    if (oldView) {
        [oldView removeFromSuperview];
    }
    [self scViewAddSubView:view idx:idx];
}

- (void)moveToIdx:(NSInteger)idx {
    [self setContentOffset:CGPointMake(idx * self.w_, 0)];
}

- (void)changeAllFrameH:(CGFloat)h {
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
    
    for (int i = 0; i < _pageNum; i ++) {
        UIView *view = [self viewWithTag:(i + kViewTag)];
        CGRect frame = view.frame;
        frame.size.height = h;
        view.frame = frame;
    }
}

#pragma mark - 内部方法

- (void)scViewAddSubView:(UIView *)view idx:(NSInteger)idx {
    view.tag = kViewTag + idx;
    view.frame = CGRectMake(idx * self.w_, 0, self.w_, self.h_);
    [self addSubview:view];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger curPage = scrollView.contentOffset.x / scrollView.w_;
    if (_dgt && [_dgt respondsToSelector:@selector(scrollTo:)]) {
        [_dgt scrollTo:curPage];
    }
}

@end
