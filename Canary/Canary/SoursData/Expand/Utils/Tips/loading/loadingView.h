//
//  loadingView.h
//  21cbh_iphone
//
//  Created by 21tech on 14-3-13.
//  Copyright (c) 2014年 ZX. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kD_FinishedImg [UIImage imageNamed:@"alert_savephoto_success.png"]
#define kD_ErrorImg [UIImage imageNamed:@"alert_tanhao.png"]
#define kLoading_width 200
#define kLoading_height 40
@interface loadingView : UIView
@property (nonatomic,retain) NSString *title;
-(id)initWithTitle:(NSString*)title Frame:(CGRect)frame;
-(id)initWithTitle:(NSString*)title Frame:(CGRect)frame IsFullScreen:(BOOL)fullScreen;
-(void)start;
-(void)stop;
-(void)setSelfTitle:(NSString*)title isSuccess:(BOOL)success andSecond:(int)second;
-(void)setError:(NSString*)title;
@end
