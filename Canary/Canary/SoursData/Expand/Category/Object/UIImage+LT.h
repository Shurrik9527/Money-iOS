//
//  UIImage+LT.h
//  LTDevDemo
//
//  Created by litong on 2017/1/6.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LT)

#pragma mark - 颜色->图片

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

#pragma mark - 拉伸图片

- (UIImage *)stretchLeftCap:(NSInteger)w topCap:(NSInteger)h __TVOS_PROHIBITED;
- (UIImage *)stretchMiddle;

#pragma mark - 格式转换、保存

- (NSData *)toPNGData;
- (UIImage *)toPNGImage;
- (NSData *)toJPEGData;
- (NSData *)toJPEGData:(CGFloat)compression;
- (UIImage *)toJPEGImage;
- (UIImage *)toJPEGImage:(CGFloat)compression;

- (BOOL)writePNGToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
- (BOOL)writeJPEGToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;
- (BOOL)writeJPEGToFile:(NSString *)path compression:(CGFloat)compression atomically:(BOOL)useAuxiliaryFile;

#pragma mark - 修改图片颜色

- (UIImage *)changeColor:(UIColor *)color;

#pragma mark - 裁剪
//按rect 裁剪图片
- (UIImage *)cutWithRect:(CGRect)rect;
//裁剪中间圆形图片
- (UIImage*)cuteCircle;
- (UIImage*)cuteCircle:(CGFloat)wh;
//裁剪中间正方形图片
- (UIImage *)cutedCenterSquare;
//缩放到指定宽高(wh)，裁剪中间正方形图片
- (UIImage *)scaledSquare:(CGFloat)wh;
//等比缩放本图片大小, 不失真
- (UIImage *)scaleToWidth:(CGFloat)iw;
//等比缩放本图片大小
- (UIImage *)scaleToWidth1:(CGFloat)iw;
- (UIImage *)scaleToSize:(CGSize)size;
//图片压缩至 kSize 单位k
- (NSData *)zipToKSize:(CGFloat)kSize;

#pragma mark - 模糊

//截取某一块图片并模糊
- (UIImage *)blurWithRadius:(CGFloat)radius cutFrame:(CGRect)frame;
//系统滤镜模糊
- (UIImage *)blurSysWithRadius:(CGFloat)blur;
//高斯模糊
- (UIImage *)blurWithRadius:(CGFloat)blurRadius;
//高斯模糊滤镜，可调节模糊程度
- (UIImage*)gaussBlur:(CGFloat)blurLevel;

#pragma mark - 获取图片某一像素的颜色

- (UIColor *)colorAtPixel:(CGPoint)point ImageViewFrame:(CGRect)viewFrame;

@end
