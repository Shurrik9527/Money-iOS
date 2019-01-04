//
//  PosinionView.m
//  Canary
//
//  Created by jihaokeji on 2018/5/7.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "PosinionView.h"

@interface PosinionView ()
@property (nonatomic ,strong) UILabel * titleLadel;
@property (nonatomic ,strong) UILabel * parameterLadel;
@end

@implementation PosinionView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        _titleLadel =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, frame.size.width * 0.4, frame.size.height)];
        _titleLadel.font = [UIFont systemFontOfSize:12.0];
        _titleLadel.textColor = LTSubTitleColor;
        [self addSubview:_titleLadel];
        
        _parameterLadel =[[UILabel alloc] initWithFrame:CGRectMake(_titleLadel.frame.size.width + 10, 0, frame.size.width - _titleLadel.frame.size.width - 10, frame.size.height)];
        _parameterLadel.font = [UIFont systemFontOfSize:12.0];
        _parameterLadel.textColor = LTRGBA(42, 101, 234, 1);
        [self addSubview:_parameterLadel];
        
    }
    return self;
}

-(void)setTitleString:(NSString *)titleString{
    _titleLadel.text = titleString;
}

-(void)setParameterString:(NSString *)parameterString{
    _parameterLadel.text = parameterString;
}

@end
