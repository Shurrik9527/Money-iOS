//
//  UIButton+LTWebCache.h
//  ixit
//
//  Created by litong on 2017/1/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIButton+WebCache.h"

/**
 (id)url:可以传入NSURL、NSString
 
 */
@interface UIButton (LTWebCache)

- (NSURL *)lt_currentImageURL;
- (NSURL *)lt_imageURLForState:(UIControlState)state;
- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state;
- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;
- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state;
- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;
- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_cancelImageLoadForState:(UIControlState)state;
- (void)lt_cancelBackgroundImageLoadForState:(UIControlState)state;


@end
