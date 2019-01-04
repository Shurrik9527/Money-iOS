//
//  LTArcProgressView.h
//  LTDevDemo
//
//  Created by litong on 2017/2/14.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kLTArcProgressBgColor LTColorHexA(0x24273E, 0.9)

typedef NS_ENUM(NSUInteger, ArcProgressType) {
    ArcProgressType_Normal=0,
    ArcProgressType_Notice
};


@interface LTArcProgressView : UIView

@property (nonatomic,strong) UIColor *arcFinishColor;//已完成的颜色
@property (nonatomic,strong) UIColor *arcUnfinishColor;//未完成的颜色

- (void)animateWithTime:(CGFloat)time fromValue:(CGFloat)fvalue toValue:(CGFloat)tvalue;
- (void)changeColor:(UIColor *)color;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
- (id)initWithFrame:(CGRect)frame type:(ArcProgressType)type;//初始化带上line的宽度
@end
