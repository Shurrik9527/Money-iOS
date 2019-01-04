//
//  TaskListMo.h
//  ixit
//
//  Created by litong on 2017/3/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "BaseMO.h"

@interface TaskListMo : BaseMO

@property (nonatomic,strong) NSString *taskId;
@property (nonatomic,strong) NSString *taskIcon;
@property (nonatomic,strong) NSString *taskTitle;
@property (nonatomic,strong) NSString *taskDesc;

//任务跳转类型：1=答题，2=分享，3=协议跳转，4=H5跳转
@property (nonatomic,assign) NSInteger taskType;
@property (nonatomic,strong) NSString *taskLinkTitle;
@property (nonatomic,strong) NSString *taskLink;

@property (nonatomic,assign) NSInteger queTotalNum;//题目总数
@property (nonatomic,assign) NSInteger queSucessNum;//已答题数量
@property (nonatomic,strong) NSString *queSucessPoints;//完成答题任务获取的积分值
@property (nonatomic,assign) NSInteger userTaskStatus;//完成状态：1=完成，2=未开始，3、进行中

@property (nonatomic,assign) NSInteger taskVersion;//任务版本号

- (BOOL)userBeginedQuestion;
+ (NSInteger)curFinishQuestionNum:(NSInteger)finishNum taskId:(NSString *)taskId;
+ (void)setCurFinishQuestionNum:(NSInteger)finishNum taskId:(NSString *)taskId;


- (void)saveTaskVersion;
- (BOOL)needReqQuestionList;

- (void)saveQuestions:(NSString *)jsonString;
- (NSArray *)locQuestions;


/*
 taskList =     (
     {
         queSucessNum = 0;
         queSucessPoints = 0;
         queTotalNum = 8;
         taskDesc = "\U5b8c\U6210\U9898\U76ee\U5373\U9001800\U79ef\U5206\Uff0c\U53ef\U5151\U63628\U5143\U4ee3\U91d1\U5238";
         taskIcon = "http://t.m.8caopan.com/images/task/icon/0/0/3/20170302193240537.png";
         taskId = 3;
         taskLink = "";
         taskLinkTitle = "";
         taskTitle = "\U65b0\U624b\U95ee\U7b54\U8d5a\U79ef\U5206";
         taskType = 1;
         taskVersion = 1;
         userTaskStatus = 2;
     }
 )
 */

@end


@interface TaskHeadMo : BaseMO

@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSString *linkTitle;
@property (nonatomic,strong) NSString *pic;
@property (nonatomic,assign) NSInteger linkType;//banner跳转类型：1=答题，2=分享，3=协议跳转，4=H5跳转

/*
 bannerList =     (
     {
         link = "http://t.w.8caopan.com/activity/hyyq/?userId=125068&sourceId=10";
         linkTitle = "\U516b\U5143\U65b0\U6625\U6d3b\U52a8";
         linkType = 4;
         pic = "http://t.m.8caopan.com/static/images/task_banner.png";
     }
 );
 */

@end
