//
//  OutcryRichCell.m
//  ixit
//
//  Created by litong on 2017/3/21.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "OutcryRichCell.h"

static CGFloat leftMar = 16.f;
static CGFloat rMar = 16.f;
static CGFloat topMar = 12.f;

static CGFloat labL = 23.f;
static CGFloat labR = 20.5f;

static CGFloat timeLabTM = 12.f;
static CGFloat timeLabH = 16.f;

static CGFloat markLabW = 42;
static CGFloat markLabH = 17.5;
static CGFloat markLabRM = 12;
static CGFloat markLabMM = 6;

static CGFloat remarkLabTM = 8;
static CGFloat remarkLabBM = 12;


#define  kTimeLabLeftMar  (leftMar + pointWH + midMar)

@interface OutcryRichCell ()

@property (nonatomic,strong) UIView *bgView;//背景
@property (nonatomic,strong) UILabel *timeLab;//时间
@property (nonatomic,strong) UIView *markView;//标签
@property (nonatomic,strong) UILabel *remarkLab;//文字提示

@end

@implementation OutcryRichCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LTBgColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCell];
    }
    return self;
}


#pragma mark - 外部

- (void)bindData:(OutcryModel *)model {
    
    self.timeLab.text = model.createTime_fmt;
    
    NSAttributedString *ABStr = model.styleContent_fmt;
    self.remarkLab.attributedText = ABStr;
    CGSize size = [OutcryRichCell ABStrHWithStr:ABStr];

    CGFloat sh = size.height;
    [self.remarkLab setSH:sh];
    
    CGFloat h = timeLabTM + timeLabH + remarkLabTM+ sh + remarkLabBM;
    [self.bgView setSH:h];
    
    NSArray *arr = model.lable_fmt;
    NSInteger labcount = arr.count;
    if (labcount > 0) {
        [_markView removeAllSubView];
        
        _markView.hidden = NO;
        CGFloat mvw = markLabW * labcount + markLabMM*(labcount - 1);
        CGFloat mvx = [OutcryRichCell bgw] - markLabRM - mvw;
        _markView.frame = CGRectMake(mvx, 12, mvw, markLabH);

        NSInteger i = 0;
        for (NSString *str in arr) {
            CGFloat x = i*(markLabW + markLabMM);
            UILabel *lab = [self markLab:x str:str];
            [_markView addSubview:lab];
            
            i++;
        }
        
    } else {
        _markView.hidden = YES;
    }

}


+ (CGFloat)cellHWithMo:(OutcryModel *)mo {
    NSAttributedString *ABStr = mo.styleContent_fmt;
    CGSize size = [OutcryRichCell ABStrHWithStr:ABStr];
    CGFloat sh = size.height;
    CGFloat h = topMar + timeLabTM + timeLabH + remarkLabTM+ sh + remarkLabBM;
    return h;
}


#pragma mark - 内部


- (void)createCell {
    
    self.bgView = [[UIView alloc] init];
    _bgView.frame = CGRectMake(leftMar, topMar, [OutcryRichCell bgw], 60);
    _bgView.backgroundColor = LTWhiteColor;
    [self addSubview:_bgView];
    [_bgView layerRadius:3 borderColor:LTColorHex(0xD0D4DB) borderWidth:0.5];
    
    //时间
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(labL, timeLabTM, [OutcryRichCell labw]/2, timeLabH)];
    self.timeLab.font = [UIFont fontOfSize:12.f];
    self.timeLab.textColor = LTSubTitleColor;
    [_bgView addSubview:self.timeLab];
    
    
    //标签
    self.markView = [[UIView alloc] init];
    [_bgView addSubview:_markView];
    
    
    //文字提示
    self.remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(labL, _timeLab.yh_ + remarkLabTM, [OutcryRichCell labw], 50)];
    self.remarkLab.numberOfLines = 0;
    [_bgView addSubview:self.remarkLab];
    
}


- (UILabel *)markLab:(CGFloat)x str:(NSString *)str {
    UIColor *color = [OutcryRichCell randomMarkColor];
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake(x, 0, markLabW, markLabH);
    lab.text = str;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont fontOfSize:12];
    lab.textColor = color;
    
    [lab layerRadius:3.f borderColor:color borderWidth:0.5];
    
    return lab;
}

//随机标签颜色
#define markcols @[@"40BA7A", @"63BEFF", @"33C8E1", @"FF6C64", @"6D92EB", @"EE937C", @"AD96FF"]
+ (UIColor *)randomMarkColor {
    NSInteger i = arc4random() % 7;
    NSString *colStr = [markcols objectAtIndex:i];
    return LTColorHexString(colStr);
}

+ (CGSize)ABStrHWithStr:(NSAttributedString *)ABStr {
    CGFloat w = [OutcryRichCell labw];
    CGSize size = [ABStr boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return size;
}

+ (CGFloat)bgw {
    return ScreenW_Lit - leftMar - rMar;
}

+ (CGFloat)labw {
    return [OutcryRichCell bgw] - labL - labR;
}



@end
