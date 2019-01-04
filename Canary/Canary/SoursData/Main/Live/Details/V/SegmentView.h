//
//  SegmentView.h
//  ixit
//
//  Created by litong on 16/10/27.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSInteger kBtnTag = 1000;

@class SegmentView;

@protocol SegmentViewDelegate <NSObject>

- (void)selectIdx:(NSInteger)idx;

@end


/** 文字直播、直播室bar切换 */
@interface SegmentView : UIView

@property (nonatomic,assign) id<SegmentViewDelegate> delegate;
@property(assign,nonatomic)NSInteger curIdx;

- (void)setTitles:(NSArray *)titles;
- (void)moveToIdx:(NSInteger)idx;

@end
