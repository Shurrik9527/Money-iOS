//
//  SessionReplayContentView.m
//  ixit
//
//  Created by Brain on 2016/12/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "SessionReplayContentView.h"
#import "NTESSessionUtil.h"
#import "UIView+NTES.h"
#import "M80AttributedLabel.h"
//#import "NIMKitUtil.h"
#import "SessionReplayAttachment.h"
//#import "NIMSDK.h"
#import "NTESGlobalMacro.h"
//#import "NIMKit.h"
#import "NSObject+LT.h"

@interface SessionReplayContentView()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) NSMutableDictionary * jsonDic;
@property(assign,nonatomic)NSInteger select;

@end

@implementation SessionReplayContentView
#define BtnHeight 30
-(instancetype)initSessionMessageContentView
{
//    if (self = [super initSessionMessageContentView]) {
//        _select=-1;//记录一级选中下标。为-1时表示缩起。
//        _textLabel = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
//        _textLabel.numberOfLines = 0;
//        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        _textLabel.font = [UIFont systemFontOfSize:Message_Font_Size];
//        _textLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:_textLabel];
//
//    }
    return self;
}

- (void)refresh:(NSObject *)data{
//    [super refresh:data];
////    NSString *text;
//    if (data.message.messageType == NIMMessageTypeCustom) {
//        NIMCustomObject *object = data.message.messageObject;
//        SessionReplayAttachment * attachment =(SessionReplayAttachment *)object.attachment;
//        if ([attachment respondsToSelector:@selector(formatedMessage)]) {
//            //获取到数据
//            _jsonDic=[attachment messageDic];
//            //根据数据生成view
//            [self configView];
//        }
//    }
//    [_textLabel setText:text];
//    if (!data.message.isOutgoingMsg) {
//        _textLabel.textColor = [UIColor blackColor];
//    }else{
//        _textLabel.textColor = [UIColor whiteColor];
//    }
//    UIEdgeInsets contentInsets = self.model.contentViewInsets;
//    CGSize contentSize = self.model.contentSize;
    CGFloat customWhiteBorardMessageImageRightToText = 5.f;
//    CGRect labelFrame = CGRectMake(self.imageView.right + customWhiteBorardMessageImageRightToText*2, contentInsets.top, contentSize.width, contentSize.height);
//    self.textLabel.frame = labelFrame;

}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"size.y=%.2f size.height=%.2f",self.y_,self.height);
}
-(void)configView{
    NSLog(@"jsonDic === %@",_jsonDic);
    NSString *str=@"";
    if (_jsonDic) {
        str = [_jsonDic objectForKey:@"msg"];
        NSArray *arr = [_jsonDic arrayFoKey:@"keyArr"];
        if (arr) {
            if (arr.count>0) {
                str = [NSString stringWithFormat:@"%@\n-----------------------",str];
            }
            for (UIView *view in self.subviews) {
                if ([view isKindOfClass:[UIButton class]] &&view.tag>=1000) {
                    view.hidden=YES;
                    [view removeFromSuperview];
                }
            }

        }
        [_textLabel setText:str];

        CGSize size =[self messageLabHeightWithStr:str];
        CGFloat y=size.height;
        CGFloat w =size.width;
        
        NSString *keyStr=@"";
        for (int i =1; i<=arr.count; i++) {
            NSString *key =arr[i-1];
            NSLog(@"key===%@",key);
            keyStr=[keyStr stringByAppendingString:@"\n"];
            keyStr=[keyStr stringByAppendingString:key];
            UIButton *btn = [self viewWithTag:i+1000];
            if (!btn) {
                //添加一级btn
                btn= [self createBtnWithFrame:CGRectMake(0, y, w, BtnHeight) title:key fontsize:midFontSize];
//                if (!self.model.message.isOutgoingMsg) {
//                    [btn setTitleColor:BlueFont forState:UIControlStateNormal];
//                }else{
//                    [btn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
//                }
                btn.tag=i+1000;
                [self addSubview:btn];
            }else{
                btn.frame=CGRectMake(0, y, w, BtnHeight);
            }
            btn.hidden=NO;
            NSArray *subArr=[_jsonDic arrayFoKey:key];
            if(i==_select+1){
                //添加2级btn
                if (subArr) {
                    for (int j=0; j<subArr.count; j++) {
                        y+=BtnHeight;
                        NSDictionary *item = subArr[j];
                        NSInteger tag = 10000*i+j;
                        UIButton *btn1 = [self viewWithTag:tag];
                        if (!btn1) {
                            UIButton *btn1= [self createBtnWithFrame:CGRectMake(0, y, w, BtnHeight) title:[item stringFoKey:@"message"] fontsize:midFontSize];
                            [btn1 setTitleColor:LTTitleRGB forState:UIControlStateNormal];
                            btn1.backgroundColor=LTClearColor;
                            btn1.tag=tag;
                            [self addSubview:btn1];
                        }else{
                            btn1.frame=CGRectMake(0, y, w, BtnHeight);
                        }
                        btn1.hidden=NO;
                    }
                }
            }else{
                if (subArr) {
                    for (int j=0; j<subArr.count; j++) {
                        NSInteger tag = 10000 *i+j;
                        UIButton *btn1 = [self viewWithTag:tag];
                        btn1.hidden=YES;
                    }
                }
            }
            y+=BtnHeight;
        }
    }

}

