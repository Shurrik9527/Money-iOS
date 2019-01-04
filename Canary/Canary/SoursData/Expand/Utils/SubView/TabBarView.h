//
//  TabBarView.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TabBarType) {
    TabBarType_Home = 0,
    TabBarType_Market = 1,
    TabBarType_Deal = 2,
//    TabBarType_Live = 3,
//    TabBarType_Mine = 4,
    TabBarType_Mine = 3,
};

@interface TabBarView : UIView

//是否中部凸出
@property(assign,nonatomic)BOOL isCenterBulge;
@property(assign,nonatomic)NSInteger centerTag;
@property (nonatomic,weak) id superController;

#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles Icons:(NSArray*)icons target:(id)superController;

#pragma mark 按钮接口
- (UIButton*)buttonWithIndex:(int)index;

#pragma mark 高亮当前按钮文字颜色
- (void)changeTextColorWithCurrentIndex:(int)index;
#pragma mark - 重新绘制中间按钮
- (void)reloadWithCenterBtn;

// 添加红点
- (void)addRedIconWithIndex:(int)index;
- (void)removeRedIconWithIndex:(int)index;

@end
