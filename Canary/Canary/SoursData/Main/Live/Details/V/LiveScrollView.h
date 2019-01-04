//
//  LiveScrollView.h
//  ixit
//
//  Created by litong on 16/10/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LiveScrollViewDelegate <NSObject>

- (void)scrollTo:(NSInteger)idx;

@end

@interface LiveScrollView : UIScrollView

@property (nonatomic,assign) id<LiveScrollViewDelegate> dgt;

@property (nonatomic,assign) NSInteger pageNum;

- (void)setView:(UIView *)view toIndex:(NSInteger)idx;
- (void)moveToIdx:(NSInteger)idx;

- (void)changeAllFrameH:(CGFloat)h;

@end
