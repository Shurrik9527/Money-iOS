//
//  NewsCellThree.m
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "NewsCellThree.h"



static CGFloat titleLabTopMar = 12.f;
static CGFloat titleLabH = 22.f;

static CGFloat subLabTopMar = 6.f;

static CGFloat btmViewTopMar = 20.f;
static CGFloat btmViewBtmMar = 24.f;

@interface NewsCellThree ()

@property (nonatomic,strong) NewsModel *mo;
@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *subLab;
@property (nonatomic,strong) CountDownView *timeView;
@property (nonatomic,strong) UIView *btmView;
@property (nonatomic,strong) SupportView *moreView;
@property (nonatomic,strong) SupportView *lessView;
@property (nonatomic,strong) UIView *tempLineView;

@property (nonatomic,strong) NSIndexPath *iPath;

@end

@implementation NewsCellThree



- (void)createCell {
    
    [self addTopLine];
    
    self.titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(LTAutoW(kLeftMar), LTAutoW(titleLabTopMar+kNewsTempLineH), [NewsBaseCell contectLabW] - LTAutoW(CountDownViewW+6), titleLabH);
    _titleLab.textColor = kNewsBlackColor;
    _titleLab.font = [UIFont autoBoldFontSize:15.f];
    [self addSubview:_titleLab];
    
    self.subLab = [[UILabel alloc] init];
    _subLab.textColor = kNewsGrayColor;
    _subLab.numberOfLines = 0;
    [self addSubview:_subLab];
    
    self.timeView = [[CountDownView alloc] initWithFrame:CGRectMake(_titleLab.xw_, LTAutoW(6.f), LTAutoW(CountDownViewW), LTAutoW(CountDownViewH))];
    [self addSubview:_timeView];
    
    self.btmView = [[UIView alloc] init];
    [self addSubview:_btmView];
    
    self.moreView = [[SupportView alloc] initWithFrame:CGRectMake(0, 0, ScreenW_Lit/2.0, LTAutoW(SupportViewH))];
    _moreView.supportType = SupportType_more;
    [_btmView addSubview:_moreView];
    [_moreView addLineRight:LTLineColor];

    self.lessView = [[SupportView alloc] initWithFrame:CGRectMake(_moreView.xw_, 0, ScreenW_Lit/2.0, LTAutoW(SupportViewH))];
    _lessView.supportType = SupportType_less;
    [_btmView addSubview:_lessView];
    
    
    self.tempLineView = [[UIView alloc] init];
    _tempLineView.backgroundColor = LTBgColor;
    [self addSubview:_tempLineView];
    

}


+ (NSAttributedString *)ABSubContent:(NSString *)content {
    return [content ABStrSpacing:3.f font:[UIFont autoFontSize:12.f]];
}

+ (CGSize)ABSubContentH:(NSString *)content {
    NSAttributedString *ABStr = [self ABSubContent:content];
    CGFloat w = [NewsBaseCell contectLabW];
    CGSize size = [ABStr boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return size;
}

#pragma mark - 外部

- (void)bindData:(NewsModel *)model indexPath:(NSIndexPath *)indexPath {
    _mo = model;
    _iPath = indexPath;
    
    _titleLab.text = model.informactionAbstract;
    
    NSString *content = model.informactionContent;
    NSAttributedString *ABStr = [NewsCellThree ABSubContent:content];
    CGSize size = [NewsCellThree ABSubContentH:content];
    
    CGFloat contentH = size.height;
//    if (contentH > LTAutoW(42)) {
//        contentH = LTAutoW(42);
//    }
    
    CGRect rect = CGRectMake(LTAutoW(kLeftMar), _titleLab.yh_ + LTAutoW(subLabTopMar), [NewsBaseCell contectLabW], contentH);
    _subLab.frame = rect;
    _subLab.attributedText = ABStr;
    
    
    _timeView.iPath = _iPath;
    [_timeView refTimeInterval:[model.reportTime doubleValue]];
    
    _btmView.frame = CGRectMake(0, _subLab.yh_ + LTAutoW(btmViewTopMar), ScreenW_Lit, SupportViewH);
    [_moreView refData:model indexPath:indexPath];
    [_lessView refData:model indexPath:indexPath];
    
    
    CGFloat lineH = LTAutoW(kNewsTempLineH);
    CGRect lineRect = CGRectMake(0, [NewsCellThree cellHWithContent:model] - lineH,ScreenW_Lit, lineH);
    _tempLineView.frame = lineRect;
}

- (void)refCell:(NewsModel *)mo {
    NSString *oid = [NSString stringWithFormat:@"%@",mo.informactionId];
    NSString *moid = [NSString stringWithFormat:@"%@",_mo.informactionId];
    if ([oid isEqualToString:moid]) {
        [_moreView refView:mo];
        [_lessView refView:mo];
    }
    
}


+ (CGFloat)cellHWithContent:(NewsModel *)mo {
    CGSize size = [NewsCellThree ABSubContentH:mo.informactionContent];
    
    CGFloat contentH = size.height;
//    if (contentH > LTAutoW(42)) {
//        contentH = LTAutoW(42);
//    }
    
    CGFloat h = contentH + LTAutoW(titleLabTopMar + titleLabH + subLabTopMar + btmViewTopMar + SupportViewH + btmViewBtmMar + kNewsTempLineH*2);
    return h;
}

@end
