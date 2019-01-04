//
//  TaskListMo.m
//  ixit
//
//  Created by litong on 2017/3/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "TaskListMo.h"

@implementation TaskListMo

- (BOOL)userBeginedQuestion {
    NSInteger finishNum = [TaskListMo curFinishQuestionNum:self.queSucessNum taskId:self.taskId];
    BOOL begined = (finishNum > 0);
    return begined;
}

+ (NSString *)curFinishQuestionNumKey:(NSString *)taskId {
    NSString *key = [NSString stringWithFormat:@"User%@FinishTaskId%@NumKey",UD_UserId,taskId];
    return key;
}
+ (NSInteger)curFinishQuestionNum:(NSInteger)finishNum taskId:(NSString *)taskId {
    NSString *key = [TaskListMo curFinishQuestionNumKey:taskId];
    NSInteger locFinishNum = [UserDefaults integerForKey:key];
    NSInteger num = MAX(finishNum, locFinishNum);
    return num;
}
+ (void)setCurFinishQuestionNum:(NSInteger)finishNum taskId:(NSString *)taskId {
    NSString *key = [TaskListMo curFinishQuestionNumKey:taskId];
    [UserDefaults setInteger:finishNum forKey:key];
}


- (NSString *)taskVersionKey {
    NSString *key = [NSString stringWithFormat:@"taskVersionKey%@",_taskId];
    return key;
}
- (void)saveTaskVersion {
    [UserDefaults setInteger:self.taskVersion forKey:[self taskVersionKey]];
}
- (BOOL)needReqQuestionList {
    NSInteger loc = [UserDefaults integerForKey:[self taskVersionKey]];
    NSInteger cur = _taskVersion;
    BOOL bl = cur > loc;
    return bl;
}


- (NSString *)taskQuestionsKey {
    NSString *key = [NSString stringWithFormat:@"taskQuestionsKey%@",_taskId];
    return key;
}
- (void)saveQuestions:(NSString *)jsonString {
    [UserDefaults setObject:jsonString forKey:[self taskQuestionsKey]];
}
- (NSArray *)locQuestions {
    NSString *str = [UserDefaults stringForKey:[self taskQuestionsKey]];
    NSArray *arr = [str jsonStringToArray];
    return [NSArray arrayWithArray:arr];
}


@end







@implementation TaskHeadMo


@end
