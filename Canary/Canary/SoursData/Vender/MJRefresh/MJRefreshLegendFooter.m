//  代码地址: https://github.com/CoderMJLee/MJRefresh
//  代码地址: http://code4app.com/ios/%E5%BF%AB%E9%80%9F%E9%9B%86%E6%88%90%E4%B8%8B%E6%8B%89%E4%B8%8A%E6%8B%89%E5%88%B7%E6%96%B0/52326ce26803fabc46000000
//  MJRefreshLegendFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/5.
//  Copyright (c) 2015年 itcast. All rights reserved.
//

#import "MJRefreshLegendFooter.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "UIScrollView+MJExtension.h"

@interface MJRefreshLegendFooter()
@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@property (nonatomic, weak) UIImageView *arrowImage;
@property(assign,nonatomic)BOOL isEndAnimation;

@end

@implementation MJRefreshLegendFooter
#pragma mark - 懒加载
- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:MJRefreshSrcName(@"arrow.png")]];
        [self addSubview:_arrowImage = arrowImage];
        _arrowImage.hidden=YES;
    }
    return _arrowImage;
}
#pragma mark - 初始化方法
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat arrowX = self.stateHidden ? self.mj_w * 0.5 : (self.mj_w * 0.3);
    self.arrowImage.center = CGPointMake(arrowX, self.mj_h * 0.5);

    // 指示器
    if (self.stateHidden) {
        self.activityView.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
    } else {
        self.activityView.center = CGPointMake(self.mj_w * 0.4 - 40, self.mj_h * 0.5);
    }
    
//    self.arrowImage.center = CGPointMake(0.348*self.mj_w, self.mj_h * 0.5);
//    self.activityView.center = self.arrowImage.center;
    
}

#pragma mark - 公共方法
- (void)setState:(MJRefreshFooterState)state
{
    if (self.state == state) return;
    
    switch (state) {
        case MJRefreshFooterStateIdle:
        {
            _arrowImage.hidden=YES;
            [LTUtils endAnimation:_arrowImage];
        }
//            [self.activityView stopAnimating];
            break;
            
        case MJRefreshFooterStateRefreshing:
        {
            _arrowImage.hidden=NO;
            [LTUtils startRotationAnimation:_arrowImage];
        }
//            [self.activityView startAnimating];
            break;
            
        case MJRefreshFooterStateNoMoreData:
        {
            _isEndAnimation=NO;
            _arrowImage.hidden=YES;
            [LTUtils endAnimation:_arrowImage];
//            [self.activityView stopAnimating];
        }
            break;
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}

@end
