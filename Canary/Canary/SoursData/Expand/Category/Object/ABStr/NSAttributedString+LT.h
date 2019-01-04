//
//  NSAttributedString+LT.h
//  LTDevDemo
//
//  Created by litong on 2017/1/7.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (LT)

- (CGSize)autoSize:(CGSize)s;
+ (NSAttributedString *)copyrightAttr;
@end





/*
 
 http://www.th7.cn/Program/IOS/201403/180653.shtml
 
 字符属性
 
 字符属性可以应用于 attributed string 的文本中。
 
 NSString *const NSFontAttributeName;(字体)
 
 NSString *const NSParagraphStyleAttributeName;(段落)
 
 NSString *const NSForegroundColorAttributeName;(字体颜色)
 
 NSString *const NSBackgroundColorAttributeName;(字体背景色)
 
 NSString *const NSLigatureAttributeName;(连字符)
 
 NSString *const NSKernAttributeName;(字间距)
 
 NSString *const NSStrikethroughStyleAttributeName;(删除线)
 
 NSString *const NSUnderlineStyleAttributeName;(下划线)
 
 NSString *const NSStrokeColorAttributeName;(边线颜色)
 
 NSString *const NSStrokeWidthAttributeName;(边线宽度)
 
 NSString *const NSShadowAttributeName;(阴影)(横竖排版)
 
 NSString *const NSVerticalGlyphFormAttributeName;
 
 常量
 
 1> NSFontAttributeName(字体)
 
 该属性所对应的值是一个 UIFont 对象。该属性用于改变一段文本的字体。如果不指定该属性，则默认为12-point Helvetica(Neue)。
 
 2> NSParagraphStyleAttributeName(段落)
 
 该属性所对应的值是一个 NSParagraphStyle 对象。该属性在一段文本上应用多个属性。如果不指定该属性，则默认为 NSParagraphStyle 的defaultParagraphStyle 方法返回的默认段落属性。
 
 3> NSForegroundColorAttributeName(字体颜色)
 
 该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的字体颜色。如果不指定该属性，则默认为黑色。
 
 4> NSBackgroundColorAttributeName(字体背景色)
 
 该属性所对应的值是一个 UIColor 对象。该属性用于指定一段文本的背景颜色。如果不指定该属性，则默认无背景色。
 
 5> NSLigatureAttributeName(连字符)
 
 该属性所对应的值是一个 NSNumber 对象(整数)。连体字符是指某些连在一起的字符，它们采用单个的图元符号。0 表示没有连体字符。1 表示使用默认的连体字符。2表示使用所有连体符号。默认值为 1（注意，iOS 不支持值为 2）。
 
 6> NSKernAttributeName(字间距)
 
 该属性所对应的值是一个 NSNumber 对象(整数)。字母紧排指定了用于调整字距的像素点数。字母紧排的效果依赖于字体。值为 0 表示不使用字母紧排。默认值为0。
 
 7> NSStrikethroughStyleAttributeName(删除线)
 
 该属性所对应的值是一个 NSNumber 对象(整数)。该值指定是否在文字上加上删除线，该值参考“Underline Style Attributes”。默认值是NSUnderlineStyleNone。
 
 8> NSUnderlineStyleAttributeName(下划线)
 
 该属性所对应的值是一个 NSNumber 对象(整数)。该值指定是否在文字上加上下划线，该值参考“Underline Style Attributes”。默认值是NSUnderlineStyleNone。
 
 9> NSStrokeColorAttributeName(边线颜色)
 
 该属性所对应的值是一个 UIColor 对象。如果该属性不指定（默认），则等同于 NSForegroundColorAttributeName。否则，指定为删除线或下划线颜色。更多细节见“Drawing attributedstrings that are both filled and stroked”。
 
 10> NSStrokeWidthAttributeName(边线宽度)
 
 该属性所对应的值是一个 NSNumber 对象(小数)。该值改变描边宽度（相对于字体size 的百分比）。默认为 0，即不改变。正数只改变描边宽度。负数同时改变文字的描边和填充宽度。例如，对于常见的空心字，这个值通常为3.0。
 
 11> NSShadowAttributeName(阴影)
 
 该属性所对应的值是一个 NSShadow 对象。默认为 nil。
 
 12> NSVerticalGlyphFormAttributeName(横竖排版)
 
 该属性所对应的值是一个 NSNumber 对象(整数)。0 表示横排文本。1 表示竖排文本。在 iOS 中，总是使用横排文本，0 以外的值都未定义。
 
 
 
 http://www.2cto.com/kf/201409/334308.html
 
 @property(readwrite) CGFloat lineSpacing;//行间距
 @property(readwrite) CGFloat paragraphSpacing;//段间距
 @property(readwrite) NSTextAlignment alignment;//对齐方式
 @property(readwrite) CGFloat firstLineHeadIndent;//首行缩紧
 @property(readwrite) CGFloat headIndent;//除首行之外其他行缩进
 @property(readwrite) CGFloat tailIndent;//每行容纳字符的宽度
 @property(readwrite) NSLineBreakMode lineBreakMode;//换行方式
 @property(readwrite) CGFloat minimumLineHeight;//最小行高
 @property(readwrite) CGFloat maximumLineHeight;//最大行高
 @property(readwrite) NSWritingDirection baseWritingDirection;//书写方式（NSWritingDirectionNatural，NSWritingDirectionLeftToRight，NSWritingDirectionRightToLeft）
 @property(readwrite) CGFloat lineHeightMultiple;
 @property(readwrite) CGFloat paragraphSpacingBefore;
 @property(readwrite) float hyphenationFactor;
 @property(readwrite,copy,NS_NONATOMIC_IOSONLY) NSArray *tabStops NS_AVAILABLE_IOS(7_0);
 @property(readwrite,NS_NONATOMIC_IOSONLY) CGFloat defaultTabInterval NS_AVAILABLE_IOS(7_0);
 
 
 
 NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
 NSForegroundColorAttributeNam      设置字体颜色，取值为 UIColor对象，默认值为黑色
 NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
 NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
 NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
 NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
 NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
 NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
 NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
 NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
 NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
 NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
 NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
 NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
 NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
 NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
 NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象
 
 
 
 */
