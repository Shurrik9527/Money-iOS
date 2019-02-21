//
//  MeAssetsView.h
//  Canary
//
//  Created by 孙武东 on 2019/1/5.
//  Copyright © 2019 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MeAssetsView : UITableViewCell

@property (nonatomic, strong)void (^selectActionBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
