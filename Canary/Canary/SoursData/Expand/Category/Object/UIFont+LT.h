//
//  UIFont+LT.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (LT)





#define FN_HelveticaNeue           @"HelveticaNeue"
#define FN_HelveticaNeue_Bold  @"HelveticaNeue-Bold"
#define FN_DINPro_Regular         @"DINPro-Regular"
#define FN_DINPro_Medium        @"DINPro-Medium"

#define LTFontNameAndSize(fontName,fontSize) [UIFont fontWithName:fontName size:fontSize]
#define DINProAutoFontSiz(fs)             LTFontNameAndSize(@"DINPro-Regular",fs)
#define DINProAutoBoldFontSiz(fs)       LTFontNameAndSize(@"DINPro-Medium",fs)


+ (UIFont *)autoFontSize:(CGFloat)fs;
+ (UIFont *)autoBoldFontSize:(CGFloat)fs;

#define autoFontSiz(fs)             [UIFont autoFontSize:fs]
#define autoBoldFontSiz(fs)     [UIFont autoBoldFontSize:fs]

+ (UIFont *)fontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldFontOfSize:(CGFloat)fontSize;
#define fontSiz(fs)             [UIFont fontOfSize:fs]
#define boldFontSiz(fs)     [UIFont boldFontOfSize:fs]

@end
