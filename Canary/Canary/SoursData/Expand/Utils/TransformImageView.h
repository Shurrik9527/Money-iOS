//
//  TransformImageView.h
//  FMStock
//
//  Created by dangfm on 15/5/5.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransformImageView;
typedef void (^transformActionBlock)(TransformImageView *transformView);

@interface TransformImageView : UIButton
{
    CGFloat angle; // 旋转角度
    BOOL isStop;
    NSTimer *time ;// 时间
}

@property (nonatomic,copy) transformActionBlock clickActionBlock; // 点击图片回调

-(void)start;
-(void)stop;

@end

