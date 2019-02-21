//
//  MyAssetsView.h
//  Canary
//
//  Created by 孙武东 on 2019/2/18.
//  Copyright © 2019 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAssetsView : UIView

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UILabel *yue;

@property (nonatomic, strong)dispatch_block_t assetsBlock;
@property (nonatomic, strong)dispatch_block_t withdrawalBlock;

@end

NS_ASSUME_NONNULL_END
