//
//  TaskQuestionVCtrl.m
//  ixit
//
//  Created by litong on 2017/3/1.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "TaskQuestionVCtrl.h"
#import "AnswerView.h"
#import "LTMaskTipView.h"
#import "IntegralVCtrl.h"
#import "UIView+LTAnimation.h"

static CGFloat kNumLabH = 24;
static CGFloat kQLabX = 24;

static CGFloat kTQBtmBtnTopMar = 36;
static CGFloat kTQBtmBtnH = 46;

typedef NS_ENUM(NSUInteger, TQBtnType) {
    TQBtnType_Next = 0,//下一题
    TQBtnType_Again,//重新答题
    TQBtnType_Finish,//查看成绩
    TQBtnType_Back,//返回任务中心
};


@interface TaskQuestionVCtrl ()
{
    TQBtnType btnType;
    CGFloat scViewH;
    BOOL questionFinished;
}

@property (nonatomic,strong) NSArray *questions;
@property (nonatomic,assign) NSInteger questionsCount;
@property (nonatomic,assign) NSInteger finishNum;
@property (nonatomic,strong) TaskQuestionMo *curQuestionMo;
@property (nonatomic,assign) BOOL saveFinish;//save请求完成
@property (nonatomic,assign) BOOL needReqSave;//

//进度
@property (nonatomic,strong) UIView *progressBaseView;
@property (nonatomic,strong) UILabel *progressLab;
@property (nonatomic,strong) UIView *progressBgView;
@property (nonatomic,strong) UIView *progressFinishView;

@property (nonatomic,strong) UIScrollView *scView;//questionView&explainView

//题目
@property (nonatomic,strong) UIView *questionView;
@property (nonatomic,strong) UILabel *qNumLab;//题目编号
@property (nonatomic,strong) UILabel *problemLab;//题目
@property (nonatomic,strong) AnswerView *answerView0;//答案0
@property (nonatomic,strong) AnswerView *answerView1;//答案1

//解释
@property (nonatomic,strong) UIView *explainView;
@property (nonatomic,strong) UILabel *explainLab;//解释
@property (nonatomic,strong) UILabel *explainDetailLab;//解释详情

//底部按钮
@property (nonatomic,strong) UIView *btmView;
@property (nonatomic,strong) UIButton *btmBtn;

@end

@implementation TaskQuestionVCtrl

