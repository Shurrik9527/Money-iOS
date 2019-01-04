//
//  WarningView.h
//  Canary
//
//  Created by litong on 2017/6/8.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IN_OutOfContract_Buy   @"Icon_OutOfContract_Buy"      //图片:合约到期 ,建仓
#define IN_OutOfContract_Sell   @"Icon_OutOfContract_Sell"      //图片:合约到期 ,持仓
#define IN_OutOfStock               @"Icon_OutOfStock"      //图片:即将爆仓

@interface WarningView : UIView

@property (nonatomic,strong) NSString *content;//提示文字
@property (nonatomic,strong) NSString *imgName;//提示图片

- (instancetype)initWithY:(CGFloat)y;

+ (WarningView *)orangeView:(CGFloat)y;
+ (WarningView *)pinkView:(CGFloat)y;

@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) UIColor *bgColor;

@end
