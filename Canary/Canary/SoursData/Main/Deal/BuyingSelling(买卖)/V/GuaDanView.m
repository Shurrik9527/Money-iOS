//
//  GuaDanView.m
//  Canary
//
//  Created by 孙武东 on 2019/1/2.
//  Copyright © 2019 litong. All rights reserved.
//

#import "GuaDanView.h"
#import "JWTHundel.h"

@interface GuaDanView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

//头部
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titlePriceLabel;


@property (weak, nonatomic) IBOutlet UITextField *gd_priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *gd_pointTextField;
@property (weak, nonatomic) IBOutlet UILabel *gd_leftPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *gd_rightPriceLabel;


@property (weak, nonatomic) IBOutlet UIButton *count_buyUp;
@property (weak, nonatomic) IBOutlet UIButton *count_buyDown;
@property (weak, nonatomic) IBOutlet UIButton *count_lx_10;
@property (weak, nonatomic) IBOutlet UIButton *count_lx_40;
@property (weak, nonatomic) IBOutlet UIButton *count_lx_100;


@property (weak, nonatomic) IBOutlet UIButton *count_jc1_1;
@property (weak, nonatomic) IBOutlet UIButton *count_jc1_5;
@property (weak, nonatomic) IBOutlet UIButton *count_jc1_10;
@property (weak, nonatomic) IBOutlet UIButton *count_jc1_other;
@property (weak, nonatomic) IBOutlet UIView *count_jc1_vie;


@property (weak, nonatomic) IBOutlet UIButton *count_jc_1;
@property (weak, nonatomic) IBOutlet UIButton *count_jc_2;
@property (weak, nonatomic) IBOutlet UIButton *count_jc_3;
@property (weak, nonatomic) IBOutlet UIButton *count_jc_4;
@property (weak, nonatomic) IBOutlet UIButton *count_jc_5;
@property (weak, nonatomic) IBOutlet UIButton *count_jc_6;
@property (weak, nonatomic) IBOutlet UIButton *count_jc_7;
@property (weak, nonatomic) IBOutlet UIButton *count_jc_8;
@property (weak, nonatomic) IBOutlet UIButton *count_jc_9;
@property (weak, nonatomic) IBOutlet UIButton *count_jc_10;
@property (weak, nonatomic) IBOutlet UIView *count_jc_view;

@property (weak, nonatomic) IBOutlet UILabel *bottomContent;

@property (weak, nonatomic) IBOutlet UILabel *tiltleLabel1;
@property (weak, nonatomic) IBOutlet UIButton *yuBtn;
@property (weak, nonatomic) IBOutlet UILabel *yuLabel;
@property (weak, nonatomic) IBOutlet UILabel *djjCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *djjBtn;


@property (weak, nonatomic) IBOutlet UIButton *s_upBtn;
@property (weak, nonatomic) IBOutlet UISlider *s_slider;
@property (weak, nonatomic) IBOutlet UIButton *s_downBtn;
@property (weak, nonatomic) IBOutlet UILabel *s_rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *s_leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *s_changeLabel;

@property (nonatomic, assign)NSInteger y_count;
@property (nonatomic, assign)NSInteger s_count;
@property (nonatomic, assign)NSInteger y_changeCount;
@property (nonatomic, assign)NSInteger s_changeCount;

@property (weak, nonatomic) IBOutlet UIButton *y_upBtn;
@property (weak, nonatomic) IBOutlet UILabel *y_leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *y_rightLabel;
@property (weak, nonatomic) IBOutlet UISlider *y_slider;
@property (weak, nonatomic) IBOutlet UIButton *y_downBtn;
@property (weak, nonatomic) IBOutlet UILabel *y_changeLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottom_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottom_subLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttom_GuaDanBtn;


@property (nonatomic, strong)UIButton *selectBtn_lx;
@property (nonatomic, strong)UIButton *selectBtn_jc;
@property (nonatomic, assign)CGFloat lxPrice;//所选类型
@property (nonatomic, assign)NSInteger lot;//所选建仓

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@end

