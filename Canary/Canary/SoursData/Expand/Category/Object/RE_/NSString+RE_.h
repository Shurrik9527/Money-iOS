//
//  NSString+RE_.h
//  LTDevDemo
//
//  Created by litong on 2017/1/7.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

//正则表达式
@interface NSString (RE_)


#pragma mark - 过滤8-12位数字
/*! 特殊字符替换成* */
- (NSString *)legalString;
/*! 特殊字符替换成replace */
- (NSString *)specialCharactersReplace:(NSString *)replace;


#pragma mark - 检验字符串（正则等）

- (BOOL)is_liveStringLegal;
//数字
- (BOOL)is_number;
//小写字母
- (BOOL)is_lowercase;
//大写字母
- (BOOL)is_uppercase;
//大小写字母
- (BOOL)is_letters;
//字母、数字
- (BOOL)is_lettersOrNumber;
//字母或数字 大于等于num位
- (BOOL)is_lettersOrNumber:(NSInteger)num;
//字母、数字、下划线
- (BOOL)is_lettersOrNumberOrUnderline;
//汉字
- (BOOL)is_ChineseCharacter;
//身份证
- (BOOL)is_IDcard;
//6-16位字母、数字
- (BOOL)is_password;
- (BOOL)is_email;
- (BOOL)is_URL;
//域名
- (BOOL)is_domain;
//ip地址
- (BOOL)is_IPAddress;

//检查手机格式
- (BOOL)is_PhoneNumber1;
//检查手机格式  1开头11位
- (BOOL)is_PhoneNumber;
//检查手机格式 严格
- (BOOL)is_phoneNumRigorous;

//匹配正则表达式
- (BOOL)matchRegularExpressions:(NSString*)pattern;

@end
