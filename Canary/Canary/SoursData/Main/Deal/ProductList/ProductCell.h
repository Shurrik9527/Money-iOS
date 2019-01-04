//
//  ProductCell.h
//  Canary
//
//  Created by litong on 2017/5/26.
//  Copyright © 2017年 litong. All rights reserved.
//
//  产品列表cell

#import <UIKit/UIKit.h>
#import "ProductMO.h"

typedef void(^BuyProductBlock)(ProductMO *mo, BOOL buyUp);

@interface ProductCell : UITableViewCell

@property (nonatomic,copy) BuyProductBlock buyProductBlock;

- (void)bindData:(ProductMO *)mo;
- (void)questionBgAction;
+ (CGFloat)cellH;

@end
