//
//  TaskListCell.m
//  ixit
//
//  Created by litong on 2017/3/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "TaskListCell.h"
#import "UIImageView+WebCache.h"

static CGFloat kTaskListCellLineH = 8.f;
static CGFloat kTitleLabH = 16.f;
static CGFloat kIconW = 60.f;
static CGFloat kBtnW = 80.f;
static CGFloat kProgressViewH = 6.f;
static CGFloat kProgressLabW = 36.f;
static CGFloat kProgressLabH = 12.f;
static CGFloat kProgressLabTopMar = 8.f;

static CGFloat kSpacingH = 5.f;
static CGFloat kTopMar = 24.f;
static CGFloat kTopMar1 = 20.f;
static CGFloat kMidMar = 10.f;

@interface TaskListCell ()
{
    CGFloat midViewW;
}

@property (nonatomic,assign) NSInteger row;

@property (nonatomic,strong) UIImageView *icon;//优惠券

@property (nonatomic,strong) UIView *midView;
@property (nonatomic,strong) UILabel *titleLab;//标题
@property (nonatomic,strong) UILabel *subLab;//副标题

@property (nonatomic,strong) UIView *progressView;
@property (nonatomic,strong) UIView *finishView;
@property (nonatomic,strong) UILabel *progressLab;

@property (nonatomic,strong) UIButton *exchangeBtn;//兑换按钮

@property (nonatomic,strong) UIView *lineView;


@end

@implementation TaskListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        midViewW = ScreenW_Lit - LTAutoW((4*kLeftMar + kIconW + kBtnW));
        self.backgroundColor = LTWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
    self.icon = [[UIImageView alloc] init];
    [self addSubview:_icon];
    _icon.layer.cornerRadius = LTAutoW(kIconW)*0.5;
    _icon.layer.masksToBounds = YES;
    
    
    self.midView = [[UIView alloc] init];
    [self addSubview:_midView];
    
    self.titleLab = [self lab:15 color:LTTitleColor];
    [_midView addSubview:_titleLab];
    
    self.subLab = [self lab:12 color:LTSubTitleColor];
    _subLab.numberOfLines = 0;
    [_midView addSubview:_subLab];
    
    self.progressView = [[UIView alloc] init];
    [_midView addSubview:_progressView];
    self.finishView = [[UIView alloc] init];
    [_progressView addSubview:_finishView];
    CGFloat r = LTAutoW(kProgressViewH*0.5);
    [_progressView layerRadius:r bgColor:LTColorHex(0xF0F2F5)];
    [_finishView layerRadius:r bgColor:LTSureFontBlue];
    
    self.progressLab = [self lab:12 color:LTSubTitleColor];
    _progressLab.textAlignment = NSTextAlignmentCenter;
    [_midView addSubview:_progressLab];
    _progressView.hidden = YES;
    _progressLab.hidden = YES;
    

    self.exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exchangeBtn.backgroundColor = [UIColor clearColor];
    [self.exchangeBtn addTarget:self action:@selector(clickExchangeBtn) forControlEvents:UIControlEventTouchUpInside];
    self.exchangeBtn.titleLabel.font = autoFontSiz(15);
    [self addSubview:_exchangeBtn];


    self.lineView = [[UIView alloc] init] ;
    _lineView.backgroundColor = LTBgColor;
    [self addSubview:_lineView];
    
}


#pragma mark - action

- (void)clickExchangeBtn {
    _taskListCellBtnAction ? _taskListCellBtnAction(_row) : nil;
}


#pragma mark - utils

- (UILabel *)lab:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = autoFontSiz(fontSize);
    lab.textColor = color;
    return lab;
}

- (void)configBtn:(TaskListMo *)mo {
    //完成状态：1=完成，2=未开始，3、进行中
    NSInteger userTaskStatus = mo.userTaskStatus;
    //任务跳转类型：1=答题，2=分享，3=协议跳转，4=H5跳转
    if (mo.taskType == 1) {//答题
        if (userTaskStatus == 1) {
            [self changeBtnState:1];
        } else {
            BOOL begined = [mo userBeginedQuestion];
            if (begined) {//已开始
                [self changeBtnState:3];
            } else {//未开始
                [self changeBtnState:2];
            }
        }
    } else {
        [self changeBtnState:userTaskStatus];
    }
    
}

