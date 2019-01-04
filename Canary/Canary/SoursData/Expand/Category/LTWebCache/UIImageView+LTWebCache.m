//
//  UIImageView+LTWebCache.m
//  ixit
//
//  Created by litong on 2017/1/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "UIImageView+LTWebCache.h"
#import "UIImageView+LTPlaceholder.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (LTWebCache)

+ (NSURL *)realUrl:(id)url {
    if ([url isKindOfClass:[NSString class]]) {
        return [url toURL];
    }
    return url;
}

#pragma mark - 自动添加placeholder

- (NSURL *)lt_imageURL {
    return [self sd_imageURL];
}

- (void)lt_setImageWithURL:(id)url {
    NSURL *kurl = [UIImageView realUrl:url];
    [self sd_setImageWithURL:kurl];
}

- (void)lt_setImageWithURL:(id)url placeholderImage:(UIImage *)placeholder {
    NSURL *kurl = [UIImageView realUrl:url];
    if (placeholder) {
        [self sd_setImageWithURL:kurl placeholderImage:placeholder];
    } else {
        [self sd_setImageWithURL:kurl placeholderImage:self.placeholderDefaultImage];
    }
}
    
- (void)lt_setImageWithURL:(id)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    NSURL *kurl = [UIImageView realUrl:url];
    if (placeholder) {
        [self sd_setImageWithURL:kurl placeholderImage:placeholder options:options];
    } else {
        [self sd_setImageWithURL:kurl placeholderImage:self.placeholderDefaultImage options:options];
    }
}

- (void)lt_setImageWithURL:(id)url completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIImageView realUrl:url];
    [self sd_setImageWithURL:kurl completed:completedBlock];
}

- (void)lt_setImageWithURL:(id)url placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIImageView realUrl:url];
    if (placeholder) {
        [self sd_setImageWithURL:kurl placeholderImage:placeholder completed:completedBlock];
    } else {
        [self sd_setImageWithURL:kurl placeholderImage:self.placeholderDefaultImage completed:completedBlock];
    }
}
    
- (void)lt_setImageWithURL:(id)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIImageView realUrl:url];
    if (placeholder) {
        [self sd_setImageWithURL:kurl placeholderImage:placeholder options:options completed:completedBlock];
    } else {
        [self sd_setImageWithURL:kurl placeholderImage:self.placeholderDefaultImage options:options completed:completedBlock];
    }
}
    
- (void)lt_setImageWithURL:(id)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIImageView realUrl:url];
    if (placeholder) {
        [self sd_setImageWithURL:kurl placeholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
    } else {
        [self sd_setImageWithURL:kurl placeholderImage:self.placeholderDefaultImage options:options progress:progressBlock completed:completedBlock];
    }
}

- (void)lt_setImageWithPreviousCachedImageWithURL:(id)url andPlaceholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIImageView realUrl:url];
    if (placeholder) {
        [self sd_setImageWithPreviousCachedImageWithURL:kurl andPlaceholderImage:placeholder options:options progress:progressBlock completed:completedBlock];
    } else {
        [self sd_setImageWithPreviousCachedImageWithURL:kurl andPlaceholderImage:self.placeholderDefaultImage options:options progress:progressBlock completed:completedBlock];
    }
}

- (void)lt_setAnimationImagesWithURLs:(NSArray *)arrayOfURLs {
    [self sd_setAnimationImagesWithURLs:arrayOfURLs];
}
- (void)lt_cancelCurrentImageLoad {
    [self sd_cancelCurrentImageLoad];
}
- (void)lt_cancelCurrentAnimationImagesLoad {
    [self sd_cancelCurrentAnimationImagesLoad];
}

@end
