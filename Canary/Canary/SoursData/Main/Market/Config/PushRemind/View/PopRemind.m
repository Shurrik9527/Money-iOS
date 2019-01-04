//
//  PopRemind.m
//  ixit
//
//  Created by litong on 2017/2/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "PopRemind.h"
#import "AppDelegate.h"
@interface PopRemind()
@property(strong,nonatomic)UIView * containerView;
@property(strong,nonatomic)UILabel * titleLab;
@property(strong,nonatomic)UILabel * modelLab;//lab
@property(strong,nonatomic)UILabel * modelTimeLab;

@property(strong,nonatomic)UIButton * marketBtn;//查看行情
@property(strong,nonatomic)UIButton * positionBtn;//查看持仓
@property(strong,nonatomic)UIButton * hidBtn;//知道了

@property(strong,nonatomic)UIButton * nextBtn;//后
@property(strong,nonatomic)UIButton * preBtn;//前


@property(strong,nonatomic)PushRemindModel * currentModel;//当前的提醒model是哪个
@property(assign,nonatomic)NSInteger currentPage;//当前的页数
@property(strong,nonatomic)NSMutableArray * remindList;//当前条数


@end
@implementation PopRemind
-(instancetype)init{
    self = [super initWithFrame:CGRectMake(0, ScreenH_Lit, ScreenW_Lit, ScreenH_Lit)];
    if (self) {
        _isShow=NO;
        _currentPage=0;
        self.backgroundColor = LTMaskColor;
        [self addSingeTap:@selector(hide) target:self];
        [self createView];
    }
    return self;
}
-(void)createView{
    if (!_containerView) {
        _containerView=[[UIView alloc]init];
        _containerView.frame=CGRectMake(0, ScreenH_Lit, ScreenW_Lit,Lit_autoH(288));
        _containerView.backgroundColor=LTWhiteColor;
        [self addSubview:_containerView];
    }
    
    [self initHeaderScrollView];
    
    if (!_marketBtn) {
        _marketBtn=[self createBtnWithFrame:CGRectMake(0, Lit_autoH(136), ScreenW_Lit, Lit_autoH(48)) title:@"查看行情" fontsize:Lit_autoH(15)];
        [_marketBtn setTitleColor:LTTitleColor forState:UIControlStateNormal];
        [_marketBtn addTarget:self action:@selector(pushMarket) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_marketBtn];
    }
    if (!_positionBtn) {
        _positionBtn=[self createBtnWithFrame:CGRectMake(0, _marketBtn.yh_+1, ScreenW_Lit, Lit_autoH(48)) title:@"查看持仓" fontsize:Lit_autoH(15)];
        [_positionBtn setTitleColor:LTTitleColor forState:UIControlStateNormal];
        [_positionBtn addTarget:self action:@selector(pushPosition) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_positionBtn];
    }
    if (!_hidBtn) {
        _hidBtn=[self createBtnWithFrame:CGRectMake(0, _containerView.h_-Lit_autoH(48), ScreenW_Lit, Lit_autoH(48)) title:@"知道了" fontsize:Lit_autoH(15)];
        [_hidBtn setTitleColor:TabBarSelCoror forState:UIControlStateNormal];
        [_hidBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_hidBtn];
    }
    
    
    UIView *line2=[self createLineWithColor:LTBgColor frame:CGRectMake(0, _containerView.h_- Lit_autoH(56), ScreenW_Lit, Lit_autoH(8))];
    [_containerView addSubview:line2];
    
    UIView *line1=[self createLineWithColor:LTBgColor frame:CGRectMake(0, line2.y_- Lit_autoH(48), ScreenW_Lit, 0.5)];
    [_containerView addSubview:line1];
    
    UIView *line=[self createLineWithColor:LTBgColor frame:CGRectMake(0, line1.y_- Lit_autoH(48), ScreenW_Lit, 0.5)];
    [_containerView addSubview:line];
    line2=nil;
    line1=nil;
    line=nil;
    
}
-(void)initHeaderScrollView{
    
    if (!_titleLab) {
        UIView *line=[self createLineWithColor:LTBgColor frame:CGRectMake(0, 0, ScreenW_Lit, Lit_autoH(36))];
        [_containerView addSubview:line];
        line=nil;
        
        _titleLab=[self createLabWithFrame:CGRectMake(16, 0, ScreenW_Lit-32, Lit_autoH(36)) text:@"行情波动提醒" fontsize:Lit_autoH(15)];
        _titleLab.textAlignment=NSTextAlignmentCenter;
        _titleLab.textColor=LTSubTitleColor;
        [_containerView addSubview:_titleLab];
    }
    if (!_modelLab) {
        _modelLab=[self createLabWithFrame:CGRectMake(0, Lit_autoH(64), ScreenW_Lit, Lit_autoH(28)) text:@"" fontsize:Lit_autoH(17)];
        _modelLab.font = boldFontSiz(Lit_autoH(17));
        _modelLab.textColor=LTTitleColor;
        [_containerView addSubview:_modelLab];
    }
    
    if (!_modelTimeLab) {
        _modelTimeLab=[self createLabWithFrame:CGRectMake(0, Lit_autoH(64), ScreenW_Lit, Lit_autoH(28)) text:@"2017.01.01 09:00" fontsize:Lit_autoH(12)];
        _modelTimeLab.textColor=LTSubTitleColor;
        [_containerView addSubview:_modelTimeLab];
    }
    
    if (!_preBtn) {
        _preBtn=[self createBtnWithFrame:CGRectMake(16, Lit_autoH(72), 40, 40) title:@"" fontsize:0];
        [_preBtn setImage:[UIImage imageNamed:@"pre"] forState:UIControlStateNormal];
        [_preBtn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_preBtn];
        _preBtn.hidden=NO;
    }
    if (!_nextBtn) {
        _nextBtn=[self createBtnWithFrame:CGRectMake(ScreenW_Lit-56, _preBtn.y_, _preBtn.w_, _preBtn.h_) title:@"" fontsize:0];
        [_nextBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventTouchUpInside];
        [_containerView addSubview:_nextBtn];
        _nextBtn.hidden=NO;
    }
}
#pragma mark - Action
-(void)configTitle{
    if (_remindList.count>1) {
        _titleLab.text=[NSString stringWithFormat:@"行情波动提醒（共%li/%li条）",_currentPage+1,_remindList.count];
    }else{
        _titleLab.text=@"行情波动提醒";
    }
}
-(void)configLeftRightBtn{
    if (_remindList.count<=1) {
        _preBtn.hidden=YES;
        _nextBtn.hidden=YES;
    }else{
        if (_currentPage==0) {
            _preBtn.hidden=YES;
            _nextBtn.hidden=NO;
        }else if(_currentPage==_remindList.count-1){
            _preBtn.hidden=NO;
            _nextBtn.hidden=YES;
        }else if(_currentPage>0 && _currentPage<_remindList.count-1){
            _preBtn.hidden=NO;
            _nextBtn.hidden=NO;
        }
    }
    
}
-(void)configViewWithModel:(PushRemindModel *)model{
    NSString *pName=model.productName;
    UIColor *color = LTKLineRed;
    NSString *margin=[NSString stringWithFormat:@"%@",model.margin];
    if([margin floatValue]>0){
    }else if([margin floatValue]<0){
        color = LTKLineGreen;
    }else{
        color = LTSubTitleColor;
        margin=[NSString stringWithFormat:@"+%@",margin];
    }
    NSString *substr = [NSString stringWithFormat:@"%@ %@ (%@)",model.customizedProfit,margin,model.mq];
    NSString *str = [NSString stringWithFormat:@"%@ %@",pName,substr];

    NSMutableAttributedString *attrStr = [self attrStrWithStr:str subStr:substr color:color];
    _modelLab.attributedText=attrStr;
    attrStr=nil;
    [_modelLab sizeToFit];
    _modelLab.frame=CGRectMake(0, _modelLab.y_, ScreenW_Lit, _modelLab.h_);
    _modelTimeLab.text=model.sendTime;
    [_modelTimeLab sizeToFit];
    _modelTimeLab.frame=CGRectMake(0, _modelLab.yh_+8, ScreenW_Lit, _modelTimeLab.h_);
    if (!removeTestData) {
        _modelTimeLab.text=model.sendTime;
    }
    [self show];
}
-(void)configViewWithModelList:(NSMutableArray *)list{
    _remindList=nil;
    _remindList =[[NSMutableArray alloc]init];
    [_remindList addObjectsFromArray:list];
    _currentModel=_remindList[0];
    _currentPage=0;
    [self configTitle];
    [self configLeftRightBtn];
    [self configViewWithModel:_currentModel];
}
//切换页
-(void)changePage:(UIButton *)sender{
    if (_remindList.count==0) {
        return;
    }
    if (sender==_nextBtn) {
        _currentPage++;
    }
    if (sender==_preBtn) {
        _currentPage--;
    }
    if (_currentPage<0) {
        _currentPage=0;
    }else if (_currentPage>=_remindList.count){
        _currentPage=_remindList.count-1;
    }
    _currentModel=_remindList[_currentPage];
    [self configTitle];
    [self configLeftRightBtn];
    if (sender==_preBtn) {
        [self changePageAnimationIsLeft:YES];
    }else{
        [self changePageAnimationIsLeft:NO];
    }
    [self configViewWithModel:_currentModel];
}