- (instancetype)init {
    self = [super init];
    if (self) {
        _finishNum = 0;
        btnType = TQBtnType_Next;
        _saveFinish = NO;
        questionFinished = NO;
        self.view.backgroundColor = LTBgColor;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createProgressView];
    [self createScView];
    [self createBtmView];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setting

- (void)setTaskMo:(TaskListMo *)taskMo {
    
    if (!taskMo) {
        [LitTipsView showTips:@"任务出错，请联系客服"];
        [self.navigationController popVC];
        return;
    }
    
    _taskMo = taskMo;
    questionFinished = (_taskMo.userTaskStatus == 1);
    if (questionFinished) {//任务已完成
        _finishNum = 0;
    } else {
        _finishNum = [TaskListMo curFinishQuestionNum:taskMo.queSucessNum taskId:taskMo.taskId];
    }

    [self navTitle:_taskMo.taskTitle backType:BackType_PopVC];
    
    [self loadData];
}

- (void)setQuestions:(NSArray *)questions {
    _questions = [NSArray arrayWithArray:questions];
    _questionsCount =_questions.count;
    
    if (_questionsCount == 0) {
        [LitTipsView showTips:@"任务出错，请联系客服"];
        [self.navigationController popVC];
        return;
    }
    
    BOOL bl = _finishNum == _questionsCount;
    if (bl) {
        if (_finishNum > 0) {
            _finishNum = _finishNum-1;
        }
    }
    _curQuestionMo = _questions[_finishNum];
    
    [self configProgress];
    [self configData];
    if (questionFinished) {
        [self finishQuestion];
    }
}


#pragma mark - 网络请求

//请求题目列表
- (void)loadData {
    if ([_taskMo needReqQuestionList]) {
        [self reqTaskQuestionList];
    } else {
        self.questions = [TaskQuestionMo objsWithList:_taskMo.locQuestions];
        if (self.questions.count == 0) {
            [self reqTaskQuestionList];
        }
    }
}

//保存答题进度
- (void)reqTaskQuestionList {
    
//    WS(ws);
//    [self.view showLoadingView];
//    [RequestCenter reqTaskQuestionList:_taskMo.taskId finish:^(LTResponse *res) {
//        [ws.view hideLoadingView];
//        if (res.success) {
//            NSArray *arr = [res.resArr copy];
//            ws.questions = [TaskQuestionMo objsWithList:arr];
//            
//            [ws.taskMo saveTaskVersion];
//            NSString *jsonString = [arr toJsonString];
//            [ws.taskMo saveQuestions:jsonString];
//        } else {
//            [ws.view showTip:res.message];
//        }
//    }];
    
}


#pragma mark - action


#pragma mark 保存答案进度
- (void)reqTaskQuestionsave:(BOOL)needHandle {
    if (_finishNum == 0) {
        return;
    }
    if (needHandle) {
        [self.view showLoadingWithMsg:@"正在提交答案"];
    }
    
//    WS(ws);
//    [RequestCenter reqTaskQuestionsave:_taskMo.taskId queSeqNum:_finishNum finish:^(LTResponse *res) {
//        ws.saveFinish = YES;
//        [ws.view hideLoadingView];
//        if (needHandle) {
//            if (res.success) {
//                
//            } else {
//                
//            }
//        }
//    }];
}


#pragma mark  配置数据（进度条）
- (void)configProgress {
    //进度条
    self.progressLab.text = [NSString stringWithFormat:@"%ld/%ld",_finishNum,_questionsCount];
    __block CGFloat w = _progressBgView.w_*_finishNum/_questionsCount;
    WS(ws);
    [UIView animateWithDuration:LTAnimationDuration animations:^{
        [ws.progressFinishView setSW:w];
    }];
}

#pragma mark  配置数据（进度条、题目、答案）
- (void)configData {
    
    //题目
    _qNumLab.text = [NSString stringWithInteger:_finishNum+1];
    
    CGFloat labW = _questionView.w_ - 2*LTAutoW(kQLabX);
    CGFloat firstLineHeadIndent = LTAutoW(kNumLabH+6);
    NSString *problem = _curQuestionMo.queDesc;
    NSAttributedString *ABStr = [problem ABStrSpacing:12 firstLineHeadIndent:firstLineHeadIndent font:autoFontSiz(17)];
    CGSize size = [ABStr autoSize:CGSizeMake(labW, CGFLOAT_MAX)];
    CGFloat labH = size.height;
    _problemLab.frame = CGRectMake(LTAutoW(kQLabX), LTAutoW(32), labW, labH);
    _problemLab.attributedText = ABStr;
    
    _answerView0.frame = CGRectMake(LTAutoW(kQLabX), _problemLab.yh_+LTAutoW(24), labW,0);
    [_answerView0 refView:_curQuestionMo.queAnsList[0]];
    
    _answerView1.frame = CGRectMake(LTAutoW(kQLabX), _answerView0.yh_+LTAutoW(16), labW,0);
    [_answerView1 refView:_curQuestionMo.queAnsList[1]];
    
    [_questionView setSH:(_answerView1.yh_+LTAutoW(24))];
    
    [_questionView animationSingleViewPush:3];
    
}

#pragma mark 点击 下一题、重新答题
- (void)btmBtnAction {
    if (btnType == TQBtnType_Back) {
        [self.navigationController popVC];
        return;
    }
    
    if (btnType == TQBtnType_Finish) {//完成
        [self finishTip];
    } else {
        [_answerView0 changeType:AnswerType_Normal];
        [_answerView1 changeType:AnswerType_Normal];
        [self showExplainViewAndBtmView:NO];
        
        if (btnType == TQBtnType_Next) {//下一题
            self.curQuestionMo = _questions[_finishNum];
            [self configData];
            if (questionFinished) {
                [self finishQuestion];
                [self showExplainViewAndBtmView:YES];
            }
        } else {//重新答题
            
        }
    }
}


#pragma mark 完成所有题目,直接显示答案
- (void)finishQuestion {
    NSInteger idx = 0;
    NSInteger rightAnswer = _curQuestionMo.queAnsSeqNum;
    for (NSDictionary *dic in _curQuestionMo.queAnsList) {
        NSInteger num = [dic integerFoKey:@"queAnsSeqNum"];
        if (num == rightAnswer) {
            break;
        }
        idx ++;
    }
    [self selectAnswer:rightAnswer idx:idx];
}


#pragma mark  选择答案
- (void)selectAnswer:(NSInteger)num idx:(NSInteger)idx {
    
    [self configExplainData];
    
    NSInteger rightAnswer = _curQuestionMo.queAnsSeqNum;
    if (num == rightAnswer) {//选对了
        _finishNum ++;
        [TaskListMo setCurFinishQuestionNum:_finishNum taskId:_taskMo.taskId];
        [self configProgress];
        if (idx == 0) {
            [_answerView0 changeType:AnswerType_Right];
            [_answerView1 changeType:AnswerType_UnSelect_Wrong];
        } else {
            [_answerView1 changeType:AnswerType_Right];
            [_answerView0 changeType:AnswerType_UnSelect_Wrong];
        }
        if (_finishNum == _questionsCount) {
            if (questionFinished) {
                [_btmBtn setTitle:@"返回任务中心" forState:UIControlStateNormal];
                btnType =TQBtnType_Back;
            } else {
                [_btmBtn setTitle:@"查看成绩" forState:UIControlStateNormal];
                btnType =TQBtnType_Finish;
                if (_taskMo.userTaskStatus == 2) {//完成状态：1=完成，2=未完成，3、进行中
                    [self reqTaskQuestionsave:YES];//网络请求
                } else {
                    [self finishTip];
                }
            }
        } else {
            [_btmBtn setTitle:@"下一题" forState:UIControlStateNormal];
            btnType =TQBtnType_Next;
        }
    } else {//选错了
        if (idx == 0) {
            [_answerView0 changeType:AnswerType_Wrong];
            [_answerView1 changeType:AnswerType_UnSelect_Right];
        } else {
            [_answerView1 changeType:AnswerType_Wrong];
            [_answerView0 changeType:AnswerType_UnSelect_Right];
        }
        
        [_btmBtn setTitle:@"重新答题" forState:UIControlStateNormal];
        btnType = TQBtnType_Again;
    }
    
    
    [self showExplainViewAndBtmView:YES];
}



#pragma mark  配置数据（解释）
- (void)configExplainData {
    //解释
    CGFloat explainLabW = self.view.w_ - 2*LTAutoW(24);
    NSString *explain = _curQuestionMo.queExplain;
    NSAttributedString *explainABS = [explain ABStrSpacing:6 font:autoFontSiz(15)];
    CGSize explainsize = [explainABS autoSize:CGSizeMake(explainLabW, CGFLOAT_MAX)];
    CGFloat explainLabH = explainsize.height;
    
    _explainDetailLab.attributedText = explainABS;
    [_explainDetailLab setSH:explainLabH];
    
    _explainView.frame = CGRectMake(0, _questionView.yh_+LTAutoW(20), ScreenW_Lit, _explainDetailLab.yh_+LTAutoW(10));
    
    _scView.contentSize = CGSizeMake(self.view.w_, _explainView.yh_+20);
}

#pragma mark explainView & btmView 显示or隐藏

#define useAllAnimation  1

- (void)showExplainViewAndBtmView:(BOOL)show {
    
    if (questionFinished) {
        _answerView0.userInteractionEnabled = NO;
        _answerView1.userInteractionEnabled = NO;
        
        _explainView.hidden = NO;
        _btmView.hidden = NO;
        
        _explainView.alpha = 1;
        _btmView.alpha = 1;
        return;
    }
    
    WS(ws);
    if (show) {
        _answerView0.userInteractionEnabled = NO;
        _answerView1.userInteractionEnabled = NO;
        
        _explainView.hidden = NO;
        _btmView.hidden = NO;
        
        _explainView.alpha = 0;
        _btmView.alpha = 0;
        if (useAllAnimation) {
            [_explainView setOX:-ScreenW_Lit];
            [_btmView setOX:ScreenW_Lit];
        }
        [UIView animateWithDuration:LTAnimationDuration animations:^{
            ws.explainView.alpha = 1;
            ws.btmView.alpha = 1;
            if (useAllAnimation) {
                [ws.explainView setOX:0];
                [ws.btmView setOX:0];
            }
        }];
    } else {
        _answerView0.userInteractionEnabled = YES;
        _answerView1.userInteractionEnabled = YES;
        
        _explainView.alpha = 1;
        _btmView.alpha = 1;
        if (useAllAnimation) {
            [_explainView setOX:0];
            [_btmView setOX:0];
        }
        [UIView animateWithDuration:LTAnimationDuration animations:^{
            ws.explainView.alpha = 0;
            ws.btmView.alpha = 0;
            if (useAllAnimation) {
                [ws.explainView setOX:-ScreenW_Lit];
                [ws.btmView setOX:ScreenW_Lit];
            }
        } completion:^(BOOL finished) {
            ws.explainView.hidden = YES;
            ws.btmView.hidden = YES;
        }];
    }
    

}

#pragma mark - init

#pragma mark 进度条
- (void)createProgressView {

    self.progressBaseView = [[UIView alloc] init];
    _progressBaseView.frame = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, LTAutoW(64));
    _progressBaseView.backgroundColor = LTBgColor;
    [self.view addSubview:_progressBaseView];
    

    CGFloat pvRightMar = LTAutoW(40);
    CGFloat pLabW = LTAutoW(56);
    CGFloat pLabX = LTAutoW(kLeftMar);
    CGFloat pvw = ScreenW_Lit - pLabX - pLabW - pvRightMar;
    
    self.progressLab = [self lab:17 color:LTSubTitleColor];
    _progressLab.frame = CGRectMake(pLabX, 0, pLabW, _progressBaseView.h_);
    _progressLab.textAlignment = NSTextAlignmentCenter;
    [_progressBaseView addSubview:_progressLab];
    
    CGFloat progressH = LTAutoW(8);
    CGFloat r = 0.5*progressH;
    self.progressBgView = [[UIView alloc] init];
    _progressBgView.frame = CGRectMake(_progressLab.xw_, (_progressBaseView.h_ - progressH)/2, pvw, progressH);
    [_progressBgView layerRadius:r bgColor:LTColorHexA(0x848999, 0.2)];
    [_progressBaseView addSubview:_progressBgView];
    
    self.progressFinishView = [[UIView alloc] init];
    _progressFinishView.frame = CGRectMake(0, 0, 0, progressH);
    [_progressFinishView layerRadius:r bgColor:LTSureFontBlue];
    [_progressBgView addSubview:_progressFinishView];
    
}


