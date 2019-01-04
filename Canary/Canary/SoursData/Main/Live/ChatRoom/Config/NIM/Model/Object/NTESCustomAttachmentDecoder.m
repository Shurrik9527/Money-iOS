//
//  NTESCustomAttachmentDecoder.m
//  NIM
//
//  Created by amao on 7/2/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESCustomAttachmentDecoder.h"
#import "NTESCustomAttachmentDefines.h"
#import "NTESJanKenPonAttachment.h"
#import "NTESSnapchatAttachment.h"
#import "NTESChartletAttachment.h"
#import "NTESWhiteboardAttachment.h"
#import "NSDictionary+NTESJson.h"
#import "NTESSessionUtil.h"
#import "SessionReplayAttachment.h"
@implementation NTESCustomAttachmentDecoder
- (id)decodeAttachment:(NSString *)content
{
    id attachment = nil;
    content=[content replacStr:@"'" withStr:@""""];
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        content=[content replacStr:@"'" withStr:@""""];

        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger type     = [dict jsonInteger:CMType];
            NSDictionary *data = [dict jsonDict:CMData];
            switch (type) {
                case CustomMessageTypeJanKenPon:
                {
                    attachment = [[NTESJanKenPonAttachment alloc] init];
                    ((NTESJanKenPonAttachment *)attachment).value = [data jsonInteger:CMValue];
                }
                    break;
                case CustomMessageTypeSnapchat:
                {
                    attachment = [[NTESSnapchatAttachment alloc] init];
                    ((NTESSnapchatAttachment *)attachment).md5 = [data jsonString:CMMD5];
                    ((NTESSnapchatAttachment *)attachment).url = [data jsonString:CMURL];
                    ((NTESSnapchatAttachment *)attachment).isFired = [data jsonBool:CMFIRE];
                }
                    break;
                case CustomMessageTypeChartlet:
                {
                    attachment = [[NTESChartletAttachment alloc] init];
                    ((NTESChartletAttachment *)attachment).chartletCatalog = [data jsonString:CMCatalog];
                    ((NTESChartletAttachment *)attachment).chartletId      = [data jsonString:CMChartlet];
                }
                    break;
                case CustomMessageTypeWhiteboard:
                {
                    attachment = [[NTESWhiteboardAttachment alloc] init];
                    ((NTESWhiteboardAttachment *)attachment).flag = [data jsonInteger:CMFlag];
                }
                    break;
                case CustomMessageTypeReplay:
                {
                    //需要创建一个自动回复结构体
                    attachment = [[SessionReplayAttachment alloc] init];
                    
                    NSString *jsonStr=[dict jsonString:@"msg"];
                    if (emptyStr(jsonStr)) {
                        NSDictionary *dic= [dict objectForKey:@"msg"];
                        jsonStr=[dic toJsonString];
                    }
                    ((SessionReplayAttachment *)attachment).jsonDicStr=jsonStr;

                    //生成对应数据，需要带上open的控制管理
                    if (emptyStr(jsonStr)) {
                        jsonStr=@"";
                    }
                    NSMutableDictionary *jsonDic= [self dicWithJsonStr:jsonStr];
                    ((SessionReplayAttachment *)attachment).jsonDic = jsonDic;
                    NSLog(@"msg===%@",((SessionReplayAttachment *)attachment).jsonDicStr);
                }
                    break;
                default:{
                    NSLog(@"dict===%@",dict);
                }
                    break;
            }
            attachment = [self checkAttachment:attachment] ? attachment : nil;
        }else{
            content=[content replacStr:@"'" withStr:@""""];
            //需要创建一个自动回复结构体
            attachment = [[SessionReplayAttachment alloc] init];
            NSString *jsonStr=[dict jsonString:@"msg"];
            ((SessionReplayAttachment *)attachment).jsonDicStr=jsonStr;
            
            //生成对应数据，需要带上open的控制管理
            NSMutableDictionary *jsonDic= [self dicWithJsonStr:jsonStr];
            ((SessionReplayAttachment *)attachment).jsonDic = jsonDic;
            NSLog(@"msg===%@",((SessionReplayAttachment *)attachment).jsonDicStr);
            NSLog(@"content===%@",content);
        }
    }else{
        NSLog(@"content===%@",content);
    }
    return attachment;
}


- (BOOL)checkAttachment:(id)attachment{
    BOOL check = NO;
    if ([attachment isKindOfClass:[NTESJanKenPonAttachment class]]) {
        NSInteger value = [((NTESJanKenPonAttachment *)attachment) value];
        check = (value>=CustomJanKenPonValueKen && value<=CustomJanKenPonValuePon) ? YES : NO;
    }
    else if ([attachment isKindOfClass:[NTESSnapchatAttachment class]]) {
        check = YES;
    }
    else if ([attachment isKindOfClass:[NTESChartletAttachment class]]) {
        NSString *chartletCatalog = ((NTESChartletAttachment *)attachment).chartletCatalog;
        NSString *chartletId      =((NTESChartletAttachment *)attachment).chartletId;
        check = chartletCatalog.length&&chartletId.length ? YES : NO;
    }
    else if ([attachment isKindOfClass:[NTESWhiteboardAttachment class]]) {
        NSInteger flag = [((NTESWhiteboardAttachment *)attachment) flag];
        check = ((flag >= CustomWhiteboardFlagInvite) && (flag <= CustomWhiteboardFlagClose)) ? YES : NO;
    }
    else if ([attachment isKindOfClass:[SessionReplayAttachment class]]) {
        check = YES;
    }
    return check;
}
#pragma mark - action 
-(NSMutableDictionary *)dicWithJsonStr:(NSString *)jsonStr{
    NSDictionary *dic = [jsonStr jsonStringToDictonary];
    if(!dic){
        return [NSMutableDictionary dictionary];
    }
    NSArray *arr=[dic arrayFoKey:@"modelList"];
    
    NSMutableDictionary *jsonDic=[[NSMutableDictionary alloc]init];
    [jsonDic setObject:[dic stringFoKey:@"msg"] forKey:@"msg"];
    [jsonDic setObject:arr forKey:@"modelList"];

    NSMutableArray *keyArr=[[NSMutableArray alloc]init];
    for (int i = 0; i<arr.count; i++) {
        NSDictionary *item = arr[i];
        NSString *key = [item stringFoKey:@"message"];
        NSArray *arr1 = [item arrayFoKey:@"modelList"];
        [jsonDic setObject:arr1 forKey:key];
        [keyArr addObject:key];
        
        NSString *openkey =[NSString stringWithFormat:@"%@_openkey",key];
        NSString *openvalue=@"0";
        [jsonDic setObject:openvalue forKey:openkey];
    }
    [jsonDic setObject:keyArr forKey:@"keyArr"];
    return jsonDic;
}
//-(NSMutableDictionary *)dicWithStr:(NSString *)jsonStr{
//    NSDictionary *dic1 = [jsonStr jsonStringToDictonary];
//    NSDictionary *dic = [dic1 objectForKey:@"msg"];
//    if (![dic isNotNull]) {
//        return dic1;
//    }
//    NSArray *arr=[dic arrayFoKey:@"modelList"];
//    
//    NSMutableDictionary *jsonDic=[[NSMutableDictionary alloc]init];
//    [jsonDic setObject:[dic stringFoKey:@"msg"] forKey:@"msg"];
//    [jsonDic setObject:[dic1 numberFoKey:@"type"] forKey:@"type"];
//
//    NSMutableArray *keyArr=[[NSMutableArray alloc]init];
//    for (int i = 0; i<arr.count; i++) {
//        NSDictionary *item = arr[i];
//        NSString *key = [item stringFoKey:@"message"];
//        NSArray *arr1 = [item arrayFoKey:@"modelList"];
//        if (arr1.count!=0) {
//            [jsonDic setObject:arr1 forKey:key];
//        }else{
//            [jsonDic setObject:item forKey:key];
//        }
//        [keyArr addObject:key];
//        
//        NSString *openkey =[NSString stringWithFormat:@"%@_openkey",key];
//        NSString *openvalue=@"0";
//        [jsonDic setObject:openvalue forKey:openkey];
//    }
//    [jsonDic setObject:keyArr forKey:@"keyArr"];
//    return jsonDic;
//}
//-(NSString *)dealJsonStr:(NSString *)jsonStr{
//    //json字符串转换成字典
//    NSDictionary *dic = [jsonStr jsonStringToDictonary];
//    NSMutableDictionary *jsonDic=[NSMutableDictionary dictionaryWithDictionary:dic];
//    NSLog(@"jsonDic=== %@",jsonDic);
//    NSString *str=@"";
//    if (dic) {
//        NSString *msg = [dic objectForKey:@"msg"];
//        str = [NSString stringWithFormat:@"%@\n---------------------------",msg];
//        NSArray *arr = [dic objectForKey:@"modelList"];
//        for (int i =0; i<arr.count; i++) {
//            NSString *key=[NSString stringWithFormat:@"isopen_%li",i];
//            if (![jsonDic objectForKey:key]) {
//                [jsonDic setObject:@"0" forKey:key];
//            }
//            NSDictionary *item=arr[i];
//            NSString *message=[NSString stringWithFormat:@"\n%@",[item stringFoKey:@"message"]];
//            str=[str stringByAppendingString:message];
//        }
//        NSLog(@"jsonDic=== %@",jsonDic);
//    }
//
//    
//    return str;
//}

//数据转json字串
-(NSString*)dataTOjsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
