//
//  LQ_MoreLevelSegmentView.h
//  CBSegment
//
//  Created by minrui on 2018/4/10.
//  Copyright © 2018年 com.bingo.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^titleChooseBlockParameter)(NSString*oneTitleID,NSString*twoTitleID,NSString*threeTitleID);

@class CBSegmentView;

@interface LQ_MoreLevelSegmentView : UIView

@property (nonatomic, copy) titleChooseBlockParameter titleChooseReturnParameter;

@property (nonatomic, strong) CBSegmentView * ScrollerSegment;

@property (nonatomic, copy) NSString *oneTitleID;

@property (nonatomic, copy) NSString *twoTitleID;

@property (nonatomic, copy) NSString *threeTitleID;

-(void)setSegementArrayTitle:(NSArray *)titleArr;

@end
