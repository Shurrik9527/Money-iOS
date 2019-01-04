//
//  MyGainDetailView.h
//  ixit
//
//  Created by litong on 2016/11/24.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGainModel.h"

#define MyGainDetailViewH 223

/**     买涨  吉银1000g 1手
 建仓价格    平仓价格
 建仓时间    平仓时间
 ...
 
 我的交易记录详情
 */
@interface MyGainDetailView : UIView

- (void)refData:(MyGainModel *)mo;

@end
