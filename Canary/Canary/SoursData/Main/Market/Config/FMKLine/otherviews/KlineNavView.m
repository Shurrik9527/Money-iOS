//
//  KlineNavView.m
//  FMStock
//
//  Created by dangfm on 15/5/3.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "KlineNavView.h"

@interface KlineNavView(){
    UIScrollView *_box;
    UIView *_line;
    BOOL _isH;
    BOOL _isUpdate;
}


@end

@implementation KlineNavView

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.isFinish = YES;
        [self initView];
    }
    return self;
}

-(void)updateViews:(CGRect)frame{
//    [_box removeFromSuperview];
//    [_line removeFromSuperview];
//    _box = nil;
//    _line = nil;
    self.frame = frame;
    _isH = NO;
//    _isUpdate = YES;
//    if (frame.size.width>320) {
//        _isH = YES;
//    }
    [self initView];
}

-(void)initView{
    
    self.backgroundColor =KlineNavViewBG;
    //    NSArray *titles = @[@"分时",@"太极线",@"八卦线",@"日线",@"15分",@"5分",@"30分",@"1小时",@"4小时",@"周线"];
//    _types = @[@"",@"shock",@"trend",@"day",@"min5",@"min15",@"min30",@"min60",@"hr4",@"week"];
    NSArray *titles = @[@"分时",@"日线",@"5分",@"15分",@"30分",@"1小时",@"4小时",@"周线"];
    _types = @[@"",@"day",@"min5",@"min15",@"min30",@"min60",@"hr4",@"week"];

    if (!_box) {
        _box = [[UIScrollView alloc] initWithFrame:CGRectMake(self.frame.origin.x, 0, self.frame.size.width-self.frame.origin.x, kLineChart_nav_height)];
        _box.backgroundColor=KlineNavViewBG;
        
        _box.bounces = NO;
        _box.showsHorizontalScrollIndicator = NO;
        [self.contentView addSubview:_box];
    }
    else
    {
        _box.frame=CGRectMake(self.frame.origin.x, 0, self.frame.size.width-self.frame.origin.x, kLineChart_nav_height);
    }
    UIFont *font = fontSiz(kLineChart_nav_fontSize);
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = [[titles firstObject] sizeWithFont:font].width;
    CGFloat h = kLineChart_nav_height;
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, h-3, w, 3)];
        _line.backgroundColor = BlueLineColor;
        _line.tag = 1000;
        if (!_isH) {
            [_box addSubview:_line];
        }
    }
    
    if (_box.subviews.count<=2)
    {
        CGFloat padding = 20;
        CGFloat boxWidth = 0;
        for (int i=0;i<titles.count;i++)
        {
            if(i>0) x = x + w;
            NSString *str = [titles objectAtIndex:i];
            UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
            bt.backgroundColor = LTClearColor;
            [bt setTitle:str forState:UIControlStateNormal];
            [bt setTitleColor:TabBarNorCoror forState:UIControlStateNormal];
            
            bt.titleLabel.font = font;
            bt.tag = i;
            [bt addTarget:self action:@selector(clickButtons:) forControlEvents:UIControlEventTouchUpInside];
            [_box addSubview:bt];
            CGFloat titleWidth = [str sizeWithFont:font].width;
            bt.frame = CGRectMake(x, y, titleWidth+padding, h);
            w = bt.frame.size.width;
            boxWidth = x + w;
            //点击选取品种
            if (i==0 && !_isUpdate)
            {
                [self clickButtons:bt];
            }
            if (i==titles.count-1 && !_isH)
            {
            }
            bt = nil;
        }
        _box.contentSize = CGSizeMake(boxWidth, h);
    }
}

-(void)updateViews{
    NSArray *views = [_box subviews];
    for (UIButton *item in views) {
        if ([[item class] isSubclassOfClass:[UIButton class]]) {
            [item setTitleColor:TabBarNorCoror forState:UIControlStateNormal];
//            item.backgroundColor = LTClearColor;
        }
    }
}

-(void)updateHighlightsButtonsWithType:(NSString*)type{
    [self updateViews];
    NSInteger index = [_types indexOfObject:type];
    if (!_isH) {
        index ++;
    }
    if (index>=0 && index<=_types.count) {
        UIButton *bt = (UIButton*)[_box.subviews objectAtIndex:index];
        if (_isH) {
//            bt.backgroundColor = LTClearColor;
            [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [bt setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
            bt.backgroundColor = LTClearColor;
            [UIView animateWithDuration:0.2 animations:^{
                _line.frame = CGRectMake(bt.frame.origin.x, _line.frame.origin.y, bt.frame.size.width, _line.frame.size.height);
            }];
        }
        // 修正
        [self repairScrollContentWithTag:bt.tag];
        bt = nil;
    }
}
-(void)updateOtherButtonText:(NSString*)str{
    UIButton *bt = (UIButton*)[_box.subviews lastObject];
    [bt setTitle:str forState:UIControlStateNormal];
    
    bt = nil;
}

-(void)clickButtons:(UIButton*)bt{
    if (self.isFinish) {
        self.isFinish = NO;
        [self updateViews];
        [bt setTitleColor:LTWhiteColor forState:UIControlStateNormal];
        bt.backgroundColor = LTClearColor;
        // 移动
        if (!_isH) {
            [UIView animateWithDuration:0.2 animations:^{
                _line.frame = CGRectMake(bt.frame.origin.x, _line.frame.origin.y, bt.frame.size.width, _line.frame.size.height);
            }];
        }else{
//            bt.backgroundColor = LTClearColor;
            [bt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        
        
        NSString *type = [_types objectAtIndex:bt.tag];
        if (self.clickNavButtonBlock) {
            self.clickNavButtonBlock(self,type);
        }
        
        // 修正
        [self repairScrollContentWithTag:bt.tag];
        
    }
    
}

#pragma mark 观察高亮位置并修复坐标
-(void)repairScrollContentWithTag:(NSInteger)tag{
    NSInteger pre = tag-1;
    if (pre<=0) {
        pre = 0;
    }
    NSInteger next = tag + 1;
    if (next>=_types.count) {
        next = _types.count - 1;
    }
    
    UIButton *button_pre = (UIButton*)[_box viewWithTag:pre];
    UIButton *button_next = (UIButton*)[_box viewWithTag:next];
    
    CGFloat scroll_pre = button_pre.frame.origin.x;
    CGFloat scroll_next = button_next.frame.origin.x;
    // 上一个坐标是否被隐藏
    if (scroll_pre<_box.contentOffset.x) {
        // 移动显示上一个
        [_box setContentOffset:CGPointMake(scroll_pre, 0) animated:YES];
    }
    if (scroll_next+button_next.frame.size.width>_box.contentOffset.x+_box.frame.size.width) {
        // 移动显示下一个
        [_box setContentOffset:CGPointMake(scroll_next-_box.frame.size.width+button_next.frame.size.width, 0) animated:YES];
    }
}

@end