- (void)changeBtnState:(NSInteger)i {
    if (i == 1) {//1=完成
        [_exchangeBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        [_exchangeBtn layerRadius:3 bgColor:LTColorHex(0xCED0D6)];
    } else if (i == 3) {//3、进行中
        [_exchangeBtn setTitle:@"继续领取" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:LTColorHex(0xFF7901) forState:UIControlStateNormal];
        [_exchangeBtn layerRadius:3 borderColor:LTColorHex(0xFF7901) borderWidth:1 bgColor:LTWhiteColor];
    } else {//2、未开始
        [_exchangeBtn setTitle:@"马上领取" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        [_exchangeBtn layerRadius:3 bgColor:LTColorHex(0xFF7901)];
    }
}

#pragma mark - 外部

- (void)bindData:(TaskListMo *)mo row:(NSInteger)row {
    self.row = row;
    
    NSString *substr = mo.taskDesc;
    NSAttributedString *ABStr = [substr ABStrSpacing:kSpacingH font:autoFontSiz(12)];
    CGSize size = [ABStr autoSize:CGSizeMake(midViewW, CGFLOAT_MAX)];
    CGFloat subh = size.height;
    
    BOOL showProgress = NO;
    CGFloat tmar = 0;
    CGFloat midh = 0;
    CGFloat h = 0;
    //任务跳转类型：1=答题，2=分享，3=协议跳转，4=H5跳转
    if (mo.taskType == 1) {//有进度条
        tmar = LTAutoW(kTopMar1);
        midh = LTAutoW(kTitleLabH)+LTAutoW(kMidMar) + subh + LTAutoW(kProgressLabTopMar) + LTAutoW(kProgressLabH);
        h = 2*tmar + midh;
        showProgress = YES;
    } else {
        tmar = LTAutoW(kTopMar);
        midh = LTAutoW(kTitleLabH)+LTAutoW(kMidMar) + subh;
        h = 2*tmar + midh;
        showProgress = NO;
    }

    _progressView.hidden = !showProgress;
    _progressLab.hidden = !showProgress;
    
    _icon.frame = CGRectMake(LTAutoW(kLeftMar), (h-LTAutoW(kIconW))/2, LTAutoW(kIconW), LTAutoW(kIconW));
    
    _midView.frame = CGRectMake(_icon.xw_ + LTAutoW(kLeftMar), tmar+LTAutoW(2), midViewW, midh);
    _titleLab.frame = CGRectMake(0, 0, _midView.w_, LTAutoW(kTitleLabH));
    _subLab.frame = CGRectMake(0, _titleLab.yh_+LTAutoW(kMidMar), _midView.w_, subh);
    CGFloat btnw = LTAutoW(kBtnW);
    CGFloat btnh = LTAutoW(36);
    _exchangeBtn.frame = CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar) - btnw, (h - btnh)*0.5, btnw, btnh);
    _lineView.frame = CGRectMake(0, h, ScreenW_Lit, LTAutoW(kTaskListCellLineH));
    
    
    [_icon sd_setImageWithURL:[mo.taskIcon toURL] placeholderImage:[UIImage imageNamed:@"gain"]];
    _titleLab.text = mo.taskTitle;
    _subLab.attributedText = ABStr;
    [self configBtn:mo];

    if (showProgress) {
        _progressLab.frame = CGRectMake(_midView.w_ - LTAutoW(kProgressLabW), _subLab.yh_ + LTAutoW(kProgressLabTopMar), LTAutoW(kProgressLabW), LTAutoW(kProgressLabH));
        CGFloat pvh = LTAutoW(kProgressViewH);
        _progressView.frame = CGRectMake(0, _progressLab.y_ + (_progressLab.h_ - pvh)/2, _midView.w_ - LTAutoW(kProgressLabW), pvh);
        NSInteger finishNum = [TaskListMo curFinishQuestionNum:mo.queSucessNum taskId:mo.taskId];
        NSInteger allNum = mo.queTotalNum;
        CGFloat vw = allNum == 0 ? 0 : _progressView.w_*finishNum/allNum;
        _finishView.frame = CGRectMake(0, 0, vw, pvh);
        
        _progressLab.text = [NSString stringWithFormat:@"%ld/%ld",finishNum,allNum];
    }
    
    
//    _midView.backgroundColor = LTYellowColor;
//    _subLab.backgroundColor = LTOrangeColor;
}

+ (CGFloat)cellH:(TaskListMo *)mo {
    NSString *substr = mo.taskDesc;
    NSAttributedString *ABStr = [substr ABStrSpacing:kSpacingH font:autoFontSiz(12)];
    CGFloat midViewW = ScreenW_Lit - LTAutoW((4*kLeftMar + kIconW + kBtnW));
    CGSize size = [ABStr autoSize:CGSizeMake(midViewW, CGFLOAT_MAX)];
    CGFloat subh = size.height;
    
    
    CGFloat tmar = 0;
    CGFloat midh = 0;
    
    //任务跳转类型：1=答题，2=分享，3=协议跳转，4=H5跳转
    if (mo.taskType == 1) {//有进度条
        tmar = LTAutoW(kTopMar1);
        midh = LTAutoW(kTitleLabH)+LTAutoW(kMidMar) + subh + LTAutoW(kProgressLabTopMar) + LTAutoW(kProgressLabH);
    } else {
        tmar = LTAutoW(kTopMar);
        midh = LTAutoW(kTitleLabH)+LTAutoW(kMidMar) + subh;
    }
    CGFloat h = 2*tmar + midh + LTAutoW(kTaskListCellLineH);

    
    return h;
}

@end
