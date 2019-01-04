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
@interface HomeTableViewCell : BaseTableViewCell
@property (nonatomic,retain) UILabel *name;
@property (nonatomic,retain) UILabel *code;
@property (nonatomic,retain) UILabel *price;
@property (nonatomic,retain) UILabel *weipanId;
@property (nonatomic,retain) UILabel *outPrice;
@property (nonatomic,retain) UIButton *change;
@property (nonatomic,retain) UIImageView *ico;
@property (nonatomic,assign)float changerate;

-(void)changeChangColorWithOldChang:(NSString*)chang;
-(void)updateCellContent:(MarketModel *)model;

@end
