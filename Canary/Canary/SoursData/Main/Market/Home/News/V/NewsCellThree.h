//
//  NewsCellThree.h
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsBaseCell.h"
#import "SupportView.h"
#import "CountDownView.h"

/** 首页新闻 - 行情预演（带日历） */
@interface NewsCellThree : NewsBaseCell

- (void)bindData:(NewsModel *)model indexPath:(NSIndexPath *)indexPath;
- (void)refCell:(NewsModel *)mo;

@end
