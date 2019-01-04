//
//  UIButton+LT.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^TouchedBlock)(NSInteger tag);

@interface UIButton (LT)

#pragma mark - block
/*!  block 替代 addTarget:self action  UIControlEventTouchUpInside */
- (void)addAction:(TouchedBlock)touchHandler;

#pragma mark - 文字&字体

- (void)setTitleFont:(UIFont *)font;
- (void)setTitleFontSize:(CGFloat)size;

- (void)setNorTitle:(NSString *)title;
- (void)setSelTitle:(NSString *)title;
- (void)setHigTitle:(NSString *)title;


#pragma mark - 设置背景

- (void)setNorBGImageName:(NSString *)name;
- (void)setNorBGImage:(UIImage *)img;

- (void)setHigBGImageName:(NSString *)name;
- (void)setHigBGImage:(UIImage *)img;

- (void)setSelBGImageName:(NSString *)name;
- (void)setSelBGImage:(UIImage *)img;

- (void)setNorImageName:(NSString *)name;
- (void)setNorImage:(UIImage *)img;

- (void)setHigImageName:(NSString *)name;
- (void)setHigImage:(UIImage *)img;

- (void)setSelImageName:(NSString *)name;
- (void)setSelImage:(UIImage *)img;

#pragma mark - 设置背景颜色

- (void)setBgColor:(UIColor *)color forState:(UIControlState)state;
- (void)setHighlightedBgColor:(UIColor *)color;
- (void)setSelectedBgColor:(UIColor *)color;
- (void)setNormalBgColor:(UIColor *)color;


#pragma mark - 获取tableviewCell的NSIndexPath
/** 获取btn 当前的NSIndexPath */
- (NSIndexPath *)getTVCellIndexPath;
- (NSIndexPath *)getTVCellIndexPathAtTV:(UITableView *)tableView;


#pragma mark - 修改点击区域
/** 点击区域 上下左右+edge */
- (void)setEnlargeEdge:(CGFloat)edge;
/** 点击区域 上下左右+top、bottom、left、right */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;


#pragma mark - 其他
/*! 贴纸底部button  图片在上，文字在下 */
+ (UIButton *)creatBottomButtonWithFarme:(CGRect)frame title:(NSString *)title font:(CGFloat)font imageName:(NSString *)imageName;

/*! @brief 按钮倒计时 */
- (void)startTime:(NSInteger )timeout title:(NSString *)tittle waitTittle:(NSString *)waitTittle;


@end
