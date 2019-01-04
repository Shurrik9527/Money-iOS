//
//  popMoreView.h
//  ixit
//
//  Created by Brain on 2017/2/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface popMoreView : UIView
//点击cell触发事件
@property (nonatomic, copy) void (^clickExchangeCell)(NSInteger index);

-(void)showPop;
-(void)hiddenPop;

@end
