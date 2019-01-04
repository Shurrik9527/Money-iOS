//
//  AnswerView.m
//  ixit
//
//  Created by litong on 2017/3/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "AnswerView.h"

static CGFloat kavtop = 14;
static CGFloat kavFontsize = 17;

static CGFloat kIconWH = 22;
static CGFloat kIconRM = 15;
static CGFloat kSpacingH = 5.f;

@interface AnswerView ()
{
    CGFloat labW;
}
@property (nonatomic,copy) NSString *answer;
@property (nonatomic,assign) NSInteger num;

@property (nonatomic,strong) UILabel *answerLab;
@property (nonatomic,strong) UIImageView *iconIV;
@property (nonatomic,strong) UIButton *btn;

@end

@implementation AnswerView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {

    self.answerLab = [[UILabel alloc] init];
    _answerLab.font = autoFontSiz(kavFontsize);
    _answerLab.numberOfLines = 0;
    [self addSubview:_answerLab];
    
    self.iconIV = [[UIImageView alloc] init];
    [self addSubview:_iconIV];
    _iconIV.hidden = YES;
    
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn.backgroundColor = [UIColor clearColor];
    [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn];
    
    [self changeType:AnswerType_Normal];
}

- (void)clickBtn {
    _answerViewBlock ? _answerViewBlock(_num) : nil;
}

#pragma mark - 外部

- (void)refView:(NSDictionary *)answerDict {
    self.answer = [answerDict stringFoKey:@"queAnsDesc"];
    self.num = [answerDict integerFoKey:@"queAnsSeqNum"];
    
    labW = self.w_- 2*LTAutoW(kLeftMar) - LTAutoW(kIconRM) - LTAutoW(kIconWH);
    
    UIFont *font = autoFontSiz(kavFontsize);
    
    NSAttributedString *ABStr = [_answer ABStrSpacing:kSpacingH font:font];
    CGSize size = [ABStr autoSize:CGSizeMake(labW, CGFLOAT_MAX)];
    CGFloat labH = size.height;
    BOOL needABStr = labH > LTAutoW(kavFontsize)*2;
    if (!needABStr) {
        labH = 24;
        _answerLab.text = _answer;
    } else {
        _answerLab.attributedText = ABStr;
    }
    CGFloat h = 2*LTAutoW(kavtop) + labH;
    [self setSH:h];
    _btn.frame = CGRectMake(0, 0, self.w_, self.h_);
    
    _answerLab.frame = CGRectMake(LTAutoW(kLeftMar), LTAutoW(kavtop) , labW, labH);
    
    _iconIV.frame = CGRectMake(_answerLab.xw_ + LTAutoW(kLeftMar), (h - LTAutoW(kIconWH))/2, LTAutoW(kIconWH), LTAutoW(kIconWH));
    
}

- (void)changeType:(AnswerType)type {

    if (type == AnswerType_Normal) {//未作答
        _iconIV.hidden = YES;
        
        UIColor *color = LTColorHex(0x4877E6);
        _answerLab.textColor = color;
        [self layerRadius:3 borderColor:color borderWidth:1 bgColor:LTWhiteColor];
        
    }
    else if (type == AnswerType_Right) {//选对
        _iconIV.image = [UIImage imageNamed:@"task_icon_right"];
        _iconIV.hidden = NO;
        
        UIColor *color = LTColorHex(0x1FB73C);
        _answerLab.textColor = color;
        [self layerRadius:3 borderColor:color borderWidth:1 bgColor:LTColorHexA(0x1FB73C, 0.04)];
    }
    else if (type == AnswerType_Wrong) {//选错
        _iconIV.image = [UIImage imageNamed:@"task_icon_wrong"];
        _iconIV.hidden = NO;
        
        UIColor *color = LTColorHex(0xF54A40);
        _answerLab.textColor = color;
        [self layerRadius:3 borderColor:color borderWidth:1 bgColor:LTColorHexA(0xF54A40, 0.04)];
    }
    else if (type == AnswerType_UnSelect_Right) {//未选答案正确
        _iconIV.image = [UIImage imageNamed:@"task_icon_right"];
        _iconIV.hidden = NO;
        
        UIColor *color = LTColorHex(0x848999);
        _answerLab.textColor = color;
        [self layerRadius:3 borderColor:LTColorHexA(0x848999, 0.2) borderWidth:1 bgColor:LTWhiteColor];
    }
    else {//未选
        _iconIV.hidden = YES;
        
        UIColor *color = LTColorHex(0x848999);
        _answerLab.textColor = color;
        [self layerRadius:3 borderColor:LTColorHexA(0x848999, 0.2) borderWidth:1 bgColor:LTWhiteColor];
    }
}

@end
