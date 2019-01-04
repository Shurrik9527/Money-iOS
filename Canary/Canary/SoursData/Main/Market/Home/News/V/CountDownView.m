//
//  CountDownView.m
//  ixit
//
//  Created by litong on 2016/11/11.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "CountDownView.h"

static CGFloat labW = 28.f;
static CGFloat labH = 28.f;

@interface CountDownView ()

@property (nonatomic,strong) UILabel *hLab;//时
@property (nonatomic,strong) UILabel *mLab;//分
@property (nonatomic,strong) UILabel *sLab;//秒

@property (nonatomic,assign) NSTimeInterval t;
@property (nonatomic,copy) NSString *timeStr;

@property (nonatomic,strong) NSTimer *myTimer;

@end

@implementation CountDownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.image = [UIImage imageNamed:@"newsCellTimeBg"];
        [self createView];
    }
    return self;
}

-  (void)createView {
    self.hLab = [self lab:0];
    [self addSubview:_hLab];
    
    self.mLab = [self lab:1];
    [self addSubview:_mLab];
    
    self.sLab = [self lab:2];
    [self addSubview:_sLab];
}

- (UILabel *)lab:(NSInteger)idx {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(LTAutoW(idx*(labW+4)) , LTAutoW(CountDownViewH-labH), LTAutoW(labW), LTAutoW(labH));
    lab.font = [UIFont autoBoldFontSize:17.f];
    lab.textColor = LTTitleColor;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

- (void)start {
    NSTimeInterval nowTi = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval disTime = _t - nowTi;
    if (disTime > 0) {
        _timeStr = [NSString countDownHMS:disTime];
        [self initTimer];
    } else {
        _timeStr = @"00:00:00";
    }
    
    NSArray *arr = [_timeStr splitWithStr:@":"];
    if (arr.count >= 3) {
        _hLab.text = arr[0];
        _mLab.text = arr[1];
        NSString *minStr = arr[2];
        _sLab.text = minStr;
        
        if (disTime <= 0) {
            [self stop];
            [[NSNotificationCenter defaultCenter] postNotificationName:NFC_HomeTimeIsUp object:_iPath];
        }
    }
}

- (void)initTimer {
    if (!_myTimer) {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                         target:self
                                                                       selector:@selector(start)
                                                                       userInfo:nil
                                                                        repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:self.myTimer forMode:NSDefaultRunLoopMode];
    }
}

- (void)stop {
    [_myTimer setFireDate:[NSDate distantFuture]];
    [_myTimer invalidate];
    _myTimer = nil;
}


- (void)refTimeInterval:(NSTimeInterval)t {
    _t = t/1000;

    [self start];
}

@end
