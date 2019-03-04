//
//  BuySellingModel.h
//  Canary
//
//  Created by 孙武东 on 2019/1/7.
//  Copyright © 2019 litong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuySellingModel : NSObject

@property (nonatomic, strong)NSString *entryOrders;
@property (nonatomic, strong)NSString *id;
@property (nonatomic, assign)CGFloat quantityCommissionCharges;
@property (nonatomic, assign)CGFloat quantityOne;
@property (nonatomic, strong)NSString *quantityOvernightFee;
@property (nonatomic, assign)CGFloat quantityPriceFluctuation;
@property (nonatomic, assign)CGFloat quantityThree;
@property (nonatomic, assign)CGFloat quantityTwo;
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, strong)NSString *symbolCode;
@property (nonatomic, strong)NSString *symbolName;
@property (nonatomic, strong)NSString *symbolShow;
@property (nonatomic, assign)NSInteger symbolType;
@property (nonatomic, assign)CGFloat unitPriceOne;
@property (nonatomic, assign)CGFloat unitPriceThree;
@property (nonatomic, assign)CGFloat unitPriceTwo;
@property (nonatomic, strong)NSString *close;
@property (nonatomic, strong)NSString *minPrice;
@property (nonatomic, strong)NSString *maxPrice;
@property (nonatomic, strong)NSString *open;
@property (nonatomic, strong)NSString *price;
@property (nonatomic, strong)NSString *presentPrice;

@end

NS_ASSUME_NONNULL_END