#pragma mark 题目& 解释

- (void)createScView {
    CGFloat scViewY = _progressBaseView.yh_;
    scViewH = self.view.h_ - scViewY - LTAutoW(kTQBtmBtnH+2*kTQBtmBtnTopMar) - 5;
    
    self.scView = [[UIScrollView alloc] init];
    _scView.frame = CGRectMake(0, scViewY, self.view.w_, scViewH);
    _scView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scView];
    
    
    [self createQuestionView];
    [self createExplainView];
}

//题目
- (void)createQuestionView {
    self.questionView = [[UIView alloc] init];
    _questionView.frame = CGRectMake(LTAutoW(kLeftMar), 0, ScreenW_Lit - 2*LTAutoW(kLeftMar), 200);
    _questionView.backgroundColor = LTWhiteColor;
    _questionView.layer.cornerRadius = 0.5*LTAutoW(8);
    _questionView.layer.masksToBounds = YES;
    [_scView addSubview:_questionView];


    CGFloat numLabW = LTAutoW(kNumLabH);
//    CGFloat questionX = LTAutoW(kQLabX);
    self.problemLab = [self lab:17 color:LTTitleColor];
    _problemLab.numberOfLines = 0;
    [_questionView addSubview:_problemLab];
    
    self.qNumLab = [self lab:17 color:LTWhiteColor];
    _qNumLab.frame = CGRectMake(0, 0, numLabW, numLabW);
    _qNumLab.textAlignment = NSTextAlignmentCenter;
    [_qNumLab layerRadius:numLabW*0.5 bgColor:LTSureFontBlue];
    [_problemLab addSubview:_qNumLab];
    

    
    WS(ws);
    self.answerView0 = [[AnswerView alloc] init];
    [_questionView addSubview:_answerView0];
    _answerView0.answerViewBlock = ^(NSInteger num){
        [ws selectAnswer:num idx:0];
    };
    
    self.answerView1 = [[AnswerView alloc] init];
    [_questionView addSubview:_answerView1];
    _answerView1.answerViewBlock = ^(NSInteger num){
        [ws selectAnswer:num idx:1];
    };
    
}

