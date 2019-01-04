//
//  FundCell.h
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kFundCellH  45

@interface FundCell : UITableViewCell

- (void)bindData:(NSString *)title;
- (void)changeDetails:(NSString *)detail;

@end
