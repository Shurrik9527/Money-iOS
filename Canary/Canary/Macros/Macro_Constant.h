//
//  Macro_String.h
//  ixit
//
//  Created by litong on 16/9/18.
//  Copyright © 2016年 ixit. All rights reserved.
//

/**  此文件只存放恒定常量  */




#ifdef DEBUG

    #define NSLog(FORMAT, ...) fprintf(stderr,"[%s:%d行] %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

    #define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

    #define NSLog(...) {}
    #define DLog( s, ... )

#endif





#pragma mark - 恒定常量

#define WS(weakSelf) __weak typeof(self) weakSelf = self;


#define AppKeyWindow     [UIApplication sharedApplication].keyWindow
#define ShutAllKeyboard     [[[UIApplication sharedApplication] keyWindow] endEditing:YES]
#define LTFileSizeOneK           (1024)
#define LTFileSizeOneM           (1024 * LTFileSizeOneK)
#define LTFileSizeOneG           (1024 * LTFileSizeOneM)

#define LIT_ONE_MINUTE         (60)
#define LIT_ONE_HOUR           (60 * LIT_ONE_MINUTE)
#define LIT_ONE_DAY            (24 * LIT_ONE_HOUR)
#define LIT_ONE_MONTH          (30 * LIT_ONE_DAY)
#define LIT_ONE_YEAR           (12 * LIT_ONE_MONTH)

#define StatusBarH_Lit        ([UIApplication sharedApplication].statusBarFrame.size.height)
#define NavBarH_Lit                 (44.0)
#define NavBarTop_Lit               (iPhoneX || iPhoneXMax || iPhoneXR ? 88 : 64.0)
#define TabBarH_Lit                  (50.0)
#define kBottomBarHeight        (iPhoneX || iPhoneXMax || iPhoneXR  ? 34.0 : 0)
#define NavAndTabBarH_Lit          (NavBarTop_Lit + TabBarH_Lit + kBottomBarHeight)

//全屏幕的bounds
#define ScreenBounds_Lit           [[UIScreen mainScreen] bounds]
#define ScreenSize_Lit              ScreenBounds_Lit.size
#define ScreenW_Lit                 ScreenSize_Lit.width
#define ScreenH_Lit                 ScreenSize_Lit.height

//除去状态栏的屏幕的frame
#define ScreenFrame_Lit           [[UIScreen mainScreen] applicationFrame]
#define ScreenAppSize_Lit        ScreenFrame_Lit.size
#define ScreenAppW_Lit            ScreenAppSize_Lit.width
#define ScreenAppH_Lit             ScreenAppSize_Lit.height

#define Lit_iphone6W       375.0
#define Lit_iphone6H       667.0

#define NavBarHeight                        self.navigationController.navigationBar.bounds.size.height
#define TabBarHeight                        self.tabBarController.tabBar.bounds.size.height
#define StateBarHeight                        [[UIApplication sharedApplication] statusBarFrame].size.height




/*  
          宽高(点)          尺寸(像素)
 4:     320*480           640*960
 5:     320*568           640*1136
 6:     375*667           750*1334
 6P:   414*736          1242*2208(实际显示时：缩小1.15=1080*1920)
 
 */
#define iphone6PLater           ([[UIScreen mainScreen] bounds].size.height>=736)
#define iphone6Later           ([[UIScreen mainScreen] bounds].size.height>=667)
#define iphone5Later            ([[UIScreen mainScreen] bounds].size.height>=568)

#define LT_IPHONE4           ([[UIScreen mainScreen] bounds].size.height==480)
#define LT_IPHONE5           ([[UIScreen mainScreen] bounds].size.height==568)
#define LT_IPHONE6           ([[UIScreen mainScreen] bounds].size.height==667)
#define LT_IPHONE6P           ([[UIScreen mainScreen] bounds].size.height==736)


#define iOSSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]


#define iOSVersionLater_8_0   \
    (iOSSystemVersion>=8.0)

#define iOSVersionLater_7_0   \
    (iOSSystemVersion>=7.0)

#define iOSVersionLater_6_0   \
    (iOSSystemVersion>=6.0)

#define iOSVersionLater_5_0   \
    (iOSSystemVersion>=5.0)

#define iOSVersionLater_5_1   \
    (iOSSystemVersion>=5.1)

#define DeviceIsIPad          \
    ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound)














#pragma mark - 以前遗留

#define iPhone4     \
    ([UIScreen instancesRespondToSelector:@selector(currentMode)]   \
    ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5     \
    ([UIScreen instancesRespondToSelector:@selector(currentMode)]   \
    ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 \
    ([UIScreen instancesRespondToSelector:@selector(currentMode)]   \
    ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6Plus \
    ([UIScreen instancesRespondToSelector:@selector(currentMode)]   \
    ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX \
([UIScreen instancesRespondToSelector:@selector(currentMode)]   \
? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneXMax \
([UIScreen instancesRespondToSelector:@selector(currentMode)]   \
? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneXR \
([UIScreen instancesRespondToSelector:@selector(currentMode)]   \
? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

#define IOS10_OR_LATER (iOSSystemVersion >= 10.0)
#define IOS9_OR_LATER (iOSSystemVersion >= 9.0)
#define IOS8_OR_LATER (iOSSystemVersion >= 8.0)
#define IOS7_OR_LATER (iOSSystemVersion >= 7.0)







