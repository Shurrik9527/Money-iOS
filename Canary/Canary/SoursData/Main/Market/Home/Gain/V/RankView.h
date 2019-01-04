//
//  RankView.h
//  ixit
//
//  Created by litong on 2016/11/21.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GainModel.h"
#import "RankIV.h"

#define RankViewW 90
#define RankViewH1 130.5
#define RankViewH23 120


static NSString *NFC_ClickRankView = @"NFC_ClickRankView";

/** 盈利列表 前3名Cell中 徽章图片&昵称&盈利&奖励券 */
@interface RankView : UIView

- (instancetype)initWithFrame:(CGRect)frame rankIdx:(NSInteger)rankIdx;
- (void)refData:(GainModel *)mo;


@end
