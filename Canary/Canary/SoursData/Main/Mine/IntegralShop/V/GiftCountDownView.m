//
//  GiftCountDownView.m
//  ixit
//
//  Created by litong on 2017/4/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "GiftCountDownView.h"


@interface GiftCountDownView ()

//天-时-分     时-分-秒
@property (nonatomic,strong) UILabel *lab0;
@property (nonatomic,strong) UILabel *lab1;
@property (nonatomic,strong) UILabel *lab2;

@property (nonatomic,strong) UILabel *sublab0;
@property (nonatomic,strong) UILabel *sublab1;
@property (nonatomic,strong) UILabel *sublab2;

@property (nonatomic,assign) NSTimeInterval t;
@property (nonatomic,copy) NSString *timeStr;

@property (nonatomic,strong) NSTimer *myTimer;
@property (nonatomic,assign) BOOL hasTimer;
@property (nonatomic,assign) BOOL oldUseDay;
@property (nonatomic,assign) BOOL curUseDay;

@end

@implementation GiftCountDownView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.hasTimer = NO;
        self.oldUseDay = NO;
        self.curUseDay = NO;
        self.image = [UIImage imageNamed:@"newsCellTimeBg"];
        [self createView];
    }
    return self;
}

-  (void)createView {
    
    [self addBgView:0];
    [self addBgView:1];
    [self addBgView:2];
    
    self.lab0 = [self lab:0];
    self.lab1 = [self lab:1];
    self.lab2 = [self lab:2];
    [self addSubview:self.lab0];
    [self addSubview:self.lab1];
    [self addSubview:self.lab2];
    
    self.sublab0 = [self sublab:0];
    self.sublab1 = [self sublab:1];
    self.sublab2 = [self sublab:2];
    [self addSubview:self.sublab0];
    [self addSubview:self.sublab1];
    [self addSubview:self.sublab2];
}

- (void)addBgView:(NSInteger)idx {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(idx*(kGiftCountDownLabW + kGiftCountDownMar), 0, kGiftCountDownLabW, kGiftCountDownH);
    [view layerRadius:2 bgColor:LTColorHex(0xF0F2F5)];
    [self addSubview:view];
}

- (UILabel *)lab:(NSInteger)idx {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(idx*(kGiftCountDownLabW + kGiftCountDownMar), LTAutoW(2), kGiftCountDownLabW, LTAutoW(17));
    lab.font = [UIFont autoFontSize:17.f];
    lab.textColor = LTTitleColor;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

#define sublabh LTAutoW(14.5)
- (UILabel *)sublab:(NSInteger)idx {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(idx*(kGiftCountDownLabW + kGiftCountDownMar), kGiftCountDownH - sublabh, kGiftCountDownLabW, sublabh);
    lab.font = [UIFont autoFontSize:9];
    lab.textColor = LTSubTitleColor;
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}

- (void)start {
    NSTimeInterval nowTi = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval disTime = _t - nowTi;
    if (disTime > 0) {
        if (disTime > LIT_ONE_DAY) {
            
            _curUseDay = YES;
            if (!_hasTimer) {
                _hasTimer = YES;
                [self configTimer];
            } else {
                if (_oldUseDay != _curUseDay) {
                    [self configTimer];
                }
            }
            _timeStr = [NSString countDownDHM:disTime];
            _oldUseDay = _curUseDay;
            
        } else {
            
            _curUseDay = NO;
            if (!_hasTimer) {
                _hasTimer = YES;
                [self configTimer];
            } else {
                if (_oldUseDay != _curUseDay) {
                    [self configTimer];
                }
            }

            _timeStr = [NSString countDownHMS:disTime];
            _oldUseDay = _curUseDay;
            
        }
    } else {
        _timeStr = @"00:00:00";
        self.sublab0.text = @"时";
        self.sublab1.text = @"分";
        self.sublab2.text = @"秒";
    }
    
    NSArray *arr = [_timeStr splitWithStr:@":"];
    if (arr.count >= 3) {
        self.lab0.text = arr[0];
        self.lab1.text = arr[1];
        NSString *minStr = arr[2];
        self.lab2.text = minStr;
        
        if (disTime <= 0) {
            [self stop];
            [[NSNotificationCenter defaultCenter] postNotificationName:NFC_GiftTimeIsUp object:@(_section)];
        }
    }
}


- (void)configTimer {
    [self stop];
    NSTimeInterval ti = 1;
    if (_curUseDay) {
        ti = 60;
        self.sublab0.text = @"天";
        self.sublab1.text = @"时";
        self.sublab2.text = @"分";
    } else {
        ti = 1;
        self.sublab0.text = @"时";
        self.sublab1.text = @"分";
        self.sublab2.text = @"秒";
    }
    [self initTimer:ti];
}

- (void)initTimer:(NSTimeInterval)ti {
    if (!_myTimer) {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:ti
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

- (void)dealloc {
    [self stop];
}


- (void)refTimeInterval:(NSTimeInterval)t {
    _t = t>10*11? t/1000:t;
    [self start];
}

@end
