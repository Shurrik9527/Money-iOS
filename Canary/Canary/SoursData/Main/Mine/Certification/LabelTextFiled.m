//
//  LabelTextFiled.m
//  Canary
//
//  Created by Brain on 2017/5/25.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LabelTextFiled.h"
@interface LabelTextFiled()<UITextFieldDelegate>
@property(copy,nonatomic)NSString * text;
@property(strong,nonatomic)UILabel * label;
@end
@implementation LabelTextFiled
#pragma mark - init view
-(instancetype)initWithFrame:(CGRect)frame leftTxt:(NSString *)leftTxt{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor=[UIColor colorWithRed:132/255.0 green:137/255.0 blue:153/255.0 alpha:0.3].CGColor;
        self.layer.borderWidth=0.5;
        self.layer.cornerRadius=3;
        self.layer.masksToBounds=YES;
        self.backgroundColor=LTWhiteColor;
        _text=leftTxt;
        [self createView];
    }
    return self;
}
-(void)createView{
    _label=[[UILabel alloc]init];
    _label.frame=CGRectMake(16, 0, 100, self.h_);
    _label.backgroundColor=LTClearColor;
    _label.font=[UIFont systemFontOfSize:midFontSize];
    [self addSubview:_label];
    _label.text=_text;
    [_label sizeToFit];
    
    CGFloat tx=_label.xw_+16;
    _textField=[[UITextField alloc]init];
    _textField.frame=CGRectMake(tx, 0, self.w_-tx, self.h_);
    _textField.font=[UIFont systemFontOfSize:15];
    _textField.textColor=LTSubTitleColor;
    _textField.delegate=self;
    [self addSubview:_textField];

}
#pragma mark - method
-(void)setMinLabW:(CGFloat)minLabW{
    _minLabW=minLabW;
    CGFloat labW=_label.w_;
    if (labW<minLabW) {
        labW=minLabW;
    }
    _label.frame=CGRectMake(16, 0, labW, self.h_);
    _label.attributedText=[LTUtils alignmentJustifiedAttr:_label.text maxW:minLabW];
    CGFloat tx=_label.xw_+16;
    _textField.frame=CGRectMake(tx, 0, self.w_-tx, self.h_);
}
#pragma mark - delegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    _edit?_edit():nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
