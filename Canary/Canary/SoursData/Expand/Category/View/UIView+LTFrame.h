//
//  UIView+LTFrame.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

// View 坐标(x,y)和宽高(width,height)
#define LTX(v)                (v).frame.origin.x
#define LTY(v)                (v).frame.origin.y
#define LTW(v)                (v).frame.size.width
#define LTH(v)                (v).frame.size.height

#define LTMinX(v)            CGRectGetMinX((v).frame) // 获得控件屏幕的x坐标
#define LTMinY(v)            CGRectGetMinY((v).frame) // 获得控件屏幕的Y坐标

#define LTMidX(v)            CGRectGetMidX((v).frame) //横坐标加上到控件中点坐标
#define LTMidY(v)            CGRectGetMidY((v).frame) //纵坐标加上到控件中点坐标

#define LTMaxX(v)            CGRectGetMaxX((v).frame) //横坐标加上控件的宽度
#define LTMaxY(v)            CGRectGetMaxY((v).frame) //纵坐标加上控件的高度


@interface UIView (LTFrame)


@property(nonatomic,readonly)CGFloat x_;
@property(nonatomic,readonly)CGFloat y_;
@property(nonatomic,readonly)CGFloat w_;
@property(nonatomic,readonly)CGFloat h_;

@property(nonatomic,readonly)CGFloat xw_;        //x+width
@property(nonatomic,readonly)CGFloat yh_;         //y+heiht


#pragma mark - 设置Frame、Center

- (void)setOrigin:(CGPoint)origin;
- (void)setSize:(CGSize)size;

- (void)setOX:(CGFloat)x;
- (void)setOY:(CGFloat)y;
- (void)setSW:(CGFloat)w;
- (void)setSH:(CGFloat)h;

- (void)setCenterX:(CGFloat)x;
- (void)setCenterY:(CGFloat)y;

//self.centerX=view.centerX
- (void)centerXSameToView:(UIView *)view;
- (void)centerYSameToView:(UIView *)view;

#pragma mark - 获取当前View的ViewController

- (UIViewController *)findViewController;

#pragma mark - 移除view上所有子view

- (void)removeAllSubView;
- (void)removeAllSubViewWithClass:(Class)cls;


#pragma mark - 坐标转换

//当前view中心点 转换成相对于aView坐标系下的CGPoint
- (CGPoint)centerConvertToView:(UIView *)aView;
//当前view 转换成相对于aView坐标系下的CGRect
- (CGRect)rectConvertToView:(UIView *)aView;



@end




