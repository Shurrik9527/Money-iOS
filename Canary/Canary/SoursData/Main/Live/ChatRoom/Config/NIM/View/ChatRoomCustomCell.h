//
//  ChatRoomCustomCell.h
//  ixit
//
//  Created by Brain on 2017/4/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NIMMessageModel.h"
typedef NS_ENUM(NSInteger, CustomCellType) {
    CustomCellTypeNone          = 0,
    CustomCellTypeReceiveGift,//收到礼物
    CustomCellTypeLookOrder,//看单
};

@interface ChatRoomCustomCell : UITableViewCell
@property(assign,nonatomic)  BOOL isUserManger;//是否为管理员
@property(strong,nonatomic)UIImageView * iconImg;
@property(strong,nonatomic)UILabel * nickL;
@property(strong,nonatomic)UIView * contentV;
@property(strong,nonatomic)UILabel * contentL;

-(void)configCellWithModel:(NSObject *)model;
+(CustomCellType)cellTypeWithModel:(NSObject *)model;
+(CGFloat)cellHeightWithModel:(NSObject *)model;
@end
