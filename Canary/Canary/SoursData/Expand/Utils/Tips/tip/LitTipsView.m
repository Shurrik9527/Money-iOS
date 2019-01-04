//
//  LitTipsView.m
//  ixit
//
//  Created by litong on 16/10/12.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "LitTipsView.h"



@interface LitTipsView()



@end



@implementation LitTipsView

static id shareInstance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceTime;
    dispatch_once(&onceTime, ^{
        shareInstance = [super allocWithZone:zone];
    });
    return shareInstance;
}
+ (instancetype)sharedInstance {
    static dispatch_once_t onceTime;
    dispatch_once(&onceTime, ^{
        shareInstance = [[self alloc] init];
    });
    return shareInstance;
}
- (id)copyWithZone:(NSZone *)zone {
    return shareInstance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return shareInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        [self createViews];
    }
    return self;
}

- (void)createViews {
    
    [self layerRadius:4.f bgColor:LTRGBA(36, 39, 62, 0.8)];

    UIFont *font = [UIFont fontOfSize:fontSize];
    self.msgLable = [[UILabel alloc] init];
    _msgLable.textAlignment = NSTextAlignmentCenter;
    _msgLable.font = font;
    _msgLable.textColor = LTWhiteColor;
    _msgLable.numberOfLines = 0;
    _msgLable.backgroundColor = LTClearColor;
    [self addSubview:_msgLable];

}

+ (void)showTip:(NSString *)tip {
    if (notemptyStr(tip)) {
        
        LitTipsView *tipView = [LitTipsView sharedInstance];

        if (tipView.showed) {
            [LitTipsView hideTip];
        }
        
        tipView.showed = YES;
        
        UIFont *font = [UIFont fontOfSize:fontSize];
        
        CGFloat maxW = ScreenW_Lit * 0.7;
        CGSize size = [tip boundingSize:CGSizeMake(maxW, MAXFLOAT) font:font];
        
        tipView.frame = CGRectMake(0, 0, size.width + leftMar*2, size.height + topMar*2);
        tipView.msgLable.frame = CGRectMake(leftMar, topMar, size.width, size.height);
        tipView.msgLable.text = tip;
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:tipView];
        
        tipView.center = window.center;
    }
}

+ (void)hideTip {
    LitTipsView *tipView = [LitTipsView sharedInstance];
    if (tipView.showed) {
        tipView.showed = NO;
        [tipView removeFromSuperview];
    }
}


#pragma mark - 外部调用

+ (void)showTips:(NSString *)tip afterHide:(NSInteger)afterHide {
    [LitTipsView showTip:tip];
    [self cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideTip) object:nil];
    [self performSelector:@selector(hideTip) withObject:nil afterDelay:afterHide];
}

+ (void)showTips:(NSString *)tip {
    [LitTipsView showTips:tip afterHide:autoHideTimeInterval];
}

+ (void)hideTips {
    LitTipsView *tipView = [LitTipsView sharedInstance];
    tipView.showed = NO;
    [tipView removeFromSuperview];
}



@end
