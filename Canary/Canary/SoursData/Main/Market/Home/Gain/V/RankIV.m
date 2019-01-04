//
//  RankIV.m
//  ixit
//
//  Created by litong on 2016/11/21.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "RankIV.h"
#import "UIImageView+WebCache.h"

@interface RankIV ()

@property (nonatomic,strong) UIImageView *maskIV;
@property (nonatomic,strong) UIImageView *IV;
@property (nonatomic,strong) UILabel *rankingLab;

@end

@implementation RankIV


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)setRanking:(NSInteger)ranking {
    _ranking = ranking;
    
    NSInteger num = ranking;
    if (ranking > 3) {
        num = 4;
        CGFloat rankingLabH =13;
        _rankingLab.text = [NSString stringWithInteger:ranking];
        _rankingLab.frame = CGRectMake(0 , self.h_ - LTAutoW(rankingLabH), self.w_, LTAutoW(rankingLabH));
        _rankingLab.font = autoFontSiz(rankingLabH);
    }
    
    NSString *imgName = [NSString stringWithFormat:@"RankingDetail%ld",(long)num];
    _maskIV.image = [UIImage imageNamed:imgName];
}

- (void)setImgUrlStr:(NSString *)imgUrlStr {
    _imgUrlStr = imgUrlStr;
    
    [_IV sd_setImageWithURL:[_imgUrlStr toURL] placeholderImage:[UIImage imageNamed:@"Head_s100"]];
}

- (void)createView {
    
    CGFloat leftMar = (ScreenW_Lit > 375) ? LTAutoW(7) : LTAutoW(4);//5
    CGFloat ivw = self.w_ - 2*leftMar;
    
    self.IV = [[UIImageView alloc] init];
    _IV.frame = CGRectMake(leftMar, 0, ivw, LTAutoW(ivw*1.11));
    _IV.contentMode = UIViewContentModeScaleToFill;
    _IV.image = [UIImage imageNamed:@"Head_s100"];
    _IV.userInteractionEnabled = YES;
    [self addSubview:_IV];
    
    self.maskIV = [[UIImageView alloc] init];
    _maskIV.frame = CGRectMake(0, 0, self.w_, self.h_);
    _maskIV.userInteractionEnabled = YES;
    [self addSubview:_maskIV];
    
    CGFloat rankingLabH = LTAutoW(16);
    self.rankingLab = [[UILabel alloc] init];
    _rankingLab.frame = CGRectMake(0 , self.h_ - rankingLabH, self.w_, rankingLabH);
    _rankingLab.font = autoFontSiz(15.f);
    _rankingLab.textColor = LTWhiteColor;
    _rankingLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_rankingLab];
}

@end
