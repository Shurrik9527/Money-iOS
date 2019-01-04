//
//  FloatingPlayView.m
//  ixit
//
//  Created by litong on 2017/3/7.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "FloatingPlayView.h"
#import <PLPlayerKit/PLPlayerKit.h>

static NSInteger kPlayerViewTag = 1010;

@interface FloatingPlayView ()<PLPlayerDelegate>
{
    BOOL hasFulled;
}
@property (nonatomic,strong) LiveModel *liveModel;
@property (nonatomic, strong) PLPlayer  *player;
@property (nonatomic, strong)UIView *playerView;
@property (nonatomic, strong)UILabel *playEmptyLab;
@property (nonatomic, strong)UITapGestureRecognizer *tap;

@property (nonatomic,strong) UIButton *shutBtn;
@property (nonatomic,strong) UIButton *bgBtn;

@property (nonatomic,assign) CGPoint beginpoint;

@end

@implementation FloatingPlayView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createPlayer];
    }
    return self;
}

#pragma mark - 外部

- (void)showed:(BOOL)bl {
    [self play:bl];
    self.hidden = !bl;
}

- (void)play:(BOOL)bl {
    if (bl) {
        if((self.player.status == PLPlayerStatusPlaying)) {
            [self.player resume];
        } else {
            [self.player play];
        }
    } else {
        [self.player stop];
    }
}

- (void)playerFullScreen:(BOOL)fullScreen {
    CGRect frame;
    
    if (fullScreen) {
        frame = CGRectMake(0, 0, ScreenH_Lit, ScreenW_Lit);
    } else {
        frame = CGRectMake(0, 0, self.w_, self.h_);
    }
    
    self.playerView.frame = frame;
}

#pragma mark - 内部

- (void)createPlayer {
    
    hasFulled = NO;
    
    self.playEmptyLab = [[UILabel alloc] init];
    self.playEmptyLab.frame = CGRectMake(0, 0, self.w_, self.h_);
    self.playEmptyLab.font = [UIFont systemFontOfSize:16.f];
    self.playEmptyLab.text = @"当前是非视频直播时段\n稍后回来...";
    self.playEmptyLab.textColor = LTSubTitleColor;
    self.playEmptyLab.numberOfLines = 0;
    self.playEmptyLab.hidden = YES;
    self.playEmptyLab.textAlignment = NSTextAlignmentCenter;
    self.playEmptyLab.backgroundColor = LTColorHexA(0x356721, 0.6);
    [self addSubview:self.playEmptyLab];
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    NSString *rtmp = [UserDefaults stringForKey:FloatingRtmpStreamKey];
    NSURL *url = [NSURL URLWithString:rtmp];
    self.player = [PLPlayer playerWithURL:url option:option];
    self.player.delegate = self;
    self.player.backgroundPlayEnable = NO;
    
    UIView *playerView = self.player.playerView;
    playerView.tag = kPlayerViewTag;
    if (!playerView.superview) {
        self.playerView = playerView;
        self.playerView.frame = CGRectMake(0, 0, self.w_, self.h_);
    }
    [self addSubview:self.playerView];

    //关闭按钮
//    CGFloat shutBtnWH = 20;
//    CGFloat shutBtnMar = 8;
    CGFloat shutBtnWH = 36;
    CGFloat shutBtnMar = 0;
    self.shutBtn = [UIButton btnWithTarget:self action:@selector(shutPlayView) frame:CGRectMake(self.w_ - shutBtnWH - shutBtnMar, shutBtnMar, shutBtnWH, shutBtnWH)];
    [self.shutBtn setImage:[UIImage imageNamed:@"floating_shut"] forState:UIControlStateNormal];
    [self addSubview:self.shutBtn];
    
    [self play:YES];
    
    [self addSingeTap:@selector(intoLiveDetailVC) target:self];
    
}

#pragma mark - action

- (void)intoLiveDetailVC {
    if (_delegate && [_delegate respondsToSelector:@selector(pushLiveDetailVC)]) {
        [_delegate pushLiveDetailVC];
    }
}

- (void)playOrStop {
    if ([self.player isPlaying]) {
        [self play:NO];
    } else {
        [self play:YES];
    }
}

