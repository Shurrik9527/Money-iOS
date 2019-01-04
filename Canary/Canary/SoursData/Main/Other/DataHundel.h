//
//  DataHundel.h
//  Canary
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DataHundel : NSObject

+(DataHundel *)shareDataHundle;
-(UIButton *)createBtnWithFrame:(CGRect)frame
                          title:(NSString *)title
                         action:(SEL)action;
-(UILabel *)createLabWithFrame:(CGRect)frame text:(NSString *)text fontsize:(CGFloat)fsize;
-(UIImageView *)createImgWithImage:(UIImage *)image frame:(CGRect)frame;
+ (NSString *)ConvertStrToTime:(NSString *)timeStr;
+(NSString *)convertime:(NSString *)timeStr;
+ (long long)getZiFuChuan:(NSString*)time;
//宽度自适应
+(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;
+(NSString *)messageObjetCode:(NSUInteger)code;
@property (nonatomic,strong)NSMutableArray * marketArrat;

@property (nonatomic,copy)NSString * ktoken;
@end
