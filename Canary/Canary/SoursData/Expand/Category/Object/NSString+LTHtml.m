//
//  NSString+LTHtml.m
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSString+LTHtml.h"

@implementation NSString (LTHtml)





/* 合成一个URL路径 */
+ (NSString *)urlStringWithBaseUrl:(NSString *)url paramDic:(NSDictionary *)param {
    
    if (!param) {
        return url;
    }
    
    NSMutableString *URL = [[NSMutableString alloc] initWithFormat:@"%@?",url];
    NSArray *keys = [param allKeys];
    NSInteger keysCount = keys.count;
    
    int i = 0;
    for (NSString *key in keys) {
        id value = [param objectForKey:key];
        [URL appendFormat:@"%@=%@", key, value];
        if (i < keysCount - 1) {
            [URL appendFormat:@"&"];
        }
        
        i ++;
    }
    
    return URL;
}

- (NSString *)urlStringAddParmDict:(NSDictionary *)param {
    return [NSString urlStringWithBaseUrl:self paramDic:param];
}

/* 把HTML转换为TEXT文本 */
- (NSString *)html2text {
    NSString *str = [NSString stringWithString:self];
    
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"<BR>" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"<BR />" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"<b>" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"<B>" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"</b>" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"</B>" withString:@" "];
    
    return str;
}

/* 移除一些HTML标签 */
- (NSString *)striptags {
    NSString *str = [NSString stringWithString:self];
    
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"<br>" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"<BR>" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"<br />" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"<BR />" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    
    return str;
}

/* 格式化文本 */
- (NSString *)textindent {
    NSString *str = [self stringByReplacingOccurrencesOfString:@"\n" withString:@"\n    "];
    str = [NSString stringWithFormat:@"    %@", str];
    return str;
}





/** html转字符串 */
- (NSString *)htmlToString {
    NSString *html = self;
    if (!html) {
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    NSString * srctext = nil;
    int imgcount = 0;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<img" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&srctext];
        // 获取图片地址
        NSString *src = [srctext substringFromIndex:[srctext rangeOfString:@"src="].location+5];
        src = [src substringToIndex:[src rangeOfString:@"\""].location];
        src = [src stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        src = [src urlEncoding];
        //替换字符
        if (![src isEqualToString:@""] && ![src isEqual:[NSNull null]] && src) {
            if ([src rangeOfString:@"http://"].location ==  NSNotFound) {
                html = [html stringByReplacingOccurrencesOfString:src withString:@""];
            }else{
                html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",srctext] withString:[NSString stringWithFormat:@"[_image]%@[/_image]",src]];
            }
            imgcount += 1;
        }
        
        src = nil;
    }
    scanner = [NSScanner scannerWithString:html];
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    if ([html rangeOfString:@"[_image]"].location==NSNotFound) {
        html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    html = [html stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    html = [html stringByReplacingOccurrencesOfString:@"[_image]" withString:@"\n<_image>"];
    html = [html stringByReplacingOccurrencesOfString:@"[/_image]" withString:@"</_image>\n"];
    
    html = [html stringByReplacingOccurrencesOfString:@"	" withString:@" "];
    html = [html stringByReplacingOccurrencesOfString:@"" withString:@" "];
    //html = [html stringByAppendingString:@"<_image>giraffe.png</_image>"];
    
    
    return html;
}
#pragma mark 清除A标签
- (NSString *)htmlClearHref {
    NSString *html = self;
    if (!html) {
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<a" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        //找到标签的起始位置
        [scanner scanUpToString:@"</a" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}
#pragma mark 清除Img标签

- (NSString *)htmlClearImgs {
    NSString *html = self;
    if (!html) {
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<img" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"/>" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/>",text] withString:@""];
        
    }
    return html;
}

/** 格式化<img标签 */
- (NSString *)htmlFormatImg {
    NSString *html = self;
    if (!html) {
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    int i=0;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<img" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@"/>" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/>",text] withString:[NSString stringWithFormat:@"<a href=""show(%d)"">%@/></a>",i,text]];
        i++;
    }
    return html;
}

- (NSArray*)htmlFindImgs {
    NSString *html = self;
    if (!html) {
        return nil;
    }
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    NSMutableArray *imgs = [NSMutableArray new];
    while([scanner isAtEnd]==NO)
    {
        
        //找到标签的起始位置
        [scanner scanUpToString:@"<img" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        // 获取图片地址
        NSString *src = [text substringFromIndex:[text rangeOfString:@"src="].location+5];
        src = [src substringToIndex:[src rangeOfString:@"\""].location];
        src = [src stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        src = [src urlEncoding];
        NSString *width ;//= [text substringFromIndex:[text rangeOfString:@"width:"].location+6];
        //width = [width substringToIndex:[width rangeOfString:@"px"].location];
        NSString *height ;//= [text substringFromIndex:[text rangeOfString:@"height:"].location+7];
        //height = [height substringToIndex:[height rangeOfString:@"px"].location];
        width = @"";
        height = @"";
        if (src) {
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 src,@"src",
                                 width,@"width",
                                 height,@"height",
                                 nil];
            
            [imgs addObject:dic];
            
            
        }
        
        src = nil;
    }
    [imgs removeLastObject];
    return imgs;
}


@end
