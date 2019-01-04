//
//  ChatRoomTextCell.h
//  ixit
//
//  Created by Brain on 2017/3/24.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NIMMessageModel.h"
#import <NIMSDK/NIMMessage.h>

typedef NS_ENUM(NSInteger, CellType) {
    CellType_Text_Default          = 0,
    CellType_Text_NickAndMsg,
    CellType_Image,
    CellType_Audio,
};

@interface ChatRoomTextCell : UITableViewCell
@property(assign,nonatomic)  BOOL isUserManger;//是否为管理员
@property(strong,nonatomic)UIImageView * iconImg;
@property(strong,nonatomic)UILabel * nickL;
@property(strong,nonatomic)UIView * contentV;
@property(strong,nonatomic)UILabel * contentL;
-(void)configCellWithModel:(NSObject *)model Type:(CellType)type;

+(CGFloat)cellHeightWithModel:(NSObject *)model;
+(NSMutableAttributedString *)attributedStringWithNick:(NSString *)nick vip:(NSInteger)vipLevel message:(NSString *)msg isManger:(BOOL)isManger isSelf:(BOOL)isSelf;
@end
