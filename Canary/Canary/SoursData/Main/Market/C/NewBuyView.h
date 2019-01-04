//
//  NewBuyView.h
//  Canary
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "BasePopView.h"
#import "ProductMO.h"
#define kBuyViewH 560
#define kTabH           40
#define kFooterH        50
typedef void(^BuyFinish)();
typedef void (^backBlock)();
typedef void (^TypeBlock)(NSString *typeString);
@interface NewBuyView : BasePopView
@property (nonatomic,copy) BuyFinish buyFinish;
@property (nonatomic,copy) backBlock prensentBlock;
@property (nonatomic,copy) TypeBlock typeBlock;
@property (nonatomic,copy)NSString * code;
@property (nonatomic,copy)NSString * code_cn;
@property (nonatomic,copy)NSString *stops_level;
@property (nonatomic,copy)NSString * closePrice;
@property (nonatomic,copy)NSString * change;
@property (nonatomic,assign)NSInteger  dataly;//小数点位数

- (void)buyType:(BuyType)buyType;

-(void)addCode :(NSString *)code code_cn:(NSString *)code_cn prcieIn:(NSString*)priceI  priceOut:(NSString *)priceOut;
@end

