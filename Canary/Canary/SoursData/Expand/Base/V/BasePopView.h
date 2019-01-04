//
//  BasePopView.h
//  Canary
//
//  Created by litong on 2017/5/26.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasePopView : UIView

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,assign) CGFloat contentViewY;

- (void)configContentH:(CGFloat)h;
- (void)showView:(BOOL)show;

@end
