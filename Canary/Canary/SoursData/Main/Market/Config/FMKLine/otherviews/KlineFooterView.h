//
//  KlineFooterView.h
//  FMStock
//
//  Created by dangfm on 15/5/3.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KlineFooterView;
typedef void (^ClickFooterButtonsBlock)(UIButton*bt);

@interface KlineFooterView : UIView

@property(nonatomic,copy) ClickFooterButtonsBlock clickFooterButtonsBlock;

@end
