//
//  ActivityGiftCell.m
//  ixit
//
//  Created by litong on 2017/3/31.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ActivityGiftCell.h"
#import "LTWebCache.h"

@interface ActivityGiftCell ()

@property (nonatomic,strong) UIImageView *bgIV;//背景
@property (nonatomic,strong) UILabel *titleLab;//亏损包赔
@property (nonatomic,strong) UILabel *surplusNumLab;//仅剩102份
@property (nonatomic,strong) UILabel *pointLab;//1,000,000积分
@property (nonatomic,strong) UILabel *exchangeLab;//10,345人已兑换
@property (nonatomic,strong) UIButton *exchangeBtn;//马上抢

@property (nonatomic,strong) NSIndexPath *iPath;
@property (nonatomic,strong) GiftMO *mo;

@end

@implementation ActivityGiftCell

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
    CGFloat ivw = LTAutoW(353);
    CGFloat ivh = LTAutoW(80);
    
    self.bgIV = [[UIImageView alloc] init];
    self.bgIV.frame = CGRectMake((ScreenW_Lit - ivw)*0.5, 0, ivw, ivh);
    [self addSubview:self.bgIV];
    
    self.titleLab = [self lab:16 color:LTWhiteColor];
    self.titleLab.font = autoBoldFontSiz(16);
    [self addSubview:self.titleLab];
    
    self.surplusNumLab = [self lab:10 color:LTWhiteColor];
    self.surplusNumLab.textAlignment = NSTextAlignmentCenter;
    [self.surplusNumLab layerRadius:0.5 bgColor:LTColorHexA(0xFFFFFF, 0.2)];
    [self addSubview:self.surplusNumLab];
    
    self.pointLab = [self lab:15 color:LTColorHexA(0xFFFFFF, 0.5)];
    self.pointLab.frame = LTRectAutoW(36, 46, 200, 15);
    [self addSubview:self.pointLab];
    
    
    self.exchangeLab = [self lab:12 color:LTColorHexA(0xFFFFFF, 0.5)];
    self.exchangeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.exchangeLab];
    
    
        CGFloat exchangeBtnW = LTAutoW(68);
    self.exchangeBtn = [UIButton btnWithTarget:self action:@selector(clickBtn:) frame:CGRectMake(ScreenW_Lit - LTAutoW(24) - exchangeBtnW,LTAutoW(36), exchangeBtnW, LTAutoW(32))];
    _exchangeBtn.titleLabel.font = autoFontSiz(12);
    _exchangeBtn.layer.cornerRadius = 3;
    _exchangeBtn.layer.masksToBounds = YES;
    [self addSubview:_exchangeBtn];
}

#pragma mark - action

- (void)clickBtn:(UIButton *)btn {
//    NSInteger state = _mo.buyStatus;
//    if (state > 0) {
//        return;
//    }
    
    NSDictionary *dict = @{
                           GiftCellMoTypeKey : @(GiftMOType_PrivilegedCard),
                           GiftCellMoKey : _mo,
                           GiftCellIndexPathKey : _iPath
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:NFC_ExchangeGift object:dict];
}

#pragma mark - utils

- (UILabel *)lab:(CGFloat)fs color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = autoFontSiz(fs);
    lab.textColor = color;
    return lab;
}

//购买状态：0=未购买 1=已购买 2=已抢光
- (void)configBtn:(GiftMO *)mo {
    NSInteger state = _mo.buyStatus;
    if (state == 1) {
        [_exchangeBtn setTitle:@"已购买" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        _exchangeBtn.backgroundColor = LTClearColor;
        [_exchangeBtn layerRadius:3 borderColor:LTClearColor borderWidth:0];
    }
    else if (state == 2) {
        [_exchangeBtn setTitle:@"已抢光" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        _exchangeBtn.backgroundColor = LTClearColor;
        [_exchangeBtn layerRadius:3 borderColor:LTClearColor borderWidth:0];
    }
    else {
        [_exchangeBtn setTitle:@"马上抢" forState:UIControlStateNormal];
        if (!mo.btnNotEnable) {
            [_exchangeBtn setTitleColor:[mo btnColor] forState:UIControlStateNormal];
            _exchangeBtn.backgroundColor = LTWhiteColor;
            [_exchangeBtn layerRadius:3 borderColor:LTWhiteColor borderWidth:0];
        } else {
            UIColor *color = [mo subTextColor];
            [_exchangeBtn setTitleColor:color forState:UIControlStateNormal];
            _exchangeBtn.backgroundColor = LTClearColor;
            [_exchangeBtn layerRadius:3 borderColor:color borderWidth:1];
        }
    }
}

#pragma mark - 外部

- (void)bindData:(GiftMO *)mo indexPath:(NSIndexPath *)indexPath {
    self.mo = mo;
    self.iPath = indexPath;
    
    [self.bgIV lt_setImageWithURL:mo.giftPic];
    
    NSString *giftName = mo.giftName;
    self.titleLab.text = giftName;
    CGSize size = [giftName boundingSize:CGSizeMake(MAXFLOAT, LTAutoW(16)) font:autoBoldFontSiz(16)];
    CGFloat titleLabW = size.width;
    self.titleLab.frame = CGRectMake(LTAutoW(36), LTAutoW(20), titleLabW, LTAutoW(16));
    
    NSString *giftLimitNum = [mo giftLimitNum_fmt];
    self.surplusNumLab.text = giftLimitNum;
    CGFloat giftLimitNumW = [giftLimitNum autoFitW:LTAutoW(10)] + LTAutoW(10);
//    self.surplusNumLab.frame = CGRectMake(self.titleLab.xw_+LTAutoW(4), self.titleLab.y_+LTAutoW(1), giftLimitNumW, LTAutoW(16));
    self.surplusNumLab.frame = CGRectMake(self.titleLab.xw_+LTAutoW(4), self.titleLab.y_, giftLimitNumW, LTAutoW(16));
    
    self.pointLab.text = [mo points_fmt];
    
    NSString *takeNum = [mo takeNum_fmt];
    self.exchangeLab.text = takeNum;
    CGFloat takeNumW = [takeNum autoFitW:LTAutoW(12)];
    self.exchangeLab.frame = CGRectMake(ScreenW_Lit - LTAutoW(24) - takeNumW, LTAutoW(17), takeNumW, LTAutoW(15));
    
    [self configBtn:_mo];
}

@end
