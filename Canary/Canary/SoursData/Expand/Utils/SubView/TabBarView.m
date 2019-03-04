//
//  TabBarView.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "TabBarView.h"

#define kFooterFontSize 14
#define kFooterSmallFontSize 10

@interface TabBarView () {
    NSInteger lastSelectIndex;
    UIButton *centerBtn;
    CGFloat vw;
    CGFloat vh;
}

@property(strong,nonatomic)NSMutableArray *btnArray;
@property (nonatomic,strong) UIImageView *maskIV;

@end

@implementation TabBarView

- (void)clickTabButtonAction:(UIButton *)button {
    // 子类中重写该方法
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles Icons:(NSArray *)icons target:(id)superController {
    if (self = [super initWithFrame:frame]) {
        // 导航栏栏目
        CGFloat x = 0;
        vw = frame.size.width / titles.count;
        vh = frame.size.height - kBottomBarHeight;
        UIView *line=[[UIView alloc]init];
        line.frame=CGRectMake(0, 0, Screen_width,0.5);
        line.backgroundColor=LTLineColor;
        [self addSubview:line];
        
#if useNewYearTheme
        _maskIV = [[UIImageView alloc] init];
        _maskIV.userInteractionEnabled = YES;
        _maskIV.backgroundColor = TabBarMaskCoror;
        [self addSubview:_maskIV];
#else
#endif
        
        _btnArray=[[NSMutableArray alloc]init];
        for (int i = 0; i < titles.count; i++) {
            NSString *iconName = [icons objectAtIndex:i];
#if useNewYearTheme
            UIImage *_img = [UIImage imageNamed:iconName];
            NSString *imageTag = [iconName substringWithRange:NSMakeRange(3, 1)];
#else
            UIImage *_img = [UIImage imageNamed:iconName];
            NSString *imageTag = [iconName substringWithRange:NSMakeRange(0, 1)];
#endif
            
            
            UIButton *_bt = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, vw, vh)];
            
            // 图标
            UIImageView *_imgView = [[UIImageView alloc] initWithImage:_img];
            //使用文件名的数字 做标记
            if ([LTUtils isPureInt:imageTag]) {
                _imgView.tag = [imageTag integerValue];
            } else {
                _imgView.tag = -1;
            }
            
            _imgView.frame = CGRectMake((vw - _img.size.width) / 2, 17, _img.size.width, _img.size.height);
            
            // 文字
            UILabel *_l = [[UILabel alloc]
                           initWithFrame:CGRectMake(0, self.h_-17-kBottomBarHeight, _bt.w_, 17)];
            [_l setText:[titles objectAtIndex:i]];
            _l.font = [UIFont systemFontOfSize:11];
            _l.textAlignment = NSTextAlignmentCenter;
            _l.textColor = TabBarSelCoror;
            _l.tag=100;
            [_bt addSubview:_l];
            _l = nil;
            [_bt setImage:_img forState:UIControlStateNormal];
            [_bt setImage:_img forState:UIControlStateHighlighted];
            [_bt setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 0)];
            _bt.tag = i;
            [_bt addTarget:superController
                    action:@selector(clickTabButtonAction:)
          forControlEvents:UIControlEventTouchUpInside];
            x += vw;
            [self addSubview:_bt];
            [_btnArray addObject:_bt];
        }
    }
    
    [self changeTextColorWithCurrentIndex:0];
    
    return self;
}

#pragma mark 按钮外接口
- (UIButton *)buttonWithIndex:(int)index {
    NSArray *views = _btnArray;
    id bt = [views objectAtIndex:index];
    if (bt && [[bt class] isSubclassOfClass:[UIButton class]]) {
        return (UIButton *) bt;
    }
    return nil;
}

#pragma mark 高亮当前按钮文字颜色

