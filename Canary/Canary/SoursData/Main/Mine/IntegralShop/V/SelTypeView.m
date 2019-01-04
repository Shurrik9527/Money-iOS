//
//  SelTypeView.m
//  ixit
//
//  Created by litong on 2016/12/21.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "SelTypeView.h"

#define SelTypeViewTabH  44
#define SelTypeViewPickerViewH  130
#define SelTypeViewH  174

@interface SelTypeView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    CGFloat labW;
}
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSArray *typeList;
@property (nonatomic,copy) NSString *typeStr;
@property (nonatomic,assign) NSInteger curRow;


@end

@implementation SelTypeView

- (instancetype)initWithFrame:(CGRect)frame selRow:(NSInteger)selRow typeList:(NSArray *)typeList {
    self = [super initWithFrame:frame];
    if (self) {
        labW = self.w_;
        self.typeList = [NSArray arrayWithArray:typeList];
        self.backgroundColor = LTMaskColor;
        self.curRow = selRow;
        if (_curRow > (_typeList.count-1)) {
            self.curRow = 0;
        }
        _typeStr = _typeList[_curRow];
        [self createView];
    }
    return self;
}

- (void)createView {
 
    UIButton *bgBtn = [self btnFrame:CGRectMake(0, 0, self.w_, self.h_) sel:@selector(clickCanlceBtn)];
    bgBtn.backgroundColor = self.backgroundColor;
    [self addSubview:bgBtn];
    
    self.contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(0, self.h_ - SelTypeViewH, self.w_, SelTypeViewH);
    _contentView.backgroundColor = LTWhiteColor;
    [self addSubview:_contentView];
    
    
    CGRect f = CGRectMake(0, SelTypeViewTabH, ScreenW_Lit, SelTypeViewPickerViewH);
    self.pickerView = [[UIPickerView alloc] initWithFrame:f];
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    _pickerView.backgroundColor = LTWhiteColor;
    _pickerView.showsSelectionIndicator = YES;
    [_contentView addSubview:_pickerView];
    [_pickerView selectRow:_curRow inComponent:0 animated:YES];
    
    
    
    UIView *bar = [[UIView alloc] init];
    bar.frame = CGRectMake(0, _pickerView.y_-SelTypeViewTabH, ScreenW_Lit, SelTypeViewTabH);
    bar.backgroundColor = LTLineColor;
    [_contentView addSubview:bar];
    
    CGFloat btnW = 70;
    UIButton *canlceBtn = [self btnFrame:CGRectMake(0, 0, btnW, SelTypeViewTabH) sel:@selector(clickCanlceBtn)];
    [canlceBtn setTitle:@"取消" forState:UIControlStateNormal];
    [bar addSubview:canlceBtn];
    
    UIButton *sureBtn = [self btnFrame:CGRectMake(ScreenW_Lit-btnW, 0, btnW, SelTypeViewTabH) sel:@selector(clickSureBtn)];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bar addSubview:sureBtn];
    
    self.hidden = YES;
}

#pragma mark - action

//- (void)showView:(BOOL)show {
//    self.hidden = !show;
//}

- (void)clickCanlceBtn {
    [self showView:NO];
    _selTypeViewShowBlock ? _selTypeViewShowBlock(NO) : nil;
}

- (void)clickSureBtn {
    [self showView:NO];
    _selTypeViewShowBlock ? _selTypeViewShowBlock(NO) : nil;
    
    NSString *typeStr = _typeStr;
    NSInteger row = _curRow;
    _selTypeBlock ? _selTypeBlock(typeStr,row) : nil;
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _typeList.count;
}

#pragma mark - UIPickerViewDelegate


//设置组件中每行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = _typeList[row];
    return str;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _curRow = row;
    NSString *str = _typeList[row];
    self.typeStr = str;
    
    [self.pickerView reloadAllComponents];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *lab = [[UILabel alloc] init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = _typeList[row];
    lab.textColor = (row == _curRow) ? LTSureFontBlue : LTBlackColor;
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
        _contentView.frame = CGRectMake(0, self.h_ - SelTypeViewH, self.w_, SelTypeViewH);
    } else {
        _contentView.frame = CGRectMake(0, self.h_, self.w_, SelTypeViewH);
    }
}



@end
