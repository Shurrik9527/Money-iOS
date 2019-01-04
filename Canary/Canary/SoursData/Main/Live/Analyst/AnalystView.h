//
//  AnalystView.h
//  ixit
//
//  Created by litong on 2017/3/30.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalystMO.h"
#import "LiveMO.h"


#define kAnalystViewH  LTAutoW(186.5)

@interface AnalystView : UIView

- (instancetype)initWithFrame:(CGRect)frame darkBg:(BOOL)darkBg;
- (void)configViewWithLiveMO:(LiveMO *)liveMO;
- (void)configViewWithAnalystMO:(AnalystMO *)analystMO;
+ (UIColor *)darkBgColor:(BOOL)darkBg;

@end
