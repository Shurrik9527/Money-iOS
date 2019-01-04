//
//  ModifyFw.m
//  Canary
//
//  Created by apple on 2018/5/13.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "ModifyFw.h"
#import "FieldView.h"
#import "DataHundel.h"
#import "NetworkRequests.h"
#define kCellTemp 12
#define kCellH 45
#define kCellW (kMidW)

#define kLineBlueColor   LTRGB(72, 119, 230)
@interface ModifyFw ()
@property (nonatomic,strong) FieldView *oldpwd;//老密码
@property (nonatomic,strong) FieldView *pwdView1;//密码
@property (nonatomic,strong) FieldView *pwdView2;//密码
@property (nonatomic,strong) UIButton *finishBtn;//完成按钮
@end

@implementation ModifyFw

- (instancetype)init {
    self = [super init];
    if (self) {
        [self navPopBackTitle:@"修改密码"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

-(void)createView
{
    self.oldpwd = [[FieldView alloc] initWithFrame:CGRectMake(kLeftMar, NavBarTop_Lit + kCellTemp, kCellW, kCellH)];
    [self.oldpwd showEyeImge:NO];
    [self.oldpwd configPlaceholder:@"请输入老密码"];
    [self.view addSubview:self.oldpwd];
    
    self.pwdView1 = [[FieldView alloc] initWithFrame:CGRectMake(kLeftMar, _oldpwd.yh_ + kCellTemp, kCellW, kCellH)];
    [self.pwdView1 showEyeImge:YES];
    [self.pwdView1 configPlaceholder:@"请输入新密码"];
    [self.view addSubview:self.pwdView1];
    
    self.pwdView2 = [[FieldView alloc] initWithFrame:CGRectMake(kLeftMar, _pwdView1.yh_ + kCellTemp, kCellW, kCellH)];
    [self.pwdView2 showEyeImge:YES];
    [self.pwdView2 configPlaceholder:@"请再次输入新密码"];
    [self.view addSubview:self.pwdView2];
    
    self.finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.finishBtn.frame = CGRectMake(kLeftMar, _pwdView2.yh_ + kCellTemp , kCellW, kCellH);
    self.finishBtn.titleLabel.font = fontSiz(15);
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishBtn layerRadius:3 bgColor:LTColorHex(0x3A69E3)];
    [self.finishBtn addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_finishBtn];
}
-(void)finishAction
{
    if (![self.pwdView1.field.text isEqualToString:self.pwdView2.field.text]) {
        [self showMyMessage:@"两次新密码不一致" type:0];
        return;
    }else
    {
        [self showLoadingView];
        NSString * url =[NSString stringWithFormat:@"%@%@",BasisUrl,@"/user/changepw"];
        NSDictionary * dic = @{@"type":@"SYSTEM",@"oldpw":self.oldpwd.field.text,@"newpw":self.pwdView1.field.text};
        [[NetworkRequests sharedInstance]POST:url dict:dic succeed:^(id data) {
            [self hideLoadingView];
            [self showMyMessage:[DataHundel messageObjetCode:[[data objectForKey:@"code"]integerValue]]type:1];
        } failure:^(NSError *error) {
            [self hideLoadingView];

        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)showMyMessage:(NSString*)aInfo type:(NSInteger)type {
    if (aInfo.length > 0) {
        if (type == 0) {
            UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView1 show];
        }else
        {
            UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView2 show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:alertView]) {
        [self popVC];
    }
}
@end
