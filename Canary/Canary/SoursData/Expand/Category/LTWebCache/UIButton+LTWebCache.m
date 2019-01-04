//
//  UIButton+LTWebCache.m
//  ixit
//
//  Created by litong on 2017/1/13.
//  Copyright © 2017年 litong. All rights reserved.
//


#import "UIButton+LTWebCache.h"
#import "UIButton+LTPlaceholder.h"
#import "UIButton+WebCache.h"

@implementation UIButton (LTWebCache)

+ (NSURL *)realUrl:(id)url {
    if ([url isKindOfClass:[NSString class]]) {
        return [url toURL];
    }
    return url;
}

#pragma mark - 重写SD

- (NSURL *)lt_currentImageURL {
    return [self sd_currentImageURL];
}

- (NSURL *)lt_imageURLForState:(UIControlState)state {
    return [self sd_imageURLForState:state];
}

- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state {
    NSURL *kurl = [UIButton realUrl:url];
    [self sd_setImageWithURL:kurl forState:state];
}

- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    NSURL *kurl = [UIButton realUrl:url];
    if (placeholder) {
        [self sd_setImageWithURL:kurl forState:state placeholderImage:placeholder];
    } else {
        [self sd_setImageWithURL:kurl forState:state placeholderImage:self.placeholderDefaultImage];
    }
    
}

- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    NSURL *kurl = [UIButton realUrl:url];
    if (placeholder) {
        [self sd_setImageWithURL:kurl forState:state placeholderImage:placeholder options:options];
    } else {
        [self sd_setImageWithURL:kurl forState:state placeholderImage:self.placeholderDefaultImage options:options];
    }
    
}

- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIButton realUrl:url];
    [self sd_setImageWithURL:kurl forState:state completed:completedBlock];
}

- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIButton realUrl:url];
    if (placeholder) {
        [self sd_setImageWithURL:kurl forState:state placeholderImage:placeholder completed:completedBlock];
    } else {
        [self sd_setImageWithURL:kurl forState:state placeholderImage:self.placeholderDefaultImage completed:completedBlock];
    }
    
}

- (void)lt_setImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIButton realUrl:url];
    if (placeholder) {
        [self sd_setImageWithURL:kurl forState:state placeholderImage:placeholder options:options completed:completedBlock];
    } else {
        [self sd_setImageWithURL:kurl forState:state placeholderImage:self.placeholderDefaultImage options:options completed:completedBlock];
    }
    
}

- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state {
    NSURL *kurl = [UIButton realUrl:url];
    [self sd_setBackgroundImageWithURL:kurl forState:state];
}

- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder {
    NSURL *kurl = [UIButton realUrl:url];
    if (placeholder) {
        [self sd_setBackgroundImageWithURL:kurl forState:state placeholderImage:placeholder];
    } else {
        [self sd_setBackgroundImageWithURL:kurl forState:state placeholderImage:self.placeholderDefaultImage];
    }
    
}

- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options {
    NSURL *kurl = [UIButton realUrl:url];
    if (placeholder) {
        [self sd_setBackgroundImageWithURL:kurl forState:state placeholderImage:placeholder options:options];
    } else {
        [self sd_setBackgroundImageWithURL:kurl forState:state placeholderImage:self.placeholderDefaultImage options:options];
    }
    
}

- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIButton realUrl:url];
    [self sd_setBackgroundImageWithURL:kurl forState:state completed:completedBlock];
}

- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIButton realUrl:url];
    if (placeholder) {
        [self sd_setBackgroundImageWithURL:kurl forState:state placeholderImage:self.placeholderDefaultImage completed:completedBlock];
    } else {
        [self sd_setBackgroundImageWithURL:kurl forState:state placeholderImage:self.placeholderDefaultImage completed:completedBlock];
    }
}

- (void)lt_setBackgroundImageWithURL:(id)url forState:(UIControlState)state placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options completed:(SDWebImageCompletionBlock)completedBlock {
    NSURL *kurl = [UIButton realUrl:url];
    if (placeholder) {
        [self sd_setBackgroundImageWithURL:kurl forState:state placeholderImage:placeholder options:options completed:completedBlock];
    } else {
        [self sd_setBackgroundImageWithURL:kurl forState:state placeholderImage:self.placeholderDefaultImage options:options completed:completedBlock];
    }
    
}

- (void)lt_cancelImageLoadForState:(UIControlState)state {
    [self sd_cancelImageLoadForState:state];
}

- (void)lt_cancelBackgroundImageLoadForState:(UIControlState)state {
    [self sd_cancelBackgroundImageLoadForState:state];
}


@end
