//
//  TYSizeAndColor.h
//  ixit
//
//  Created by shuoliu on 16/1/6.
//  Copyright © 2016年 ixit. All rights reserved.
//

#ifndef TYSizeAndColor_h
#define TYSizeAndColor_h


#define SMAHeight 32 //SMA相关高度


#pragma mark - 字体
#pragma mark -

//字体大小
#define  bigFontSize 24

#define  midFontSize 15
#define  smallFontSize 12
//字体名称
#define kFontName @"HelveticaNeue"
#define kFontBoldName @"HelveticaNeue-Bold"
#define kFontNumberRegular @"DINPro-Regular"
#define kFontNumberMedium @"DINPro-Medium"

#define kFontNumber(fontSize) [UIFont fontWithName:kFontName size:fontSize]
#define kNumberFont(fontSize) [UIFont fontWithName:kFontNumberRegular size:fontSize]
#define kNumberMediumFont(fontSize) [UIFont fontWithName:kFontNumberMedium size:fontSize]





// 公共视图尺寸定义
#define kNavigationHeight 48
#define Screen_height [[UIScreen mainScreen] bounds].size.height
#define Screen_width [[UIScreen mainScreen] bounds].size.width


#pragma mark - 常用颜色
#pragma mark -

//使用新年红色主题   改为1
#define useNewYearTheme         0


#define NavBarBgCoror0           LTColorHex(0xD32930)
#define NavBarTitleCoror0          LTWhiteColor
#define NavBarSubCoror0          LTColorHexA(0xFFFFFF, 0.5)
#define NavBarBtmLineCoror0   LTBlackColor


#if useNewYearTheme


//控制 NavBar和TabBar 上的图片颜色   1开启
#define kChangeImageColor       0

    #define mark 导航Coror

        #define NavBarBgCoror           LTColorHex(0x24273E)
        #define NavBarTitleCoror          LTWhiteColor
        #define NavBarSubCoror          LTWhiteColor
        #define NavBarBtmLineCoror   LTBlackColor


    #define mark TabBarColor

        #define TabBarBgCoror           LTColorHex(0xFFFFFF)
        #define TabBarMaskCoror       LTColorHexA(0xFF0000,0.1)
        #define TabBarSelCoror           LTColorHex(0xF54A40)
        #define TabBarNorCoror          LTColorHex(0x848999)

#else

//控制 NavBar和TabBar 上的图片颜色   1开启
#define kChangeImageColor       0

    #pragma mark - 黑色导航Coror

        #define NavBarBgCoror           LTColorHex(0x24273E)

        #define NavHeadBgCoror           LTColorHex(0x262940)

        #define NavBarTitleCoror          LTWhiteColor
        #define NavBarSubCoror          LTWhiteColor
        #define NavBarBtmLineCoror   LTBlackColor


    #pragma mark - 黑色TabBarColor

//        #define TabBarBgCoror           LTRGBA(240, 242, 245, 0.5)
        #define TabBarBgCoror           LTColorHex(0xF7F8FA)
        #define TabBarSelCoror           LTColorHex(0x3a69e3)
        #define TabBarNorCoror          LTColorHex(0x86919c)

#endif




#pragma mark NormalCoror

#define LTTitleColor              LTColorHex(0x24273E)//黑色字体
#define LTTitleRGB               LTRGB(36, 39, 62)
#define TitleHex                    @"24273E"


#define LTSubTitleColor         LTColorHex(0x848999)//灰色字体
#define LTSubTitleRGB          LTRGB(132, 137, 153)
#define PlaceholderColor       LTRGBA(132, 137, 153, 0.7)
#define SubTitleHex               @"848999"

#define LTGrayBtnBGColor              LTColorHex(0xe4e5e8)//灰色按钮背景颜色


#define LTLineColor                LTColorHex(0xE6E7EA)//灰色线条颜色

#define LTBgColor                   LTColorHex(0xF0F2F5)//浅灰色背景颜色
#define LTBgRGB                    LTRGB(240, 242, 245)

#define LTMaskColor               LTRGBA(0, 0, 0, 0.5)//蒙版半透明

#define LTKLineGreen              LTColorHex(0x1FB73C)//k线跌
#define LTKLineGreenRGB      LTRGB(31, 183, 60)
#define KLineGreenHex           @"1FB73C"  //kline绿

#define LTKLineRed                  LTColorHex(0xF54A40)//k线涨
#define LTKLineRedRGB           LTRGB(245, 74, 64)
#define KLineRedHex                @"F54A40"   //kline红

#define LTSureFontBlue             LTColorHex(0x4877E6)//确定按钮字体颜色
#define LTSureFontBlueRGB      LTRGB(72, 119, 230)
#define SureFontBlueHex           @"4877E6"   //确定按钮字体颜色

#define kMeVipColor @[@"FFB601",@"FF9F01",@"FF7901",\
@"FF5101",@"FF3A01",@"FF0000",@"FF006A"]


//颜色
#define GRAYCOL  [UIColor colorWithWhite:0.9 alpha:1]
#define BlueFont LTRGB(58, 105, 227)
#define KLineBoxBG  LTRGB(32, 34, 46)
#define BlueLineColor LTRGB(57, 94, 224)
#define KlineNavViewBG  LTRGB(44, 47, 71)
//RGB(58, 105, 227) == #3a69e3
//RGB(32, 34, 46) == #20222e
//RGB(57, 94, 224) == #395ee0
//RGB(44, 47, 71) == #2c2f47



#endif /* TYSizeAndColor_h */
