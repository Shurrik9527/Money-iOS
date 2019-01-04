//
//  NameField.m
//  Canary
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "NameField.h"

@interface NameField ()<UITextFieldDelegate>

/** 是否明文显示密码 */
@property (nonatomic,strong) UIButton *showPwdBtn;


@end


@implementation NameField

-(instancetype)initWithFrame:(CGRect)frame {
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
        
        _field.secureTextEntry = YES;
        
    }
    return self;
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
