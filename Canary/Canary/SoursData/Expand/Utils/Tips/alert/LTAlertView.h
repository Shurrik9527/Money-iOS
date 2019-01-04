//
//  LTAlertView.h
//  ixit
//
//  Created by litong on 2016/11/30.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, LTAlertType) {
    LTAlertType_Nomal,
    LTAlertType_Image,
    LTAlertType_Field,
};

static CGFloat kLTAlertViewW = 270;//整个view的宽度

typedef void(^LTAlertAction)(void);
typedef void(^LTAlertInputAction)(NSString *inputStr);

@interface LTAlertView : UIView

#pragma mark - 返回弹框
+ (LTAlertView *)tokenFailAlert;

#pragma mark  button 默认 取消 & 确定

+ (void)alertWithMessage:(NSString *)message sureAction:(LTAlertAction)sureAction;
+ (void)alertWithTitle:(NSString *)title sureAction:(LTAlertAction)sureAction;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message sureAction:(LTAlertAction)sureAction cancelAction:(LTAlertAction)cancelAction;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction cancelAction:(LTAlertAction)cancelAction;

#pragma mark  通用
+ (void)alertMessage:(NSString *)message;
+ (void)alertMessage:(NSString *)message sureAction:(LTAlertAction)sureAction;
+ (void)alertMessage:(NSString *)message sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction;

+ (void)alertTitle:(NSString *)title;
+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction;
+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle;

#pragma mark  base

+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction;

#pragma mark  自定义

+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction
        customView:(UIView *)customView;

+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction
  sureBtnTextColor:(UIColor *)sureBtnTextColor cancelBtnTextColor:(UIColor *)cancelBtnTextColor;

+ (void)alertTitle:(NSString *)title message:(NSString *)message
         sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
       cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction
  sureBtnTextColor:(UIColor *)sureBtnTextColor cancelBtnTextColor:(UIColor *)cancelBtnTextColor customView:(UIView *)customView;

#pragma mark - 其他
+ (void)alertSuccessMsg:(NSString *)msg
              sureTitle:(NSString *)sureTitle sureAction:(LTAlertAction)sureAction
            cancelTitle:(NSString *)cTitle cancelAction:(LTAlertAction)cAction;
+ (UIView *)successViewWithMsg:(NSString *)msg;


#pragma mark - Field提示

+ (void)alertFieldMsg:(NSString *)msg sureTitle:(NSString *)sureTitle sureAction:(LTAlertInputAction)sureAction cancelTitle:(NSString *)cancelTitle cancelAction:(LTAlertAction)cancelAction;
//更新提示
+ (void)alertAppUpdate:(NSString *)version content:(NSString *)content;

@end
