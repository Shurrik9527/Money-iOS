//
//  ProductSingeView.h
//  ixit
//
//  Created by litong on 2017/3/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Quotation.h"

#define ProductSingeViewW    104
#define ProductSingeViewH     63


typedef void(^ProductSingeBlock)(Quotation *q);


@interface ProductSingeView : UIView

@property (nonatomic,strong) Quotation *quotation;
@property (nonatomic,copy) ProductSingeBlock productSingeBlock;



@end
