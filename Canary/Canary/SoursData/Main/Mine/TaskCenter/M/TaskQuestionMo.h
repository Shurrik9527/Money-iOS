//
//  TaskQuestionMo.h
//  ixit
//
//  Created by litong on 2017/3/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface TaskQuestionMo : BaseMO

@property (nonatomic,strong) NSString *queSeqNum;//题号
@property (nonatomic,strong) NSString *queDesc;//问题描述
@property (nonatomic,strong) NSString *queExplain;//问题解释

@property (nonatomic,strong) NSArray *queAnsList;//答案列表
@property (nonatomic,assign) NSInteger queAnsSeqNum;//正确答案



/*
 {
     queAnsList =     (
         {
             queAnsDesc = "T+0";
             queAnsSeqNum = 1;
         },
         {
             queAnsDesc = TFboys;
             queAnsSeqNum = 2;
         }
     );
     queAnsSeqNum = 1;
     queDesc = "\U4e0b\U9762\U54ea\U4e2a\U662f\U8d35\U91d1\U5c5e\U6295\U8d44\U7684\U4ea4\U6613\U5236\U5ea6\Uff1f";
     queExplain = "\U6240\U8c13T+0\Uff0c\U662f\U6307\U5f53\U5929\U7684\U5efa\U4ed3\U5f53\U5929\U5c31\U53ef\U4ee5\U5e73\U4ed3\U3002T\U4ee3\U8868today\Uff08\U4eca\U5929\Uff09\Uff0c0\U4ee3\U8868\U5efa\U4ed3\U540e\U51e0\U5929\U80fd\U5e73\U4ed3\U3002\U5efa\U4ed3\U4ee3\U8868\U4e70\Uff0c\U5e73\U4ed3\U4ee3\U8868\U5356\U3002";
     queSeqNum = 1;
 }
 */

@end
