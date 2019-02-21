//
//  HomeTableViewCell.h
//  FMStock
//
//  Created by dangfm on 15/4/30.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "QuotationCellModel.h"
#import "MarketModel.h"
#import "BuySellingModel.h"
@interface HomeTableViewCell : BaseTableViewCell
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *code;
@property (nonatomic, strong) UILabel *price;
//@property (nonatomic, strong) UILabel *weipanId;
@property (nonatomic, strong) UIButton *change;
@property (nonatomic, strong) UIImageView *ico;
@property (nonatomic, assign)float changerate;

//- (void)changeChangColorWithOldChang:(NSString*)chang;

- (void)updateCellContent:(MarketModel *)model;

- (void)updateCellContent1:(BuySellingModel *)model;

@end
