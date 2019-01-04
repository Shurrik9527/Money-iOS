//
//  MineMsgCenterCell.h
//  ixit
//
//  Created by litong on 2017/3/10.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineMsgCenterMO.h"


@interface MineMsgCenterCell : UITableViewCell

- (void)bindData:(MineMsgCenterMO *)mo;
+ (CGFloat)viewH:(MineMsgCenterMO *)mo;

@end