//解释
- (void)createExplainView {

    self.explainView = [[UIView alloc] init];
    _explainView.backgroundColor = LTBgColor;
    [_scView addSubview:_explainView];
    _explainView.hidden = YES;
    
    self.explainLab = [self lab:12 color:LTWhiteColor];
    _explainLab.frame = LTRectAutoW(24, 0, 48, 20);
    _explainLab.text = @"解释";
    _explainLab.textAlignment = NSTextAlignmentCenter;
    [_explainLab layerRadius:3 bgColor:LTColorHexA(0x848999, 0.5)];
    [_explainView addSubview:_explainLab];
    
    self.explainDetailLab = [self lab:15 color:LTColorHex(0x4A4A4A)];
    _explainDetailLab.frame = CGRectMake(LTAutoW(24), _explainLab.yh_ + LTAutoW(12), self.view.w_ - 2*LTAutoW(24), 60);
    _explainDetailLab.numberOfLines = 0;
    [_explainView addSubview:_explainDetailLab];
    
}

#pragma mark 底部按钮
- (void)createBtmView {
    
    CGFloat btnh = LTAutoW(kTQBtmBtnH);
    CGFloat btmViewH = LTAutoW(2*kTQBtmBtnTopMar) + btnh;
    self.btmView = [[UIView alloc] init];
    _btmView.frame = CGRectMake(0, self.view.h_ - btmViewH, self.view.w_, btmViewH);
    _btmView.backgroundColor = LTBgColor;
    [self.view addSubview:_btmView];
    _btmView.hidden = YES;
    
    self.btmBtn = [UIButton btnWithTarget:self action:@selector(btmBtnAction) frame:CGRectMake(LTAutoW(kLeftMar), LTAutoW(kTQBtmBtnTopMar), self.view.w_ - 2*LTAutoW(kLeftMar), btnh)];
    [_btmBtn layerRadius:3 bgColor:LTSureFontBlue];
    [_btmBtn setTitleColor:LTWhiteColor forState:UIControlStateNormal];
    [_btmView addSubview:_btmBtn];
    

}


