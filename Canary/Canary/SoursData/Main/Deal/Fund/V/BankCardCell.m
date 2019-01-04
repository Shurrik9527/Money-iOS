//
//  BankCardCell.m
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BankCardCell.h"
#import "LTWebCache.h"

@interface BankCardCell ()

@property (nonatomic,strong) BankCarkMO *mo;

@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *addCardLab;
@property (nonatomic,strong) UILabel *detailLab;
@property (nonatomic,strong) UIButton *selectBtn;//选中
@property (nonatomic,strong) UIButton *unBindBtn;//解绑

@end

@implementation BankCardCell

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
    
    CGFloat iconX = 16;
    CGFloat iconIVWH = 30;
    self.iconIV = [[UIImageView alloc] init];
    _iconIV.frame = CGRectMake(iconX, (kBankCardCellH - iconIVWH)/2.0, iconIVWH, iconIVWH);
    _iconIV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_iconIV];
    
    CGFloat labH = 23;
    CGFloat labW = ScreenW_Lit*0.6;
    CGFloat labY = (kBankCardCellH - 2*labH)*0.5;
    self.titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(_iconIV.xw_ + iconX, labY, labW, labH);
    _titleLab.font = fontSiz(15);
    _titleLab.textColor = LTTitleColor;
    [self addSubview:_titleLab];
    
    self.addCardLab = [[UILabel alloc] init];
    _addCardLab.frame = CGRectMake(_iconIV.xw_ + iconX, (kBankCardCellH - labH)*0.5, labW, labH);
    _addCardLab.font = fontSiz(15);
    _addCardLab.textColor = LTTitleColor;
    _addCardLab.hidden = YES;
    _addCardLab.text = @"添加银行卡";
    [self addSubview:_addCardLab];
    
    self.detailLab = [[UILabel alloc] init];
    _detailLab.frame = CGRectMake(_titleLab.x_, _titleLab.yh_, labW, labH);
    _detailLab.font = fontSiz(15);
    _detailLab.textColor = LTSubTitleColor;
    [self addSubview:_detailLab];
    
    CGFloat unBindBtnW = 32;
    CGFloat unBindBtnH = 15;
    CGRect unBindRect = CGRectMake(ScreenW_Lit - kLeftMar - unBindBtnW, (kBankCardCellH - unBindBtnH)/2.0, unBindBtnW, unBindBtnH);
    self.unBindBtn = [UIButton btnWithTarget:self action:@selector(unBindAction) frame:unBindRect];
    self.unBindBtn.titleLabel.font = fontSiz(unBindBtnH);
    [self.unBindBtn setTitleColorNSH:LTSureFontBlue];
    [self.unBindBtn setTitle:@"解绑" forState:UIControlStateNormal];
    self.unBindBtn.hidden = YES;
    [self addSubview:self.unBindBtn];
    
    CGFloat selectBtnWH = 23;
    CGRect selectRect = CGRectMake(ScreenW_Lit - kLeftMar - selectBtnWH, (kBankCardCellH - selectBtnWH)/2.0, selectBtnWH, selectBtnWH);
    self.selectBtn = [UIButton btnWithTarget:self action:@selector(selectAction) frame:selectRect];
    [self.selectBtn setNorImageName:@"unselect0"];
    [self.selectBtn setSelImageName:@"select0"];
    self.selectBtn.hidden = YES;
    [self addSubview:self.selectBtn];


    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, kBankCardCellH-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
    
}

#pragma mark - action

- (void)selectAction {
    if (_delegate && [_delegate respondsToSelector:@selector(selectCard:)]) {
        [_delegate selectCard:_mo];
    }
}

- (void)unBindAction {
    if (_delegate && [_delegate respondsToSelector:@selector(unBindCard:)]) {
        [_delegate unBindCard:_mo];
    }
}

#pragma mark - 外部

- (void)setTyp:(BankCardCellType)typ {
    _typ = typ;
    
    if (_typ == BankCardCellType_AddCard) {
        _iconIV.image = [UIImage imageNamed:@"addCard"];

        self.addCardLab.hidden = NO;
        self.titleLab.hidden = YES;
        self.detailLab.hidden = YES;
//        self.unBindBtn.hidden = YES;
        self.selectBtn.hidden = YES;
    } else {
        self.addCardLab.hidden = YES;
        self.titleLab.hidden = NO;
        self.detailLab.hidden = NO;
//        self.unBindBtn.hidden = YES;
        self.selectBtn.hidden = YES;
        
        if (_typ == BankCardCellType_UnBind) {
//            self.unBindBtn.hidden = NO;
            self.selectBtn.hidden = YES;
        }
        else if (_typ == BankCardCellType_Select) {
//            self.unBindBtn.hidden = YES;
            self.selectBtn.hidden = NO;
        }
        else {
//            self.unBindBtn.hidden = YES;
            self.selectBtn.hidden = YES;
        }
    }

}

- (void)bindData:(BankCarkMO *)mo {
    self.mo = mo;
    
    [_iconIV lt_setImageWithURL:_mo.icon placeholderImage:[UIImage imageNamed:@""]];
    _titleLab.text = _mo.bankName;
    _detailLab.text = [NSString stringWithFormat:@"尾号：%@",[_mo end4BankNO]];
}

- (void)selectCell:(BOOL)selected {
    self.selectBtn.selected = selected;
}

@end
