//
//  KLineOtherIndexView.h
//  FMStock
//
//  Created by dangfm on 15/5/24.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KLineOtherIndexView;
typedef void (^ClickSelectButtonsBlock)(NSString* code);
@interface KLineOtherIndexView : UIView
@property (nonatomic,copy) ClickSelectButtonsBlock clickSelectButtonsBlock;
-(instancetype)initWithFrame:(CGRect)frame SuperView:(UIView*)superview Data:(NSArray*)data;
-(void)show;
-(void)hide;
@end
