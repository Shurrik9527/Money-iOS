//
//  WQAnnouncementView.h
//  ixit
//
//  Created by Brain on 16/7/18.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQAnnouncementView : UIView
@property(strong,nonatomic)UIImageView * icon;
@property(copy,nonatomic)NSString * msg;
@property(strong,nonatomic)UILabel * msgLab;
-(instancetype)initWithFrame:(CGRect)frame Message:(NSString *)msg;
-(void)show;
-(void)hide;
@end
