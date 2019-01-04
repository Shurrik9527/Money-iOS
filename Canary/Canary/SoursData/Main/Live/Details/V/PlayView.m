//
//  PlayView.m
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "PlayView.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "LiveMO.h"
static NSInteger kPlayerViewTag = 1010;

@interface PlayView ()<PLPlayerDelegate>
{
    
}
@property (nonatomic,strong) LiveMO *liveModel;
@property (nonatomic, strong) PLPlayer  *player;
@property (nonatomic, strong)UIView *playerView;
@property (nonatomic, strong)UILabel *playEmptyLab;
@property (nonatomic, strong)UITapGestureRecognizer *tap;

@end

@implementation PlayView

- (instancetype)initWithFrame:(CGRect)frame liveModel:(LiveMO *)liveModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.liveModel = liveModel;
        self.backgroundColor = LTColorHex(0x1c1c1e);
        [self createPlayer];
    }
    return self;
}

#pragma mark - 外部

- (void)play:(BOOL)bl {
    if (bl) {
        if(!(self.player.status==PLPlayerStatusStopped))
        {
            [self.player resume];
        }
        else
        {
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

    self.playEmptyLab = [[UILabel alloc] init];
    self.playEmptyLab.frame = CGRectMake(0, 0, self.w_, self.h_);
    self.playEmptyLab.font = [UIFont systemFontOfSize:16.f];
    self.playEmptyLab.text = @"当前是非视频直播时段\n稍后回来...";
    self.playEmptyLab.textColor = LTSubTitleColor;
    self.playEmptyLab.numberOfLines = 0;
    self.playEmptyLab.hidden = YES;
    self.playEmptyLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.playEmptyLab];
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    NSURL *url = [NSURL URLWithString:self.liveModel.rtmpDownstreamAddress];
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

    [self.player play];
}


//点击背景关闭
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UIView *touchView = [self hitTest:[touches.anyObject locationInView:self] withEvent:event];
    if (touchView == self || touchView.tag == kPlayerViewTag) {
        if (_delegate && [_delegate respondsToSelector:@selector(pressPlayView)]) {
            [_delegate pressPlayView];
        }
    }
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





@end