#pragma mark - utils

- (UILabel *)lab:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *lab = [[UILabel alloc] init];
    lab.font = autoFontSiz(fontSize);
    lab.textColor = color;
    return lab;
}

- (void)finishTip {
    WS(ws);
    [LTMaskTipView showTaskFinishTip:^{
        IntegralVCtrl *ctrl = [[IntegralVCtrl alloc] init];
        ctrl.backType = BackType_PopToRoot;
        [ws.navigationController pushVC:ctrl];
    } cancleBlock:^{
        [ws backTaskCenter];
    } point:_taskMo.queSucessPoints];
}



#pragma mark 重新父类方法

- (void)returnBack {
    
    if (questionFinished) {
        [self.navigationController popVC];
        return;
    }
    
    if (_finishNum == 0) {
        [self backTaskCenter];
    } else {
        WS(ws);
        [LTAlertView alertTitle:@"确定退出？" message:@"全部答完才能获得积分" sureTitle:@"继续答题" sureAction:nil cancelTitle:@"退出" cancelAction:^{
            [ws backTaskCenter];
        } sureBtnTextColor:LTSureFontBlue cancelBtnTextColor:LTSubTitleColor];
    }
}

- (void)backTaskCenter {
    if (_finishNum == _questionsCount) {
        _reloadTaskList ? _reloadTaskList() : nil;
    }
    [self.navigationController popVC];
}


@end