- (void)changeTextColorWithCurrentIndex:(int)index {
    NSArray *views = _btnArray;
    for (int j = 0; j < views.count; j++) {
        UIButton *bt = [views objectAtIndex:j];
        NSArray *subviews = [bt subviews];
        if (bt && [[bt class] isSubclassOfClass:[UIButton class]]) {
            for (int i = 0; i < subviews.count; i++) {
                UILabel *lb = [subviews objectAtIndex:i];
                if (lb && [[lb class] isSubclassOfClass:[UILabel class]]) {
                    if (j == index) {
                        lb.textColor = TabBarSelCoror;
                    } else
                        lb.textColor = TabBarNorCoror;
                }
            }
        }
    }
    
    UIButton *lastSelectBt = [views objectAtIndex:lastSelectIndex];
    NSString *lastSelectImagName = [NSString stringWithFormat:@"%zd-%d", lastSelectIndex, 0];
    UIImage *lastSelectImag = [UIImage imageNamed:lastSelectImagName];
    [lastSelectBt setImage:lastSelectImag forState:UIControlStateNormal];
    
    UIButton *selectBt = [views objectAtIndex:index];
    NSString *imageStr = [NSString stringWithFormat:@"%zd-%d", index, 1];
    UIImage *norImg = [UIImage imageNamed:imageStr];
    [selectBt setImage:norImg forState:UIControlStateNormal];
    [selectBt setImage:norImg forState:UIControlStateHighlighted];
    [self removeRedIconWithIndex:index];
    lastSelectIndex = index;
    
//#if useNewYearTheme
//    
//    _centerTag=_btnArray.count/2;
//    centerBtn =[self viewWithTag:_centerTag];
//    UIImage *img = nil;
//    if (index == 2) {
//        img = [UIImage imageNamed:@"NY_2-1"];
//        _maskIV.frame = CGRectMake(vw*index, 0, vw, vh);
//        //        _maskIV.hidden = YES;
//    } else {
//        img = [UIImage imageNamed:@"NY_2-0"];
//        _maskIV.frame = CGRectMake(vw*index, 0, vw, vh);
//        _maskIV.hidden = NO;
//    }
//    [centerBtn setImage:img forState:UIControlStateNormal];
//    
//#else
//    
//    NSInteger count =  views.count;
//    
//    UIButton *lastSelectBt = [views objectAtIndex:lastSelectIndex];
//    NSString *lastSelectImag;
//    
//    if(count == 4 &&
//       (lastSelectIndex ==(count-1) ||
//        lastSelectIndex ==(count-2))) {
//           
//        lastSelectImag = [NSString stringWithFormat:@"%zd-%d", lastSelectIndex+1, 0];
//    } else {
//        lastSelectImag = [NSString stringWithFormat:@"%zd-%d", lastSelectIndex, 0];
//    }
//    
//    UIImage *norImg = [UIImage imageNamed:lastSelectImag];
//    [lastSelectBt setImage:norImg forState:UIControlStateNormal];
//    
//    UIButton *selectBt = [views objectAtIndex:index];
//    NSString *imageStr;
//    if(count == 4 && (index ==(count-1) || index ==(count-2))) {
//        imageStr = [NSString stringWithFormat:@"%zd-%d", index+1, 1];
//    } else {
//        imageStr = [NSString stringWithFormat:@"%zd-%d", index, 1];
//    }
//    
//    UIImage *img = [UIImage imageNamed:imageStr];
//    
//    [selectBt setImage:img forState:UIControlStateNormal];
//    [selectBt setImage:img forState:UIControlStateHighlighted];
//#endif
//    [self removeRedIconWithIndex:index];
//    lastSelectIndex = index;
}

- (void)removeRedIconWithIndex:(int)index {
    UIButton *bt = [self buttonWithIndex:index];
    UIImageView *redImageView = [bt viewWithTag:1200 + index];
    if (redImageView) {
        [redImageView removeFromSuperview];
    }
}

- (void)addRedIconWithIndex:(int)index {
    UIButton *meBt = [self buttonWithIndex:index];
    UIImage *redImage = [UIImage imageNamed:@"Red"];
    [self removeRedIconWithIndex:index];
    UIImageView *redImageView = [[UIImageView alloc] initWithImage:redImage];
    [meBt addSubview:redImageView];
    redImageView.tag = 1200 + index;
    [redImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-20));
        make.top.equalTo(@10);
        make.width.height.equalTo(@6);
    }];
}
- (void)reloadWithCenterBtn {
    if (_isCenterBulge) {
        
        _centerTag=_btnArray.count/2;
        centerBtn =[self viewWithTag:_centerTag];
        centerBtn.frame=CGRectMake(centerBtn.x_, -18, centerBtn.w_, self.h_+18);
        [centerBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 12, 0)];
        
        CGFloat labH = 17;
        UILabel *_l =[centerBtn viewWithTag:100];
        _l.frame=CGRectMake(0, centerBtn.h_ - labH, centerBtn.w_, labH);
    }
    else {
        _centerTag=_btnArray.count/2;
    }
}

//重写hitTest方法，去监听发布按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //这一个判断是关键，不判断的话push到其他页面，点击发布按钮的位置也是会有反应的，这样就不好了
    //self.isHidden == NO 说明当前页面是有tabbar的，那么肯定是在导航控制器的根控制器页面
    //在导航控制器根控制器页面，那么我们就需要判断手指点击的位置是否在发布按钮身上
    //是的话让发布按钮自己处理点击事件，不是的话让系统去处理点击事件就可以了
    if (self.isHidden == NO) {
        if (!_isCenterBulge) {
            return [super hitTest:point withEvent:event];
        }
        //将当前tabbar的触摸点转换坐标系，转换到发布按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:centerBtn];
        
        //判断如果这个新的点是在发布按钮身上，那么处理点击事件最合适的view就是发布按钮
        if ( [centerBtn pointInside:newP withEvent:event]) {
            return centerBtn;
        }
        else {
            //如果点不在发布按钮身上，直接让系统处理就可以了
            return [super hitTest:point withEvent:event];
        }
    }
    else {//tabbar隐藏了，那么说明已经push到其他的页面了，这个时候还是让系统去判断最合适的view处理就好了
        return [super hitTest:point withEvent:event];
    }
}

@end
