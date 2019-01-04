//
//  NavBarView.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BackType) {
    BackType_Non = 0,//无返回
    BackType_PopVC = 1,
    BackType_Dismiss = 2,
    BackType_PopToRoot = 3,
};

@interface NavBarView : UIView

@property (nonatomic,strong) UILabel *titler;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,weak) id superController;
@property (nonatomic,strong) UIView *bottomline;

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title isBack:(BOOL)isback target:(id)superController;

#pragma mark 背景变化
- (void)changeViewBackgroundColor;
- (void)changeBgImage;

@end
