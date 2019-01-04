//
//  BindCardCell.m
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BindCardCell.h"

@interface BindCardCell ()<UITextFieldDelegate>
{
    BOOL hasNext;
}
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UITextField *field;
@property (nonatomic,strong) UIImageView *nextIV;
@property (nonatomic,strong) UIButton *shutBtn;

@property (nonatomic,strong) NSString *holder;


@end

@implementation BindCardCell

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
    
    CGFloat titleLabW = 32;
    CGFloat labh = kBindCardCellH;
    self.titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(kLeftMar, 0, titleLabW, labh);
    _titleLab.font = fontSiz(15);
    _titleLab.textColor = LTTitleColor;
    _titleLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_titleLab];
    
    CGFloat nextIVW = 7;
    CGFloat nextIVH = 11;
    self.nextIV = [[UIImageView alloc] init];
    _nextIV.frame = CGRectMake(ScreenW_Lit - kLeftMar - nextIVW, (labh - nextIVH)/2.0, nextIVW, nextIVH);
    _nextIV.image = [UIImage imageNamed:@"next"];
    _nextIV.hidden = YES;
    [self addSubview:_nextIV];
    

    CGRect shutRect =CGRectMake(ScreenW_Lit - labh, 0, labh, labh);
    self.shutBtn = [UIButton btnWithTarget:self action:@selector(clearField) frame:shutRect];
    [self.shutBtn setNorImageName:@"dealShut"];
    self.shutBtn.contentMode = UIViewContentModeScaleAspectFit;
    self.shutBtn.hidden = YES;
    [self addSubview:_shutBtn];
    
    CGFloat fieldx = _titleLab.xw_ + 25;
    CGFloat fieldw = ScreenW_Lit - fieldx - labh;
    self.field = [[UITextField alloc] init];
    _field.frame = CGRectMake(fieldx, 0, fieldw, labh);
    _field.font = fontSiz(15);
    _field.textColor = LTTitleColor;
    _field.delegate = self;
    [_field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:_field];

    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, labh-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
    
}

#pragma mark - action

- (void)clearField {
    _field.text = nil;
    self.shutBtn.hidden = YES;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (!hasNext) {
        NSString *str = textField.text;
        BOOL show = str.length > 0;
        self.shutBtn.hidden = !show;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //25 = 20 + (20/4)
    if (textField.text.length >= 25) {
        return NO;
    }
    
    if ([self numberKeyboard]) {
        // 四位加一个空格
        if ([string isEqualToString:@""]) { // 删除字符
            if ((textField.text.length - 2) % 5 == 0) {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        } else {
            if (textField.text.length % 5 == 0) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        return YES;
    }
    
    return YES;
}

- (BOOL)numberKeyboard {
    BOOL bl = [_holder contains:@"卡号"];
    return bl;
}

#pragma mark - 外部

- (void)bindData:(NSDictionary *)dict {

    NSString *title = [dict stringFoKey:key_BCC_Title];
    _holder = [dict stringFoKey:key_BCC_Holder];
    hasNext = [dict boolFoKey:key_BCC_Next];
    self.titleLab.text = title;
    
    if ([self numberKeyboard]) {
        _field.keyboardType = UIKeyboardTypeNumberPad;
    } else {
        _field.keyboardType = UIKeyboardTypeDefault;
    }
    
    NSAttributedString *abstr = [_holder ABStrColor:LTSubTitleColor range:NSMakeRange(0, _holder.length)];
    self.field.attributedPlaceholder = abstr;
    self.field.userInteractionEnabled = !hasNext;
    
    self.nextIV.hidden = !hasNext;
    self.shutBtn.hidden = YES;
}

- (void)changeField:(NSString *)text {
    self.field.text = text;
}
- (NSString *)fieldString {
    NSString *str = self.field.text;
    return str;
}

@end
