//
//  GainDetailView.h
//  ixit
//
//  Created by litong on 2016/11/23.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyGainModel.h"

#define GainDetailViewH 187

/**     买涨  吉银1000g 1手
        建仓价格    平仓价格
        建仓时间    平仓时间
        平仓类型
 盈利详情
 */
@interface GainDetailView : UIView

- (void)refData:(MyGainModel *)mo;

@end
