//
//  ChangeNicknameVCtrl.m
//  ixit
//
//  Created by litong on 2016/12/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "ChangeNicknameVCtrl.h"
#import "NetworkRequests.h"
#import "DataHundel.h"
@interface ChangeNicknameVCtrl ()<UITextFieldDelegate>

@property (nonatomic,strong) UITextField *nickNameField;
@property (nonatomic,strong) UIButton *changeBtn;

@end

@implementation ChangeNicknameVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navTitle:@"修改昵称" backType:BackType_PopVC rightTitle:@"保存"];
    
    [self createView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)createView {
    
    CGFloat filedY = NavBarTop_Lit + 10;
    
    UIView *fieldBg = [[UIView alloc] init];
    fieldBg.frame = CGRectMake(0, filedY, Screen_width,44);
    fieldBg.backgroundColor = LTWhiteColor;
    [self.view addSubview:fieldBg];
    
    self.nickNameField = [[UITextField alloc] init];
    _nickNameField.frame = CGRectMake(0.05*Screen_width, filedY, 0.9*Screen_width, 44);
    _nickNameField.backgroundColor = LTWhiteColor;
    _nickNameField.placeholder = @"请输入您想要的昵称";
    _nickNameField.font=[UIFont systemFontOfSize:16];
    _nickNameField.text = UD_NickName;
    _nickNameField.textColor = LTTitleRGB;
    _nickNameField.delegate = self;
    [self.view addSubview:_nickNameField];
    
}


- (void)rightAction {
    NSString *nickName = _nickNameField.text;
    if (nickName.length <= 0) {
        [self.view showTip:@"昵称不能为空"];
        return;
    }
    if ([nickName isEqualToString:[NSUserDefaults objFoKey:kNickName]]) {
        [LTAlertView alertMessage:@"昵称和之前是一样的"];
        return;
    }
    [self showLoadingView];
    NSString * url =[NSString stringWithFormat:@"%@%@",BasisUrl,@"/changeNickname"];
    NSDictionary * dic = @{@"nickname":nickName};
    [[NetworkRequests sharedInstance]POST:url dict:dic succeed:^(id data) {
        [self hideLoadingView];
        if ([[data objectForKey:@"code"]integerValue] == 0 ) {
            [NSUserDefaults setObj:nickName foKey:kNickName];
        }else
        {
        [LTAlertView alertMessage:[DataHundel messageObjetCode:[[data objectForKey:@"code"]integerValue]]];
        }
    } failure:^(NSError *error) {
        [self hideLoadingView];

    }];
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


@end
