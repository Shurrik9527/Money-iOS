//
//  NSAttributedString+LT.m
//  LTDevDemo
//
//  Created by litong on 2017/1/7.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSAttributedString+LT.h"

@implementation NSAttributedString (LT)

- (CGSize)autoSize:(CGSize)s {
    CGSize size = [self boundingRectWithSize:s options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return size;
}

//修改行高参考
- (NSAttributedString *)ss {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 15; //
    paragraphStyle.firstLineHeadIndent = 15; //首行缩进
    paragraphStyle.lineSpacing = 7; // 行间距
    UIFont *font = [UIFont systemFontOfSize:20]; //
    NSDictionary *attrsDictionary = @{ NSFontAttributeName:font,
       NSParagraphStyleAttributeName: paragraphStyle};
    return [[NSAttributedString alloc]
            initWithString:@"Hello World over many lines!" attributes:attrsDictionary];
}
+ (NSAttributedString *)copyrightAttr {
    NSString *str = @"@2002-2017 FXBTG Global 版权所有";
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = [str rangeOfString:@"FX"];
    NSRange range2 = [str rangeOfString:@"BTG"];
    [ABStr addAttribute:NSForegroundColorAttributeName value:LTTitleColor range:range1];
    [ABStr addAttribute:NSForegroundColorAttributeName value:LTRGB(255, 95, 6) range:range2];
    return ABStr;
}

@end
