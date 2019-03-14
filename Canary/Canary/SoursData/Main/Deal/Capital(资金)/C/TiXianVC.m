//
//  TiXianVC.m
//  Canary
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "TiXianVC.h"
#import "CZHAddressPickerView.h"
#import "AddressPickerHeader.h"
#import "NetworkRequests.h"
@interface TiXianVC ()<UITextFieldDelegate>
@property (nonatomic ,strong)UITextField * priceTextFiled;
@property (nonatomic ,strong)UITextField * bankTextFiled;
@property (nonatomic ,strong)UITextField * personTextFiled;
@property (nonatomic ,strong)UITextField * zhiBankTextFiled;

@property (nonatomic,strong)UIButton *selectBank;
@property (nonatomic,strong)UIButton *selectArea;
@property (nonatomic,strong)UIButton *SubmitBut;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *area;
@end

@implementation TiXianVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navTitle:@"提 现" backType:BackType_Dismiss];
    [self creatTableView];
}
-(void)creatTableView
{
    UIView * viiew1 =[[UIView alloc]initWithFrame:CGRectMake(0, NavBarTop_Lit, Screen_width, 140)];
    viiew1.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:viiew1];
    
    UIView * line1 =[[UIView alloc]initWithFrame:CGRectMake(0, viiew1.yh_, Screen_width, 8)];
    line1.backgroundColor =LTLineColor;
    [self.view addSubview:line1];
    
    UILabel * messageLabel =[[UILabel  alloc]initWithFrame:CGRectMake(15, 15, 120, 20)];
    messageLabel.text = @"提现金额";
    messageLabel.font =[UIFont systemFontOfSize:15];
    [viiew1 addSubview:messageLabel];
    
