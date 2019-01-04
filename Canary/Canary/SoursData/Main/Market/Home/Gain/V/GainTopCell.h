//
//  GainTopCell.h
//  ixit
//
//  Created by litong on 2016/11/20.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankView.h"

#define GainTopCellH       211.f        //满3位 的高度
#define GainTopCellH1       91    //未满3位 的高度

/** 盈利列表 前3名Cell */
@interface GainTopCell : UITableViewCell

- (void)bindData:(NSArray *)mos;

@end
