//
//  UIView+LTLayer.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIView+LTLayer.h"

@implementation UIView (LTLayer)

#pragma mark - layer

- (void)borderColor:(UIColor *)color width:(CGFloat)width {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.masksToBounds = YES;
}


- (void)circleViwe {
    float r = self.frame.size.width / 2;
    self.layer.cornerRadius = r;
    self.layer.masksToBounds = YES;
}

- (void)layerRadius:(CGFloat)r bgColor:(UIColor *)color {
    self.layer.cornerRadius = r;
    self.layer.backgroundColor = color.CGColor;
    self.layer.masksToBounds = YES;
}

- (void)layerRadius:(CGFloat)r borderColor:(UIColor *)boColor borderWidth:(CGFloat)width {
    self.layer.cornerRadius = r;
    self.layer.borderWidth = width;
    self.layer.borderColor = boColor.CGColor;
    self.layer.masksToBounds = YES;
}

- (void)layerRadius:(CGFloat)r borderColor:(UIColor *)boColor borderWidth:(CGFloat)width bgColor:(UIColor *)bgColor {
    self.layer.cornerRadius = r;
    self.layer.backgroundColor = bgColor.CGColor;
    self.layer.borderWidth = width;
    self.layer.borderColor = boColor.CGColor;
    self.layer.masksToBounds = YES;
}


- (void)layerShadowOffset:(CGSize)size color:(UIColor *)color opacity:(CGFloat)opacity radius:(CGFloat)radius {
    self.layer.shadowOffset = size;//默认 (0, -3)
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOpacity = opacity;//阴影透明度，默认0
    self.layer.shadowRadius = radius;//阴影半径，默认3
}

#pragma mark - 设置部分圆角
/** 设置部分圆角(绝对布局) */
- (void)layerRadius:(CGFloat)r corners:(UIRectCorner)corners {
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(r, r)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

/** 设置部分圆角(相对布局) */
- (void)layerRadius:(CGFloat)r corners:(UIRectCorner)corners rect:(CGRect)rect {
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(r, r)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

- (void)layerRadius:(CGFloat)r corners:(UIRectCorner)corners rect:(CGRect)rect strokeColor:(UIColor *)strokeColor lineWidth:(CGFloat)lineWidth {
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(r, r)];
    
    CAShapeLayer* shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = path.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = strokeColor.CGColor;
    borderLayer.lineWidth = lineWidth;
    borderLayer.frame = self.bounds;
    [self.layer addSublayer:borderLayer];
    
}

- (void)layerRadius:(CGFloat)r corners:(UIRectCorner)corners rect:(CGRect)rect borderColor:(UIColor *)borderColor borderWidth:(CGFloat)width shadowOffset:(CGSize)size shadowColor:(UIColor *)shadowColor {
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(r, r)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    shape.borderWidth = width;
    shape.borderColor = borderColor.CGColor;
    
    shape.shadowOffset = size;
    shape.shadowColor = shadowColor.CGColor;
    
    self.layer.mask = shape;
}


@end
