//
//  UIImageView+LTPlaceholder.h
//  ixit
//
//  Created by litong on 2017/1/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (LTPlaceholder)

//生成 view.size大小 的默认图片
- (UIImage *)placeholderDefaultImage;
- (UIImage *)placeholderDefaultImage:(UIColor *)bgColor;

@end
