//
//  LiveTimeCell.h
//  ixit
//
//  Created by litong on 2016/12/29.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveMO.h"

#define LiveTimeCellW   300
#define LiveTimeCellH   64

/** 视频时间cell */
@interface LiveTimeCell : UITableViewCell

- (void)bindData:(LiveTimeMo *)mo;

@end
