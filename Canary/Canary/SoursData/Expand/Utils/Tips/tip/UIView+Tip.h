//
//  UIView+Tip.h
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tip)

- (void)showSuccessWithTitle:(NSString *)msg;

- (void)showTip:(NSString *)tip afterHide:(NSInteger)afterHide;
- (void)showTip:(NSString *)tip;
- (void)hideTip;




@end
