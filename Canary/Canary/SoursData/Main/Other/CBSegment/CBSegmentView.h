//
//  CBSegmentView.h
//  CBSegment
//
//  Created by minrui on 2017/9/9.
//  Copyright © 2017年 com.bingo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^titleChooseBlock)(NSInteger x);


@interface CBSegmentView : UIScrollView

@property (nonatomic, copy) titleChooseBlock titleChooseReturn;

- (void)setTitleArray:(NSArray<NSString *> *)titleArray;


- (void)setTitleArray:(NSArray<NSString *> *)titleArray
            titleFont:(CGFloat)font
           titleColor:(UIColor *)titleColor
   titleSelectedColor:(UIColor *)selectedColor;

- (void)choseTitle:(NSUInteger)bntIndex;

@end

@interface UIView (CBViewFrame)

@property (nonatomic, assign) CGFloat cb_Width;

@property (nonatomic, assign) CGFloat cb_Height;

@property (nonatomic, assign) CGFloat cb_CenterX;

@property (nonatomic, assign) CGFloat cb_CenterY;

@end
