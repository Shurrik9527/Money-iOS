//
//  PlayView.h
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveModel.h"


@protocol PlayViewDelegate <NSObject>

- (void)pressPlayView;

@end

/** 视频播放 */
@interface PlayView : UIView

@property (nonatomic,assign) id <PlayViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame liveModel:(LiveMO *)liveModel;
- (void)play:(BOOL)bl;

- (void)playerFullScreen:(BOOL)fullScreen;

@end
