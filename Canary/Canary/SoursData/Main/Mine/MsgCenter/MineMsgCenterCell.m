//
//  MineMsgCenterCell.m
//  ixit
//
//  Created by litong on 2017/3/10.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MineMsgCenterCell.h"

#define MMCIconColors @[@"848999", @"F54A40", @"FEA848", @"7698EF"]
#define MMCIconTitles   @[@"异", @"官", @"券", @"仓"]

@interface MineMsgCenterCell ()
{
    CGFloat titleLabMaxW;
}
@property (nonatomic,strong) UILabel *iconLab;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *subLab;
@property (nonatomic,strong) UIImageView *redPointIV;
@property (nonatomic,strong) UIView *lineView;

@end


@implementation MineMsgCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LTWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCell];
    }
    return self;
}

#define MMC_TopMar  20
#define MMC_IconWH  18
#define MMC_SubLabTopMar  10
#define MMC_SubFontSize  12
#define MMC_timeLabW  115

- (void)createCell {

    CGFloat iconWH = LTAutoW(MMC_IconWH);
    self.iconLab = [self lab:CGRectMake(LTAutoW(kLeftMar), LTAutoW(MMC_TopMar), iconWH, iconWH) fontSize:12 color:LTWhiteColor];
    [self addSubview:_iconLab];
    _iconLab.layer.cornerRadius = 3;
    _iconLab.textAlignment = NSTextAlignmentCenter;
    _iconLab.layer.masksToBounds = YES;
    
    CGFloat timeLabW = LTAutoW(MMC_timeLabW);
    CGFloat timeLabX = ScreenW_Lit - LTAutoW(kLeftMar) - timeLabW;
    self.timeLab = [self lab:CGRectMake(timeLabX, LTAutoW(MMC_TopMar), timeLabW, LTAutoW(MMC_IconWH)) fontSize:12 color:LTSubTitleColor];
    _timeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_timeLab];
    
    CGFloat subLabX = LTAutoW(kLeftMar+MMC_IconWH+10);
    titleLabMaxW = _timeLab.x_ - subLabX;
    self.titleLab = [self lab:CGRectMake(subLabX, LTAutoW(MMC_TopMar), titleLabMaxW, iconWH) fontSize:15 color:LTTitleColor];
    [self addSubview:_titleLab];
    
    CGFloat subLabW = [MineMsgCenterCell subLableW];
    self.subLab = [self lab:CGRectMake(subLabX, _titleLab.yh_ + LTAutoW(MMC_SubLabTopMar), subLabW, LTAutoW(MMC_SubFontSize)) fontSize:MMC_SubFontSize color:LTSubTitleColor];
    _subLab.numberOfLines = 2;
    [self addSubview:_subLab];
    
    CGFloat ivwh = LTAutoW(6);
    self.redPointIV = [[UIImageView alloc] init];
    _redPointIV.frame = CGRectMake(subLabX, _iconLab.y_+(iconWH - ivwh)*0.5, ivwh, ivwh);
    _redPointIV.image = [UIImage imageNamed:@"redPointIcon"];
    [self addSubview:_redPointIV];
    _redPointIV.hidden = YES;
    
    
    self.lineView = [[UIView alloc] init];
    _lineView.backgroundColor = LTLineColor;
    [self addSubview:_lineView];
    
//    _titleLab.backgroundColor = LTYellowColor;
//    _timeLab.backgroundColor = LTGreenColor;
//    _subLab.backgroundColor = LTGrayColor;
}

#pragma mark - utils

- (UILabel *)lab:(CGRect)frame fontSize:(CGFloat)fz color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] initWithFrame:frame];
    lab.font = autoFontSiz(fz);
    lab.textColor = color;
    return lab;
}



+ (CGFloat)subLableW {
    CGFloat subLabX = LTAutoW(kLeftMar+MMC_IconWH+10);
    
    CGFloat subLabW = ScreenW_Lit - subLabX - LTAutoW(kLeftMar);
    return subLabW;
}

- (void)configIcon:(MineMsgType)typ {
    _iconLab.text = MMCIconTitles[typ];
    
    NSString *colorString = MMCIconColors[typ];
    _iconLab.backgroundColor = LTColorHexString(colorString);
}

#pragma mark - 外部

- (void)bindData:(MineMsgCenterMO *)mo {
    
    [self configIcon:mo.mineMsgType];
    
    NSString *msgTitle = mo.messageTitle;
    _titleLab.text = msgTitle;
    
    BOOL showRedPoint = mo.showRed;
    if (showRedPoint) {
        CGSize tsize = [msgTitle boundingSize:CGSizeMake(MAXFLOAT, LTAutoW(MMC_IconWH)) font:autoFontSiz(15) ];
        CGFloat w = tsize.width;
        if (w >= titleLabMaxW) {
            w = titleLabMaxW;
            [_redPointIV setOX:(_titleLab.x_+w)];
        } else {
            [_redPointIV setOX:(_titleLab.x_+w + LTAutoW(8))];
        }
    }
    _redPointIV.hidden = !showRedPoint;
    
    _timeLab.text = mo.createTime_fmt;
    
    CGFloat subLabW = [MineMsgCenterCell subLableW];
    NSString *msgContent = mo.messageContent;
    NSAttributedString *ABStr = [msgContent ABStrSpacing:4 font:autoFontSiz(MMC_SubFontSize)];
    CGSize size = [ABStr autoSize:CGSizeMake(subLabW, CGFLOAT_MAX)];
    CGFloat h = size.height;
    if (h < 20) {
        h = MMC_SubFontSize;
        [_subLab setSH:h];
        _subLab.attributedText = nil;
        _subLab.text = msgContent;
    } else {
        [_subLab setSH:h];
        _subLab.text = nil;
        _subLab.attributedText = ABStr;
    }
    
    CGFloat liney = self.subLab.yh_ + LTAutoW(MMC_TopMar) - 0.5;
    self.lineView.frame = CGRectMake(0, liney, ScreenW_Lit, 0.5);
}

+ (CGFloat)viewH:(MineMsgCenterMO *)mo {
    CGFloat subLabW = [MineMsgCenterCell subLableW];
    
    NSString *str = mo.messageContent;
    NSAttributedString *ABStr = [str ABStrSpacing:4 font:autoFontSiz(MMC_SubFontSize)];
    CGSize size = [ABStr autoSize:CGSizeMake(subLabW, CGFLOAT_MAX)];
    CGFloat h = size.height;
    if (h < 20) {
        h = MMC_SubFontSize;
    }
    
    CGFloat vh = LTAutoW(MMC_TopMar + MMC_IconWH + MMC_SubLabTopMar + h + MMC_TopMar);
    
    return vh;
}

@end
