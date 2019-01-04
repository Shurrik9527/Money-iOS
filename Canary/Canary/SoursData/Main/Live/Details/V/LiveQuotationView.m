//
//  LiveQuotationView.m
//  ixit
//
//  Created by litong on 2017/4/11.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveQuotationView.h"
#import "Quotation.h"

@interface LiveQuotationView ()
{
    NSInteger arrCount;
    CGFloat labW;
}

@property (nonatomic,strong) UIScrollView *scView;

@end

@implementation LiveQuotationView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTRGB(36, 39, 62);
        [self createView];
    }
    return self;
}


- (void)createView {
    self.scView = [[UIScrollView alloc] init];
    _scView.frame = CGRectMake(0, 0, self.w_, self.h_);
    _scView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scView];
}

#pragma mark - utils

//http请求，重新创建lab
- (void)setPList:(NSArray *)pList {
    _pList = pList;
    
    [self configLabs];
}


- (void)configLabs {
    [_scView removeAllSubView];
    
    arrCount = _pList.count;
    CGFloat singleNum = 3;
    if (arrCount >= singleNum) {
        CGFloat num = (ScreenW_Lit >= Lit_iphone6W) ? 0.5 : 0.3 ;
        singleNum += num;
    } else {
        singleNum = arrCount;
    }

    labW = self.w_/singleNum;
    _scView.contentSize = CGSizeMake(arrCount*labW, self.h_);
    
    NSInteger i = 0;
    CGFloat titleLaby = 4;
    CGFloat titleLabH = 11;
    CGFloat laby = titleLaby + titleLabH + 6;
    CGFloat labH0 = 12;
    for (Quotation *q in _pList) {
        CGFloat labx = i*labW;
        UILabel *titleLab = [self createLab:11];
        titleLab.frame = CGRectMake(labx, titleLaby, labW, titleLabH);
        [_scView addSubview:titleLab];
        titleLab.text = q.productNamed;
        
        UILabel *lab = [self createLab:12];
        lab.frame = CGRectMake(labx, laby, labW, labH0);
        lab.stringTag = q.onlyKey;
        [_scView addSubview:lab];
        [self changeUILabWithObj:q];
 
        i ++;
    }
}


- (void)changeUILabWithObj:(id)obj  {
    
    Quotation *item = (Quotation *)obj;
    if (emptyStr(item.out_price)) {
        return;
    }
    
    NSString *sellTemp = item.out_price;
    NSString *marginTemp = item.change;
    NSString *onlykey = item.onlyKey;
    
    UILabel *lab = (UILabel *)[self viewWithStringTag:onlykey];
    
    if (!lab) {
        return;
    }
    
    NSString *sell = sellTemp ? sellTemp : @"-" ;
    NSString *margin = marginTemp ? marginTemp : @"-";
    UIColor *color = LTKLineGreen;
    
    if ([marginTemp floatValue]>0) {
        color=LTKLineRed;
        margin = [NSString stringWithFormat:@"+%@",marginTemp];
    } else if ([marginTemp floatValue] == 0) {
        color = LTGrayColor;
    }
    
    NSString * sub = [NSString stringWithFormat:@" %@ %@",sell,margin];
    
    lab.text = sub;
    lab.textColor = color;
}

- (UILabel *)createLab:(CGFloat)fs {
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont fontOfSize:fs];
    lab.backgroundColor = self.backgroundColor;
    return lab;
}


#pragma mark - 外部

//长连接行情，刷新油、银价格
- (void)refQuotation:(NSArray *)list {
    for (Quotation *item in list) {
        [self changeUILabWithObj:item];
    }
}


@end
