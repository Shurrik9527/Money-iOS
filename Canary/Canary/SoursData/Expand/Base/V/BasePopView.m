//
//  BasePopView.m
//  Canary
//
//  Created by litong on 2017/5/26.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BasePopView.h"

@interface BasePopView ()

@property (nonatomic,assign) CGFloat contentViewH;

@end

@implementation BasePopView


- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenW_Lit, ScreenH_Lit);
        self.backgroundColor = LTMaskColor;
    }
    return self;
}

- (void)configContentH:(CGFloat)h {
    self.contentViewH = h;
    self.contentViewY = ScreenH_Lit - self.contentViewH;
    [self createView];
}

- (void)createView {
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(0, 0, self.w_, self.h_);
    [bgBtn addTarget:self action:@selector(shutView) forControlEvents:UIControlEventTouchUpInside];
    bgBtn.backgroundColor = self.backgroundColor;
    [self addSubview:bgBtn];
    
    self.contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(0, self.contentViewY, self.w_, self.contentViewH);
    _contentView.backgroundColor = LTWhiteColor;
    [self addSubview:_contentView];
}


#pragma mark - action

- (void)shutView {
    [self showView:NO];
}


#pragma mark 动画显示隐藏

static CGFloat animateDuration = 0.3;
- (void)showView:(BOOL)show {
    WS(ws);
    if (show) {
        [self.superview bringSubviewToFront:self];
        self.alpha = 0.3;
        [self changeContentViewUp:NO];
        self.hidden = NO;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:animateDuration animations:^{
            ws.alpha = 1;
            [ws changeContentViewUp:YES];
        } completion:^(BOOL finished) {
            ws.userInteractionEnabled = YES;
        }];
        
    } else {
        ShutAllKeyboard;
        self.alpha = 1;
        self.userInteractionEnabled = NO;
        [self changeContentViewUp:YES];
        [UIView animateWithDuration:animateDuration animations:^{
            ws.alpha = 0.3;
            [ws changeContentViewUp:NO];
        } completion:^(BOOL finished) {
            ws.userInteractionEnabled = YES;
            ws.hidden = YES;
        }];
    }
    
}

- (void)changeContentViewUp:(BOOL)up {
    CGFloat y = up ? self.contentViewY : self.h_;
    [_contentView setOY:y];
}



@end
