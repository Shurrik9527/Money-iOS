//
//  LabelTextFiled.h
//  Canary
//
//  Created by Brain on 2017/5/25.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^TextEditAction)(void);

@interface LabelTextFiled : UIView
@property(assign,nonatomic)CGFloat minLabW;
@property(strong,nonatomic)UITextField * textField;
@property (nonatomic,copy) TextEditAction edit;

-(instancetype)initWithFrame:(CGRect)frame leftTxt:(NSString *)leftTxt;
@end
