//
//  DataHundel.m
//  Canary
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "DataHundel.h"

@implementation DataHundel


+ (DataHundel *) shareDataHundle{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
#pragma mark - utils
-(UIButton *)createBtnWithFrame:(CGRect)frame
                          title:(NSString *)title
                         action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
    btn.titleLabel.font = fontSiz(midFontSize);
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(UILabel *)createLabWithFrame:(CGRect)frame text:(NSString *)text fontsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.textColor=LTSubTitleRGB;
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
-(UIImageView *)createImgWithImage:(UIImage *)image frame:(CGRect)frame {
    UIImageView *imgV = [[UIImageView alloc]init];
    imgV.frame=frame;
    if (kChangeImageColor) {
        image = [image changeColor:NavBarSubCoror];
    }
    imgV.contentMode =  UIViewContentModeCenter;
    imgV.image=image;
    return imgV;
}
//毫秒转年月日
+ (NSString *)ConvertStrToTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
    
}
+(NSString *)convertime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
}
//年月日转毫秒
+ (long long)getZiFuChuan:(NSString*)time
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:time];
    return [date timeIntervalSince1970]*1000;
}

+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    }else{
#pragma clang diagnostic push
        
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return  [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:(NSLineBreakByCharWrapping)];
#pragma clang diagnostic pop
    }
}
#pragma mark - 判断code
+(NSString *)messageObjetCode:(NSUInteger)code;
{
    if (code == 0) {
        return @"OK";
    }else if(code==1){
        return @"手机号码格式错误";
    }
    else if(code==2){
        return @"验证码错误";
    }
    else if(code==3){
        return @"验证码失效";
    }
    else if(code==4){
        return @"账号或密码错误";
    }
    else if(code==5){
        return @"短信发送失败";
    }
    else if(code==6){
        return @"该产品不支持售卖";
    }
    else if(code==7){
        return @"买入信息不完整";
    }
    else if(code==8){
        return @"账户余额不足";
    }
    else if(code==9){
        return @"交易状态码编码错误";
    }
    else if(code==10){
        return @"交易信息错误";
    }
    else if(code==11){
        return @"交易时间错误";
    }
    else if(code==12){
        return @"账号已存在";
    }
    else if(code== -1){
        return @"参数不完整";
    }
    else if(code== -9){
        return @"请重新登录";
    }
    else if(code== -111){
        return @"请刷新JWT";
    }
    else if(code== -999){
        return @"非法访问";
    }
    else if(code== -2){
        return @"服务器错误";
    }
    return nil;
}

@end
