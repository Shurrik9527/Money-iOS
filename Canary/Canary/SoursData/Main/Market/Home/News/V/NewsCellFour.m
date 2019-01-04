//
//  NewsCellFour.m
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "NewsCellFour.h"
#import "NewsPercentView.h"

static CGFloat topMar = 13.f;
static CGFloat productLabH = 22.f;
static CGFloat productLabSize = 15.f;
//static CGFloat midViewTopMar = 11.f;
static CGFloat contentTopMar = 13.f;
static CGFloat subContentTopMar = 6.f;
static CGFloat subTopMar = 8.f;
static CGFloat subH = 15.f;
static CGFloat midBtmMar = 8.f;
static CGFloat btmViewH = 40.f;

@interface NewsCellFour ()

@property (nonatomic,strong) UIView * topView;
@property (nonatomic,strong) UILabel *productLab;//银 看多
//@property (nonatomic,strong) UILabel *timeLab;//10:55

@property (nonatomic,strong) UIView * midView;
@property (nonatomic,strong) UILabel *titleLab;//专家解读
@property (nonatomic,strong) UILabel *contentLab;//黄金持续走低，初请向好，白银利多
@property (nonatomic,strong) UILabel *subContentLab;//建议：420附近买涨，目标4000下方，止损20
@property (nonatomic,strong) UILabel *subLab;//一休老师（分析师策略仅供参考）

@property (nonatomic,strong) UIView *btmView;
@property (nonatomic,strong) UILabel *upLab;//38% 用户买涨
@property (nonatomic,strong) UILabel *downLab;//62% 用户买跌
@property (nonatomic,strong)NewsPercentView *percentView;
@property (nonatomic,strong)UIView *btmTopLineView;

@property (nonatomic,strong) UIView *tempLineView;

@end

@implementation NewsCellFour

#pragma mark - 内部

- (void)createCell {
    [self addTopLine];
    [self createTopView];
    [self createMidView];
    [self createBtmView];
    
    self.tempLineView = [[UIView alloc] init];
//    _tempLineView.backgroundColor = LTBgColor;
    [self addSubview:_tempLineView];

}

- (void)createTopView {
    CGFloat topViewH = topMar + productLabH;
    self.topView = [[UIView alloc] init];
    _topView.frame = CGRectMake(0, LTAutoW(kNewsTempLineH), ScreenW_Lit, LTAutoW(topViewH));
    [self addSubview:_topView];
    
    self.productLab = [[UILabel alloc] init];
    _productLab.frame = CGRectMake(LTAutoW(kLeftMar), LTAutoW(topMar), _topView.w_*2/3, LTAutoW(productLabH));
    _productLab.font = [UIFont autoBoldFontSize:productLabSize];
    _productLab.textColor = LTBlackColor;
    [_topView addSubview:_productLab];
    
}

- (void)createMidView {
    self.midView = [[UIView alloc] init];
    [self addSubview:_midView];
    
    
    self.contentLab = [[UILabel alloc] init];
    _contentLab.numberOfLines = 0;
    _contentLab.font = [UIFont autoBoldFontSize:15.f];
    _contentLab.textColor = kNewsBlackColor;
    [_midView addSubview:_contentLab];
   
    self.titleLab = [[UILabel alloc] init];
    [_titleLab layerRadius:1.f bgColor:LTBgColor];
    _titleLab.font = [UIFont autoFontSize:titleFontSize];
    _titleLab.textColor = LTSubTitleColor;
    [_contentLab addSubview:_titleLab];
    
    
    self.subContentLab = [[UILabel alloc] init];
    _subContentLab.numberOfLines = 0;
    _subContentLab.font = [UIFont autoFontSize:14.f];
    _subContentLab.textColor = kNewsBlackColor;
    [_midView addSubview:_subContentLab];
    
    
    self.subLab = [[UILabel alloc] init];
    _subLab.font = [UIFont autoFontSize:titleFontSize];
    _subLab.textColor = LTSubTitleColor;
    [_midView addSubview:_subLab];
}

- (void)createBtmView {
    self.btmView = [[UIView alloc] init];
    [self addSubview:_btmView];
    
    self.btmTopLineView = [[UIView alloc] init];
    _btmTopLineView.backgroundColor = LTLineColor;
    _btmTopLineView.frame = CGRectMake(0, 0, ScreenW_Lit, 0.5);
    [_btmView addSubview:_btmTopLineView];
    
    CGFloat labW = (ScreenW_Lit - LTAutoW(kNewsPercentViewW + 2*kLeftMar))/2;
    self.upLab = [[UILabel alloc] init];
    _upLab.frame = CGRectMake(LTAutoW(kLeftMar), 0, labW, LTAutoW(btmViewH));
    _upLab.textColor = LTKLineRed;
    _upLab.font = [UIFont autoFontSize:12.f];
    [_btmView addSubview:_upLab];
    
    self.downLab = [[UILabel alloc] init];
    _downLab.frame = CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar) - labW, 0, labW, LTAutoW(btmViewH));
    _downLab.textColor = LTKLineGreen;
    _downLab.font = [UIFont autoFontSize:12.f];
    _downLab.textAlignment = NSTextAlignmentRight;
    [_btmView addSubview:_downLab];
    
    CGRect pr = CGRectMake(LTAutoW(kLeftMar) + labW, LTAutoW((btmViewH - kNewsPercentViewH)/2.0), LTAutoW(kNewsPercentViewW), LTAutoW(kNewsPercentViewH));
    self.percentView = [[NewsPercentView alloc] initWithFrame:pr];
    [_btmView addSubview:_percentView];
    
}

