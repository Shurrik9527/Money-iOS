
//
//  ChoicePopView.m
//  Canary
//
//  Created by apple on 2018/4/15.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "ChoicePopView.h"
#import "UserModel.h"
@interface ChoicePopView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UILabel *text;
@property (assign ,nonatomic)NSInteger selectedRow;
@end

@implementation ChoicePopView
-(instancetype)init
{
    self = [super init];
    if (self) {
        _selectedRow = 0;
        [self configContentH:kBuyViewH];
        [self creatView];
    }
    return self;
}
-(void)creatView
{
    UILabel * messageLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.w_, 30)];
    messageLabel.textAlignment = 1;
    messageLabel.font =[UIFont systemFontOfSize:15];
    messageLabel.text = @"请选择账户";
    messageLabel.textColor = [UIColor colorFromHexString:@"#161725"];
    messageLabel.userInteractionEnabled = YES;
    [self.contentView addSubview:messageLabel];
    
    UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(self.w_ - 50, 5, 40, 20)];
    [bt setTitle:@"确定" forState:UIControlStateNormal];
    bt.backgroundColor =[UIColor clearColor];
    [bt setTitleColor: [UIColor colorFromHexString:@"#4878e6"] forState:(UIControlStateNormal)];
    bt.titleLabel.font = [UIFont systemFontOfSize:13];
    [bt addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
    [messageLabel addSubview:bt];
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0,30, self.frame.size.width, kBuyViewH - messageLabel.h_)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.pickerView reloadAllComponents];
    [self.contentView addSubview:self.pickerView];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataAray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0f;
}
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  self.frame.size.width;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }

   _text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.w_, 40)];
    _text.textAlignment = NSTextAlignmentCenter;
    if ([self.a isEqualToString:@"1"]) {
        UserModel * model =[_dataAray objectAtIndex:row];
        if (row == _selectedRow) {
            _text.textColor = [UIColor colorFromHexString:@"#4878e6"];
        }else
        {
            _text.textColor =  LTRGB(75, 75, 75);
        }
        NSString * string = [NSString stringWithFormat:@"%@   %@  %@   %@",@"►",model.mt4id,model.type,@"◄"];
        _text.text = string;
    }else
    {
        if (row == _selectedRow) {
            _text.textColor = [UIColor colorFromHexString:@"#4878e6"];
        }else
        {
            _text.textColor =  LTRGB(75, 75, 75);
        }
        NSString * str = [_dataAray objectAtIndex:row];
        _text.text = str;
    }
    [view addSubview:_text];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.w_, 0.5)];
    line2.backgroundColor =[UIColor colorFromHexString:@"#4878e6"];
    [_text addSubview:line2];
    
    return view;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _selectedRow = row;
    if (row == _selectedRow) {
        _text.textColor = [UIColor colorFromHexString:@"#4878e6"];
    }else
    {
        _text.textColor =  LTRGB(75, 75, 75);
    }
    [_pickerView reloadAllComponents];
}
-(void)clickButtons:(id)sender
{
    if ([_a isEqualToString:@"1"]) {
        UserModel * model = [self.dataAray objectAtIndex:_selectedRow];
        self.callBackBlock(model.type,model.mt4id);
    }else
    {
        NSString * str = [_dataAray objectAtIndex:_selectedRow];
        self.typeblock(str);
    }

}
@end
