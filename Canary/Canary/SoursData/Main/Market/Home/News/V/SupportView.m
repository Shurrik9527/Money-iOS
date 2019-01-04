//
//  SupportView.m
//  ixit
//
//  Created by litong on 2016/11/11.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "SupportView.h"
#import "LitTipsView.h"

@interface SupportView ()
{
    BOOL canClick;
}
@property (nonatomic,strong) NewsModel *mo;
@property (nonatomic,strong) NSIndexPath *iPath;
@property (nonatomic,strong) UIButton *upBtn;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *subLab;
@property (nonatomic,strong) UILabel *lab;

@end

@implementation SupportView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        canClick = YES;
        [self createView];
    }
    return self;
}

- (void)createView {
    [self addSingeTap:@selector(clickUpBtn) target:self];
    
    CGFloat btnWH = LTAutoW(SupportViewH);
    self.upBtn = [UIButton btnWithTarget:self action:@selector(clickUpBtn) frame:CGRectMake(LTAutoW(20.f), 0, btnWH, btnWH)];
//    [_upBtn setBackgroundImage:[UIImage imageNamed:@"supportSelectedBg"] forState:UIControlStateSelected];
//    _upBtn.selected = NO;
    [self addSubview:_upBtn];
    
    self.lab = [[UILabel alloc] init];
    _lab.frame = CGRectMake(_upBtn.xw_ + LTAutoW(kLeftMar), 0, LTAutoW(50.f), LTAutoW(16.f));
    _lab.font = [UIFont autoFontSize:12.f];
    _lab.textColor = kNewsGrayColor;
    _lab.text = @"支持";
    [self addSubview:_lab];
    
    self.titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(_lab.x_, _lab.yh_, LTAutoW(43.f), LTAutoW(20.f));
    _titleLab.font = [UIFont autoFontSize:15.f];
    [self addSubview:_titleLab];
    
    self.subLab = [[UILabel alloc] init];
    _subLab.frame = CGRectMake(_titleLab.xw_, _lab.yh_, LTAutoW(60.f), LTAutoW(20.f));
    _subLab.font = [UIFont autoFontSize:20.f];
    [self addSubview:_subLab];
}

- (void)clickUpBtn {
    if (canClick) {
        NSDictionary *dict = @{
                               @"type":@(_supportType),
                               @"obj":_mo,
                               @"iPath":_iPath
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:NFC_SupportNewsCell object:dict];
    } else {
        [LitTipsView showTips:@"不能重复点击..." afterHide:2];
    }
}

- (void)setSubLabText:(NewsModel *)mo {
    NSString *str = (_supportType == SupportType_more) ? [mo moreStr] : [mo lessStr]  ;
    _subLab.text = str;
}

- (void)animationBegin {
    UIColor *color = LTKLineGreen;
    if (_supportType == SupportType_more) {
        color = LTKLineRed;
    }
    CGFloat labW = LTAutoW(18);
    CGFloat labH = LTAutoW(15);
    CGFloat labX = _upBtn.center.x - labW*0.5;
    CGFloat labY = _upBtn.y_ - labH;
    UILabel *lab = [[UILabel alloc] init];
    lab.text = @"+1";
    lab.textColor = color;
    lab.font = autoFontSiz(15);
    lab.textAlignment = NSTextAlignmentCenter;
    lab.frame = CGRectMake(labX, labY, labW, labH);
    [self addSubview:lab];
    
    CGFloat labY_End = labY - 10;
    __weak UILabel *wLab = lab;
    [UIView animateWithDuration:0.3 animations:^{
        wLab.frame = CGRectMake(labX, labY_End, labW, labH);
    } completion:^(BOOL finished) {
        [wLab removeFromSuperview];
    }];
}


- (void)changeUI:(NewsModel *)mo animation:(BOOL)animation {
    
    NSInteger cType = [mo.clickType integerValue];
    if (cType > 0) {
        canClick = NO;
        
        if (_supportType == SupportType_more) {
            if (cType == SupportType_more) {
                [self setUpBtnImgName:@"supportMoreBg_sel"];
                if (animation) {
                    [self animationBegin];
                }
            } else {
                [self setUpBtnImgName:@"supportSelectedBg"];
            }
        } else {
            if (cType == SupportType_less) {
                if (animation) {
                    [self animationBegin];
                }
                [self setUpBtnImgName:@"supportLessBg_sel"];
            } else {
                [self setUpBtnImgName:@"supportSelectedBg"];
            }
        }

    } else {
        canClick = YES;
        
        NSString *iName = @"supportLessBg";
        if (_supportType == SupportType_more) {
            iName = @"supportMoreBg";
        }
        [self setUpBtnImgName:iName];
        
    }
}


- (void)setUpBtnImgName:(NSString *)imgName {
    [_upBtn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
}


#pragma mark - 外部

- (void)setSupportType:(SupportType)supportType {
    _supportType = supportType;
    
    NSString *iName = @"supportLessBg";
    UIColor *color = LTKLineGreen;
    NSString *str = @"利空";
    if (_supportType == SupportType_more) {
        iName = @"supportMoreBg";
        color = LTKLineRed;
        str = @"利多";
    }
    
    [self setUpBtnImgName:iName];
    
    _titleLab.textColor = color;
    _titleLab.text = str;
    
    _subLab.textColor = color;
}

- (void)refData:(NewsModel *)mo indexPath:(NSIndexPath *)indexPath {
    _mo = mo;
    _iPath = indexPath;
    
    [self setSubLabText:mo];
    
    [self changeUI:mo animation:NO];
    
}


//点击利多利空后 刷新UI
- (void)refView:(NewsModel *)mo {
    [self changeUI:mo animation:YES];
    [self setSubLabText:mo];
}




@end
