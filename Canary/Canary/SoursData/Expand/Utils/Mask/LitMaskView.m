//
//  LitMaskView.m
//  ixit
//
//  Created by litong on 16/10/5.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "LitMaskView.h"

@interface LitMaskView ()

@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic,copy)NSString *imgKey;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,copy)MaskClickBtn maskClickBtn;

@end

@implementation LitMaskView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = [UIScreen mainScreen].bounds;
        [self createImgView];
    }
    return self;
}


- (void)createImgView {
    self.imgView = [[UIImageView alloc] init];
    self.imgView.frame = CGRectMake(0, 0, self.w_, self.h_);
    self.imgView.userInteractionEnabled = YES;
    self.imgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_imgView];
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.backgroundColor = LTClearColor;
    [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
    
}


- (void)hideView:(NSString *)imgName {
    [UserDefaults setBool:YES forKey:imgName];
    [self removeFromSuperview];
}

- (void)clickBtn {
    self.hidden=YES;
    if(self.maskClickBtn){
        self.maskClickBtn();
    }
    [self hideView:self.imgKey];
//    self.maskClickBtn ? self.maskClickBtn() : nil;
}


#pragma mark - utils

+ (LitMaskView *)maskView:(NSString *)imgKey btnFrame:(CGRect)frame block:(MaskClickBtn)block {
    
    NSString *imgStr = [LitMaskView imgNameStr:imgKey];
    LitMaskView *maskView = [[LitMaskView alloc] init];
    maskView.imgView.image = [UIImage imageNamed:imgStr];
    
    maskView.maskClickBtn = block;
    maskView.imgKey = imgKey;
    maskView.btn.frame = frame;
  
    return maskView;
}


+ (NSString *)imgNameStr:(NSString *)imgName {
    
    if (iPhone4) {
        return [NSString stringWithFormat:@"%@_4",imgName];
    }
    else if (iPhone5) {
        return [NSString stringWithFormat:@"%@_5",imgName];
    }
    
//    else if (iPhone6) {
//        return [NSString stringWithFormat:@"%@_6",imgName];
//    }
//    else {//iPhone6p
//        return [NSString stringWithFormat:@"%@_6p",imgName];
//    }
    
    return imgName;
}


#pragma mark - 实现

+ (void)removeAllMaskView {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    for (UIView *view in keyWindow.subviews) {
        if ([view isKindOfClass:[LitMaskView class]]) {
            [view removeAllSubView];
        }
    }
}

+ (void)onceIntoJG:(MaskClickBtn)block {
//    NSString *keyStr = kMask_onceInto_JG;
//    BOOL bl = [UserDefaults boolForKey:keyStr];
//    if(!block){
//        block=^{};
//    }
//    if (!bl) {
//        CGRect frame = CGRectMake(0, 0, Screen_width, Screen_height);
//        LitMaskView *maskView = [LitMaskView maskView:keyStr btnFrame:frame block:block];
//        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
//    }
}

+ (void)onceIntoJGHoldList {
    NSString *keyStr = kMask_onceInto_JGHoldList;
    BOOL bl = [UserDefaults boolForKey:keyStr];
    if (!bl) {
        CGRect frame = CGRectMake(0, 0, Screen_width, Screen_height);
        LitMaskView *maskView = [LitMaskView maskView:keyStr btnFrame:frame block:^{}];
        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    }
}

/** 首次进入视频直播蒙版 */
+ (void)onceIntoLivePlay {
    NSString *keyStr = kMask_onceInto_LivePlay;
    BOOL bl = [UserDefaults boolForKey:keyStr];
    if (!bl) {
        CGRect frame = CGRectMake(0, 0, Screen_width, Screen_height);
        LitMaskView *maskView = [LitMaskView maskView:keyStr btnFrame:frame block:^{}];
        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    }
}
//首次进入资金-选择交易所蒙版
+ (void)onceIntoChooseExchange {
//    NSString *keyStr = kMask_onceInto_chooseExchange_Deal;
//    BOOL bl = [UserDefaults boolForKey:keyStr];
//    if (!bl) {
//        CGRect frame = CGRectMake(0, 0, Screen_width, Screen_height);
//        LitMaskView *maskView = [LitMaskView maskView:keyStr btnFrame:frame block:^{}];
//        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
//    }
}
+(void)commonOneceMaskWithKey:(NSString *)key {
    NSString *keyStr = key;
    if (iPhone4) {
        keyStr=[NSString stringWithFormat:@"%@_4",key];
    }
    BOOL bl = [UserDefaults boolForKey:keyStr];
    if (!bl) {
        CGRect frame = CGRectMake(0, 0, Screen_width, Screen_height);
        LitMaskView *maskView = [LitMaskView maskView:keyStr btnFrame:frame block:^{}];
        [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    }
}
@end
