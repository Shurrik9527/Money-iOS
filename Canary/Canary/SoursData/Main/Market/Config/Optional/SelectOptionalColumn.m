//
//  SelectOptionalColumn.m
//  golden_iphone
//
//  Created by dangfm on 15/7/1.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "SelectOptionalColumn.h"

@interface SelectOptionalColumn(){
    CGPoint _point;
    CGPoint _point2;
    BOOL _isMove;
    BOOL _isTouch;
    int _startIndex,_endIndex;
    SelectOptionalColumn *_moveView;
    NSMutableArray *_datas;
    SelectMoveDirection _moveDirectioin;
    CGFloat _touchTime;
    NSString *titleStr;
}

@end

@implementation SelectOptionalColumn

-(instancetype)initWithFrame:(CGRect)frame Datas:(NSMutableArray*)datas{
    if (self==[super initWithFrame:frame]) {
        self.layer.cornerRadius = 3;
        self.layer.borderColor = LTSubTitleRGB.CGColor;
        self.layer.borderWidth = 0.5;
        self.multipleTouchEnabled = YES;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
        _isTouch = NO;
        _isTouchMove = YES;
        _datas = datas;
        [self createViews];
    }
    return self;
}

-(void)createViews
{
    if (!_titleLb)
    {
        _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _titleLb.adjustsFontSizeToFitWidth = YES;
        _titleLb.font = fontSiz(midFontSize);
        _titleLb.textColor=LTSubTitleRGB;
        _titleLb.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLb];
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _isTouch = YES;
    _isMove = NO;
    titleStr=_titleLb.text;
    [self clickSelf];
    _touchTime = [NSDate curMS];
    UITouch * touch = [touches anyObject];
    UIView *superView = self.superview;
    _point = [touch locationInView:superView];
    _point2 = [touch locationInView:superView];
    // 得到所按视图下标和父视图的下标
    _startIndex = (int)[superView.subviews indexOfObject:self];
    _endIndex = (int)superView.subviews.count-1;
    NSLog(@"touchesBegan：%d,%d",_startIndex,_endIndex);
    if (_isTouchMove)
    {
        NSLog(@"createMoveView");

        [self performSelector:@selector(createMoveView) withObject:nil afterDelay:0.5];
    }
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesCancelled");
    [self clear];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesEnded");
    [self clear];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesMoved");
    _isMove = YES;
    if (_moveView && _isTouchMove)
    {
        UITouch * touch = [touches anyObject];
        UIView *superView = self.superview;
        CGPoint p2 = [touch locationInView:superView];
        CGFloat moveX = _moveView.frame.origin.x + p2.x-_point2.x;
        CGFloat moveY = _moveView.frame.origin.y+p2.y-_point2.y;
        if ((p2.x-_point2.x)>=0)
        {
            _moveDirectioin = select_moveRight;
        }
        else
        {
            _moveDirectioin = select_moveLeft;
        }
        _point2 = p2;
        // 移动替身
        _moveView.frame = CGRectMake(moveX, moveY, _moveView.frame.size.width, _moveView.frame.size.height);
        // 主子移动
        //self.frame = CGRectMake(moveX, moveY, _moveView.frame.size.width, _moveView.frame.size.height);
        
        // 移动的时候获取移动到哪个下标下
        int index = [self indexForPoint:CGPointMake(moveX, moveY) SuperView:superView];
        if (index!=_startIndex) {
            _startIndex = index;
            [self moveWithFirst:index EndIndex:_endIndex];
        }
    }
}

-(void)clear
{
    _isTouch = NO;
    _touchTime = [NSDate curMS]-_touchTime;
    NSLog(@"%f",_touchTime);
    // 清除替身
    [_moveView removeFromSuperview];
    _moveView = nil;
    
    if (self.touchActionBlock && !_isMove && _touchTime<=2) {
        self.touchActionBlock(self);
    }
    if (self.touchMoveEndBlock && _isMove && _isTouchMove) {
        self.touchMoveEndBlock(self);
    }
    if (!_isMove) {
        self.titleLb.text=titleStr;
    }
    _isMove = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = LTBgColor;
    } completion:^(BOOL finished){
        
    }];
}

-(void)clickSelf
{
}

#pragma mark 通过坐标转换为子视图下标
-(int)indexForPoint:(CGPoint)p SuperView:(UIView*)superView{
    
    int count = (int)superView.subviews.count-1;
    int index = -1;
    CGFloat x = p.x+self.frame.size.width/2;
    CGFloat y = p.y+self.frame.size.height/2;

    for (int i=0; i<count; i++) {
        SelectOptionalColumn *s = [superView.subviews objectAtIndex:i];
        CGFloat sx = s.frame.origin.x;
        CGFloat sy = s.frame.origin.y;
        CGFloat sw = s.frame.size.width;
        CGFloat sh = s.frame.size.height;
        if (x>=sx && x<=sx+sw && y>=sy && y<=sy+sh && s.tag!=self.tag) {
            index = i;
        }
    }
    return index;
}

