//
//  ChooseSexV.m
//  Canary
//
//  Created by Brain on 2017/6/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ChooseDateV.h"
@interface ChooseDateV ()
@property(strong,nonatomic)UIDatePicker * datePicker;//时间选取

@end
#define ChooseSexVH 216
@implementation ChooseDateV
- (instancetype)init {
    self = [super init];
    if (self) {
        [self configContentH:ChooseSexVH];
        [self initView];
    }
    return self;
}
-(void)initView{
    [self.contentView layerRadius:3 bgColor:LTWhiteColor];
    
    if (!_datePicker) {
        _datePicker=[[UIDatePicker alloc]init];
        [ _datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
        _datePicker.frame=CGRectMake(0, 0, ScreenW_Lit, 216);
        _datePicker.datePickerMode = UIDatePickerModeDate;
        [ self.contentView addSubview:_datePicker];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy.MM.dd"];
        NSDate *minDate = [formatter dateFromString:@"1900.01.01"];
        NSDate *maxDate = [formatter dateFromString:@"2100.01.01"];
        _datePicker.minimumDate=minDate;
        _datePicker.maximumDate=maxDate;
    }
    [ _datePicker setDate:[NSDate date] animated:YES];

}
#pragma mark - action
-(void)dateChanged:(UIDatePicker*)sender{
    NSDate* date = sender.date;
    NSString *day = [LTUtils dayString:date];
    //根据时间显示数据
    _chooseDate?_chooseDate(day):nil;
}

@end
