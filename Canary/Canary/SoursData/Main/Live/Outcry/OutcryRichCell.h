//
//  OutcryRichCell.h
//  ixit
//
//  Created by litong on 2017/3/21.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OutcryModel.h"

/** 喊单富文本格式 cell */
@interface OutcryRichCell : UITableViewCell

- (void)bindData:(OutcryModel *)model;

+ (CGFloat)cellHWithMo:(OutcryModel *)mo;

@end