#pragma mark - createView
-(CGFloat)cellHeightWithModel:(NSObject *)data{
    NSString *str=@"";
    CGFloat y=0;
    if (_jsonDic) {
        NSString *msg = [_jsonDic objectForKey:@"msg"];
        str=msg;
        NSArray *arr = [_jsonDic arrayFoKey:@"keyArr"];
        if (arr) {
            if (arr.count>0) {
                str = [NSString stringWithFormat:@"%@\n-----------------------",msg];
            }
        }
        _textLabel.text = str;
        
        CGSize size =[self messageLabHeightWithStr:str];
        y=size.height;
        for (int i =1; i<=arr.count; i++) {
            NSString *key =arr[i-1];
            NSArray *subArr=[_jsonDic arrayFoKey:key];
            if(i==_select+1){
                //添加2级btn
                if (subArr) {
                    for (int j=0; j<subArr.count; j++) {
                        y+=BtnHeight;
                    }
                }
            }
            y+=BtnHeight;
        }
    }
    return y;
}
-(CGSize)messageLabHeightWithStr:(NSString *)str{
    M80AttributedLabel *label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:Message_Font_Size];
    
    [label setText:str];
    CGFloat msgBubbleMaxWidth    = (UIScreenWidth - 130);
    CGFloat bubbleLeftToContent  = 0;
    CGFloat contentRightToBubble = 0;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
