//
//  UIImageView+LTWebCache.h
//  ixit
//
//  Created by litong on 2017/1/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

/**
 (id)url:可以传入NSURL、NSString
 */
@interface UIImageView (LTWebCache)

#pragma mark - 自动添加placeholder
- (NSURL *)lt_imageURL;
- (void)lt_setImageWithURL:(id)url;
- (void)lt_setImageWithURL:(id)url placeholderImage:(UIImage *)placeholder;
- (void)lt_setImageWithURL:(id)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options;
- (void)lt_setImageWithURL:(id)url completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_setImageWithURL:(id)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_setImageWithURL:(id)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_setImageWithURL:(id)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_setImageWithPreviousCachedImageWithURL:(id)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;
- (void)lt_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs;
- (void)lt_cancelCurrentImageLoad;
- (void)lt_cancelCurrentAnimationImagesLoad;
@end
