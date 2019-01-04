//
//  NameField.h
//  Canary
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameField : UIView
@property (nonatomic,strong) UITextField *field;
@property (nonatomic,copy) NSString *saveFieldKey;

- (void)openEye:(BOOL)open;
- (void)showEyeImge:(BOOL)show;
- (void)showError:(BOOL)isError;
- (void)configPlaceholder:(NSString *)holder;
- (void)addToolsBar;//键盘上方添加 完成
@end