//    CGFloat customWhiteBorardMessageImageRightToText = 10.f;
    CGSize labelSize = [label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
    label=nil;
    return labelSize;
}
//-(NSString *)textLabTextWithStr:(NSString *)jsonStr{
//    NSString *str;
//    NSDictionary *dic = [self dictionaryWithJsonString:jsonStr];
//    if (dic) {
//        NSString *msg = [dic objectForKey:@"msg"];
//        str = [NSString stringWithFormat:@"%@\n-----------------------",msg];
//        NSArray *arr = [dic objectForKey:@"modelList"];
//        if(!_jsonDic){
//            _jsonDic=[[NSMutableDictionary alloc]init];
//        }
//        for (int i =0; i<arr.count; i++) {
//            NSDictionary *item=arr[i];
//            NSString *message=[NSString stringWithFormat:@"\n%@",[item stringFoKey:@"message"]];
//            str=[str stringByAppendingString:message];
//            NSString *key = [NSString stringWithFormat:@"%@_isopen"];//用于限制开关
//            NSArray *list_one=[_jsonDic objectForKey:message];
//            if (!list_one) {
//                list_one=[item arrayFoKey:@"modelList"];
//                [_jsonDic setObject:list_one forKey:message];
//                [_jsonDic setObject:@"0" forKey:key];
//            }
//            NSString *value=[_jsonDic stringFoKey:key];
//            if(!emptyStr(value)){
//                if (![value isEqualToString:@"0"]) {
//                    for (int i = 0; i<list_one.count; i++) {
//                        
//                    }
//                    NSString *message=[NSString stringWithFormat:@"\n%@",[item stringFoKey:@"message"]];
//                    str=[str stringByAppendingString:message];
//                }
//            }else{
//                [_jsonDic setObject:@"0" forKey:key];
//            }
//        }
//    }
//    return str;
//}
#pragma mark - btnAction
-(void)btnAction:(UIButton *)sender{
    NSInteger tag=sender.tag;
    if (tag-1000<100) {
        //点击一级按钮展开或者缩放
        NSInteger num=tag-1000-1;
        NSArray *arr = [_jsonDic objectForKey:@"keyArr"];
        NSArray *arr1 = [_jsonDic objectForKey:@"modelList"];
        
        NSInteger oldSelect=_select;
        BOOL isAdd=NO;
        if(_select==num){
            _select=-1;
        }else{
            _select=num;
            isAdd=YES;
        }
        
        NSString *key;
        if (_select==-1) {
            if (oldSelect>-1) {
                key=arr[oldSelect];
            }
        }else{
            key=arr[_select];
        }
        NSArray *subArr=[_jsonDic arrayFoKey:key];
        NSString *str = [_jsonDic objectForKey:@"msg"];
        if (arr) {
            if (arr.count>0) {
                str = [NSString stringWithFormat:@"%@\n------------------------",str];
            }
        }
        CGSize size =[self messageLabHeightWithStr:str];
//        CGFloat width = self.model.contentSize.width;
//        CGFloat y=size.height;
//        if (isAdd) {
//            size.height = y+(arr.count+subArr.count)*BtnHeight;
//            self.model.contentSize =CGSizeMake(width, size.height);
//        }else{
//            size.height = y+arr.count*BtnHeight;
//            self.model.contentSize =CGSizeMake(width, size.height);
//        }
//        [kPublicData.replayCellHeight setObject:[NSNumber numberWithFloat:size.height] forKey:self.model.message.messageId];
        if(arr1.count>0){
            NSDictionary *item = arr1[num];
            NSString *key = [item stringFoKey:@"message"];
            NSString *url = [item stringFoKey:@"hrefUrl"];
        
         if (notemptyStr(url) && notemptyStr(key)) {
                NSString *title = sender.titleLabel.text;
                [self postPushURLWithKey:title Url:url];
                return;
            }
        }

        NFC_PostName(NFC_ReloadReplayCell);
//        [self refresh:self.model];
//        _changeCellFrame?_changeCellFrame(h,isAdd):nil;

    }else{
        //点击二级按钮
        NSInteger index= tag-10000*(_select+1);
        //获取btn对应的url
        NSArray *arr = [_jsonDic objectForKey:@"keyArr"];
        NSString *key = arr[_select];
        NSArray *arr1=[_jsonDic objectForKey:key];
        NSDictionary *dic = arr1[index];
        NSString *url = [dic stringFoKey:@"hrefUrl"];
        //发送跳转url通知
        NSString *title = sender.titleLabel.text;
        [self postPushURLWithKey:title Url:url];
    }
}
-(void)postPushURLWithKey:(NSString *)key Url:(NSString *)url{
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:url,@"url",key,@"title", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:NFC_IMPushURL object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
#pragma mark - utils
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"SessionReplayContentView == json解析失败");
        return nil;
    }
    return dic;
}
-(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title fontsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    return btn;
 }



@end
