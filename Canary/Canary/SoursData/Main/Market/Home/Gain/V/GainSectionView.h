//
//  GainSectionView.h
//  ixit
//
//  Created by litong on 2016/11/9.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ClickNewComerBtn)();
typedef void(^ClickGainBtn)();

/** 首页新手学堂、盈利榜按钮 */
@interface GainSectionView : UIView

@property (nonatomic,copy) ClickNewComerBtn clickNewComerBtn;
@property (nonatomic,copy) ClickGainBtn clickGainBtn;

- (void)refGainLab:(NSString *)name profitRate:(NSString *)profitRate;

+ (CGFloat)viewH;

@end
