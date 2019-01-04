//
//  NewsCellOne.m
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "NewsCellOne.h"

static CGFloat contentTopMar = 15.f;
static CGFloat btmMar = 16.f;
static CGFloat subTopMar = 6.f;
static CGFloat subH = 16.f;


@interface NewsCellOne ()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UILabel *subLab;
@property (nonatomic,strong) UIView *tempLineView;

@end

@implementation NewsCellOne



- (void)createCell {
    
    [self addTopLine];
    
    self.contentLab = [[UILabel alloc] init];
    _contentLab.numberOfLines = 0;
    _contentLab.font = [UIFont autoBoldFontSize:15.f];
    _contentLab.textColor = kNewsBlackColor;
    [self addSubview:_contentLab];
    
    self.titleLab = [[UILabel alloc] init];
    [_titleLab layerRadius:1.f bgColor:kNewsGrayBgColor];
    _titleLab.font = [UIFont autoFontSize:titleFontSize];
    _titleLab.textColor = kNewsGrayColor;
    [_contentLab addSubview:_titleLab];
    
    self.subLab = [[UILabel alloc] init];
    _subLab.font = [UIFont autoFontSize:titleFontSize];
    _subLab.textColor = kNewsGrayColor;
    [self addSubview:_subLab];
    
    self.tempLineView = [[UIView alloc] init];
    _tempLineView.backgroundColor = LTBgColor;
    [self addSubview:_tempLineView];
}




#pragma mark - 外部

- (void)bindData:(NewsModel *)model {
    NSString *title = [model getCellTypeTitle];
    
    _titleLab.text = title;
    
    NSString *content = model.informactionContent;
    NSAttributedString *ABStr = [NewsBaseCell ABStr:title content:content];
    _contentLab.attributedText = ABStr;
    CGSize size = [NewsBaseCell ABStrH:title content:content];
    
    CGFloat contentH = size.height;
//    CGFloat maxContentH = 3*LTAutoW(15.5) + 10;
//    if (contentH > LTAutoW(maxContentH)) {
//        contentH = LTAutoW(maxContentH);
//    }
    
    CGRect rect = CGRectMake(LTAutoW(kLeftMar), LTAutoW(contentTopMar+kNewsTempLineH), [NewsBaseCell contectLabW], contentH);
    _contentLab.frame = rect;
    
    CGSize titleSize = [title boundingSize:CGSizeMake(MAXFLOAT, titleFontSize) font:[UIFont autoFontSize:titleFontSize]];
    _titleLab.frame = CGRectMake(-1, 0, titleSize.width, LTAutoW(19));
    
    NSString *subStr = [NSString stringWithFormat:@"%@ %@",[model time_fmt],model.authorName];
    _subLab.frame = CGRectMake(LTAutoW(kLeftMar), _contentLab.yh_+LTAutoW(subTopMar), _contentLab.w_, LTAutoW(subH));
    _subLab.text = subStr;
    
    CGFloat lineH = LTAutoW(kNewsTempLineH);
    CGRect lineRect = CGRectMake(0, [NewsCellOne cellHWithContent:model] - lineH,ScreenW_Lit, lineH);
    _tempLineView.frame = lineRect;
}


+ (CGFloat)cellHWithContent:(NewsModel *)mo {
    NSString *title = [mo getCellTypeTitle];
    
    CGSize size = [NewsBaseCell ABStrH:title content:mo.informactionContent];
    
    CGFloat contentH = size.height;
//    CGFloat maxContentH = 3*LTAutoW(15.5) + 10;
//    if (contentH > maxContentH) {
//        contentH = maxContentH;
//    }
    
    CGFloat h = contentH + LTAutoW(contentTopMar + subTopMar + subH + btmMar + kNewsTempLineH*2);
    return h;
}

@end
