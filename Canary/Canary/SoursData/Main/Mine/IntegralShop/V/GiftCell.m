//
//  GiftCell.m
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GiftCell.h"
#import "UIImageView+WebCache.h"

@interface GiftCell ()

@property (nonatomic,strong) UIImageView *icon;//优惠券
@property (nonatomic,strong) UILabel *titleLab;//哈贵所200元代金券
@property (nonatomic,strong) UILabel *subLab;//100,000积分
@property (nonatomic,strong) UILabel *exchangeLab;//31人已兑换
@property (nonatomic,strong) UIButton *exchangeBtn;//马上兑换

@property (nonatomic,strong) NSIndexPath *iPath;
@property (nonatomic,strong) GiftMO *mo;

@end

@implementation GiftCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LTWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
    self.icon = [[UIImageView alloc] init];
    _icon.frame = LTRectAutoW(kLeftMar, 20, 80, 44);
    [self addSubview:_icon];
    
    self.titleLab = [self lab:CGRectMake(_icon.xw_+LTAutoW(12), LTAutoW(21), LTAutoW(150), LTAutoW(15)) fontSize:15 color:LTTitleColor];
    [self addSubview:_titleLab];
    
    self.subLab = [self lab:CGRectMake(_titleLab.x_, _titleLab.yh_ + LTAutoW(12), _titleLab.w_, LTAutoW(15)) fontSize:15 color:LTColorHex(0xFF5D01)];
    [self addSubview:_subLab];
    
    CGFloat exchangeLabW = LTAutoW(98);
    self.exchangeLab = [self lab:CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar)-exchangeLabW, _titleLab.y_, exchangeLabW, LTAutoW(12)) fontSize:12 color:LTSubTitleColor];
    _exchangeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_exchangeLab];
    
    CGFloat exchangeBtnW = LTAutoW(68);
    self.exchangeBtn = [UIButton btnWithTarget:self action:@selector(clickBtn:) frame:CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar)-exchangeBtnW, _exchangeLab.yh_+LTAutoW(7), exchangeBtnW, LTAutoW(32))];
    [_exchangeBtn setTitle:@"马上兑换" forState:UIControlStateNormal];
    [_exchangeBtn setTitleColor:LTSureFontBlue forState:UIControlStateNormal];
    _exchangeBtn.titleLabel.font = autoFontSiz(12);
    [_exchangeBtn layerRadius:3 borderColor:LTSureFontBlue borderWidth:1];
    [self addSubview:_exchangeBtn];
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, kGiftCellH-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
    
}

#pragma mark - action

- (void)clickBtn:(UIButton *)btn {
    NSDictionary *dict = @{
                           GiftCellMoTypeKey : @(GiftMOType_quan),
                           GiftCellMoKey : _mo,
                           GiftCellIndexPathKey : _iPath
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:NFC_ExchangeGift object:dict];
}


#pragma mark - utils

- (UILabel *)lab:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = frame;
    lab.font = autoFontSiz(fontSize);
    lab.textColor = color;
    return lab;
}


#pragma mark - 外部

- (void)bindData:(GiftMO *)mo indexPath:(NSIndexPath *)indexPath {
    self.mo = mo;
    self.iPath = indexPath;
    
    //优惠券
    [_icon sd_setImageWithURL:[mo.giftPic toURL] placeholderImage:[UIImage imageNamed:@"Shop_pic_def"]];
    //哈贵所200元代金券
    self.titleLab.text = mo.giftName;
    //100,000积分
    self.subLab.text = [mo points_fmt];
    //31人已兑换
    self.exchangeLab.text = [mo takeNum_fmt];
}

@end
