//
//  NSString+RE_.m
//  LTDevDemo
//
//  Created by litong on 2017/1/7.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "NSString+RE_.h"
#import "NSString+LT.h"

// https://c.runoob.com/front-end/854


@implementation NSString (RE_)



#pragma mark - 过滤8-12位数字

- (NSString *)legalString {
    NSString *str = [self specialCharactersReplace:@""];
    BOOL bl = [str is_liveStringLegal];
    if (!bl) {
        NSString *res = [self specialCharactersReplace0:@"*"];
        return res;
    }
    return self;
}

#define LTSpecialCharacters @"／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"，。,.  "

- (NSString *)specialCharactersReplace:(NSString *)replace {
    NSCharacterSet *doNotWantStr = [NSCharacterSet characterSetWithCharactersInString:LTSpecialCharacters];
    NSString *tempString = [[self componentsSeparatedByCharactersInSet: doNotWantStr] componentsJoinedByString:replace];
    return tempString;
}

- (NSString *)specialCharactersReplace0:(NSString *)replace {
    //    NSString *scr = [NSString stringWithFormat:@"123456789%@",LTSpecialCharacters];
    NSString *scr = @"1234567890 ";
    NSCharacterSet *doNotWantStr = [NSCharacterSet characterSetWithCharactersInString:scr];
    NSString *tempString = [[self componentsSeparatedByCharactersInSet: doNotWantStr] componentsJoinedByString:replace];
    return tempString;
}






#pragma mark - 检验字符串（正则等）

- (BOOL)is_liveStringLegal {
    NSString *regex = @".*[0-9]{8,}.*";
    return ![self matchRegularExpressions:regex];
}


//数字
- (BOOL)is_number {
    NSString *regex = @"^[0-9]*$";
    return [self matchRegularExpressions:regex];
}
//小写字母
- (BOOL)is_lowercase {
    NSString *regex = @"^[a-z]+$";
    return [self matchRegularExpressions:regex];
}
//大写字母
- (BOOL)is_uppercase {
    NSString *regex = @"^[A-Z]+$";
    return [self matchRegularExpressions:regex];
}
//大小写字母
- (BOOL)is_letters {
    NSString *regex = @"^[A-Za-z]+$";
    return [self matchRegularExpressions:regex];
}
//字母、数字
- (BOOL)is_lettersOrNumber {
    NSString *regex = @"^[A-Za-z0-9]+$";
    return [self matchRegularExpressions:regex];
}
//字母或数字 大于等于num位
- (BOOL)is_lettersOrNumber:(NSInteger)num {
    NSString *regex = [NSString stringWithFormat:@"^[A-Za-z0-9]{%ld,}$",num];
    return [self matchRegularExpressions:regex];
}
//字母、数字、下划线
- (BOOL)is_lettersOrNumberOrUnderline {
    NSString *regex = @"^[A-Za-z0-9_]+$";
    return [self matchRegularExpressions:regex];
}
//汉字
- (BOOL)is_ChineseCharacter {
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";
    return [self matchRegularExpressions:regex];
}

//身份证
- (BOOL)is_IDcard {
    NSString *regex = @"(^\\d{15}$)|(^\\d{18}$)|(^\\d{17}(\\d|X|x)$)";
    return [self matchRegularExpressions:regex];
}
//6-16位字母、数字
- (BOOL)is_password {
    NSString *regex = @"^[a-zA-Z0-9]{6,16}$";
    return [self matchRegularExpressions:regex];
}

- (BOOL)is_email{
//    NSString *regex0 = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self matchRegularExpressions:regex];
}

- (BOOL)is_URL {
    NSString *str = [self replacStr:@" " withStr:@""];
    NSString *regex = @"((http|ftp|https)://|www.)(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
    return [str matchRegularExpressions:regex];
}
//域名
- (BOOL)is_domain {
    NSString *regex = @"[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(/.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+/.?";
    return [self matchRegularExpressions:regex];
}
//ip地址
- (BOOL)is_IPAddress {
    NSString *regex = @"((?:(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d?\\d))";
    return [self matchRegularExpressions:regex];
}

//检查手机格式
- (BOOL)is_PhoneNumber1 {
    NSString *regex = @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
    return [self matchRegularExpressions:regex];
}
//检查手机格式  1开头11位
- (BOOL)is_PhoneNumber {
    NSString *regex = @"^1\\d{10}$";
    return [self matchRegularExpressions:regex];
}

//检查手机格式 严格
- (BOOL)is_phoneNumRigorous {
    
    if (self == nil) {
        return NO;
    }
    
    //联通号码
    NSString *regex_Unicom = @"^(130|131|132|133|185|186|156|155)[0-9]{8}";
    //移动号码
    NSString *regex_CMCC = @"^(134|135|136|137|138|139|147|150|151|152|157|158|159|182|187|188)[0-9]{8}";
    //电信号码段(电信新增号段181)
    NSString *regex_Telecom = @"^(133|153|180|181|189)[0-9]{8}";
    
    BOOL isMatch_Unicom = [self matchRegularExpressions:regex_Unicom];
    BOOL isMatch_CMCC = [self matchRegularExpressions:regex_CMCC];
    BOOL isMatch_Telecom = [self matchRegularExpressions:regex_Telecom];
    
    return (isMatch_Unicom || isMatch_CMCC || isMatch_Telecom);
}










//匹配正则表达式
- (BOOL)matchRegularExpressions:(NSString*)pattern {
    NSPredicate *patternTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [patternTest evaluateWithObject:self];
}



@end