- (void)shutPlayView {
    WS(ws);
    [UserDefaults setObject:nil forKey:FloatingRtmpStreamKey];
    CGFloat cx = self.center.x;
    CGFloat x = ScreenW_Lit+10;
    if (cx <= ScreenW_Lit*0.5) {
        x = -1*x;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [ws setOX:x];
    } completion:^(BOOL finished) {
        [ws removeFromSuperview];
    }];
}

- (void)fullPlay {
    hasFulled = !hasFulled;
    [self playerFullScreen:hasFulled];
}


#pragma mark - PLPlayerDelegate

/**
 告知代理对象 PLPlayer 即将开始进入后台播放任务
 
 @param player 调用该代理方法的 PLPlayer 对象
 
 @since v1.0.0
 */
- (void)playerWillBeginBackgroundTask:(nonnull PLPlayer *)player {
    NSLog(@"playerWillBeginBackgroundTask");
}

/**
 告知代理对象 PLPlayer 即将结束后台播放状态任务
 
 @param player              调用该方法的 PLPlayer 对象
 
 @since v2.1.1
 */
- (void)playerWillEndBackgroundTask:(nonnull PLPlayer *)player {
    NSLog(@"playerWillEndBackgroundTask");
}

/**
 告知代理对象播放器状态变更
 
 @param player 调用该方法的 PLPlayer 对象
 @param state  变更之后的 PLPlayer 状态
 
 @since v1.0.0
 */
- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    //    NSLog(@"state  = %d",state);
    
}

/**
 告知代理对象播放器因错误停止播放
 
 @param player 调用该方法的 PLPlayer 对象
 @param error  携带播放器停止播放错误信息的 NSError 对象
 
 @since v1.0.0
 */
- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error{
    NSLog(@"paly error = %@",error);
    if (error) {//隐藏视频view
        self.playerView.hidden = YES;
        self.playEmptyLab.hidden = NO;
        [self sendSubviewToBack:self.playerView];
    } else {
        self.playerView.hidden = NO;
        self.playEmptyLab.hidden = YES;
        [self sendSubviewToBack:self.playEmptyLab];
    }
}

/**
 回调将要渲染的帧数据
 该功能只支持直播
 
 @param player 调用该方法的 PLPlayer 对象
 @param frame  将要渲染帧 YUV 数据。
 CVPixelBufferGetPixelFormatType 获取 YUV 的类型。
 软解为 kCVPixelFormatType_420YpCbCr8Planar.
 硬解为 kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange.
 
 @since v2.2.3
 */
- (void)player:(nonnull PLPlayer *)player willRenderFrame:(nullable CVPixelBufferRef)frame {
    
}

#pragma mark - UIResponder

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    UITouch *touch = [touches anyObject];
    self.beginpoint = [touch locationInView:self];
    [[self superview] bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - self.beginpoint.x;
    float dy = point.y - self.beginpoint.y;
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    self.center=newcenter;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self configRightLocation:touches];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self configRightLocation:touches];
}


//上下左右 边界判断
- (void)configRightLocation:(NSSet<UITouch *> *)touches {
    CGPoint point = [[touches anyObject] locationInView:self];
    
    float dx = point.x - self.beginpoint.x;
    float dy = point.y - self.beginpoint.y;
    
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    float halfx = CGRectGetMidX(self.bounds);
    
    float curx = newcenter.x;
    //左边界判断
    if (curx < halfx) {
        newcenter.x = halfx;
    }
    //右边界判断
    if (curx > (ScreenW_Lit - halfx)) {
        newcenter.x = ScreenW_Lit - halfx;
    }
    
   
    float cury = newcenter.y;
    float halfy = CGRectGetMidY(self.bounds);
    //上边界判断
    float halfy_top = NavBarTop_Lit + halfy;
    if (cury < halfy_top) {
        newcenter.y = halfy_top;
    }
    //下边界判断
    float halfy_btm = ScreenH_Lit - TabBarH_Lit - FloatingPlayBtmTemp - halfy;
    if (cury > halfy_btm) {
        newcenter.y = halfy_btm;
    }

    WS(ws);
    [UIView animateWithDuration:0.5 animations:^{
        ws.center = newcenter;
    }];
}


@end