@implementation GuaDanView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initWithUI];
    [self networkgGetMoney];
    
    [_y_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [_s_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    self.count_lx_10.tag = 101;
    self.count_lx_40.tag = 102;
    self.count_lx_100.tag = 103;
    
    _count_jc1_1.tag = 201;
    _count_jc1_5.tag = 205;
    _count_jc1_10.tag = 210;

    _count_jc_1.tag = 201;
    _count_jc_2.tag = 202;
    _count_jc_3.tag = 203;
    _count_jc_4.tag = 204;
    _count_jc_5.tag = 205;
    _count_jc_6.tag = 206;
    _count_jc_7.tag = 207;
    _count_jc_8.tag = 208;
    _count_jc_9.tag = 209;
    _count_jc_10.tag = 210;
    
}

- (void)networkgGetMoney{
    
    NSString * url = [NSString stringWithFormat:@"%@%@",BaseUrl,@"/userAmount/get"];
    
    [[NetworkRequests sharedInstance] SWDPOST:url dict:nil succeed:^(id resonseObj, BOOL isSuccess, NSString *message) {
        NSLog(@"zj == %@",resonseObj);
        
        if (isSuccess) {
            
//            NSString * yu = [resonseObj objectForKey:@"balance"];
            NSDecimalNumber *yue = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f", [[resonseObj objectForKey:@"balance"] floatValue]]];

            self.yuLabel.text = [NSString stringWithFormat:@"%@",yue];
            
        }else{
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
    
}


- (void)initWithUI{
    
    self.bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTap:)];
    [bgTap setNumberOfTapsRequired:1];
    bgTap.cancelsTouchesInView = NO;
    [self.bgView addGestureRecognizer:bgTap];
    
    self.gd_pointTextField.delegate = self;
    self.gd_priceTextField.delegate = self;
    
    [self.gd_priceTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.gd_pointTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.count_buyDown addTarget:self action:@selector(buyButtonChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_buyUp addTarget:self action:@selector(buyButtonChange:) forControlEvents:UIControlEventTouchUpInside];
    self.count_buyDown.layer.cornerRadius = 4;
    self.count_buyUp.layer.cornerRadius = 4;
    
    [self.count_buyUp setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.count_buyUp setTitleColor:[UIColor colorFromHexString:@"9a9a9a"] forState:UIControlStateNormal];
    [self.count_buyDown setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.count_buyDown setTitleColor:[UIColor colorFromHexString:@"9a9a9a"] forState:UIControlStateNormal];
    

    [self selectJcButton:self.count_jc1_1];
    [self selectLxButton:self.count_lx_10];
    
    [self.count_lx_10 addTarget:self action:@selector(selectLxButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_lx_40 addTarget:self action:@selector(selectLxButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_lx_100 addTarget:self action:@selector(selectLxButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.count_jc1_10 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc1_5 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc1_1 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc_1 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc_2 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc_3 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc_4 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc_5 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc_6 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc_7 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc_8 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc_9 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.count_jc_10 addTarget:self action:@selector(selectJcButton:) forControlEvents:UIControlEventTouchUpInside];

    [self.s_downBtn addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.s_upBtn addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.y_downBtn addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventTouchUpInside];
    [self.y_upBtn addTarget:self action:@selector(changeSlider:) forControlEvents:UIControlEventTouchUpInside];

    self.y_count = 200;
    self.s_count = 200;
    
}

- (void)setIsGuaDan:(BOOL)isGuaDan{
    _isGuaDan = isGuaDan;
    
    self.topViewHeight.constant = _isGuaDan ? 140 : 0;
    self.gd_pointTextField.text = @"3";
    [self.buttom_GuaDanBtn setTitle:_isGuaDan ?@"挂单":@"下单" forState:UIControlStateNormal];
}

- (void)setIsBuyDown:(BOOL)isBuyDown{
    _isBuyDown = isBuyDown;
    [self buyButtonChange:_isBuyDown ? _count_buyDown : self.count_buyUp];

}

- (void)setModel:(BuySellingModel *)model{
    _model = model;
    
    _titleNameLabel.text = model.symbolName;
    _titlePriceLabel.text = model.price;
    
    NSDecimalNumber *unitPriceOne = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", model.unitPriceOne]];
    NSDecimalNumber *unitPriceTwo = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", model.unitPriceTwo]];
    NSDecimalNumber *unitPriceThree = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", model.unitPriceThree]];

    [_count_lx_10 setTitle:[NSString stringWithFormat:@"%@美元/手",[unitPriceOne stringValue]] forState:UIControlStateNormal];
    [_count_lx_40 setTitle:[NSString stringWithFormat:@"%@美元/手",[unitPriceTwo stringValue]] forState:UIControlStateNormal];
    [_count_lx_100 setTitle:[NSString stringWithFormat:@"%@美元/手",[unitPriceThree stringValue]] forState:UIControlStateNormal];
    
    _tiltleLabel1.text = [NSString stringWithFormat:@"每波动一个点，收益%@美元",model.quantityPriceFluctuation];
    _bottomContent.text = [NSString stringWithFormat:@"*过夜费%@美元/天，默认开启，建仓后可手动关闭",model.quantityOvernightFee];
    
    _bottom_subLabel.text = [NSString stringWithFormat:@"(手续费:%@美元)",model.quantityCommissionCharges];
    
    [self getTotelPrice];

}

- (void)setPriceStr:(NSString *)priceStr{
    _priceStr = priceStr;
    
    _titlePriceLabel.text = priceStr;

}

- (void)changeSlider:(UIButton *)btn{
    
    if (btn == self.s_downBtn) {
        
        self.s_slider.value = self.s_slider.value - 0.01;
        [self sliderValueChanged:self.s_slider];
    }else if (btn == self.s_upBtn){
        
        self.s_slider.value = self.s_slider.value + 0.01;
        [self sliderValueChanged:self.s_slider];

        
    }else if (btn == self.y_downBtn){
        
        self.y_slider.value = self.y_slider.value - 0.01;
        [self sliderValueChanged:self.y_slider];

        
    }else if (btn == self.y_upBtn){
        
        self.y_slider.value = self.y_slider.value + 0.01;
        [self sliderValueChanged:self.y_slider];

    }
    
}

-(void)sliderValueChanged:(UISlider *)slider
{
    NSLog(@"slider value%f",slider.value);

    if (slider == self.y_slider) {
        if (slider.value == 0) {
            self.y_changeLabel.text = @"不限";
            self.y_changeCount = 0;

        }else{
            
            NSDecimalNumber *dian = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", ceil(self.y_count * slider.value)]];
            NSDecimalNumber *money = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", ceil(self.y_count * slider.value) * _model.quantityPriceFluctuation.floatValue]];
            self.y_changeCount = dian.integerValue;
            self.y_changeLabel.text = [NSString stringWithFormat:@"%@点（%@美元）",[dian stringValue],[money stringValue]];
        }
    }else{
        if (slider.value == 0) {
            self.s_changeLabel.text = @"不限";
            self.s_changeCount = 0;

        }else{
            
            
            // 将字符串转成一个十进制数。
            NSDecimalNumber *dian = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", ceil(self.s_count * slider.value)]];
            NSDecimalNumber *money = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", ceil(self.s_count * slider.value) * _model.quantityPriceFluctuation.floatValue]];
            self.s_changeCount = dian.integerValue;

            self.s_changeLabel.text = [NSString stringWithFormat:@"%@点（%@美元）",[dian stringValue],[money stringValue]];

        }
    }
}

- (void)getTotelPrice{
    
    self.lxPrice = self.selectBtn_lx.tag == 101 ? _model.unitPriceOne : self.selectBtn_lx.tag == 102 ? _model.unitPriceTwo:_model.unitPriceThree;
    
    self.lot = self.selectBtn_jc.tag % 200;
    
    NSLog(@"lxPrice == %f  lot == %ld",self.lxPrice,self.lot)
    NSDecimalNumber *money = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", self.lxPrice * self.lot + _model.quantityCommissionCharges.floatValue]];

    _bottom_priceLabel.text = [NSString stringWithFormat:@"%@",money];
    
}

- (void)selectLxButton:(UIButton *)btn{
   
    self.selectBtn_lx.layer.borderWidth = 0;
    self.selectBtn_lx.backgroundColor = [UIColor whiteColor];
    [self.selectBtn_lx setTitleColor:[UIColor colorFromHexString:@"9a9a9a"] forState:UIControlStateNormal];


    self.selectBtn_lx = btn;
    
    self.selectBtn_lx.layer.borderColor = self.count_buyUp.selected ? [UIColor redColor].CGColor : [UIColor colorFromHexString:@"28CD41"].CGColor;
    self.selectBtn_lx.layer.borderWidth = 1;
    self.selectBtn_lx.layer.cornerRadius = 3;
    self.selectBtn_lx.backgroundColor = self.count_buyUp.selected ? [UIColor colorFromHexString:@"E90000" alpha:0.1] : [UIColor colorFromHexString:@"28CD41" alpha:0.1];
    [self.selectBtn_lx setTitleColor:self.count_buyUp.selected ? [UIColor redColor] : [UIColor colorFromHexString:@"28CD41"] forState:UIControlStateNormal];

    [self getTotelPrice];

}

- (void)selectJcButton:(UIButton *)btn{
    
    self.selectBtn_jc.layer.borderWidth = 0;
    self.selectBtn_jc.backgroundColor = [UIColor whiteColor];
    [self.selectBtn_jc setTitleColor:[UIColor colorFromHexString:@"9a9a9a"] forState:UIControlStateNormal];
    self.selectBtn_jc = btn;

    self.selectBtn_jc.layer.borderColor = self.count_buyUp.selected ? [UIColor redColor].CGColor : [UIColor colorFromHexString:@"28CD41"].CGColor;
    self.selectBtn_jc.layer.borderWidth = 1;
    self.selectBtn_jc.layer.cornerRadius = 3;
    [self.selectBtn_jc setTitleColor:self.count_buyUp.selected ? [UIColor redColor] : [UIColor colorFromHexString:@"28CD41"] forState:UIControlStateNormal];
    self.selectBtn_jc.backgroundColor = self.count_buyUp.selected ? [UIColor colorFromHexString:@"E90000" alpha:0.1] : [UIColor colorFromHexString:@"28CD41" alpha:0.1];
    
    [self getTotelPrice];

}

- (void)buyButtonChange:(UIButton *)btn{
    
    if (!btn.selected) {
        
        self.count_buyDown.selected = self.count_buyUp == btn ? NO : YES;
        self.count_buyUp.selected = self.count_buyUp == btn ? YES : NO;
        
        self.count_buyUp.backgroundColor = btn == self.count_buyUp ? [UIColor redColor] : [UIColor colorFromHexString:@"efeff4"];
        self.count_buyDown.backgroundColor = btn == self.count_buyDown ? [UIColor colorFromHexString:@"28CD41"] : [UIColor colorFromHexString:@"efeff4"];

        [self textColorChanges:self.count_buyUp == btn];
    }
    
}

- (void)textColorChanges:(BOOL) isUp{
    
    self.selectBtn_jc.layer.borderColor = isUp ? [UIColor redColor].CGColor : [UIColor colorFromHexString:@"28CD41"].CGColor;
    self.selectBtn_jc.backgroundColor = isUp ? [UIColor colorFromHexString:@"E90000" alpha:0.1] : [UIColor colorFromHexString:@"28CD41" alpha:0.1];
    [self.selectBtn_jc setTitleColor:self.count_buyUp.selected ? [UIColor redColor] : [UIColor colorFromHexString:@"28CD41"] forState:UIControlStateNormal];

    self.selectBtn_lx.layer.borderColor = isUp ? [UIColor redColor].CGColor : [UIColor colorFromHexString:@"28CD41"].CGColor;
    self.selectBtn_lx.backgroundColor = isUp ? [UIColor colorFromHexString:@"E90000" alpha:0.1] : [UIColor colorFromHexString:@"28CD41" alpha:0.1];
    [self.selectBtn_lx setTitleColor:self.count_buyUp.selected ? [UIColor redColor] : [UIColor colorFromHexString:@"28CD41"] forState:UIControlStateNormal];

    self.buttom_GuaDanBtn.backgroundColor = isUp ? [UIColor colorFromHexString:@"E90000"] : [UIColor colorFromHexString:@"28CD41"];

}

- (void)bgViewTap:(UITapGestureRecognizer *) sender{
    
    UIEvent *event = [[UIEvent alloc] init];
    CGPoint location = [sender locationInView:sender.view];
    UIView *view = [sender.view hitTest:location withEvent:event];
    
    if ([view.gestureRecognizers containsObject:sender]) {
        NSLog(@"当前视图响应了事件");
        
        [self removeFromSuperview];
    }

}

- (IBAction)otherAction:(UIButton *)sender {
    
    self.count_jc_view.hidden = NO;
    self.count_jc1_vie.hidden = YES;
    
    [self selectJcButton:self.count_jc_1];

    
}

- (IBAction)yuBtnAction:(UIButton *)sender {
    self.djjBtn.selected = NO;
    self.yuBtn.selected = YES;
}

- (IBAction)djjBtnAction:(UIButton *)sender {
    self.yuBtn.selected = NO;
    self.djjBtn.selected = YES;
}

- (IBAction)buyAction:(UIButton *)sender {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.isGuaDan) {
        
        if (self.gd_priceTextField.text.length == 0) {
            [LTAlertView alertMessage:@"请输入挂单价格"];
            return;
        }
        
        [dic setObject:_model.id forKey:@"id"];
        [dic setObject:[NSUserDefaults objFoKey:@"loginName"] forKey:@"loginName"];
        [dic setObject:@(self.lot) forKey:@"lot"];
        [dic setObject:_isBuyDown ? @(2):@(1) forKey:@"ransactionType"];
        [dic setObject:@(3) forKey:@"transactionStatus"];
        [dic setObject:_model.symbolCode forKey:@"symbolCode"];
        [dic setObject:@(_lxPrice) forKey:@"unitPrice"];
        
        NSString *jsonStr = [NSString stringWithFormat:@"id:%@,loginName:%@,lot:%@,ransactionType:%@,symbolCode:%@,transactionStatus:%@,unitPrice:%@,url:/transaction/reserve",dic[@"id"],dic[@"loginName"],dic[@"lot"],dic[@"ransactionType"],dic[@"symbolCode"],dic[@"transactionStatus"],dic[@"unitPrice"]];
        NSLog(@"json === %@",jsonStr);
        NSLog(@"dic === %@",dic);
        NSString *sign = [[JWTHundel shareHundle] getRSAKEY:jsonStr];
        
        [dic setObject:sign forKey:@"sign"];
        [dic setObject:@(self.s_changeCount) forKey:@"stopLossCount"];
        [dic setObject:@(self.y_changeCount) forKey:@"stopProfitCount"];
        [dic setObject:self.gd_priceTextField.text forKey:@"entryOrdersPrice"];
        [dic setObject:self.gd_pointTextField.text.length ? self.gd_pointTextField.text : @"0" forKey:@"errorRange"];

    }else{
        [dic setObject:_model.id forKey:@"id"];
        [dic setObject:[NSUserDefaults objFoKey:@"loginName"] forKey:@"loginName"];
        [dic setObject:@(self.lot) forKey:@"lot"];
        [dic setObject:_isBuyDown ? @(2):@(1) forKey:@"ransactionType"];
        [dic setObject:@(1) forKey:@"transactionStatus"];
        [dic setObject:_model.symbolCode forKey:@"symbolCode"];
        [dic setObject:@(_lxPrice) forKey:@"unitPrice"];
        
        NSString *jsonStr = [NSString stringWithFormat:@"id:%@,loginName:%@,lot:%@,ransactionType:%@,symbolCode:%@,transactionStatus:%@,unitPrice:%@,url:/transaction/buy",dic[@"id"],dic[@"loginName"],dic[@"lot"],dic[@"ransactionType"],dic[@"symbolCode"],dic[@"transactionStatus"],dic[@"unitPrice"]];
        NSLog(@"json === %@",jsonStr);
        NSLog(@"dic === %@",dic);
        NSString *sign = [[JWTHundel shareHundle] getRSAKEY:jsonStr];
        
        [dic setObject:sign forKey:@"sign"];
        [dic setObject:@(self.s_changeCount) forKey:@"stopLossCount"];
        [dic setObject:@(self.y_changeCount) forKey:@"stopProfitCount"];
    }

    
    if (self.retureBuyDic) {
        self.retureBuyDic(dic, self.isGuaDan);
    }

}

- (void)closeView{
    [self removeFromSuperview];
}

#pragma mark - delegete

- (void)textFieldChange:(UITextField *)textField{
    
    if (self.gd_pointTextField.text.length && self.gd_priceTextField.text.length) {
        
        CGFloat gd_left = [self.gd_priceTextField.text floatValue] - [self.gd_pointTextField.text floatValue];
        
        self.gd_leftPriceLabel.text = [NSString stringWithFormat:@"%.2f",gd_left < 0 ? 0 : gd_left];
        
        self.gd_rightPriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.gd_priceTextField.text floatValue] + [self.gd_pointTextField.text floatValue]];
        
    }
    
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if ([string isEqualToString:@"."]) {
        return YES;
    }else if ([string is_number]){
        return YES;
    }
    return NO;
    
    
}

@end
