//
//  UIColor+LT.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>


#define LTHEX(rgbValue)    \
                            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                            blue:((float)(rgbValue & 0xFF))/255.0 \
                            alpha:1.0]

#define LTRGBA(r, g, b, a)        \
                            [UIColor colorWithRed:(CGFloat)r/255.0f \
                            green:(CGFloat)g/255.0f \
                            blue:(CGFloat)b/255.0f \
                            alpha:(CGFloat)a]

#define LTRGB(r, g, b)            LTRGBA(r, g, b, 1)

#define LTColorHex(hexValue)             [UIColor colorFromHex:hexValue]
#define LTColorHexString(hexValue)   [UIColor colorFromHexString:hexValue]

#define LTColorHexA(hex, a)                [UIColor colorFromHex:hex alpha:a]
#define LTColorHexAString(hex, a)      [UIColor colorFromHexString:hex alpha:a];

#define HEXColor(hexValue)      [UIColor colorFromHex:hexValue]
#define HEXStrColor(hexValue)   [UIColor colorFromHexString:hexValue]

//common use colors

//#define LTTitleColor              LTColorHex(0x24273E)//黑色字体
//#define LTSubTitleColor       LTColorHex(0x848999)//灰色字体
//#define LTLineColor             LTColorHex(0xE6E7EA)//灰色线条颜色
//#define LTBgColor               LTColorHex(0xF0F2F5)//浅灰色背景颜色
//#define LTMaskColor           LTRGBA(0, 0, 0, 0.5)//蒙版半透明
//#define LTKLineGreen         LTColorHex(0x1FB73C)//k线跌
//#define LTKLineRed             LTColorHex(0xF54A40)//k线涨

// These colors are cached.
#define LTBlackColor             [UIColor blackColor]    // 0.0 white
#define LTDarkGrayColor      [UIColor darkGrayColor]// 0.333 white
#define LTLightGrayColor      [UIColor lightGrayColor]// 0.667 white
#define LTWhiteColor             [UIColor whiteColor]     // 1.0 white
#define LTGrayColor              [UIColor grayColor]       // 0.5 white
#define LTRedColor               [UIColor redColor]        // 1.0, 0.0, 0.0 RGB
#define LTGreenColor            [UIColor greenColor]// 0.0, 1.0, 0.0 RGB
#define LTBlueColor              [UIColor blueColor]       // 0.0, 0.0, 1.0 RGB
#define LTCyanColor              [UIColor cyanColor]// 0.0, 1.0, 1.0 RGB
#define LTYellowColor            [UIColor yellowColor]// 1.0, 1.0, 0.0 RGB
#define LTMagentaColor       [UIColor magentaColor]// 1.0, 0.0, 1.0 RGB
#define LTOrangeColor         [UIColor orangeColor]// 1.0, 0.5, 0.0 RGB
#define LTPurpleColor            [UIColor purpleColor]// 0.5, 0.0, 0.5 RGB
#define LTBrownColor             [UIColor brownColor]// 0.6, 0.4, 0.2 RGB
#define LTClearColor             [UIColor  clearColor]// 0.0 white, 0.0 alpha


@interface UIColor (LT)

// 返回一个十六进制表示的颜色: @"FF0000" or @"#FF0000"
+ (instancetype)colorFromHexString:(NSString *)hexString;
+ (instancetype)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha;
// 返回一个十六进制表示的颜色: 0xFF0000
+ (instancetype)colorFromHex:(int)hex;
+ (instancetype)colorFromHex:(int)hex alpha:(CGFloat)alpha;
// 返回颜色的十六进制string
- (NSString *)hexString;
// 数组内容依次是：r, g, b, a .
- (NSArray *)rgbaArray;
// 根据自己的颜色,返回黑色或者白色
- (instancetype)blackOrWhiteContrastingColor;

#pragma mark - 颜色转图片
- (UIImage *)imageFromUIColor;


@end
