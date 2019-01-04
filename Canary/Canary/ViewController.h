//
//  ViewController.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarView.h"
#import "BaseVCtrl.h"

@interface ViewController : BaseVCtrl
@property (nonatomic,assign) TabBarType tabBarType;

- (void)selectTabBarType:(TabBarType)type;
- (void)pushReg;

@end

