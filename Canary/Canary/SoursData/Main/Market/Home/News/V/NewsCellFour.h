//
//  NewsCellFour.h
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsBaseCell.h"
#import "ChanceModel.h"
/** 首页新闻 - 交易机会（专家解读） */
@interface NewsCellFour : NewsBaseCell
/** 交易机会数据模型*/
@property (nonatomic, strong) ChanceModel * chanceModel;

@end