//    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 80, 20)];
//    label.textColor = [UIColor blackColor];
//    label.text = @"(可提现金额 2.27";
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:12];
//    [viiew1 addSubview:label];

    
    UILabel * anmer =[[UILabel alloc]initWithFrame:CGRectMake(15, messageLabel.yh_ + 15, 20, 38)];
    anmer.text = @"$";
    anmer.font =[UIFont boldFontOfSize:30];
    [viiew1 addSubview:anmer];
 
    self.priceTextFiled = [self field:CGRectMake(anmer.xw_ + 5, messageLabel.yh_ + 25, 130, 30) placeholder:@"1美元起"];
    [viiew1 addSubview:self.priceTextFiled];
    
    UIView * lineView =[[UIView alloc]initWithFrame:CGRectMake(15, anmer.yh_ , Screen_width - 20, 1)];
    lineView.backgroundColor = LTLineColor;
    [viiew1 addSubview:lineView];
    
    UILabel * label1 =[[UILabel  alloc]initWithFrame:CGRectMake(15, lineView.yh_ + 15, 70, 20)];
    label1.text = @"到账时间:";
    label1.textColor =LTSubTitleColor;
    label1.font =[UIFont systemFontOfSize:14];
    [viiew1 addSubview:label1];
    UILabel * label2 =[[UILabel  alloc]initWithFrame:CGRectMake(label1.xw_, lineView.yh_ + 15, 100, 20)];
    label2.text = @"1~2个工作日";
    label2.font =[UIFont systemFontOfSize:14];
    [viiew1 addSubview:label2];
    
    UIButton * rightBut =[UIButton buttonWithType:(UIButtonTypeCustom)];
    rightBut.frame =CGRectMake(Screen_width - 30,lineView.yh_ +15, 20, 20);
    [rightBut setImage:[UIImage imageNamed:@"wenhao"] forState:(UIControlStateNormal)];
    [rightBut addTarget:self action:@selector(clickAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [viiew1 addSubview:rightBut];
    
    UIView * viiew2 =[[UIView alloc]initWithFrame:CGRectMake(0, line1.yh_, Screen_width, 150)];
    viiew2.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:viiew2];
    for (int i = 0; i < 3; i ++) {
        UIView * linehead =[[UIView alloc]initWithFrame:CGRectMake(0, 50 * i, Screen_width, 0.5)];
        linehead.backgroundColor =LTLineColor;
        [viiew2 addSubview:linehead];

    }
    UIView * linefoot =[[UIView alloc]initWithFrame:CGRectMake(0, 150, Screen_width, 0.5)];
    linefoot.backgroundColor =LTLineColor;
    [viiew2 addSubview:linefoot];
    
    UILabel * titleLabe1 =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
    titleLabe1.font =[UIFont systemFontOfSize:15];
    titleLabe1.text = @"卡号";
    [viiew2 addSubview:titleLabe1];
    UILabel * titleLabe2 =[[UILabel alloc]initWithFrame:CGRectMake(10, 65, 70, 20)];
    titleLabe2.font =[UIFont systemFontOfSize:15];
    titleLabe2.text = @"户名";
    [viiew2 addSubview:titleLabe2];
    UILabel * titleLabe3 =[[UILabel alloc]initWithFrame:CGRectMake(10, 115, 70, 20)];
    titleLabe3.font =[UIFont systemFontOfSize:15];
    titleLabe3.text = @"选择银行";
    [viiew2 addSubview:titleLabe3];

    self.bankTextFiled = [self field:CGRectMake(titleLabe1.xw_ + 15, 15, 130, 20) placeholder:@"请输入借记卡号"];
    [viiew2 addSubview:self.bankTextFiled];
    
    self.personTextFiled = [self field:CGRectMake(titleLabe1.xw_ + 15, 65, 130, 20) placeholder:@"请输入持卡人姓名"];
    [viiew2 addSubview:self.personTextFiled];
    
    self.selectBank =[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.selectBank.frame =CGRectMake(titleLabe1.xw_ + 15, 115, 130, 20);
    self.selectBank.titleLabel.font =[UIFont systemFontOfSize:13];
    [self.selectBank setTitle:@"选择银行" forState:(UIControlStateNormal)];
    self.selectBank.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.selectBank setTitleColor:LTSubTitleColor forState:(UIControlStateNormal)];
    [self.selectBank addTarget:self action:@selector(clickBank:) forControlEvents:(UIControlEventTouchUpInside)];
    [viiew2 addSubview:self.selectBank];
    
    UIImageView * imageRight =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
    imageRight.frame =CGRectMake(Screen_width - 25, 117.5, 15, 15);
    [viiew2 addSubview:imageRight];
    
    UIView * line2 =[[UIView alloc]initWithFrame:CGRectMake(0, viiew2.yh_, Screen_width, 8)];
    line2.backgroundColor =LTLineColor;
    [self.view addSubview:line2];
    
    UIView * viiew3 =[[UIView alloc]initWithFrame:CGRectMake(0, line2.yh_, Screen_width, 100)];
    viiew3.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:viiew3];
    
    for (int i = 0; i < 3; i ++) {
        UIView * linehead1 =[[UIView alloc]initWithFrame:CGRectMake(0, 50 * i, Screen_width, 0.5)];
        linehead1.backgroundColor =LTLineColor;
        [viiew3 addSubview:linehead1];
        
    }
    UIView * linefoot1 =[[UIView alloc]initWithFrame:CGRectMake(0, 100, Screen_width, 0.5)];
    linefoot1.backgroundColor =LTLineColor;
    [viiew3 addSubview:linefoot1];
    
    UILabel * titleLabe5 =[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 70, 20)];
    titleLabe5.font =[UIFont systemFontOfSize:15];
    titleLabe5.text = @"地区";
    [viiew3 addSubview:titleLabe5];
    UILabel * titleLabe6 =[[UILabel alloc]initWithFrame:CGRectMake(10, 65, 70, 20)];
    titleLabe6.font =[UIFont systemFontOfSize:15];
    titleLabe6.text = @"户名";
    [viiew3 addSubview:titleLabe6];
    
    self.selectArea =[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.selectArea.frame =CGRectMake(titleLabe5.xw_ + 15, 15, Screen_width -140, 20);
    self.selectArea.titleLabel.font =[UIFont systemFontOfSize:15];
    self.selectArea.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.selectArea setTitle:@"选择地区" forState:(UIControlStateNormal)];
    [self.selectArea setTitleColor:LTSubTitleColor forState:(UIControlStateNormal)];
    [self.selectArea addTarget:self action:@selector(clickArea:) forControlEvents:(UIControlEventTouchUpInside)];
    [viiew3 addSubview:self.selectArea];
    
    self.zhiBankTextFiled = [self field:CGRectMake(titleLabe6.xw_ + 15, 65, 130, 20) placeholder:@"请输入支行名称"];
    [viiew3 addSubview:self.zhiBankTextFiled];
    
    UIImageView * imageRight1 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
    imageRight1.frame =CGRectMake(Screen_width - 25, 17.5, 15, 15);
    [viiew3 addSubview:imageRight1];
    
    self.SubmitBut =[UIButton buttonWithType:(UIButtonTypeCustom)];
    self.SubmitBut.frame =CGRectMake(15, Screen_height - 80, Screen_width - 30, 50);
    self.SubmitBut.titleLabel.font =[UIFont systemFontOfSize:15];
    [self.SubmitBut setTitle:@"提交" forState:(UIControlStateNormal)];
    [self.SubmitBut setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.SubmitBut.backgroundColor =BlueLineColor;
    CGColorSpaceRef cmykSpace = CGColorSpaceCreateDeviceCMYK();
    CGFloat cmykValue[] = {0, 0, 0, 0, 0};
    CGColorRef colorCMYK = CGColorCreate(cmykSpace, cmykValue);
    CGColorSpaceRelease(cmykSpace);
     self.SubmitBut.layer.cornerRadius = 5.0;
     self.SubmitBut.layer.borderColor = colorCMYK;
     self.SubmitBut.layer.borderWidth = 1.0f;
    [self.SubmitBut addTarget:self action:@selector(SubmitButClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.SubmitBut];
}

- (UITextField *)field:(CGRect)rect placeholder:(NSString *)placeholder {
    UIFont *font = fontSiz(13);
    UIFont *pFont = fontSiz(13);
    UITextField *field = [[UITextField alloc] initWithFrame:rect];
    field.font = font;
    field.textColor = LTTitleColor;
    field.textAlignment = NSTextAlignmentLeft;
    field.keyboardType = UIKeyboardTypeDecimalPad;
    field.delegate = self;
    field.inputAccessoryView = [self addToolbar];
    NSAttributedString *attrString = [placeholder ABStrFont:font placeholderFont:pFont color:LTSubTitleColor];
    field.attributedPlaceholder = attrString;
    
    return field;
}
- (UIToolbar *)addToolbar {
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 35)];
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
-(void)clickArea:(id)sender
{
    CZHWeakSelf(self);
    [CZHAddressPickerView areaPickerViewWithProvince:self.province city:self.city area:self.area type:@"ctiy" areaBlock:^(NSString *province, NSString *city, NSString *area) {
        CZHStrongSelf(self);
        self.province = province;
        self.city = city;
        self.area = area;
        [sender setTitle:[NSString stringWithFormat:@"%@ %@ %@",province,city,area] forState:UIControlStateNormal];
        self.selectArea.titleLabel.font =[UIFont systemFontOfSize:13];
    }];
}

-(void)clickBank:(id)sender
{
    [CZHAddressPickerView provincePickerViewWithtype:@"bank" ProvinceBlock:^(NSString *province) {
        [sender setTitle:province forState:UIControlStateNormal];
    }];

}
-(void)SubmitButClick:(id)sender
{
    [self getNetWork];
}
-(void)clickAction:(id)sender
{

}
-(void)getNetWork
{
    NSString * urlString = [NSString stringWithFormat:@"%@%@",BasisUrl,@"/withdraw/apply"];
    NSDictionary * dic = @{@"mt4id":[NSUserDefaults objFoKey:MT4ID],@"type":@"WireTransfer",@"amount":self.priceTextFiled.text,@"accountNumber":_bankTextFiled.text,@"accountName":self.personTextFiled.text,@"bankName":self.selectBank.titleLabel.text,@"bankAddress":self.zhiBankTextFiled.text};
    [[NetworkRequests sharedInstance]POST:urlString dict:dic succeed:^(id data) {
        if ([[data objectForKey:@"code"]integerValue] ==0) {
            [self showMyMessage:@"提交成功"];
        }
    } failure:^(NSError *error) {
        
    }];

}
-(void)showMyMessage:(NSString*)aInfo {
    if (aInfo.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:aInfo delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
