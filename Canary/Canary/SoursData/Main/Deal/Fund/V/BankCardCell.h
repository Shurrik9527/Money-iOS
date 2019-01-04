//
//  BankCardCell.h
//  Canary
//
//  Created by litong on 2017/6/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankCarkMO.h"

#define kBankCardCellH  60

typedef NS_ENUM(NSUInteger, BankCardCellType) {
    BankCardCellType_Non,
    BankCardCellType_AddCard,
    BankCardCellType_UnBind,
    BankCardCellType_Select,
};

@protocol BankCardCellDelegate <NSObject>

@optional
- (void)unBindCard:(BankCarkMO *)mo;
- (void)selectCard:(BankCarkMO *)mo;

@end

@interface BankCardCell : UITableViewCell

@property (nonatomic,assign) BankCardCellType typ;
@property (nonatomic,assign) id<BankCardCellDelegate> delegate;
- (void)bindData:(BankCarkMO *)mo;
- (void)selectCell:(BOOL)selected;

@end
