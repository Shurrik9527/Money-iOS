//
//  LTUtils.h
//  Canary
//
//  Created by litong on 2017/5/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTUtils : NSObject





#define LTAutoW(w)                ((1.0*(w))*(ScreenW_Lit/Lit_iphone6W))
//#define LTAutoW(w)                [LTUtils autowh:w]
#define Lit_autoH(h)                  ((h)*(ScreenH_Lit/Lit_iphone6H))
#define LTRectAutoW(x,y,w,h)    CGRectMake(LTAutoW((x)),LTAutoW((y)),LTAutoW((w)),LTAutoW((h)))
#define LTRectAutoH(x,y,w,h)    CGRectMake(Lit_autoH((x)),Lit_autoH((y)),Lit_autoH((w)),Lit_autoH((h)))

+ (CGFloat)autowh:(CGFloat)w;

/** YES:不隐藏  NO:隐藏 */
+ (BOOL)noHide;


//格式化小数 四舍五入类型 保留2位小数
+ (NSString *)decimal4PWithFormat:(CGFloat)floatValue;
//格式化小数 四舍五入类型 保留4位小数
+ (NSString *)decimal2PWithFormat:(CGFloat)floatValue;
//根据code 格式化小数
+ (NSString *)decimalPriceWithCode:(NSString *)code floatValue:(CGFloat)floatValue;
//根据code 返回精确度
+ (NSString *)pointWithCode:(NSString *)code;
#pragma mark 判空
/*! 是否为空(nil、NULL、[NSNull class]、@"") */
+(BOOL)emptyString:(NSString *)str;
+(BOOL)notEmptyString:(NSString *)str;
+ (BOOL)isNull:(id)obj;
+ (BOOL)isNotNull:(id)obj;

#pragma mark 字符查找、包含
+ (BOOL)searchStr:(NSString *)str isContainStr:(NSString *)subStr;

#pragma mark 页面跳转  Schemes

+ (BOOL)isIxitScheme:(NSString *)str;

#define kSS_register    @"register" //注册
#define kSS_cashin    @"cashin"     // 充值界面
#define kSS_trade    @"trade"       //交易界面
#define kSS_market    @"market"     //看行情界面
#define kSS_share    @"share"       //分享页面
#define kSS_liveList    @"liveList"    //直播

//注册
+ (BOOL)schemeRegister:(NSString *)eqStr;
// 充值界面
+ (BOOL)schemeCashin:(NSString *)eqStr;
//交易界面
+ (BOOL)schemeTrade:(NSString *)eqStr;
//看行情界面
+ (BOOL)schemeMarket:(NSString *)eqStr;
//分享页面
+ (BOOL)schemeShare:(NSString *)eqStr;
//直播
+ (BOOL)schemeLiveList:(NSString *)eqStr;

#pragma mark app信息
/* 项目bundleID */
NSString *identifier_();
/* 项目名称 */
NSString *displayName_();
NSString *shortVersionString_();
NSInteger shortVersionInt_();
NSInteger integerVersion_();

//获取vip等级
+(UIColor *)vipColor:(NSInteger)level;
//手机号码 中间 4个*
+ (NSString *)phoneNumMid4Star;
/** 返回总页数
 allNum 产品个数
 onePageSize 每页显示个数
 如：allNum=108    onePageSize = 20  返回 6
 如：allNum=100    onePageSize = 20  返回 5
 */
+ (NSInteger)pageNumWith:(NSInteger)allNum onePageSize:(NSInteger)onePageSize;


//判断是否为整形：
+ (BOOL)isPureInt:(NSString *)string;
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString *)string;



/**
 *  传入一个view进行旋转
 *
 *  @param rotationView 将要进行旋转的view
 */
+(void)startRotationAnimation:(UIView *)rotationView;
/**
 *  结束旋转动画
 */
+(void)endAnimation:(UIView *)rotationView;



// url添加默认参数
+ (NSString *)urlAddDefaultPrams:(id )url;


+ (NSString *)debugInfo;
#pragma mark - iphone类型4、5、6、6p
+ (NSString *)iphoneType;
#pragma mark - DeviceInfo
+ (NSString *)iphoneDeviceModel;

#pragma mark - 系统
+ (NSString *)appName;
NSString *bundleIdentifier();
NSString *bundleDisplayName();
NSString *bundleShortVersionString();
NSInteger bundleShortVersionInt();
NSInteger bundleIntegerVersion();


#pragma mark - NSUserDefault
//获取设置值
+(NSString *)getSeting:(NSString*)key;
//移除配置
+(void)removeSetingWithKey:(NSString *)key;
//设置默认值
+(void)setSetingDefaultValue;

