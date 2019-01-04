//
//  NewsPercentView.m
//  ixit
//
//  Created by litong on 2016/11/11.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "NewsPercentView.h"

@interface NewsPercentView ()
{
    CGFloat viewW;
}
@property (nonatomic,strong) UIImageView *upView;

@end

@implementation NewsPercentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        viewW = frame.size.width;
        [self createView];
    }
    return self;
}

- (void)createView {
    self.image = [UIImage imageNamed:@"newsGreenBg"];
    
    self.upView = [[UIImageView alloc] init];
    _upView.image = [[UIImage imageNamed:@"newsRedBg"] stretchLeftCap:1 topCap:1];
    [self addSubview:_upView];
    [self setUpValue:0];
}


- (void)setUpValue:(CGFloat)up {
    CGFloat w = up*viewW;
    _upView.frame = CGRectMake(0, 0, w, self.h_);
}


@end
