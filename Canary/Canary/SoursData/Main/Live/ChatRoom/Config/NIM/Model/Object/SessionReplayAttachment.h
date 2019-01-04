//
//  SessionReplayAttachment.h
//  ixit
//
//  Created by Brain on 2016/12/14.
//  Copyright © 2016年 litong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESCustomAttachmentDefines.h"

@interface SessionReplayAttachment : NSObject
@property (nonatomic,copy) NSString *jsonDicStr;
@property (nonatomic,retain) NSDictionary *jsonDic;
-(NSMutableDictionary *)messageDic;
@end
