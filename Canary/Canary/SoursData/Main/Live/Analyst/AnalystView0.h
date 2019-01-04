//
//  AnalystView0.h
//  ixit
//
//  Created by litong on 2017/3/30.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalystMO.h"
#import "LiveMO.h"


#define kAnalystViewH  LTAutoW(239)

@interface AnalystView0 : UIView

- (void)configViewWithLiveMO:(LiveMO *)liveMO;
- (void)configViewWithAnalystMO:(AnalystMO *)analystMO;

@end
