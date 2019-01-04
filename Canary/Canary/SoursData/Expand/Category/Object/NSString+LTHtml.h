//
//  NSString+LTHtml.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LTHtml)


/*! 合成一个URL路径 */
+ (NSString *)urlStringWithBaseUrl:(NSString *)url paramDic:(NSDictionary *)param;
/*! 合成一个URL路径
 self : url字符串
 */
- (NSString *)urlStringAddParmDict:(NSDictionary *)param;

/*! 把HTML转换为TEXT文本 */
- (NSString *)html2text;

/*! 移除一些HTML标签 */
- (NSString *)striptags;

/*! 格式化文本 */
- (NSString *)textindent;

/** html转字符串 */
- (NSString *)htmlToString;

/** 清除< a标签 */
- (NSString *)htmlClearHref;
/** 清除< img标签 */
- (NSString *)htmlClearImgs;
/** 格式化< img标签 */
- (NSString *)htmlFormatImg;
/** 找< img 返回imgs数组 */
- (NSArray*)htmlFindImgs;


@end
