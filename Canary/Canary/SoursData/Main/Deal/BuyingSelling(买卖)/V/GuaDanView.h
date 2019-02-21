//
//  GuaDanView.h
//  Canary
//
//  Created by 孙武东 on 2019/1/2.
//  Copyright © 2019 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuySellingModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GuaDanView : UIView

@property (nonatomic, assign)BOOL isBuyDown;
@property (nonatomic, assign)BOOL isGuaDan;
@property (nonatomic, strong)BuySellingModel *model;
@property (nonatomic, strong)NSString *priceStr;
@property (nonatomic, strong)void (^retureBuyDic)(NSDictionary *buyDic,BOOL isGuaDan);

- (void)closeView;

@end

NS_ASSUME_NONNULL_END
