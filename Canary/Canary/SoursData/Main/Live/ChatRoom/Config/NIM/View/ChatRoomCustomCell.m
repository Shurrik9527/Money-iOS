//
//  ChatRoomCustomCell.m
//  ixit
//
//  Created by Brain on 2017/4/4.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ChatRoomCustomCell.h"

@implementation ChatRoomCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isUserManger=NO;
        self.backgroundColor = LTClearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
#pragma mark - Init View
-(void)createCell{
    if (!_contentV) {
        _contentV=[[UIView alloc]init];
        _contentV.backgroundColor=LTClearColor;
        [self.contentView addSubview:_contentV];
    }
    if (!_contentL) {
        _contentL = [self createLabWithFrame:CGRectMake(0, 0, ScreenW_Lit-32, 44) text:@"" fontsize:LTAutoW(15)];
        [_contentV addSubview:_contentL];
    }
    
    if (!_iconImg) {
        _iconImg=[self createImgViewWithFrame:CGRectMake(0, 0, 20, 20) imageName:@"me_face"];
        _iconImg.hidden=YES;
    }
}

#pragma mark - Utils
-(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title fontsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    return btn;
}
-(UILabel *)createLabWithFrame:(CGRect)frame text:(NSString *)text fontsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentLeft;
    label.numberOfLines=0;
    label.textColor=LTTitleColor;
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
-(UIImageView *)createImgViewWithFrame:(CGRect)frame imageName:(NSString *)image{
    UIImageView *imgv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:image]];
    imgv.frame=frame;
    return imgv;
}
#pragma mark - 外部方法

-(void)configCellWithModel:(NSObject *)model{
//    CustomCellType type = [ChatRoomCustomCell cellTypeWithModel:model];
//    NSString *giftKey=[NSString stringWithFormat:@"gift_%@",model.message.messageId];
//    NSString *giftValue = UD_ObjForKey(giftKey);
//    if (type==1) {//收到礼物type
//        double timeTamp=model.message.timestamp;
//        double nowTamp = [[NSDate date] timeIntervalSince1970];
//        if (fabs(nowTamp-timeTamp)<=20) {
//            NSMutableDictionary *user=[[NSMutableDictionary alloc]initWithDictionary:model.message.remoteExt];
//            if (emptyStr(giftValue)) {
//                UD_SetObjForKey(@"1", giftKey);
//                NSString *senderId=model.message.from;
//                [user setObject:senderId forKey:@"senderId"];
//                NSString *senderName = @"";
//                if([model.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]){
//                    NIMMessageChatroomExtension *chatroomExtension=model.message.messageExt;
//                    senderName=chatroomExtension.roomNickname;
//                }
//                [user setObject:senderName forKey:@"senderName"];
//                NSNotification *notice=[[NSNotification alloc]initWithName:NFC_ReceiveGift object:nil userInfo:user];
//                [[NSNotificationCenter defaultCenter]postNotification:notice];
//            }
//        }else{
//            if (emptyStr(giftValue)) {
//                UD_RemoveForKey(giftKey);
//            }
//        }
//    }else if(type==2){//看单类型
//
//    }
}

+(CustomCellType)cellTypeWithModel:(NSObject *)model{
    CustomCellType type = CustomCellTypeNone;
//    if ([NSObject isNotNull:model.message.remoteExt]) {
//        NSNumber *typeNum=[model.message.remoteExt objectForKey:@"type"];
//        if ([NSObject isNotNull:typeNum]) {
//            type=[typeNum integerValue];
//        }
//    }
    return type;
}
+(CGFloat)cellHeightWithModel:(NSObject *)model {
    CGFloat h=0;
    if ([self cellTypeWithModel:model]==CustomCellTypeLookOrder) {
        //计算看单的高度
    }
    return h;
}
@end
