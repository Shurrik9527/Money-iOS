//
//  SessionReplayContentView.h
//  ixit
//
//  Created by Brain on 2016/12/14.
//  Copyright © 2016年 litong. All rights reserved.
//

//#import "NIMSessionMessageContentView.h"
@class M80AttributedLabel;

@interface SessionReplayContentView : UIView
@property (nonatomic, copy) void (^changeCellFrame)(NSInteger H,BOOL isAdd);

@property (nonatomic, strong) M80AttributedLabel *textLabel;
@property(copy,nonatomic)NSString * contentText;
//返回containview size
-(CGFloat)cellHeightWithModel:(NSObject *)data;
@end
