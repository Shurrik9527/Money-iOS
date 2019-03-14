//
//  TopUpVC.m
//  Canary
//
//  Created by 孙武东 on 2019/1/20.
//  Copyright © 2019 litong. All rights reserved.
//

#import "TopUpVC.h"
#import <AlipaySDK/AlipaySDK.h>
#import "RechargeWebView.h"
@interface TopUpVC (){
    NSInteger rechargeMoney;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UILabel *moneyChangeLabel;
@property (weak, nonatomic) IBOutlet UIButton *aliPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *yinlianBtn;

@property (nonatomic, strong)UIButton *selectBtn;
@property (nonatomic, strong)UIButton *selectMoneyBtn;

@end

@implementation TopUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navPopBackTitle:@"充值"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success) name:@"didsuccess" object:Nil];
    self.topHeight.constant = 44;
    self.moneyChangeLabel.text = @"请选择充值金额";
    // Do any additional setup after loading the view from its nib.
}
-(void)success{
    
}
- (IBAction)payBtnAction:(UIButton *)sender {
    if (_aliPayBtn == sender) {
        _aliPayBtn.selected = YES;
        _yinlianBtn.selected = NO;
    }else{
        _aliPayBtn.selected = NO;
        _yinlianBtn.selected = YES;
    }
}


- (IBAction)selectMoneyBtnAction:(UIButton *)sender {
    
    if (sender == self.selectMoneyBtn) {
        return;
    }
    
    if (self.selectMoneyBtn) {
        self.selectMoneyBtn.backgroundColor = [UIColor colorFromHexString:@"efedff"];
        self.selectMoneyBtn.layer.borderWidth = 0;
        self.selectMoneyBtn.layer.cornerRadius = 0;
        self.selectMoneyBtn.selected = NO;
    }
    
    self.selectMoneyBtn = sender;
    
    self.selectMoneyBtn.backgroundColor = [UIColor whiteColor];
    self.selectMoneyBtn.layer.borderWidth = 1;
    self.selectMoneyBtn.layer.cornerRadius = 5;
    self.selectMoneyBtn.layer.borderColor = [UIColor colorFromHexString:@"007AFF"].CGColor;
    self.selectMoneyBtn.selected = YES;
    
    
    NSInteger money = sender.tag == 1 ? 3 :sender.tag == 2 ? 10 :sender.tag == 3 ? 50 :sender.tag == 4 ? 100 :sender.tag == 5 ? 300 :sender.tag == 6 ? 500 :sender.tag == 7 ? 800 : 1000;
    rechargeMoney = money;
    self.moneyChangeLabel.text = [NSString stringWithFormat:@"充值%ld美元, 大约需要人民币¥%.2f",money,money * 6.3];
    
}

- (IBAction)topUpAction:(UIButton *)sender {
    
    if (!_selectMoneyBtn) {
        [self.view showTip:@"请选择充值金额"];
        
    }else{
        NSInteger type = 0;
        if (_yinlianBtn.isSelected) {
            type = 1;
        }
        if (_aliPayBtn.isSelected) {
            type = 2;
        }
        
        NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/amountRecord/pay"];
        NSDictionary * dic = @{@"payWay":[NSString stringWithFormat:@"%ld",(long)type],@"returnUrl":@"https://www.baidu.com",@"money":[NSString stringWithFormat:@"%ld",(long)rechargeMoney]};
        [[NetworkRequests sharedInstance] SWDPOST:url dict:dic succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
            if (isSuccess) {
                NSDictionary *dic = (NSDictionary *)resonseObj;
                RechargeWebView *vc= [[RechargeWebView alloc] init];
                vc.urlString = dic[@"pay_url"];
                [self presentVC:vc];
            }
        } failure:^(NSError *error) {
            
        }];
        
        
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
