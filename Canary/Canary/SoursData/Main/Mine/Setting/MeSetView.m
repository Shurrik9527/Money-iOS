//
//  MeSetView.m
//  ixit
//
//  Created by litong on 2016/12/22.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "MeSetView.h"
#import "UIImageView+WebCache.h"

#define subLabW 210

@interface MeSetView ()
{
    CGFloat viewH;
    CGFloat nextIVW;
    CGFloat nextIVH;
}
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *subLab;
@property (nonatomic,strong) UIImageView *headIV;
@property (nonatomic,strong) UIImageView *nextIV;

@property (nonatomic,assign) MeSetType msType;
@property (nonatomic,strong) NSString *titleStr;

@end

@implementation MeSetView

- (instancetype)initTitle:(NSString *)title y:(CGFloat)y {
    self = [super init];
    if (self) {
        _msType = MeSetType_Normal;
        _titleStr = title;
        viewH = LTAutoW(MeSetViewH) ;
        self.frame = CGRectMake(0, y, ScreenW_Lit, viewH);
        self.backgroundColor = LTWhiteColor;
        
        [self createView];
    }
    return self;
}

- (instancetype)initTitle:(NSString *)title y:(CGFloat)y type:(MeSetType)msType {
    self = [super init];
    if (self) {
        _msType = msType;
        _titleStr = title;
        
        viewH = (msType == MeSetType_Head) ? LTAutoW(MeSetViewHeadH) : LTAutoW(MeSetViewH) ;
        self.frame = CGRectMake(0, y, ScreenW_Lit, viewH);
        self.backgroundColor = LTWhiteColor;
        
        [self createView];
    }
    return self;
}

- (void)createView {
    

    self.titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(LTAutoW(kLeftMar), 0, LTAutoW(130), viewH);
    _titleLab.font = autoFontSiz(15);
    _titleLab.textColor = LTTitleColor;
    _titleLab.text = _titleStr;
    [self addSubview:_titleLab];
    
    
    self.subLab = [[UILabel alloc] init];
    _subLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_subLab];
    _subLab.hidden = YES;
    
    nextIVW = LTAutoW(7);
    nextIVH = LTAutoW(11);
    CGFloat nextIVX = ScreenW_Lit - LTAutoW(kLeftMar) - nextIVW;
    self.nextIV = [[UIImageView alloc] init];
    _nextIV.frame = CGRectMake(nextIVX, (viewH - nextIVH)*0.5, nextIVW, nextIVH);
    _nextIV.image = [UIImage imageNamed:@"next"];
    [self addSubview:_nextIV];
    _nextIV.hidden = YES;
    
    CGFloat headIVWH = LTAutoW(60);
    CGFloat headIVX = nextIVX - headIVWH- LTAutoW(12);
    self.headIV = [[UIImageView alloc] init];
    _headIV.frame = CGRectMake(headIVX, (viewH - headIVWH)*0.5, headIVWH, headIVWH);
    [_headIV circleViwe];
    [self addSubview:_headIV];
    _headIV.hidden = YES;
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, viewH-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
    
    UIButton *btn = [UIButton btnWithTarget:self action:@selector(clickeBtn) frame:CGRectMake(0, 0, self.w_, self.h_)];
    btn.backgroundColor = LTClearColor;
    [self addSubview:btn];
    
    [self confitDatas];
}

- (void)clickeBtn {
    _meSetViewBlock ? _meSetViewBlock() : nil;
}

- (void)confitDatas {
    
    CGFloat sLabW = LTAutoW(210);
    
    if (_msType == MeSetType_Head) {
        _headIV.hidden = NO;
        _nextIV.hidden = NO;
    } else if (_msType == MeSetType_NickName) {
        _subLab.hidden = NO;
        _nextIV.hidden = NO;
        
        _subLab.frame = CGRectMake(ScreenW_Lit - sLabW - LTAutoW(kLeftMar) - nextIVW - LTAutoW(12), 0, sLabW, viewH);
        _subLab.font = autoFontSiz(15);
        _subLab.textColor = LTTitleColor;
        
    } else if (_msType == MeSetType_UserName) {
        _subLab.hidden = NO;
        
        _subLab.frame = CGRectMake(ScreenW_Lit - sLabW - LTAutoW(kLeftMar), 0, sLabW, viewH);
        _subLab.font = autoFontSiz(15);
        _subLab.textColor = LTSubTitleColor;
        
    } else if (_msType == MeSetType_ChangePwd) {
        _nextIV.hidden = NO;
    } else if (_msType == MeSetType_ChangePwd1) {
        _subLab.hidden = NO;
        _nextIV.hidden = NO;
        
        _subLab.frame = CGRectMake(ScreenW_Lit - sLabW - LTAutoW(kLeftMar) - nextIVW - LTAutoW(12), 0, sLabW, viewH);
        _subLab.font = autoFontSiz(12);
        _subLab.textColor = LTSubTitleColor;
    } else {
        _nextIV.hidden = NO;
    }
}

#pragma mark - 外部

- (void)configTitleText:(NSString *)text {
    _titleLab.text = text;
}

- (void)configSubText:(NSString *)text {
    _subLab.text = text;
}

- (void)configHeadImg:(id)img {
    if ([img isKindOfClass:[NSString class]]) {
        [_headIV sd_setImageWithURL:[img toURL] placeholderImage:[UIImage imageNamed:@"Head80"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                _headIV.image = [image cutedCenterSquare];
            }
        }];
    } else {
        UIImage *image = img;
        _headIV.image = [image cutedCenterSquare];
    }
}



@end
