//
//  OutcryCell.h
//  ixit
//
//  Created by litong on 16/11/5.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutcryModel.h"


/** 喊单cell */
@interface OutcryCell : UITableViewCell

- (void)bindData:(OutcryModel *)model begin:(BOOL)begin;

+ (CGFloat)cellHWithMo:(OutcryModel *)mo;

@end
