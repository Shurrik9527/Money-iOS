//
//  SessionReplayAttachment.m
//  ixit
//
//  Created by Brain on 2016/12/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "SessionReplayAttachment.h"
#import "M80AttributedLabel.h"
#import "NTESSessionUtil.h"
#define BtnHeight 30

@implementation SessionReplayAttachment
- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{CMType : @(CustomMessageTypeReplay),
                           CMData : self.jsonDicStr};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}
-(NSMutableDictionary *)messageDic{
    return [NSMutableDictionary dictionaryWithDictionary:self.jsonDic];
}
- (NSString *)formatedMessage{
    return self.jsonDicStr;
}
- (NSString *)cellContent:(NSObject *)message{
    NSString *content;
    content = @"SessionReplayContentView";
    return content;
}
//设置content位置
- (CGSize)contentSize:(NSObject *)message cellWidth:(CGFloat)width{
    CGSize contentSize;
    M80AttributedLabel *label = [[M80AttributedLabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont systemFontOfSize:Message_Font_Size];
    
    [label setText:[self textLabTextWithStr:self.jsonDicStr]];
    CGFloat msgBubbleMaxWidth    = (UIScreenWidth - 130);
    CGFloat bubbleLeftToContent  = 0;
    CGFloat contentRightToBubble = 0;
    CGFloat msgContentMaxWidth = (msgBubbleMaxWidth - contentRightToBubble - bubbleLeftToContent);
//    CGFloat customWhiteBorardMessageImageRightToText = 10.f;
    CGSize labelSize = [label sizeThatFits:CGSizeMake(msgContentMaxWidth, CGFLOAT_MAX)];
    contentSize = CGSizeMake(labelSize.width, labelSize.height);
    
    NSDictionary *dic = [self dictionaryWithJsonString:self.jsonDicStr];
    NSArray *arr = [dic objectForKey:@"modelList"];
    CGFloat addH=arr.count*BtnHeight;
    contentSize.height +=addH;
    
//    NSString *key = message.messageId;
//    NSNumber *contentH = [kPublicData.replayCellHeight objectForKey:key];
//    if ([NSObject isNull:contentH]) {
//        NSNumber *h =[NSNumber numberWithFloat:contentSize.height];
//        [kPublicData.replayCellHeight setObject:h forKey:key];
//    }else{
//        CGFloat h = [contentH floatValue];
//        contentSize = CGSizeMake(labelSize.width, h);
//    }
    return contentSize;
}
#pragma mark - createView
-(CGFloat)cellHeightWithModel:(NSObject *)data{
//    NSString *str;
    CGFloat y=0;
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

-(NSString *)textLabTextWithStr:(NSString *)jsonStr{
    /*
     NSArray *arr = [_jsonDic objectForKey:@"keyArr"];
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
     CGFloat h=subArr.count*BtnHeight;
     NSString *str = [_jsonDic objectForKey:@"msg"];
     if ([arr isNotNull]) {
     if (arr.count>0) {
     str = [NSString stringWithFormat:@"%@\n------------------------",str];
     }
     }
     CGSize size =[self messageLabHeightWithStr:str];
     CGFloat width = self.model.contentSize.width;
     CGFloat y=size.height;
     if (isAdd) {
     size.height = y+(arr.count+subArr.count)*BtnHeight;
     self.model.contentSize =CGSizeMake(width, size.height);
     }else{
     size.height = y+arr.count*BtnHeight;
     self.model.contentSize =CGSizeMake(width, size.height);
     }
     [kPublicData.replayCellHeight setObject:[NSNumber numberWithFloat:size.height] forKey:self.model.message.messageId];
     */
    NSString *str=@"";
    NSDictionary *dic = [self dictionaryWithJsonString:jsonStr];
    if (dic) {
        NSString *msg = [dic objectForKey:@"msg"];
        str=msg;
        NSArray *arr = [dic objectForKey:@"modelList"];
        if(arr.count>0){
            str = [NSString stringWithFormat:@"%@\n-----------------------",msg];
        }
//        for (int i =0; i<arr.count; i++) {
//            NSDictionary *item=arr[i];
//            NSString *message=[NSString stringWithFormat:@"\n%@",[item stringFoKey:@"message"]];
//            str=[str stringByAppendingString:message];
//        }
    }
    return str;
}

- (UIEdgeInsets)contentViewInsets:(NSObject *)message
{
        CGFloat selfBubbleTopToContentForBoard     = 11.f;
        CGFloat selfBubbleLeftToContentForBoard    = 11.f;
        CGFloat selfContentButtomToBubbleForBoard  = 9.f;
        CGFloat selfBubbleRightToContentForBoard   = 15.f;
        
        CGFloat otherBubbleTopToContentForBoard    = 11.f;
        CGFloat otherBubbleLeftToContentForBoard   = 15.f;
        CGFloat otherContentButtomToBubbleForBoard = 9.f;
        CGFloat otherContentRightToBubbleForBoard  = 9.f;
    return UIEdgeInsetsZero;
//        return message.isOutgoingMsg ? UIEdgeInsetsMake(selfBubbleTopToContentForBoard,
//                                                        selfBubbleLeftToContentForBoard,
//                                                        selfContentButtomToBubbleForBoard,
//                                                        selfBubbleRightToContentForBoard):
//        UIEdgeInsetsMake(otherBubbleTopToContentForBoard,
//                         otherBubbleLeftToContentForBoard,
//                         otherContentButtomToBubbleForBoard,
//                         otherContentRightToBubbleForBoard);
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"SessionReplayAttachment == json解析失败");
        return nil;
    }
    return dic;
}

@end