+ (NSAttributedString *)ABSubContent:(NSString *)content {
    return [content ABStrSpacing:3.f font:[UIFont autoFontSize:14.f]];
}

+ (CGSize)ABSubContentH:(NSString *)content {
    NSAttributedString *ABStr = [NewsCellFour ABSubContent:content];
    CGFloat w = [NewsBaseCell contectLabW];
    CGSize size = [ABStr boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return size;
}

#pragma mark - 外部

#pragma mark - 交易机会数据模型赋值
- (void)setChanceModel:(ChanceModel *)chanceModel{
    //topview  参数赋值
    NSString *pName = chanceModel.name;
    NSString *upOrDown = chanceModel.trend;
    NSInteger udCount = upOrDown.length;
    UIColor *pColor = [UIColor redColor];
    NSString *p = [NSString stringWithFormat:@"%@ %@",pName,upOrDown];
    NSAttributedString *ABStr_p = [p ABStrColor:pColor range:NSMakeRange(p.length - udCount, udCount)];
    _productLab.attributedText = ABStr_p;
    //    _timeLab.text = [model time_fmt];
    
    
    //midView
    NSString *title =chanceModel.type;
    _titleLab.text = title;
    
    NSString *content = chanceModel.title;
    NSAttributedString *ABStr = [NewsBaseCell ABStr:title content:content];
    _contentLab.attributedText = ABStr;
    CGSize size = [NewsBaseCell ABStrH:title content:content];
    
    CGFloat contentH = size.height;
    //    CGFloat maxContentH = 3*LTAutoW(15) + 10;
    //    if (contentH > maxContentH) {
    //        contentH = maxContentH;
    //    }
    
    CGRect rect = CGRectMake(LTAutoW(kLeftMar), LTAutoW(contentTopMar), [NewsBaseCell contectLabW], contentH);
    _contentLab.frame = rect;
    CGSize titleSize = [title boundingSize:CGSizeMake(MAXFLOAT, titleFontSize) font:[UIFont autoFontSize:titleFontSize]];
    _titleLab.frame = CGRectMake(-1, 0, titleSize.width, LTAutoW(19));
    
    
    NSString *subConten =[NSString stringWithFormat:@"建议: %@",chanceModel.suggest];
    NSAttributedString *ABStr_sub = [NewsCellFour ABSubContent:subConten];
    _subContentLab.attributedText = ABStr_sub;
    CGSize size_sub = [NewsCellFour ABSubContentH:subConten];
    CGRect rect_sub = CGRectMake(LTAutoW(kLeftMar), _contentLab.yh_ + LTAutoW(subContentTopMar), [NewsBaseCell contectLabW], size_sub.height);
    _subContentLab.frame = rect_sub;
    
    //    NSString *subStr = model.authorName;
    //    _subLab.frame = CGRectMake(LTAutoW(kLeftMar), _subContentLab.yh_+LTAutoW(subTopMar), [NewsBaseCell contectLabW], LTAutoW(subH));
    //    _subLab.text = subStr;
    
    NSString *subStr = [NSString stringWithFormat:@"%@  %@",chanceModel.time,chanceModel.trend];
    _subLab.frame = CGRectMake(LTAutoW(kLeftMar), _subContentLab.yh_+LTAutoW(subTopMar), [NewsBaseCell contectLabW], LTAutoW(subH));
    _subLab.text = subStr;
    
    _midView.frame = CGRectMake(0, _topView.yh_, ScreenW_Lit, _subLab.yh_+LTAutoW(midBtmMar));
    
    
    _btmView.frame = CGRectMake(0, _midView.yh_, ScreenW_Lit, LTAutoW(btmViewH));
    NSInteger more = [chanceModel.range integerValue];
    NSInteger less = 100 - [chanceModel.range integerValue];
    CGFloat morePer = 100.0*more/(more + less);
    CGFloat lessPer = 100-morePer;
    
    NSString *upStr = [NSString stringWithFormat:@"%.0f%%用户买涨",morePer];
    NSString *downStr = [NSString stringWithFormat:@"%.0f%% 用户买跌",lessPer];;
    _upLab.text = upStr;
    _downLab.text = downStr;
    [_percentView setUpValue:morePer/100.0];
    
    
    CGFloat lineH = LTAutoW(kNewsTempLineH);
    CGRect lineRect = CGRectMake(0, 10 - lineH,ScreenW_Lit, lineH);
    _tempLineView.frame = lineRect;
}

//- (void)bindData:(NewsModel *)model {
//
//    //topview
//    NSString *pName = model.informactionProduct;
//    NSString *upOrDown = model.informactionAbstract;
//    NSInteger udCount = upOrDown.length;
//    UIColor *pColor = [model titleColor];
//    NSString *p = [NSString stringWithFormat:@"%@ %@",pName,upOrDown];
//    NSAttributedString *ABStr_p = [p ABStrColor:pColor range:NSMakeRange(p.length - udCount, udCount)];
//    _productLab.attributedText = ABStr_p;
////    _timeLab.text = [model time_fmt];
//
//
//    //midView
//    NSString *title = [model getCellTypeTitle];
//    _titleLab.text = title;
//
//    NSString *content = model.informactionContent;
//    NSAttributedString *ABStr = [NewsBaseCell ABStr:title content:content];
//    _contentLab.attributedText = ABStr;
//    CGSize size = [NewsBaseCell ABStrH:title content:content];
//
//    CGFloat contentH = size.height;
////    CGFloat maxContentH = 3*LTAutoW(15) + 10;
////    if (contentH > maxContentH) {
////        contentH = maxContentH;
////    }
//
//    CGRect rect = CGRectMake(LTAutoW(kLeftMar), LTAutoW(contentTopMar), [NewsBaseCell contectLabW], contentH);
//    _contentLab.frame = rect;
//    CGSize titleSize = [title boundingSize:CGSizeMake(MAXFLOAT, titleFontSize) font:[UIFont autoFontSize:titleFontSize]];
//    _titleLab.frame = CGRectMake(-1, 0, titleSize.width, LTAutoW(19));
//
//
//    NSString *subConten = [model authorPropose_fmt];
//    NSAttributedString *ABStr_sub = [NewsCellFour ABSubContent:subConten];
//    _subContentLab.attributedText = ABStr_sub;
//    CGSize size_sub = [NewsCellFour ABSubContentH:subConten];
//    CGRect rect_sub = CGRectMake(LTAutoW(kLeftMar), _contentLab.yh_ + LTAutoW(subContentTopMar), [NewsBaseCell contectLabW], size_sub.height);
//    _subContentLab.frame = rect_sub;
//
////    NSString *subStr = model.authorName;
////    _subLab.frame = CGRectMake(LTAutoW(kLeftMar), _subContentLab.yh_+LTAutoW(subTopMar), [NewsBaseCell contectLabW], LTAutoW(subH));
////    _subLab.text = subStr;
//
//    NSString *subStr = [NSString stringWithFormat:@"%@ %@",[model time_fmt],model.authorName];
//    _subLab.frame = CGRectMake(LTAutoW(kLeftMar), _subContentLab.yh_+LTAutoW(subTopMar), [NewsBaseCell contectLabW], LTAutoW(subH));
//    _subLab.text = subStr;
//
//    _midView.frame = CGRectMake(0, _topView.yh_, ScreenW_Lit, _subLab.yh_+LTAutoW(midBtmMar));
//
//
//    _btmView.frame = CGRectMake(0, _midView.yh_, ScreenW_Lit, LTAutoW(btmViewH));
//
//    NSInteger more = [model.more integerValue];
//    NSInteger less = [model.less integerValue];
//    CGFloat morePer = 100.0*more/(more + less);
//    CGFloat lessPer = 100-morePer;
//
//    NSString *upStr = [NSString stringWithFormat:@"%.0f%%用户买涨",morePer];
//    NSString *downStr = [NSString stringWithFormat:@"%.0f%% 用户买跌",lessPer];;
//    _upLab.text = upStr;
//    _downLab.text = downStr;
//    [_percentView setUpValue:morePer/100.0];
//
//
//    CGFloat lineH = LTAutoW(kNewsTempLineH);
//    CGRect lineRect = CGRectMake(0, [NewsCellFour cellHWithContent:model] - lineH,ScreenW_Lit, lineH);
//    _tempLineView.frame = lineRect;
//}

//+ (CGFloat)cellHWithContent:(NewsModel *)mo {
//
//    CGFloat topVH = LTAutoW(topMar + productLabH);
//    CGFloat btmVH = LTAutoW(btmViewH);
//
//    NSString *title = [mo getCellTypeTitle];
//    CGSize size = [NewsBaseCell ABStrH:title content:mo.informactionContent];
//    CGSize subSize = [NewsCellFour ABSubContentH:[mo authorPropose_fmt]];
//
//    CGFloat contentH = size.height;
////    CGFloat maxContentH = 3*LTAutoW(15) + 10;
////    if (contentH > maxContentH) {
////        contentH = maxContentH;
////    }
//
//    CGFloat midVH = contentH + subSize.height + LTAutoW(contentTopMar + subContentTopMar + subTopMar + subH + midBtmMar);
//
//    return topVH + midVH + btmVH + LTAutoW(kNewsTempLineH*2);
//}

@end