//跳转行情
-(void)pushMarket{
    [self hide];
    _clickCell?_clickCell(ActionType_PushMarket,_currentModel):nil;
}
//跳转持仓
-(void)pushPosition{
    [self hide];
    if([LTUser hideDeal]){
        [[AppDelegate sharedInstance].rootNavCtrl popToRootVC];
        [AppDelegate selectTabBarIndex:1];
    }else{
        _clickCell?_clickCell(ActionType_PushPosition,_currentModel):nil;
    }
}

-(void)show{
    WS(ws);
    if ([LTUser hideDeal]) {
        [_positionBtn setTitle:@"查看其他行情" forState:UIControlStateNormal];
    }else{
        [_positionBtn setTitle:@"查看持仓" forState:UIControlStateNormal];
    }
    if(ws.containerView.y_<ScreenH_Lit){
        NSLog(@"%.2f",ws.containerView.y_);
        return;
    }
    self.backgroundColor=LTClearColor;
    ws.hidden=NO;
    [UIView animateWithDuration:0.25 animations:^{
        ws.frame=CGRectMake(0, 0, ScreenW_Lit, ScreenH_Lit);
        ws.containerView.frame=CGRectMake(0, ScreenH_Lit-Lit_autoH(288), ScreenW_Lit, Lit_autoH(288));
    } completion:^(BOOL finished) {
        ws.backgroundColor=LTMaskColor;
    }];
    _isShow=YES;
    
}
-(void)hide{
    WS(ws);
    NFC_PostName(NFC_ReloadRemind);
    [UIView animateWithDuration:0.25 animations:^{
        ws.containerView.frame=CGRectMake(0, ScreenH_Lit, ScreenW_Lit, Lit_autoH(288));
    } completion:^(BOOL finished) {
        ws.hidden=YES;
        ws.frame=CGRectMake(0, ScreenH_Lit, ScreenW_Lit, ScreenH_Lit);
    }];
    _isShow=NO;
    _clickCell?_clickCell(ActionType_Hide,_currentModel):nil;
}
-(void)changePageAnimationIsLeft:(BOOL)isLeft{
    if (isLeft) {
        [_modelLab animationSingleViewPush:2];
        [_modelTimeLab animationSingleViewPush:2];
    }else{
        [_modelLab animationSingleViewPush:3];
        [_modelTimeLab animationSingleViewPush:3];
    }
}
- (void)animateShake {
    [self.containerView animationShakeHorizontally];
}

#pragma mark - Utils
-(UIButton *)createBtnWithFrame:(CGRect)frame title:(NSString *)title fontsize:(CGFloat)fsize{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:fsize];
    return btn;
}
-(UILabel *)createLabWithFrame:(CGRect)frame text:(NSString *)text fontsize:(CGFloat)fsize{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:fsize];
    return label;
}
-(UIView *)createLineWithColor:(UIColor *)color frame:(CGRect)frame{
    UIView *line=[[UIView alloc]init];
    line.frame=frame;
    line.backgroundColor=color;
    return line;
}
-(UIScrollView *)createScrollWithFrame:(CGRect)frame{
    UIScrollView *scroll=[[UIScrollView alloc]init];
    scroll.frame=frame;
    scroll.backgroundColor=LTClearColor;
    scroll.scrollEnabled=NO;
//    scroll.pagingEnabled=YES;
//    scroll.delegate=self;
    return scroll;
}
-(NSMutableAttributedString *)attrStrWithStr:(NSString *)str subStr:(NSString *)subStr color:(UIColor *)color{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = [str rangeOfString:subStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attrStr;
}
@end
