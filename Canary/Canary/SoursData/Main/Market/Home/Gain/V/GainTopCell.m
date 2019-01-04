//
//  GainTopCell.m
//  ixit
//
//  Created by litong on 2016/11/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GainTopCell.h"


@interface GainTopCell ()

@property (nonatomic,strong) NSArray *mos;

@property (nonatomic,strong) UIView *contView;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) RankView *rankView1;
@property (nonatomic,strong) RankView *rankView2;
@property (nonatomic,strong) RankView *rankView3;

@property (nonatomic,strong) UIView *contEmptyView;
@property (nonatomic,strong) UILabel *tipLab;

@end

@implementation GainTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LTTitleColor;
        [self createCell];
    }
    return self;
}

static CGFloat bgIVW = 155;
static CGFloat bgIVH = 90.5;

- (void)createCell {
    
    [self createContEmptyView];
    _contEmptyView.hidden = NO;
    
    [self createContView];
    _contView.hidden = YES;
}

- (void)createContEmptyView {
    self.contEmptyView = [[UIView alloc] init];
    _contEmptyView.frame = CGRectMake(0, 0, ScreenW_Lit, LTAutoW(GainTopCellH1));
    [self addSubview:_contEmptyView];
    
    UIImageView *bgIV = [[UIImageView alloc] init];
    bgIV.frame = CGRectMake((ScreenW_Lit - LTAutoW(bgIVW))/2, 0, LTAutoW(bgIVW), LTAutoW(GainTopCellH1));
    bgIV.image = [UIImage imageNamed:@"GainBG_flower_empty"];
    [_contEmptyView addSubview:bgIV];
    
    self.tipLab = [[UILabel alloc] init];
    _tipLab.frame = CGRectMake(0 , 0, ScreenW_Lit, LTAutoW(15));
    _tipLab.textColor = LTSubTitleColor;
    _tipLab.font = autoFontSiz(15.f);
    _tipLab.text = @"今日榜首正虚位以待...";
    _tipLab.textAlignment = NSTextAlignmentCenter;
    [_contEmptyView addSubview:_tipLab];
    
   
}

- (void)createContView {
    
    self.contView = [[UIView alloc] init];
    _contView.frame = CGRectMake(0, 0, ScreenW_Lit, LTAutoW(GainTopCellH));
    [self addSubview:_contView];
    
    self.timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(0 , 0, ScreenW_Lit, LTAutoW(26));
    _timeLab.textColor = LTSubTitleColor;
    _timeLab.font = autoFontSiz(15.f);
    _timeLab.text = @"08-08 23:33:02";
    _timeLab.textAlignment = NSTextAlignmentCenter;
    [_contView addSubview:_timeLab];
    
    UIImageView *bgIV = [[UIImageView alloc] init];
    bgIV.frame = CGRectMake((ScreenW_Lit - LTAutoW(bgIVW))/2, LTAutoW(136/2), LTAutoW(bgIVW), LTAutoW(bgIVH));
    bgIV.image = [UIImage imageNamed:@"GainBG_flower"];
    [_contView addSubview:bgIV];
    
    CGRect r1 = CGRectMake((ScreenW_Lit - LTAutoW(RankViewW))/2, LTAutoW(36), LTAutoW(RankViewW), LTAutoW(RankViewH1));
    self.rankView1 = [[RankView alloc] initWithFrame:r1 rankIdx:1];
    [_contView addSubview:_rankView1];
    
    CGFloat leftMar = LTAutoW(25.f);
    CGFloat topMar = LTAutoW(72.5);
    CGRect r2 = CGRectMake(leftMar, topMar, LTAutoW(RankViewW), LTAutoW(RankViewH23));
    self.rankView2 = [[RankView alloc] initWithFrame:r2 rankIdx:2];
    [_contView addSubview:_rankView2];
    
    CGRect r3 = CGRectMake(ScreenW_Lit - leftMar - LTAutoW(RankViewW), topMar, LTAutoW(RankViewW), LTAutoW(RankViewH23));
    self.rankView3 = [[RankView alloc] initWithFrame:r3 rankIdx:3];
    [_contView addSubview:_rankView3];
}


#pragma mark - 外部

- (void)bindData:(NSArray *)mos {
    _mos = mos;
    
    if (_mos.count >= 3) {
        
        GainModel *mo = _mos[0];
        _timeLab.text = mo.closeDate;
        
        [_rankView1 refData:mo];
        [_rankView2 refData:_mos[1]];
        [_rankView3 refData:_mos[2]];
        
        self.contView.hidden = NO;
        self.contEmptyView.hidden = YES;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, GainTopCellH);
    } else {
        self.contView.hidden = YES;
        self.contEmptyView.hidden = NO;
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, GainTopCellH1);
    }
}



@end
