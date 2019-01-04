//
//  FloatingPlayView.h
//  ixit
//
//  Created by litong on 2017/3/7.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveModel.h"



#define  FloatingPlayViewW  (336/2)
#define  FloatingPlayViewH   (190/2)
#define  FloatingPlayBtmTemp   (13)

//视频悬浮窗口

@protocol FloatingPlayViewDelegate <NSObject>

//- (void)pressPlayView;
- (void)pushLiveDetailVC;

@end


@interface FloatingPlayView : UIView

@property (nonatomic,assign) id <FloatingPlayViewDelegate> delegate;

- (void)showed:(BOOL)bl;
//播放or暂停
- (void)play:(BOOL)bl;
//全屏播放
- (void)playerFullScreen:(BOOL)fullScreen;

@end
