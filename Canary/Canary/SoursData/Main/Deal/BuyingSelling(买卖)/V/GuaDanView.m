//
//  GuaDanView.m
//  Canary
//
//  Created by 孙武东 on 2019/1/2.
//  Copyright © 2019 litong. All rights reserved.
//

#import "GuaDanView.h"

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

@property (weak, nonatomic) IBOutlet UIButton *y_upBtn;
@property (weak, nonatomic) IBOutlet UILabel *y_leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *y_rightLabel;
@property (weak, nonatomic) IBOutlet UISlider *y_slider;
@property (weak, nonatomic) IBOutlet UIButton *y_downBtn;

@property (weak, nonatomic) IBOutlet UILabel *bottom_priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottom_subLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttom_GuaDanBtn;


@property (nonatomic, strong)UIButton *selectBtn_lx;
@property (nonatomic, strong)UIButton *selectBtn_jc;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@end

@implementation GuaDanView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self initWithUI];
    
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

    
}

- (void)setIsGuaDan:(BOOL)isGuaDan{
    _isGuaDan = isGuaDan;
    
    self.topViewHeight.constant = _isGuaDan ? 140 : 0;

}

- (void)setIsBuyDown:(BOOL)isBuyDown{
    _isBuyDown = isBuyDown;
    [self buyButtonChange:_isBuyDown ? _count_buyDown : self.count_buyUp];

}

- (void)changeSlider:(UIButton *)btn{
    
    if (btn == self.s_downBtn) {
        
        self.s_slider.value = self.s_slider.value - 0.01;
        
    }else if (btn == self.s_upBtn){
        
        self.s_slider.value = self.s_slider.value + 0.01;

        
    }else if (btn == self.y_downBtn){
        
        self.y_slider.value = self.y_slider.value - 0.01;

        
    }else if (btn == self.y_upBtn){
        
        self.y_slider.value = self.y_slider.value + 0.01;
        
    }
    
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

#pragma mark - delegete

- (void)textFieldChange:(UITextField *)textField{
    
    if (self.gd_pointTextField.text.length && self.gd_priceTextField.text.length) {
        
        CGFloat gd_left = [self.gd_priceTextField.text floatValue] - [self.gd_pointTextField.text floatValue];
        
        self.gd_leftPriceLabel.text = [NSString stringWithFormat:@"%.2f",gd_left < 0 ? 0 : gd_left];
        
        self.gd_rightPriceLabel.text = [NSString stringWithFormat:@"%.2f",[self.gd_priceTextField.text floatValue] + [self.gd_pointTextField.text floatValue]];
        
    }
    
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
