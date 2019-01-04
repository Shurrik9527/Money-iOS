//
//  SGShakeLable.h
//  LTDevDemo
//
//  Created by litong on 2017/3/28.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SGShakeLableTextColor         LTColorHex(0xF5DF23)
#define SGShakeLableBorderColor     LTColorHex(0x5F210A)

@interface SGShakeLable : UILabel

// 动画时间
@property (nonatomic,assign) NSTimeInterval duration;
// 描边颜色
@property (nonatomic,strong) UIColor *borderColor;

- (void)startAnimWithDuration:(NSTimeInterval)duration;

@end
