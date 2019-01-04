//
//  PopTableView.h
//  ixit
//
//  Created by Brain on 2017/2/15.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopTableView : UIView
@property (nonatomic, copy) void (^clickCell)(NSInteger cellRow);
@property(strong,nonatomic)NSMutableArray * titles;//标题
@property(strong,nonatomic)NSMutableArray * icons;//图标
@property(assign,nonatomic)NSInteger count;
@property(copy,nonatomic)NSString * excode;
@property(copy,nonatomic)NSString * code;

//设置默认的值
-(void)setDefaultMorePop;
//设置三角形定点位置
-(void)setTriangleCenterX:(CGFloat)x;
-(void)showPop;
-(void)hiddenPop;
@end
