//
//  LQ_MoreLevelSegmentView.m
//  CBSegment
//
//  Created by minrui on 2018/4/10.
//  Copyright © 2018年 com.bingo.com. All rights reserved.
//

#import "LQ_MoreLevelSegmentView.h"
#import "CBSegmentView.h"
#import "dataModel.h"
#define CBColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define CBScreenH 40
#define CBScreenW [UIScreen mainScreen].bounds.size.width

@implementation LQ_MoreLevelSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
 
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setSegementArrayTitle:(NSArray *)dataArr {
    
    self.oneTitleID = @"";
    self.twoTitleID = @"";
    self.threeTitleID = @"";
    
    //第一组
    NSMutableArray *firstSubjectsArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *firstSujectsID = [NSMutableArray arrayWithCapacity:0];
    //第二组
    NSMutableArray *subjectsMArr = [NSMutableArray arrayWithObject:@"全部"];
    NSMutableArray *subjectsID = [NSMutableArray arrayWithObject:@"0"];
    //第三组
    NSMutableArray *gradesMArr = [NSMutableArray arrayWithObject:@"全部"];
    NSMutableArray *gradesID = [NSMutableArray arrayWithObject:@"0"];
    
    for (int i =0; i<dataArr.count; i++) {
        
        self.ScrollerSegment = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, i*CBScreenH,CBScreenW , CBScreenH)];
        self.ScrollerSegment.tag = 100+i;
        
        [self addSubview:self.ScrollerSegment];
        
#pragma mark - 初始化默认标题
        
        if (i==0) {
            //一级标题
            for (int i=0; i<dataArr.count; i++) {
                dataModel *model = dataArr[i];
                [firstSubjectsArr addObject:model.name];
                [firstSujectsID addObject:model.firstID];
            }
            [self.ScrollerSegment setTitleArray:firstSubjectsArr];
            
             __weak typeof(self) weakSelf = self;
            
#pragma mark -第一组点击事件
            
            self.ScrollerSegment.titleChooseReturn = ^(NSInteger x) {
                
                NSLog(@"第一组第%ld个按钮=%@ =%@",x+1,firstSubjectsArr[x],firstSujectsID[x]);
                
                weakSelf.oneTitleID = firstSujectsID[x];
                if (weakSelf.titleChooseReturnParameter) {
                    weakSelf.twoTitleID = @"";
                    weakSelf.threeTitleID = @"";
                    weakSelf.titleChooseReturnParameter( weakSelf.oneTitleID, weakSelf.twoTitleID, weakSelf.threeTitleID);
                    
                }
                    //二级 默认
                    dataModel * model = dataArr[x];
                    NSArray *grades = model.grades;
                    //二组 移除
                    [gradesMArr removeObjectsInRange:NSMakeRange(1, gradesMArr.count-1)];
                    [gradesID removeObjectsInRange:NSMakeRange(1, gradesID.count-1)];
                    for (NSDictionary * d in grades) {
                        [gradesMArr addObject:[d objectForKey:@"name"] ];
                        [gradesID addObject:[d objectForKey:@"threeID"]];
                    }
                    
                    //三级 科目
                    NSArray *subjects = model.subjects;
                    //三组 移除数组
                    [subjectsMArr removeObjectsInRange:NSMakeRange(1, subjectsMArr.count-1)];
                    [subjectsID removeObjectsInRange:NSMakeRange(1, subjectsID.count-1)];
                    for (NSDictionary *d in subjects) {
                        [subjectsMArr addObject:[d objectForKey:@"name"]];
                        [subjectsID addObject:[d objectForKey:@"twoID"]];
                    }
                    
                    //移除和添加
                    if ([weakSelf viewWithTag:101]) {
                        
                        [[weakSelf viewWithTag:101] removeFromSuperview];
                        weakSelf.ScrollerSegment = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, CBScreenH,CBScreenW , CBScreenH)];
                        weakSelf.ScrollerSegment.tag = 101;
                        [weakSelf addSubview:weakSelf.ScrollerSegment];
                        
                        [weakSelf.ScrollerSegment setTitleArray:subjectsMArr];
                        weakSelf.ScrollerSegment.titleChooseReturn = ^(NSInteger x) {
                            
                            NSLog(@"点击了第二注第%ld个按钮=%@ =%@",x+1,subjectsMArr[x],subjectsID[x]);
                            
                            weakSelf.twoTitleID = subjectsID[x];
                            
                            if (weakSelf.titleChooseReturnParameter) {
                                weakSelf.titleChooseReturnParameter( weakSelf.oneTitleID, weakSelf.twoTitleID, weakSelf.threeTitleID);
                            }
                        };
                    }
    
                    if ([weakSelf viewWithTag:102]) {
                        [[weakSelf viewWithTag:102] removeFromSuperview];
                        weakSelf.ScrollerSegment = [[CBSegmentView alloc]initWithFrame:CGRectMake(0, 2*CBScreenH,CBScreenW , CBScreenH)];
                        weakSelf.ScrollerSegment.tag = 102;
                        [weakSelf addSubview:weakSelf.ScrollerSegment];
                        [weakSelf.ScrollerSegment setTitleArray:gradesMArr];
                        
                        weakSelf.ScrollerSegment.titleChooseReturn = ^(NSInteger x) {
                            NSLog(@"点击了第三组第%ld个按钮=%@ =%@",x+1,gradesMArr[x],gradesID[x]);
                            
                            weakSelf.threeTitleID = gradesID[x];
                            
                            if (weakSelf.titleChooseReturnParameter) {
                                weakSelf.titleChooseReturnParameter( weakSelf.oneTitleID, weakSelf.twoTitleID, weakSelf.threeTitleID);
                            }
                            
                        };
                    }
            };
        }
        
