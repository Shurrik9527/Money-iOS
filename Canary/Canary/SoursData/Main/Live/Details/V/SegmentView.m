//
//  SegmentView.m
//  ixit
//
//  Created by litong on 16/10/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "SegmentView.h"


static CGFloat lineW = 48;

@interface SegmentView ()
{
    
    CGFloat btnW;
}
/** 移动线
 颜色CGSizeMake(12, 3)
 */
@property (nonatomic,strong) UIView *moveLine;


@end

@implementation SegmentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _curIdx = 0;
        self.backgroundColor = LTColorHex(0xFFFFFF);
    }
    return self;
}



#pragma mark - action

- (void)moveLine:(NSInteger)idx {
    WS(ws);
    
    CGFloat x = btnW * (idx + 0.5) - lineW/2.0;
    
    [UIView animateWithDuration:0.25 animations:^{
        ws.moveLine.frame =CGRectMake(x, self.h_ - 3, lineW, 3);
    }];

}

- (void)clickBtn:(UIButton *)sender {
    NSInteger idx = sender.tag % kBtnTag;
    
    if (idx == _curIdx) {
        return;
    }
    
    [self moveToIdx:idx];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectIdx:)]) {
        [_delegate selectIdx:idx];
    }
}



#pragma mark - init

- (void)createMoveLine {
    self.moveLine = [[UIView alloc] init] ;
    self.moveLine.backgroundColor = LTSureFontBlue;
    [self addSubview:self.moveLine];
}


#pragma mark - 外部方法

- (void)moveToIdx:(NSInteger)idx {
    
    if (idx == _curIdx) {
        return;
    }
    
    NSInteger oldIdx = _curIdx ;
    _curIdx = idx;
    
    UIButton *oldBtn = [self viewWithTag:(oldIdx+kBtnTag)];
    oldBtn.selected = NO;
    UIButton *curBtn = [self viewWithTag:(_curIdx+kBtnTag)];
    curBtn.selected = YES;
    
    [self moveLine:idx];
}

- (void)setTitles:(NSArray *)titles {
    
    NSInteger count = titles.count;
    btnW = self.w_ / count*1.0;

    NSInteger i = 0;
    for (NSString *str in titles) {
        NSLog(@"str= %@",str);
        CGRect frame = CGRectMake(i*btnW, 0, btnW, self.h_);
        UIButton *btn = [UIButton btnWithTarget:self action:@selector(clickBtn:) frame:frame];
        btn.backgroundColor = self.backgroundColor;
        btn.tag = kBtnTag + i;
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btn setTitleColor:LTSubTitleColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self addSubview:btn];

        if (i == 0) {
            btn.selected = YES;
        }
        
        i++;
    }

    [self createMoveLine];
    [self moveLine:0];

}



@end
