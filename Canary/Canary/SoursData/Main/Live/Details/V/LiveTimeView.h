//
//  LiveTimeView.h
//  ixit
//
//  Created by litong on 2016/12/29.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveTimeCell.h"

/** 视频时间列表 */
@interface LiveTimeView : UIView

@property (nonatomic,strong) NSArray *list;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)showView:(BOOL)show;

@end