#pragma mark - UI默认标题二组
        
        dataModel * model = dataArr[0];
        
        if (i==1) {
            
            NSArray *subjects = model.subjects;

            for (NSDictionary *d in subjects) {
                [subjectsMArr addObject:[d objectForKey:@"name"]];
                [subjectsID addObject:[d objectForKey:@"twoID"]];
            }
            
            [self.ScrollerSegment setTitleArray:subjectsMArr];
            
             __weak typeof(self) weakSelf = self;
            
            self.ScrollerSegment.titleChooseReturn = ^(NSInteger x) {
                NSLog(@"点击了第二组第%ld个按钮=%@ =%@",x+1,subjectsMArr[x],subjectsID[x]);
                
                weakSelf.twoTitleID = subjectsID[x];
                
                if (weakSelf.titleChooseReturnParameter) {
                    weakSelf.titleChooseReturnParameter( weakSelf.oneTitleID, weakSelf.twoTitleID, weakSelf.threeTitleID);
                }
            };
        }
        
#pragma mark - UI默认标题三组
        
        if (i==2) {
            
            //三级 科目
    
            NSArray *grades = model.grades;
            for (NSDictionary * d in grades) {
                [gradesMArr addObject:[d objectForKey:@"name"] ];
                [gradesID addObject:[d objectForKey:@"threeID"]];
            }
            
            [self.ScrollerSegment setTitleArray:gradesMArr];
            
              __weak typeof(self) weakSelf = self;
            self.ScrollerSegment.titleChooseReturn = ^(NSInteger x) {
                
                NSLog(@"点击了第二组第%ld个按钮=%@ =%@",x+1,gradesMArr[x],gradesID[x]);
                weakSelf.threeTitleID = gradesID[x];
                
                if (weakSelf.titleChooseReturnParameter) {
                    weakSelf.titleChooseReturnParameter( weakSelf.oneTitleID, weakSelf.twoTitleID, weakSelf.threeTitleID);
                }
            };
        }
    }
}

@end
