//
//  ChatRoomTextCell.m
//  ixit
//
//  Created by Brain on 2017/3/24.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "ChatRoomTextCell.h"
#import "UIImageView+LTWebCache.h"
//#import "NIMKitUtil.h"
//#import <NIMSDK/nimutil>

//#import "NIMInputEmoticonParser.h"
//#import "NIMInputEmoticonManager.h"
//#import "NIMSDK.h"
#import "NTESGlobalMacro.h"
//#import "NIMKit.h"
#import "NSString+RE_.h"

#define linePading 16
@implementation ChatRoomTextCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isUserManger=NO;
        self.backgroundColor = LTClearColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCell];
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
#pragma mark - privite
- (void)setAvatarByMessage:(NIMMessage *)message
{
//    NIMKitInfo *info = [[NIMKit sharedKit] infoByUser:message.from
//                                          withMessage:message];
//    NSURL *url = info.avatarUrlString ? [NSURL URLWithString:info.avatarUrlString] : nil;
//    [self.iconImg sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"me_face"]];
}
-(void)reloadFrameWithType:(CellType)type{
    
}
+(NSMutableAttributedString *)attributedStringWithNick:(NSString *)nick vip:(NSInteger)vipLevel message:(NSString *)msg isManger:(BOOL)isManger isSelf:(BOOL)isSelf  {
    UIColor *nickColor = LTSubTitleColor;
    UIColor *msgColor = LTTitleColor;
    nick=[nick replacStr:@"\n" withStr:@""];

    NSUInteger asciiLength = 0;
    NSInteger nickLength=0;
    for (NSUInteger i = 0; i < nick.length; i++) {
        unichar uc = [nick characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
        nickLength=i+1;
        if (asciiLength>=16) {
            break;
        }
    }
    nick = [nick substringWithRange:NSMakeRange(0, nickLength)];
    if ([nick is_PhoneNumber]) {
        NSRange range = NSMakeRange(4, 4);
        nick = [nick stringByReplacingCharactersInRange:range withString:@"****"];
    }
    if (isSelf) {
        nickColor=BlueLineColor;
        msgColor=BlueLineColor;
    }
    vipLevel=vipLevel>7?7:vipLevel;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
    NSString *brStr=@"";
    if (!isManger){
        if (vipLevel!=-1) {
            NSString *vipImgeName=[NSString stringWithFormat:@"live_level_v%li",vipLevel];
            NSTextAttachment *vipAttach = [[NSTextAttachment alloc] init];
            vipAttach.image = [UIImage imageNamed:vipImgeName];
            vipAttach.bounds = CGRectMake(0, 0, 18, 12);
            NSAttributedString *vipAttachString = [NSAttributedString attributedStringWithAttachment:vipAttach];
            [string appendAttributedString:vipAttachString];
            brStr=@" ";
        }
    }else {
        // 创建管理员图片附件
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"v2"];
        attach.bounds = CGRectMake(0, -2, 17, 17);
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        [string appendAttributedString:attachString];
        nickColor = BlueLineColor;
        brStr=@" ";
    }
    NSString *nickS=[NSString stringWithFormat:@"%@%@",brStr,nick];
    NSMutableAttributedString *nickNameAttr = [[NSMutableAttributedString alloc] initWithString:nickS];
    // 设置LTTitleColor
    [nickNameAttr addAttribute:NSForegroundColorAttributeName value:nickColor range:NSMakeRange(0, nickS.length)];
    [string appendAttributedString:nickNameAttr];
    
    NSMutableAttributedString *nickAttr =[[NSMutableAttributedString alloc] initWithString:@"："];
    [nickAttr addAttribute:NSForegroundColorAttributeName value:nickColor range:NSMakeRange(0, 1)];
    [string appendAttributedString:nickAttr];

    //解析msg
    msg=[msg replacStr:@"\n" withStr:@""];
    if (!isManger) {
        msg=msg.legalString;
    }
    NSArray *tokens;
//    [[NIMInputEmoticonParser currentParser] tokens:msg];
//    for (NIMInputTextToken *token in tokens)
//    {
//        if (token.type == NIMInputTokenTypeEmoticon)
//        {
//            NIMInputEmoticon *emoticon = [[NIMInputEmoticonManager sharedManager] emoticonByTag:token.text];
//            UIImage *image = [UIImage imageNamed:emoticon.filename];
//            if (image)
//            {
//                NSTextAttachment *attach = [[NSTextAttachment alloc] init];
//                attach.image =image;
//                attach.bounds = CGRectMake(0, -2, image.size.width/2.0, image.size.height/2.0);
//                NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
//                [string appendAttributedString:attachString];
//            }
//        }
//        else
//        {
//            NSString *text = token.text;
//            NSMutableAttributedString *msgAttr =[[NSMutableAttributedString alloc] initWithString:text];
//            [msgAttr addAttribute:NSForegroundColorAttributeName value:msgColor range:NSMakeRange(0, text.length)];
//            [string appendAttributedString:msgAttr];
//        }
//    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 2.f;
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:LTAutoW(15)] range:NSMakeRange(0, string.length)];

    return string;
}
#pragma mark - 外部方法
-(void)configCellWithModel:(NSObject *)model Type:(CellType)type {
//    if (type == CellType_Text_NickAndMsg) {
//        if (model.message.messageType==NIMMessageTypeText) {
//            NSString *nickStr=[NIMKitUtil showNick:model.message.from inMessage:model.message];
//            _isUserManger=[NIMKitUtil isManger:model.message.from inMessage:model.message];
//            NSString *msgStr=model.message.text;
//            NSInteger vip=[[self class] getVipStrWithModel:model];//获取vip等级
//
//            NSMutableAttributedString *attr=[ChatRoomTextCell attributedStringWithNick:nickStr vip:vip  message:msgStr isManger:_isUserManger isSelf:!model.shouldShowLeft];
//            _contentL.attributedText=attr;
//            CGSize size = [_contentL sizeThatFits:CGSizeMake(_contentL.w_, MAXFLOAT)];
//            _contentL.frame=CGRectMake(16, 8, ScreenW_Lit-32, size.height);
//            _contentV.frame=CGRectMake(0, 0, ScreenW_Lit, _contentL.h_+linePading);
//            attr=nil;
//        }
//    }
}
+(NSInteger )getVipStrWithModel:(NSObject *)model {
    NSInteger vip=1;
//    if (!model.shouldShowLeft) {
//        vip=[[LTUser userVipLv] integerValue];
//    }else {
//        if([model.message.messageExt isKindOfClass:[NIMMessageChatroomExtension class]]){
//            NIMMessageChatroomExtension *chatroomExtension=model.message.messageExt;
//            NSDictionary *roomExt=[chatroomExtension.roomExt jsonStringToDictonary];
//            NSNumber *level = [roomExt numberFoKey:@"levelNum"];
//            if (level) {
//                vip = [level integerValue];
//            }else {
//                vip=-1;
//            }
//        }
//    }
    return vip;
}
+(CGFloat)cellHeightWithModel:(NSObject *)model{
    CGFloat h=0;
//    if (model.message.messageType==NIMMessageTypeText) {
//        NSString *nickStr=[NIMKitUtil showNick:model.message.from inMessage:model.message];
//        BOOL _isUserManger=[NIMKitUtil isManger:model.message.from inMessage:model.message];
//        NSString *msgStr=model.message.text;
//        NSInteger vip = [self getVipStrWithModel:model];
//        NSMutableAttributedString *attr=[[self class] attributedStringWithNick:nickStr vip:vip  message:msgStr isManger:_isUserManger isSelf:!model.shouldShowLeft];
//
//        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, ScreenW_Lit-32, 1000)];
//        lab.font=[UIFont systemFontOfSize:LTAutoW(15)];
//        lab.attributedText = attr;
//        lab.numberOfLines = 0;
//        CGSize labSize = [lab sizeThatFits:lab.bounds.size];
//
//        h=labSize.height+linePading;
//        lab=nil;
//    }
    return h;
}

@end