#pragma mark - market
/**    返回：middletime
 startTime :开始时间; endTime:结束时间
 */
+(NSString *)middleTimeWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
/**    返回：K线中_type对应的时间间隔，单位s
 startTime :开始时间; endTime:结束时间
 */
+(NSInteger)timeNumberWithType:(NSString *)_type;
#pragma mark - 涨跌幅
+(NSString *)changeRateFormat:(NSString*)sellprice ClosePrice:(NSString*)closeprice;
+(NSString *)changeFormat:(NSString*)sellprice ClosePrice:(NSString*)closeprice;
#pragma mark 读取缓存文件夹
+(void)createCacheWithFileName:(NSString*)filename Path:(NSString*)path Content:(NSDictionary*)content;
+(NSDictionary*)readCacheWithFileName:(NSString*)filename Path:(NSString*)path;
+(NSString*)realPathWithFileName:(NSString*)filename Path:(NSString*)path;

#pragma mark 转换为价格
+ (NSString*)priceFormat:(NSString*)price;
#pragma mark - 获取当前时间
+(NSString *)getNowTimeString;
#pragma mark - 获取当前天数
+(NSString *)getNowDayString;
#pragma mark 返回时间段集合
+(NSArray*)changeTimesWithStartTime:(NSString*)starttime MiddleTime:(NSString*)middletime  EndTime:(NSString*)endtime Vertical:(int)vertical;
#pragma mark 返回分钟数
+(CGFloat)changeMinutesWithStartTime:(NSString*)starttime MiddleTime:(NSString*)middletime  EndTime:(NSString*)endtime Vertical:(int)vertical Type:(int)type;

#pragma mark 换算时间
+(NSString*)changeTimestampToCount:(double)time;
+(NSString*)timeformat_monthDay:(double)time;
+(NSString*)timeformat:(double)time;
+(NSString*)timeformat_hourstyle:(double)time;
+(NSString*)timeFormat_ShortHourStyle:(double)time;
+(NSString*)timeformatLong:(double)time;
+(NSString*)timeforMin:(double)time;
+(double)timeformat_shortTime:(NSString *)time;
+(double)timeformat_hourTime:(NSString *)time;
//输入开始时间和第一个数据对应的时间确定时间差
+(double)startTimeSubWithStartTime:(NSString *)start firstP:(double)first;

+(NSDateComponents*)getDateComponents:(NSDate*)date;
+(NSTimeInterval)compareWithTime:(NSDate*)timeOne TimeTow:(NSDate*)timeTow;
//时间yyyy.mm.dd
+(NSString *)dayString:(NSDate*)date;

#pragma mark - common view
//版权图
+ (UIImageView *)copyrightViewWithF:(CGRect)frame;
+(void)drawLineAtSuperView:(UIView*)superView andTopOrDown:(int)type andHeight:(CGFloat)height andColor:(UIColor*)color;
+(void)drawLineAtSuperView:(UIView*)superView andTopOrDown:(int)type andHeight:(CGFloat)height andColor:(UIColor*)color andFrame:(CGRect)frame;
// 画虚线
+ (UIImage*)dottedImageWithStartPoint:(CGPoint)startPoint EndPoint:(CGPoint)endPoint Color:(UIColor *)color Width:(int)width;
#pragma mark - common size
//计算label宽度
+(CGFloat)labelWithFontsize:(CGFloat)fsize text:(NSString *)text;
//计算label高度
+(CGFloat)labHeightWithFontsize:(CGFloat)fsize text:(NSString *)text;//单行
+(CGFloat)labHeightWithWidth:(CGFloat)labW fontsize:(CGFloat)fsize text:(NSString *)text;//限制宽度计算高度

+(CGFloat)getContentWidth:(NSString *)text FontSize:(UIFont *)font;
//subview在window中的位置
+(CGRect)viewFrameInWindow:(UIView *)subV;
#pragma mark - common attrstring
//左右对齐
+(NSMutableAttributedString *)alignmentJustifiedAttr:(NSString *)str maxW:(CGFloat)maxW;
#pragma mark - imagepicker
+ (BOOL)canUseCamera;

#pragma mark - NFC
+(void)NoticePostWithName:(NSString *)name obj:(NSDictionary *)userinfo;

#pragma mark - request
//  hash算法
+ (NSString *)calculateFx168Key:(NSString *)excode Code:(NSString*)code Type:(NSString*)type timeString:(NSString *)timeString;
//  行情数据接口hash地址
+ (NSString*)hashUrlStringWithExcode:(NSString*)excode Code:(NSString*)code Type:(NSString*)type FontUrl:(NSString*)fontUrl;
@end
