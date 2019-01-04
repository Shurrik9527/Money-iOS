//
//  CodeFieldView.m
//  Canary
//
//  Created by litong on 2017/5/25.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "CodeFieldView.h"

@interface CodeFieldView ()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *sendBtn;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) double cutdownT;//倒计时毫秒数

@end

@implementation CodeFieldView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        
    }
    return self;
}

- (void)dealloc {
    [self timeStop];
}

- (void)createView {
    self.backgroundColor = LTWhiteColor;
    self.layer.cornerRadius = 3;
    self.layer.borderWidth = 1;
    self.layer.borderColor = LTLineColor.CGColor;
    self.layer.masksToBounds = YES;
    
    CGFloat timeLabW = 100+2*kLeftMar;
    CGFloat codeFieldW = self.w_ - timeLabW - kLeftMar;
    
    self.codeField = [[UITextField alloc] init];
    _codeField.delegate = self;
    _codeField.frame = CGRectMake(kLeftMar, 0, codeFieldW, self.h_);
    _codeField.font = fontSiz(15);
    [self addSubview:_codeField];
    [self configPlaceholder:@"请输入验证码"];
    
    self.timeLab = [[UILabel alloc] init];
    _timeLab.frame = CGRectMake(self.w_ - timeLabW, 0, timeLabW, self.h_);
    _timeLab.font = fontSiz(15);
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.textColor = LTSubTitleColor;
    [self addSubview:_timeLab];
    _timeLab.hidden = YES;
    
    
    CGFloat sendBtnW = 60+2*kLeftMar;
    self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame = CGRectMake(self.w_ - sendBtnW, 0, sendBtnW, self.h_);
    _sendBtn.backgroundColor = LTWhiteColor;
    _sendBtn.titleLabel.font = fontSiz(15);
    [_sendBtn setTitle:@"点击获取" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:LTSureFontBlue forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_sendBtn];

}

- (void)setCodeFieldType:(CodeFieldType)codeFieldType {
    _codeFieldType = codeFieldType;
    [self configSendBtn];
}

#pragma mark - action

- (void)sendCodeAction {
    if (_delegate && [_delegate respondsToSelector:@selector(sendCodeMsg)]) {
        [_delegate sendCodeMsg];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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

#pragma mark - utils

- (void)configPlaceholder:(NSString *)holder {
    NSAttributedString *ABStr = [holder ABStrFont:fontSiz(15) color:LTSubTitleColor];
    _codeField.attributedPlaceholder = ABStr;
}

- (NSString *)codeFieldTypeString:(CodeFieldType)typ {
    if (typ == CodeFieldType_Reg) {
        return @"CodeFieldType_RegKey";
    }
    else if (typ == CodeFieldType_ForgetPwd) {
        return @"CodeFieldType_ForgetPwdKey";
    }
    else if (typ == CodeFieldType_RegEX) {
        return @"CodeFieldType_RegEXKey";
    }
    else if (typ == CodeFieldType_ForgetPwdEX) {
        return @"CodeFieldType_ForgetPwdEXKey";
    }
    return @"";
}


#pragma mark - 发验证码&倒计时

- (void)sendCodeSuccess {
    double curT = [[NSDate date] timeIntervalSince1970];
    self.cutdownT = curT + 60;
    NSString *typKey = [self codeFieldTypeString:_codeFieldType];
    [UserDefaults setObject:@(self.cutdownT) forKey:typKey];
    [self timeStart];
    _sendBtn.hidden = YES;
    _timeLab.hidden = NO;
}

- (void)configSendBtn {
    NSString *typKey = [self codeFieldTypeString:_codeFieldType];
    self.cutdownT = [[UserDefaults objectForKey:typKey] doubleValue];
    double curT = [[NSDate date] timeIntervalSince1970];
    double tempT = self.cutdownT - curT;
    if (tempT > 0 && tempT <= 60) {
        [self timeStart];
        _sendBtn.hidden = YES;
        _timeLab.hidden = NO;
    } else {
        [self timeStop];
        _sendBtn.hidden = NO;
        _timeLab.hidden = YES;
    }
}

- (void)configTimeLab {
    double curT = [[NSDate date] timeIntervalSince1970];
    NSInteger tempT = self.cutdownT - curT;
    if (tempT > 0) {
        _timeLab.text = [NSString stringWithFormat:@"%lds后重新获取",(long)tempT];
    } else {
        [self timeStop];
        _sendBtn.hidden = NO;
        _timeLab.hidden = YES;
    }
}

- (void)timeStart {
    [self configTimeLab];
    if (!_timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(configTimeLab) userInfo:nil repeats:YES];
    }
}

- (void)timeStop {
    [_timer setFireDate:[NSDate distantFuture]];
    [_timer invalidate];
    _timer = nil;
}

- (void)addToolsBar {
    _codeField.inputAccessoryView = [self addToolbar];
}


@end
