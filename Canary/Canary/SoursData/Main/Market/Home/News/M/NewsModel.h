//
//  NewsModel.h
//  ixit
//
//  Created by litong on 2016/11/8.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "BaseMO.h"


typedef NS_ENUM(NSUInteger, NewsCellType) {
    NewsCellType_Notice = 1,//公告，
    NewsCellType_MorningLayout = 2,//早间布局，
    NewsCellType_Quotation = 3,//行情预演（带日历）
    NewsCellType_DealChance = 4,//交易机会（专家解读），
    NewsCellType_MorningNews = 5,//早间资讯，
};


@interface NewsModel : BaseMO

@property (nonatomic,strong) NSNumber *informactionId;//data.	Long	资讯编号
@property (nonatomic,strong) NSNumber *informactionType;//NewsCellType
@property (nonatomic,strong) NSNumber *articleId;//Long	文章编号
@property (nonatomic,strong) NSNumber *authorId;//
@property (nonatomic,strong) NSNumber *more;//	int	买涨
@property (nonatomic,strong) NSNumber *less;//	int	买跌
@property (nonatomic,strong) NSNumber *createTime;//Long	创建时间
@property (nonatomic,strong) NSNumber *clickType;//	int	用户支持利多利空（1利多，2利空）
@property (nonatomic,strong) NSNumber *reportTime;//Long	报告时间
@property (nonatomic,assign) NSInteger top;//

@property (nonatomic,strong) NSString *articleUrl;//String文章地址（有文章标号的才有文章地址，文章访问的时候请加userId,informationId,articleId）
@property (nonatomic,strong) NSString *productName;//String	产品名称（油，银，咖啡，美元）
@property (nonatomic,strong) NSString *informactionAbstract;//String	摘要
@property (nonatomic,strong) NSString *informactionContent;//String	内容
@property (nonatomic,strong) NSString *authorPropose;//String专家建议
@property (nonatomic,strong) NSString *authorName;//String	作者名称
@property (nonatomic,strong) NSString *authorHeadPortrait;//
@property (nonatomic,strong) NSString *informactionProduct;//


- (NSString *)getCellTypeTitle;
- (NewsCellType)getCellType;
- (NSString *)time_fmt;
- (NSString *)authorPropose_fmt;
- (UIColor *)titleColor;
- (NSString *)createTimeYMD;
- (NSString *)moreStr;
- (NSString *)lessStr;


+ (NSArray *)objsWithList:(NSArray *)list;


//articleId: null,
//articleUrl: "",
//authorHeadPortrait: "http://t.m.8caopan.com/images/appContent/author/0/0/11/20160401135003622.png",
//authorId: 11,
//authorName: "分析师:一休老师(更多策略和互动可进直播室)",
//authorPropose: "",
//clickType: null,
//createTime: 1477474090000,
//informactionAbstract: "八元操盘",
//informactionContent: "八元操盘",
//informactionId: 10028,
//informactionProduct: "-1",
//informactionType: 1,
//less: null,
//more: null,
//reportTime: null,
//sourceId: 10,
//top: 0


@end
