//
//  FieldView.m
//  Canary
//
//  Created by litong on 2017/5/25.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "FieldView.h"

@interface FieldView ()<UITextFieldDelegate>

/** 是否明文显示密码 */
@property (nonatomic,strong) UIButton *showPwdBtn;


@end

@implementation FieldView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTWhiteColor;
        self.layer.cornerRadius = 3;
        self.layer.borderWidth = 1;
        [self showError:NO];
        
        CGFloat showPwdBtnW = self.h_;
        CGFloat showPwdBtnRMar = 3.5;
        self.field = [[UITextField alloc] init];
        _field.delegate = self;
        _field.frame = CGRectMake(kLeftMar, 0, self.w_ - showPwdBtnRMar - showPwdBtnW - kLeftMar, showPwdBtnW);
        _field.font = autoFontSiz(15);

        [self addSubview:_field];
        [_field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        
        self.showPwdBtn = [UIButton btnWithTarget:self action:@selector(clickBtn:) frame:CGRectMake(self.w_ - showPwdBtnRMar - showPwdBtnW, 0, showPwdBtnW, showPwdBtnW)];
        [_showPwdBtn setImage:[UIImage imageNamed:@"shutEye"] forState:UIControlStateNormal];
        [_showPwdBtn setImage:[UIImage imageNamed:@"openEye"] forState:UIControlStateSelected];
        [self addSubview:_showPwdBtn];
        
        _showPwdBtn.selected = NO;
        _field.secureTextEntry = YES;
        
    }
    return self;
}


//开眼，显示密码;      闭眼，不显示密码
- (void)clickBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    BOOL show = sender.selected;
    _field.enabled = NO;
    _field.secureTextEntry = !show;
    _field.enabled = YES;
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (self.saveFieldKey) {
        NSString *str = textField.text;
        [UserDefaults setObject:str forKey:_saveFieldKey];
    }
}


- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 35)];
    toolbar.tintColor = [UIColor blueColor];
    toolbar.backgroundColor = LTBgColor;
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    toolbar.items = @[space, bar];
    return toolbar;
}

- (void)textFieldDone {
    
//    [self yZeroMove];
    ShutAllKeyboard;
}

#pragma mark - 外部

- (void)openEye:(BOOL)open {
    _showPwdBtn.selected = open;
    _field.secureTextEntry = !open;
}

- (void)showEyeImge:(BOOL)show {
    _showPwdBtn.hidden = !show;
    [self openEye:YES];
}

- (void)showError:(BOOL)isError {
    UIColor *color = isError ? LTKLineRed : LTLineColor;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

- (void)configPlaceholder:(NSString *)holder {
    NSAttributedString *ABStr = [holder ABStrFont:fontSiz(15) color:LTSubTitleColor];
    _field.attributedPlaceholder = ABStr;
}


- (void)addToolsBar {
    _field.inputAccessoryView = [self addToolbar];
}

@end
