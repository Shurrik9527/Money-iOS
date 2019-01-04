//
//  SelDateView.m
//  ixit
//
//  Created by litong on 2016/12/20.
//  Copyright © 2016 litong. All rights reserved.
//

#import "SelDateView.h"

#define SelDateViewTabH  44
#define SelDateViewPickerViewH  130
#define SelDateViewH  174

@interface SelDateView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    CGFloat labW;
}
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSArray *yearList;
@property (nonatomic,strong) NSArray *monthList;

@property (nonatomic,copy) NSString *yearStr;
@property (nonatomic,copy) NSString *monthStr;
@property (nonatomic,assign) NSInteger curRow0;
@property (nonatomic,assign) NSInteger curRow1;

@end

@implementation SelDateView

- (instancetype)initWithFrame:(CGRect)frame ym:(NSString *)ym {
    self = [super initWithFrame:frame];
    if (self) {
        labW = self.w_*0.3;
        self.yearList = @[@"2016",@"2017",@"2018",@"2019",@"2020"];
        self.monthList = @[
                           @"01",@"02",@"03",@"04",@"05",@"06",
                           @"07",@"08",@"09",@"10",@"11",@"12"
                           ];
        self.backgroundColor = LTMaskColor;
        [self configCurRow:ym];
        [self createView];
    }
    return self;
}

- (void)configCurRow:(NSString *)ym {
    NSArray *arr = [ym splitWithStr:@"-"];
    if (arr.count > 1) {
        NSString *y = arr[0];
        int i = 0;
        for (NSString *item in _yearList) {
            if ([y isEqualToString:item]) {
                _curRow0 = i;
                break;
            }
            i ++;
        }
        
        NSString *m = arr[1];
        int j = 0;
        for (NSString *item in _monthList) {
            if ([m isEqualToString:item]) {
                _curRow1 = j;
                break;
            }
            j++;
        }
    } else {
        _curRow0 = 0;
        _curRow1 = 0;
    }
    _yearStr = _yearList[_curRow0];
    _monthStr = _monthList[_curRow1];
}

- (void)createView {

    UIButton *bgBtn = [self btnFrame:CGRectMake(0, 0, self.w_, self.h_) sel:@selector(clickCanlceBtn)];
    bgBtn.backgroundColor = self.backgroundColor;
    [self addSubview:bgBtn];
    
    self.contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(0, self.h_ - SelDateViewH, self.w_, SelDateViewH);
    _contentView.backgroundColor = LTWhiteColor;
    [self addSubview:_contentView];
    
    CGRect f = CGRectMake(0, SelDateViewTabH, ScreenW_Lit, SelDateViewPickerViewH);
    self.pickerView = [[UIPickerView alloc] initWithFrame:f];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = LTWhiteColor;
    _pickerView.showsSelectionIndicator = YES;
    [_contentView addSubview:_pickerView];

    [_pickerView selectRow:_curRow0 inComponent:0 animated:YES];
    [_pickerView selectRow:_curRow1 inComponent:1 animated:YES];
    
    
    
    UIView *bar = [[UIView alloc] init];
    bar.frame = CGRectMake(0, _pickerView.y_-SelDateViewTabH, ScreenW_Lit, SelDateViewTabH);
    bar.backgroundColor = LTLineColor;
    [_contentView addSubview:bar];
    
    CGFloat btnW = 70;
    UIButton *canlceBtn = [self btnFrame:CGRectMake(0, 0, btnW, SelDateViewTabH) sel:@selector(clickCanlceBtn)];
    [canlceBtn setTitle:@"取消" forState:UIControlStateNormal];
    [bar addSubview:canlceBtn];
    
    UIButton *sureBtn = [self btnFrame:CGRectMake(ScreenW_Lit-btnW, 0, btnW, SelDateViewTabH) sel:@selector(clickSureBtn)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bar addSubview:sureBtn];

    
    self.hidden = YES;
}

#pragma mark - action


- (void)clickCanlceBtn {
    [self showView:NO];
    _selDateViewShowBlock ? _selDateViewShowBlock(NO) : nil;
}

- (void)clickSureBtn {
    [self showView:NO];
    _selDateViewShowBlock ? _selDateViewShowBlock(NO) : nil;
    
    NSString *ym = [NSString stringWithFormat:@"%@-%@",_yearStr,_monthStr];
    _selDateBlock ? _selDateBlock(ym) : nil;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return _yearList.count;
    }
    return _monthList.count;
}

#pragma mark - UIPickerViewDelegate


//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        NSString *y = _yearList[row];
        return y;
    }
    NSString *m = _monthList[row];
    return m;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _curRow0 = row;
        NSString *y = _yearList[row];
        self.yearStr = y;
    } else {
        _curRow1 = row;
        NSString *m = _monthList[row];
        self.monthStr = m;
    }
    [self.pickerView reloadAllComponents];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *lab = [[UILabel alloc] init];
    lab.textAlignment = NSTextAlignmentCenter;
    if (component == 0) {
        lab.text = _yearList[row];
        lab.textColor = (row == _curRow0) ? LTSureFontBlue : LTBlackColor;
    } else {
        lab.text = _monthList[row];
        lab.textColor = (row == _curRow1) ? LTSureFontBlue : LTBlackColor;
    }
    return lab;
}

//设置组件的宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return labW;
}

#pragma mark  - utils

- (UIButton *)btnFrame:(CGRect)r sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = r;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:LTSureFontBlue forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontOfSize:15.f];
    [self addSubview:btn];
    return btn;
}


#pragma mark 动画显示隐藏

static CGFloat animateDuration = 0.3;
- (void)showView:(BOOL)show {
    WS(ws);
    if (show) {
        NFCPost_FloatingPlayHide;
        [self.superview bringSubviewToFront:self];
        self.alpha = 0.3;
        [self changeContentViewUp:NO];
        self.hidden = NO;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:animateDuration animations:^{
            ws.alpha = 1;
            [ws changeContentViewUp:YES];
        } completion:^(BOOL finished) {
            ws.userInteractionEnabled = YES;
        }];
        
    } else {
        NFCPost_FloatingPlayShow;
        self.alpha = 1;
        self.userInteractionEnabled = NO;
        [self changeContentViewUp:YES];
        [UIView animateWithDuration:animateDuration animations:^{
            ws.alpha = 0.3;
            [ws changeContentViewUp:NO];
        } completion:^(BOOL finished) {
            ws.userInteractionEnabled = YES;
            ws.hidden = YES;
        }];
    }
    
}

- (void)changeContentViewUp:(BOOL)bl {
    
    if (bl) {
        _contentView.frame = CGRectMake(0, self.h_ - SelDateViewH, self.w_, SelDateViewH);
    } else {
        _contentView.frame = CGRectMake(0, self.h_, self.w_, SelDateViewH);
    }
}



@end