-(void)moveWithFirst:(int)startIndex EndIndex:(int)endIndex{
    
    if (startIndex<0) {
        return;
    }
    CGPoint tempP;
    BOOL left = YES;
    // 左右移动方向算法
    if (startIndex<self.tag) {
        endIndex = (int)self.tag-1;
        left = YES;
    }
    if (startIndex>self.tag) {
        endIndex = startIndex;
        startIndex = (int)self.tag+1;
        left = NO;
    }
    if (left) {
        // 占位
        tempP = [self pointWithIndex:startIndex];
        self.frame = CGRectMake(tempP.x, tempP.y, self.frame.size.width, self.frame.size.height);
        // 插入
        NSObject *obj = [_datas objectAtIndex:self.tag];
        [_datas removeObjectAtIndex:self.tag];
        [_datas insertObject:obj atIndex:startIndex];
        
        [self.superview insertSubview:self atIndex:startIndex];
    }else{
        // 占位
        tempP = [self pointWithIndex:endIndex];
        self.frame = CGRectMake(tempP.x, tempP.y, self.frame.size.width, self.frame.size.height);
        // 插入
        NSObject *obj = [_datas objectAtIndex:self.tag];
        [_datas removeObjectAtIndex:self.tag];
        [_datas insertObject:obj atIndex:endIndex];
        
        [self.superview insertSubview:self atIndex:endIndex];
    }
    int i=0;
    for (SelectOptionalColumn *s in self.superview.subviews) {
        
        if (i>_datas.count-1) {
            if (s!=self && s!=_moveView)
            [s removeFromSuperview];
            break;
        }
        tempP = [self pointWithIndex:i];
        s.tag = i;
        //NSLog(@"tag=%ld text=%@",(long)s.tag,s.titleLb.text);
        if (i>=startIndex-1 && i<=endIndex+1) {
            if (s!=self && s!=_moveView) {
                [UIView animateWithDuration:0.3 animations:^{
                    s.frame = CGRectMake(tempP.x, tempP.y, kSelectOptionColumn_Width, kSelectOptionColumn_height);
                }];
            }else{
                //s.frame = CGRectMake(tempP.x, tempP.y, kSelectOptionColumn_Width, kSelectOptionColumn_height);
            }
        }
        
        i++;
    }
 
    
}

-(void)createMoveView{
    if (!_moveView && _isTouch) {
        _moveView = [[SelectOptionalColumn alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height) Datas:_datas];
        _moveView.titleLb.text = self.titleLb.text;
        _moveView.tag = 10010;
        _moveView.titleLb.textColor = [UIColor whiteColor];
        _moveView.layer.borderColor = BlueFont.CGColor;
        _moveView.layer.backgroundColor = BlueFont.CGColor;
        [self.superview addSubview:_moveView];
        [self.superview bringSubviewToFront:_moveView];
        self.titleLb.text = @"";
        self.layer.borderWidth = 0;
        [self setImage:[self createSelectImage] forState:UIControlStateNormal];
        
        self.backgroundColor = LTClearColor;
        [UIView animateWithDuration:0.3 animations:^{
            _moveView.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-15, self.frame.size.width, self.frame.size.height);
        }];
        
    }
}
#pragma mark 子视图下标转换成对应坐标
-(CGPoint)pointWithIndex:(int)index{
    CGFloat y = floor((index)/kSelectOptionColumn_vertical) * (kSelectOptionColumn_height+kSelectOptionColumn_padding)+15;
    if (index<4) {
        y = 15;
    }
    CGFloat x = (index) % kSelectOptionColumn_vertical * (kSelectOptionColumn_Width+kSelectOptionColumn_padding)+kSelectOptionColumn_padding;
    if (index<=0) {
        x = kSelectOptionColumn_padding;
    }
    
    CGPoint p = CGPointMake(x, y);
    return p;
}

-(UIImage*)createSelectImage{
    //NSLog(@"draw start.....");
    CGRect rect = CGRectMake(0, 0, kSelectOptionColumn_Width, kSelectOptionColumn_height);
    //UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 画一个虚线的view
    CGFloat dashPattern[]= {3.0, 2};
    //CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetStrokeColorWithColor(context, BlueFont.CGColor);
    // And draw with a blue fill color
    CGContextSetRGBFillColor(context, 0.0, 0.0, 1.0, 0.0);
    // Draw them with a 2.0 stroke width so they are a bit more visible.
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineDash(context, 0.0, dashPattern, 2);
    
    CGContextAddRect(context, rect);
    
    CGContextStrokePath(context);
    
    // Close the path
    CGContextClosePath(context);
    // Fill & stroke the path
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
