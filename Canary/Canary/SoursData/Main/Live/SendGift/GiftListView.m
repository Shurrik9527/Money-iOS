//
//  GiftListView.m
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "GiftListView.h"
#import "GiftSingleView.h"
#import "LTWebCache.h"

#define kGiftListViewCH   LTAutoW(200)
#define kTopViewH  LTAutoW(40)
#define kBtmViewH  LTAutoW(45)
#define Tag_GiftSingleView  2000

@interface GiftListView ()

@property (nonatomic,assign) CGFloat contentViewY;
@property (nonatomic,assign) CGFloat contentViewH;
@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UIScrollView *scView;
@property (nonatomic,strong) UIImageView *headIV;
@property (nonatomic,strong) UILabel *pointLab;
@property (nonatomic,strong) UIButton *sendBtn;

@property (nonatomic,strong) LiveGiftListMO *mo;
@property (nonatomic,assign) NSInteger selectIdx;

@end

@implementation GiftListView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenW_Lit, ScreenH_Lit);
        self.backgroundColor = LTClearColor;
        self.contentViewH = kGiftListViewCH;
        self.contentViewY = ScreenH_Lit - self.contentViewH;
        [self createView];
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"GiftListView dealloc");
}

- (void)createView {
    UIButton *bgBtn = [self btnFrame:CGRectMake(0, 0, self.w_, self.h_) sel:@selector(shutView)];
    [self addSubview:bgBtn];
    
    self.contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(0, self.contentViewY, self.w_, self.contentViewH);
    _contentView.backgroundColor = GiftSingleBgColor;
    [self addSubview:_contentView];
    
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, ScreenW_Lit, kTopViewH);
    [_contentView addSubview:topView];
    
    UIView *line0 = [UIView lineFrame:CGRectMake(0, kTopViewH-LTAutoW(0.5), self.w_, LTAutoW(0.5)) color:LTColorHex(0x454546)];
    [topView addSubview:line0];
    
    
    UILabel *lab0 = [self lab:15 color:LTColorHex(0xB4B9CB)];
    lab0.frame = CGRectMake(LTAutoW(16), 0, LTAutoW(68), kTopViewH);
    lab0.text = @"礼物送给:";
    [topView addSubview:lab0];
    
    self.nameLab = [self lab:15 color:LTWhiteColor];
    self.nameLab.frame = CGRectMake(lab0.xw_, 0, LTAutoW(200), kTopViewH);
    [topView addSubview:self.nameLab];
    
    UIButton *shutBtn = [self btnFrame:CGRectMake(self.w_ - kTopViewH - LTAutoW(2), 0, kTopViewH, kTopViewH) sel:@selector(shutView)];
    [shutBtn setImage:[UIImage imageNamed:@"icon_x"] forState:UIControlStateNormal];
    [topView addSubview:shutBtn];
    
    
    
    self.scView = [[UIScrollView alloc] init];
    _scView.frame = CGRectMake(0, kTopViewH, self.w_, self.contentViewH - kTopViewH);
    [_contentView addSubview:_scView];
    
    
    
    UIView *btmView = [[UIView alloc] init];
    btmView.frame = CGRectMake(0, self.contentViewH - kBtmViewH, ScreenW_Lit, kBtmViewH);
    [_contentView addSubview:btmView];
    
    UIView *line1 = [UIView lineFrame:CGRectMake(0, 0, self.w_, LTAutoW(0.5)) color:LTColorHex(0x454546)];
    [btmView addSubview:line1];
    

    CGFloat headwh = LTAutoW(29);
    self.headIV = [[UIImageView alloc] init];
    _headIV.frame = CGRectMake(LTAutoW(kLeftMar), (kBtmViewH - headwh)*0.5, headwh, headwh);
    [btmView addSubview:_headIV];
    [_headIV circleViwe];
    
    
    UILabel *lab1 = [self lab:15 color:LTColorHex(0xB4B9CB)];
    lab1.frame = CGRectMake(_headIV.xw_+LTAutoW(8), 0, LTAutoW(68), kBtmViewH);
    lab1.text = @"积分余额:";
    [btmView addSubview:lab1];
    
    self.pointLab = [self lab:18 color:LTWhiteColor];
    self.pointLab.frame = CGRectMake(lab1.xw_, 0, LTAutoW(120), kBtmViewH);
    [btmView addSubview:self.pointLab];
    
    CGFloat sendBtnW = LTAutoW(72);
    CGFloat sendBtnH = LTAutoW(32);
    self.sendBtn = [self btnFrame:CGRectMake(self.w_ - sendBtnW - LTAutoW(kLeftMar), (kBtmViewH - sendBtnH)*0.5, sendBtnW, sendBtnH) sel:@selector(sendAciont)];
    self.sendBtn.titleLabel.font = autoFontSiz(15);
    [self.sendBtn setTitle:@"送出" forState:UIControlStateNormal];
    [btmView addSubview:self.sendBtn];
    [self.sendBtn layerRadius:sendBtnH*0.5 bgColor:LTColorHex(0x4877E6)];
    
    self.userInteractionEnabled = YES;
    self.hidden = YES;
}

- (void)createSingeView {
     [_scView removeAllSubView];
    
    NSArray *arr = _mo.giftList_fmt;
    NSInteger i = 0;
    NSInteger count = arr.count;
    for (LiveGiftMO *mo in arr) {
        CGFloat x = i*kGiftSingleViewW;
        GiftSingleView *view = [[GiftSingleView alloc] initWithFrame:CGRectMake(x, 0, kGiftSingleViewW, kGiftSingleViewH)];
        view.tag = Tag_GiftSingleView + i;
        [view configData:mo idx:i];
        [_scView addSubview:view];
        
        WS(ws);
        [view setSelectIdxBlock:^(NSInteger idx) {
            ws.selectIdx = idx;
        }];
        
        i ++;
    }
    
    self.selectIdx = 0;
    _scView.contentSize = CGSizeMake(kGiftSingleViewW*count+1, _scView.h_);
}

#pragma mark - action

- (void)setSelectIdx:(NSInteger)selectIdx {
    _selectIdx = selectIdx;
    
    NSArray *arr = _mo.giftList_fmt;
    NSInteger i = 0;
    NSInteger count = arr.count;
    for (i = 0; i < count; i++) {
        GiftSingleView *view = (GiftSingleView *)[_scView viewWithTag:(Tag_GiftSingleView + i)];
        BOOL seled = (_selectIdx == i);
        [view selectedView:seled];
    }
}

- (void)shutView {
    [self showView:NO];
}

- (void)sendAciont {
    _sendGiftBlock ? _sendGiftBlock(_selectIdx) : nil;
}


#pragma mark - utils

- (UILabel *)lab:(CGFloat)fs color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = autoFontSiz(fs);
    lab.textColor = color;
    return lab;
}


- (UIButton *)btnFrame:(CGRect)r sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = r;
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mark 动画显示隐藏

static CGFloat animateDuration = 0.3;
- (void)showView:(BOOL)show {
    WS(ws);
    if (show) {
        NFCPost_FloatingPlayHide;
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
        NFCPost_FloatingPlayShow;
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


#pragma mark - 外部

- (void)refValidPoints:(NSString *)validPoints {
    self.pointLab.text = validPoints;
}

- (void)configData:(LiveGiftListMO *)mo name:(NSString *)name {
    self.nameLab.text = name;
    
    self.mo = mo;
    [self createSingeView];
    
    [self.headIV lt_setImageWithURL:UD_Avatar placeholderImage:[UIImage imageNamed:@"Head80"] ];
    self.pointLab.text = mo.validPoints;
}

@end
