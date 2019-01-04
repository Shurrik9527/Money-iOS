//
//  AnswerView.h
//  ixit
//
//  Created by litong on 2017/3/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, AnswerType) {
    AnswerType_Normal = 0,//未作答
    AnswerType_Right,//选对
    AnswerType_Wrong,//选错
    AnswerType_UnSelect_Right,//未选答案正确
    AnswerType_UnSelect_Wrong,//未选答案错误
};

typedef void(^AnswerViewBlock)(NSInteger num);

@interface AnswerView : UIView

@property (nonatomic,copy) AnswerViewBlock answerViewBlock;

- (instancetype)init;
- (void)refView:(NSDictionary *)answerDict;
- (void)changeType:(AnswerType)type;

@end
