//
//  PopADView.h
//  ixit
//
//  Created by litong on 2016/11/15.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopADModel.h"

typedef void(^ADImgViewAction)();

@interface PopADView : UIView

@property (nonatomic,copy) ADImgViewAction imgViewAction;

+ (void)showAction:(ADImgViewAction)imgViewAction;
+ (void)shut;

@end
