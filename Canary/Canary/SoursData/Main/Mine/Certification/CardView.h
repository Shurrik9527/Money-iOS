//
//  CardView.h
//  Canary
//
//  Created by Brain on 2017/5/23.
//  Copyright © 2017年 litong. All rights reserved.
//  身份证正反面view

#import <UIKit/UIKit.h>
typedef void(^ClickAction)(void);

@interface CardView : UIView
@property(strong,nonatomic)UIImageView *photoImg;
@property (nonatomic,copy) ClickAction choosePhoto;

-(instancetype)initWithFrame:(CGRect)frame isFront:(BOOL)isFront;
-(void)configStatus:(BOOL)isSuccess image:(UIImage *)image;
@end
