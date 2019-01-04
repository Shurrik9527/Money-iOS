//
//  OutcryCell.m
//  ixit
//
//  Created by litong on 16/11/5.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "OutcryCell.h"

//static CGFloat pointWH = 7.f;
//static CGFloat leftMar = 16.f;
//static CGFloat midMar = 16.f;
//static CGFloat rMar = 16.f;
//static CGFloat topMar = 12.f;
//static CGFloat timeLabH = 15.f;
//static CGFloat remarkLabFontSize = 15.f;
//static CGFloat remarkLabTopMar = 7.f;

#define pointWH LTAutoW(7)
#define leftMar LTAutoW(16)
#define midMar LTAutoW(16)
#define rMar LTAutoW(16)
#define topMar LTAutoW(12)
#define timeLabH LTAutoW(15)
#define remarkLabFontSize LTAutoW(15)
#define remarkLabTopMar LTAutoW(7)

#define  kTimeLabLeftMar  (leftMar + pointWH + midMar)

@interface OutcryCell ()

@property (nonatomic,strong) UILabel *timeLab;//时间
@property (nonatomic,strong) UILabel *remarkLab;//文字提示
@property (nonatomic,strong) UIImageView *iv;
@property (nonatomic,strong) UIImageView *lineIV;


@end

@implementation OutcryCell

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

- (void)bindData:(OutcryModel *)model begin:(BOOL)begin {

    
    self.timeLab.text = model.createTime_fmt;
    
    NSString *content = [NSString stringWithFormat:@"%@",model.remark];
    
    NSAttributedString *ABStr = [OutcryCell ABStrWithStr:content];
    self.remarkLab.attributedText = ABStr;
    
    CGSize size = [OutcryCell ABStrHWithStr:content];
    
    CGRect remarkLabRect =self.remarkLab.frame;
    remarkLabRect.size = size;
    self.remarkLab.frame = remarkLabRect;
    
    if (begin) {
        self.iv.image = [UIImage imageNamed:@"outcry_dian1"];
        
        CGFloat lh = topMar + timeLabH + remarkLabTopMar + size.height - _timeLab.yh_;
        _lineIV.frame = CGRectMake(leftMar+(pointWH/2.0)-LTAutoW(0.5), _timeLab.yh_, LTAutoW(1), lh);
        
    } else {
        self.iv.image = [UIImage imageNamed:@"outcry_dian"];
        
        CGFloat lh = topMar + timeLabH + remarkLabTopMar + size.height;
        _lineIV.frame = CGRectMake(leftMar+(pointWH/2.0)-LTAutoW(0.5), 0, LTAutoW(1), lh);
    }

}


+ (CGFloat)cellHWithMo:(OutcryModel *)mo {
    NSString *str = [NSString stringWithFormat:@"%@",mo.remark];
    CGSize size = [OutcryCell ABStrHWithStr:str];
    return topMar + timeLabH + remarkLabTopMar + size.height;
}


#pragma mark - 内部


- (void)createCell {
    
    self.lineIV = [[UIImageView alloc] init];
    _lineIV.frame = CGRectMake(leftMar+(pointWH/2.0)-LTAutoW(0.5), 0, LTAutoW(1), pointWH);
    UIColor *linebgcolor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"live_pic_Dotted"]];
    _lineIV.backgroundColor = linebgcolor;
    [self addSubview:_lineIV];
    
    self.iv = [[UIImageView alloc] init];
    _iv.frame = CGRectMake(leftMar, topMar + (timeLabH - pointWH)/2.0, pointWH, pointWH);
    _iv.image = [UIImage imageNamed:@"outcry_dian"];
    [self addSubview:_iv];
    

    
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(kTimeLabLeftMar, topMar, 200, timeLabH)];
    self.timeLab.font = [UIFont autoFontSize:12.f];
    self.timeLab.textColor = LTSubTitleColor;
    [self addSubview:self.timeLab];
    
    self.remarkLab = [[UILabel alloc] initWithFrame:CGRectMake(kTimeLabLeftMar, self.timeLab.yh_ + LTAutoW(7), [OutcryCell timeLabW], LTAutoW(50))];
    self.remarkLab.font = [UIFont systemFontOfSize:remarkLabFontSize];
    self.remarkLab.textColor = LTColorHex(0x30354F);
    self.remarkLab.numberOfLines = 0;
    [self addSubview:self.remarkLab];
    
}


#define kLineSpacing   3

+ (NSAttributedString *)ABStrWithStr:(NSString *)str {
    NSRange range = NSMakeRange(0, [str length]);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = kLineSpacing;
    paragraphStyle.lineSpacing = LTAutoW(kLineSpacing);
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    [ABStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [ABStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:remarkLabFontSize] range:range];
    
    return ABStr;
}

+ (CGSize)ABStrHWithStr:(NSString *)str {
    NSAttributedString *ABStr = [OutcryCell ABStrWithStr:str];
    CGFloat w = [OutcryCell timeLabW];
    CGSize size = [ABStr boundingRectWithSize:CGSizeMake(w, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return size;
}

+ (CGFloat)timeLabW {
    return ScreenW_Lit - kTimeLabLeftMar - rMar;
}

@end
