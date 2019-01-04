//
//  FieldView.h
//  Canary
//
//  Created by litong on 2017/5/25.
//  Copyright © 2017年 litong. All rights reserved.
//
//  输入框

#import <UIKit/UIKit.h>


@interface FieldView : UIView

@property (nonatomic,strong) UITextField *field;
@property (nonatomic,copy) NSString *saveFieldKey;

- (void)openEye:(BOOL)open;
- (void)showEyeImge:(BOOL)show;
- (void)showError:(BOOL)isError;
- (void)configPlaceholder:(NSString *)holder;
- (void)addToolsBar;//键盘上方添加 完成


@end
