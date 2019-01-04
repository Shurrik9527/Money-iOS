//
//  LiveMO.m
//  Canary
//
//  Created by litong on 2017/5/15.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "LiveMO.h"

@implementation LiveMO

+ (NSArray *)objsWithList:(NSArray *)list {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSDictionary *dict in list) {
        LiveMO *mo = [LiveMO objWithDict:dict];
        if ([mo canShow]) {
            [arr addObject:mo];
        }
    }
    return [NSArray arrayWithArray:arr];
}


- (BOOL)canShow {
    //    是否为付费观看的 1免费，2付费
    BOOL canShow_isPay = (_isPay==1);
    //    直播室类型（1.文字直播，2视频）
    BOOL canShow_channelType = (_channelType == 2);
    //    是否隐藏
    BOOL canShow_hidden = (!_hidden);
    
    BOOL bl = (canShow_hidden && canShow_channelType && canShow_isPay);
    return bl ;
}

- (NSString *)onlineNumberSimpleName_fmt {
    if (emptyStr(_onlineNumberSimpleName)) {
        return @"0";
    }
    return _onlineNumberSimpleName;
}

- (NSString *)cardId_fmt {
    NSString *str = [NSString stringWithFormat:@"资格证号: %@",self.cardId];
    return str;
}

- (BOOL)isLiving {
    //    BOOL bl = [[self segmentModel_fmt] isLiving];
    
    //	直播室状态  1:直播中  0:休息中
    BOOL bl = ([self.channelStatus integerValue] == 1);
    return bl;
}

/** 1:聊天室不允许发送图片, 0:可以 */
- (BOOL)canSendPic {
    BOOL bl = (self.sendPicStatus == 0);
    return bl;
}

- (NSString *)beginTime_fmt {
    if ([self isLiving]) {
        //        return @"直播中";
        NSString *str = [NSString stringWithFormat:@"%@在看",[self onlineNumberSimpleName_fmt]];
        return str;
    } else {
        return [[self segmentModel_fmt] startTime_fmt];
    }
}

- (NSString *)descStr_fmt {
    //    if (notemptyStr(self.activityName)) {
    //        return self.activityName;
    //    }
    //    return self.channelName;
    NSString *str = self.authorName;
    return str;
}

- (NSString *)lableStr_fmt {
    NSArray *labs = [self.label splitWithStr:@","];
    if (labs.count > 0) {
        return labs[0];
    }
    return nil;
}


- (NSArray *)liveTimeList_fmt {
    NSArray *arr = [LiveTimeMo objsWithList:self.liveTimeList];
    return arr;
}

- (LiveTimeMo *)segmentModel_fmt {
    LiveTimeMo *mo = [LiveTimeMo objWithDict:self.segmentModel];
    return mo;
}

@end
