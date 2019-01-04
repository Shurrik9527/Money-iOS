//
//  NSString+ABStr.m
//  LTDevDemo
//
//  Created by litong on 2017/1/7.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSString+ABStr.h"

@implementation NSString (ABStr)

#pragma mark - 富媒体文本

- (NSAttributedString *)ABStrColor:(UIColor *)color range:(NSRange)range {
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:self];
    [ABStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return ABStr;
}
- (NSAttributedString *)ABStrFont:(UIFont *)font range:(NSRange)range {
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:self];
    [ABStr setAttributes:@{NSFontAttributeName:font} range:range];
    return ABStr;
}
- (NSAttributedString *)ABStrColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range {
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc]initWithString:self];
    [ABStr setAttributes:@{NSForegroundColorAttributeName:color,
                           NSFontAttributeName:font}
                   range:range];
    return ABStr;
}
- (NSAttributedString *)ABStrColor:(UIColor *)color font:(UIFont *)font {
    return [self ABStrColor:color font:font range:NSMakeRange(0, self.length)];
}
- (NSAttributedString *)ABStrFont:(UIFont *)font color:(UIColor *)color  {
    NSDictionary *dict = @{ NSForegroundColorAttributeName:color,
                            NSFontAttributeName:font };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self attributes:dict];
    return attrString;
}


- (NSAttributedString *)ABStrFont:(UIFont *)font placeholderFont:(UIFont *)placeholderFont color:(UIColor *)color {
    CGFloat fontLineH = font.lineHeight;
    CGFloat pFontLineH = placeholderFont.lineHeight;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.minimumLineHeight = fontLineH - (fontLineH - pFontLineH) / 2.0;
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName : LTSubTitleColor ,
                           NSFontAttributeName : placeholderFont ,
                           NSParagraphStyleAttributeName : paragraph};
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self attributes:dict];
    return attrString;
}


//删除线
- (NSAttributedString *)ABStrStrikethrough {
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = NSMakeRange(0, str.length);
    [ABStr setAttributes:@{
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)
                           }
                   range:range];
    return ABStr;
}
- (NSAttributedString *)ABStrStrikethroughWithFont:(UIFont *)font color:(UIColor *)color {
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = NSMakeRange(0, str.length);
    [ABStr setAttributes:@{
                           NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
                           NSFontAttributeName:font,
                           NSForegroundColorAttributeName:color}
                   range:range];
    return ABStr;
}

//下划线
- (NSAttributedString *)ABStrUnderlineSpacing:(CGFloat)lineSpacing font:(UIFont *)font color:(UIColor *)color {
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSRange range = NSMakeRange(0, str.length);
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    
    NSDictionary *dict = @{
                           NSParagraphStyleAttributeName:paragraphStyle,
                           NSFontAttributeName:font,
                           NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),
                           NSForegroundColorAttributeName:color
                           };
    [ABStr setAttributes:dict range:range];
    return ABStr;
}

//行间距
- (NSAttributedString *)ABStrSpacing:(CGFloat)lineSpacing font:(UIFont *)font {
    
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = NSMakeRange(0, str.length);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [ABStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [ABStr addAttribute:NSFontAttributeName value:font range:range];
    
    return ABStr;
}

//行间距
- (NSAttributedString *)ABStrSpacing:(CGFloat)lineSpacing font:(UIFont *)font color:(UIColor *)color {
    
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = NSMakeRange(0, str.length);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [ABStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    [ABStr addAttribute:NSFontAttributeName value:font range:range];
    [ABStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    return ABStr;
}

- (NSAttributedString *)ABStrSpacing:(CGFloat)lineSpacing firstLineHeadIndent:(CGFloat)firstLineHeadIndent font:(UIFont *)font {
    
    NSString *str = [NSString stringWithFormat:@"%@",self];
    NSRange range = NSMakeRange(0, str.length);
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.firstLineHeadIndent = firstLineHeadIndent;
    
    NSDictionary *dict = @{
                           NSParagraphStyleAttributeName:paragraphStyle,
                           NSFontAttributeName:font,
                           };
    [ABStr setAttributes:dict range:range];
    
    return ABStr;
}


@end
