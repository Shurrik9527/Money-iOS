//
//  BaseVCtrl.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavBarView.h"
#import "TabBarView.h"
#import "LTResponse.h"

@interface BaseVCtrl : UIViewController

@property (nonatomic, strong) UIView *stateView;
@property (nonatomic, strong) NavBarView *header; // 导航视图
@property (nonatomic, strong) TabBarView *footer; // 底部导航视图
@property (nonatomic,assign) BackType backType;

@property (nonatomic, assign) BOOL hadLoadData;


#pragma mark - 初始化
//中间文字
- (void)navTitle:(NSString *)title;
//pop返回按钮 & 中间文字
- (void)navPopBackTitle:(NSString *)title;
//backType返回按钮 & 中间文字
- (void)navTitle:(NSString *)title backType:(BackType)backType;

//backType返回按钮 & 中间文字 & 右按钮文字
- (void)navTitle:(NSString *)title backType:(BackType)backType rightTitle:(NSString *)title;

//backType返回按钮 & 中间文字 & 右按钮图片
- (void)navTitle:(NSString *)title backType:(BackType)backType rightImgName:(NSString *)rightImgName;

//backType返回按钮 & 中间文字 & 右按钮图片
- (void)navTitle:(NSString *)title backType:(BackType)backType rightImgName:(NSString *)rightImgName  rightSelImgName:(NSString *)rightSelImgName;

- (void)showRightBtn:(BOOL)bl;
- (void)rightItemSelect:(BOOL)sel;
- (void)rightItemFrame:(CGRect)frame;

- (void)addLeftImageBtn:(NSString *)imageName;


#pragma mark - action
-(void)initAction;
//点击左按钮时调用，默认返回前一页，子类可重载
- (void)leftAction;
//点击右按钮时调用，空方法，仅供子类重载
- (void)rightAction;

- (void)themeChanged;



#pragma mark - 显示空数据数据view
- (void)showEmptySubView:(UIView *)view;
- (void)showEmptySubView:(UIView *)view title:(NSString *)title;
- (void)hideEmptyView;
- (void)showEmptyView;
- (void)showEmptyView:(NSString *)title;
- (void)loadData;



#pragma mark - 验证用户是否实名认证
- (BOOL)checkRealNameCert;
#pragma mark - token验证

- (BOOL)checkTimeOut;
- (BOOL)checkTimeOut:(void (^)())success failure:(void (^)())failure;
- (BOOL)checkTimeOut:(void (^)())alertSure alertCancel:(void (^)())alertCancel success:(void (^)())success failure:(void (^)())failure;

#pragma mark - 处理token_timeout

- (void)handleTokenTimeout:(LTResponse *)res;

- (void)handleTokenTimeout:(LTResponse *)res success:(void (^)())success failure:(void (^)())failure;

- (void)handleTokenTimeout:(LTResponse *)res alertSure:(void (^)())alertSure alertCancel:(void (^)())alertCancel success:(void (^)())success failure:(void (^)())failure;

#pragma mark - 输入密码弹框
//重新输入密码
- (void)alertInputPWD;
//重新输入密码
- (void)alertInputPWD:(void (^)())success failure:(void (^)())failure;

//重新输入密码
- (void)alertInputPWD:(void (^)())alertSure alertCancel:(void (^)())alertCancel success:(void (^)())success failure:(void (^)())failure;

#pragma mark - findNav
- (BaseVCtrl *)findBaseVC;

#pragma mark - 关闭键盘
- (void)shutKeyboard;

@end
