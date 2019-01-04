//
//  SelectProductView.h
//  ixit
//
//  Created by litong on 2017/3/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BasePopView.h"
#import "BuyView.h"
#import "Quotation.h"

@protocol SelectProductViewDelegate <NSObject>

- (void) buyUp:(BOOL)buyUp;

@end


/**  请选择交易产品  */
@interface SelectProductView : BasePopView

@property (nonatomic,assign) id<SelectProductViewDelegate> delegate;

- (instancetype)initWithContentH:(CGFloat)h;
- (void)configDatas:(NSArray *)datas;

@end
