//
//  QuotationBtn.h
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketModel.h"
#import "SocketModel.h"
#define QuotationBtnH    100.f

/** 单个产品行情 */
@interface QuotationBtn : UIView
@property (nonatomic,strong) UILabel *nameLab;//哈贵油
@property (nonatomic,strong) UILabel *priceLab;//2464.7
@property (nonatomic,strong) UILabel *changeLab;//-10.7  -0.41%
- (void)refData:(MarketModel *)q;

-(void)socketmodel:(SocketModel*)m;
+ (CGFloat)viewH;

+ (CGFloat)viewW;


@end
