//
//  CBSegmentView.m
//  CBSegment
//
//  Created by minrui on 2017/9/9.
//  Copyright © 2017年 com.bingo.com. All rights reserved.
//

#import "CBSegmentView.h"

@interface CBSegmentView ()

//分段高度
@property (nonatomic, assign) CGFloat HeaderH;
//滚动条
@property (nonatomic, weak) UIView *slider;
//缓存按钮宽度
@property (nonatomic, strong) NSMutableArray *titleWidthArray;
//当前选中btn
@property (nonatomic, weak) UIButton *selectedBtn;
//btn默认字体颜色
@property (nonatomic, strong) UIColor *titleColor;
//btn选中字体颜色
@property (nonatomic, strong) UIColor *titleSelectedColor;
//btn字体大小
@property (nonatomic, assign) CGFloat titleFont;
//记录上个btn的tag值
@property (nonatomic, assign) NSInteger olderTag;

@end

#define CBColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define CBScreenH [UIScreen mainScreen].bounds.size.height
#define CBScreenW [UIScreen mainScreen].bounds.size.width

@implementation CBSegmentView

#pragma mark - delayLoading
- (NSMutableArray *)titleWidthArray {
    if (!_titleWidthArray) {
        _titleWidthArray = [NSMutableArray new];
    }
    return _titleWidthArray;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.layer.borderColor = CBColorA(227,227,227,1).CGColor;
        self.layer.borderWidth = 0.5;
    
        self.HeaderH = frame.size.height;
        self.titleColor = CBColorA(153,153,153,1);
        self.titleSelectedColor = CBColorA(0,160,233,1);
        self.titleFont = 15;
    }
    return self;
}

#pragma mark - 传入数据
- (void)setTitleArray:(NSArray<NSString *> *)titleArray{
    [self setTitleArray:titleArray titleFont:0 titleColor:nil titleSelectedColor:nil];
}

#pragma mark - UI处理
- (void)setTitleArray:(NSArray<NSString *> *)titleArray
            titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor {
    
    if (font != 0) {
        self.titleFont = font;
    }
    if (titleColor) {
        self.titleColor = titleColor;
    }
    if (selectedColor) {
        self.titleSelectedColor = selectedColor;
    }
    
    UIView *slider = [[UIView alloc]init];
    slider.frame = CGRectMake(0, self.HeaderH-2, 0, 2);
    slider.backgroundColor = self.titleSelectedColor;
    [self addSubview:slider];
    self.slider = slider;
    
    [self.titleWidthArray removeAllObjects];
    //宽度
    CGFloat totalWidth = 15;
    //间距
    CGFloat btnSpace = 15;
    for (NSInteger i = 0; i<titleArray.count; i++) {
//        cache title width
        CGFloat titleWidth = [self widthOfTitle:titleArray[i] titleFont:self.titleFont];
        [self.titleWidthArray addObject:[NSNumber numberWithFloat:titleWidth]];
//        creat button
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        CGFloat btnW = titleWidth+20;
        btn.frame =  CGRectMake(totalWidth, 0.5, btnW, self.HeaderH-0.5-2);
        btn.contentMode = UIViewContentModeCenter;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.tag = i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.titleColor forState:UIControlStateNormal];
        [btn setTitleColor:self.titleSelectedColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:self.titleFont]];
        [btn addTarget:self action:@selector(titleButtonSelected:) forControlEvents:UIControlEventTouchUpInside];
        totalWidth = totalWidth+btnW+btnSpace;

        if (i == 0) {
            btn.selected = YES;
            self.selectedBtn = btn;
            self.slider.cb_Width = titleWidth;
            self.slider.cb_CenterX = btn.cb_CenterX;
            self.olderTag = 0;
        }
    }
    totalWidth = totalWidth+btnSpace;
    //可滚动区域
    self.contentSize = CGSizeMake(totalWidth, 0);
}

#pragma mark - 按钮点击事件

- (void)titleButtonSelected:(UIButton *)btn {
    
    if (btn.tag != self.olderTag) {
    //记录上个btn tag值
    self.olderTag = btn.tag;
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    
    NSNumber* sliderWidth = self.titleWidthArray[btn.tag];
    [UIView animateWithDuration:0.2 animations:^{
        self.slider.cb_Width = sliderWidth.floatValue;
        self.slider.cb_CenterX = btn.cb_CenterX;
    }];
    
    self.selectedBtn = btn;
    CGFloat offsetX = btn.cb_CenterX - self.frame.size.width*0.5;
    if (offsetX<0) {
        offsetX = 0;
    }
    
    if (offsetX>self.contentSize.width-self.frame.size.width) {
        
        if (btn.cb_CenterX+btn.cb_Width -self.frame.size.width <= 0) {
            offsetX = 0;
        }else {
            offsetX = self.contentSize.width-self.frame.size.width;
        }
    }
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    if (self.titleChooseReturn) {
        self.titleChooseReturn(btn.tag);
    }
  }
}

#pragma - mark 外部访问内部
- (void)choseTitle:(NSUInteger)bntIndex {
    
    self.selectedBtn.selected =NO;
    UIButton *btn =[self viewWithTag:bntIndex];
    if (btn) {
        btn.selected = YES;
        self.selectedBtn = btn;
        self.slider.cb_Width = btn.cb_Width;
        self.slider.cb_CenterX = btn.cb_CenterX;
    }
    
    CGFloat offsetX = btn.cb_CenterX - self.frame.size.width*0.5;
    
    if (offsetX<0) {
        offsetX = 0;
    }
    
    if (offsetX>self.contentSize.width-self.frame.size.width) {
        
        if (btn.cb_CenterX -self.frame.size.width <= 0) {
            offsetX = 0;
        }else {
            offsetX = self.contentSize.width-self.frame.size.width;
        }
    }
    [self setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

#pragma mark - 缓存title宽度
- (CGFloat)widthOfTitle:(NSString *)title titleFont:(CGFloat)titleFont {
    CGSize titleSize = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, self.HeaderH-2)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:titleFont] forKey:NSFontAttributeName]
                                            context:nil].size;
    return titleSize.width;
}



@end

@implementation UIView (CBViewFrame)

- (void)setCb_Width:(CGFloat)cb_Width {
    CGRect frame = self.frame;
    frame.size.width = cb_Width;
    self.frame = frame;
}

- (CGFloat)cb_Width {
    return self.frame.size.width;
}

- (void)setCb_Height:(CGFloat)cb_Height {
    CGRect frame = self.frame;
    frame.size.height = cb_Height;
    self.frame = frame;
}

- (CGFloat)cb_Height {
    return self.frame.size.height;
}

- (void)setCb_CenterX:(CGFloat)cb_CenterX {
    CGPoint center = self.center;
    center.x = cb_CenterX;
    self.center = center;
}

- (CGFloat)cb_CenterX {
    return self.center.x;
}

- (void)setCb_CenterY:(CGFloat)cb_CenterY {
    CGPoint center = self.center;
    center.y = cb_CenterY;
    self.center = center;
}

- (CGFloat)cb_CenterY {
    return self.center.y;
}
@end
