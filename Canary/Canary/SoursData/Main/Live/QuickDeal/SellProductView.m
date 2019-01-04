//
//  SellProductView.m
//  ixit
//
//  Created by litong on 2017/3/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "SellProductView.h"
#import "QuickDealHoldCell.h"
#import "Masonry.h"


#define kHeadViewH  45
#define kFootViewH    44

#define footBtnTag  3000

static CGFloat kMid = 12.f;
static CGFloat kHeaderH = 48.f;
static CGFloat kCellH = kQuickDealHoldCellH;
static NSInteger kBtnSectionTag = 2000;
static NSInteger kHeadSectionTag = 3000;


@interface SellProductView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,assign) CGFloat contentViewY;
@property (nonatomic,assign) CGFloat contentViewH;
@property (nonatomic,strong) UIView *contentView;// headView+ scView + footView
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIButton *sellBtn;

@property (nonatomic,strong) NSArray *exTypeNames;


@property (nonatomic,copy) NSMutableArray *holdList;//一围数组
@property (nonatomic,copy) NSMutableArray *holdListTwo;//二围数组
@property (nonatomic,assign) BOOL canUpdate;//是否能更新数据
@property(strong,nonatomic)NSMutableDictionary * slectDic;//用于标记选中状态的字典

@property (nonatomic,strong) UIView *emptyView;


@end

@implementation SellProductView


- (instancetype)initWithContentY:(CGFloat)y; {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenW_Lit, ScreenH_Lit);
        self.backgroundColor = LTMaskColor;
        self.contentViewY = y;
        self.contentViewH = ScreenH_Lit - self.contentViewY;

        _slectDic = [[NSMutableDictionary alloc] init];
        _holdList = [NSMutableArray array];
        _holdListTwo = [NSMutableArray array];
        _canUpdate = YES;
        [self createView];
    }
    return self;
}

- (void)createView {
    
    UIButton *bgBtn = [self btnFrame:CGRectMake(0, 0, self.w_, self.h_) sel:@selector(shutThisView)];
    bgBtn.backgroundColor = self.backgroundColor;
    [self addSubview:bgBtn];
    
    self.contentView = [[UIView alloc] init];
    _contentView.frame = CGRectMake(0, self.contentViewY, self.w_, self.contentViewH);
    _contentView.backgroundColor = LTWhiteColor;
    [self addSubview:_contentView];
    
    //头部条
    CGFloat headH = LTAutoW(kHeadViewH);
    self.headView = [[UIView alloc] init];
    _headView.frame = CGRectMake(0, 0, ScreenW_Lit, headH);
    _headView.backgroundColor = LTBgColor;
    [_contentView addSubview:_headView];
    
    UILabel *titleLab = [UILabel labRect:CGRectMake(0, 0, _headView.w_, _headView.h_) font:boldFontSiz(18) textColor:LTTitleColor];
    titleLab.text = @"平仓";
    titleLab.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:titleLab];
    
    //底部条
    CGFloat footH = LTAutoW(kFootViewH);
    self.footView = [[UIView alloc] init];
    _footView.frame = CGRectMake(0, _contentViewH - footH, ScreenW_Lit, footH);
    _footView.backgroundColor = LTBgColor;
    [_contentView addSubview:_footView];
    
    UIButton *cancleBtn = [self footBtn:0];
    [_footView addSubview:cancleBtn];
    
    self.sellBtn = [self footBtn:1];
    _sellBtn.selected = NO;
    _sellBtn.userInteractionEnabled = NO;
    [_footView addSubview:_sellBtn];
    
    [_footView addLine:LTLineColor frame:CGRectMake(0, 0, _footView.w_, 0.5)];
    
    //中间部分

    CGRect rect = CGRectMake(0, headH, self.w_, self.contentViewH - headH - _footView.h_);
    self.tableView = [[UITableView alloc] init];
    _tableView.frame = rect;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces=NO;
    [self addSubview:_tableView];
    
    [_tableView registerClass:[QuickDealHoldCell class] forCellReuseIdentifier:@"QuickDealHoldCellID"];
    [_contentView addSubview:_tableView];
    
    self.userInteractionEnabled = YES;
    self.hidden = YES;
    
    
    self.emptyView = [[UIView alloc] init];
    _emptyView.frame = rect;
    [_contentView addSubview:_emptyView];
    
    CGFloat ivw = 270/2.0;
    CGFloat ivh = 252/2.0;
    UIImageView *emptyIV = [[UIImageView alloc] init];
    emptyIV.image = [UIImage imageNamed:@"holdListEmptyView"];
    emptyIV.frame = CGRectMake((_emptyView.w_ - ivw)/2.0, (_emptyView.h_ - ivh)/2.0, ivw, ivh);
    [_emptyView addSubview:emptyIV];
    
}



#pragma mark  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _holdListTwo.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_holdListTwo[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"QuickDealHoldCellID";
    QuickDealHoldCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[QuickDealHoldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark  UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return kHeaderH;
    }
    else {
        return kHeaderH + kMid;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark - utils

- (void)configAllSelectBtn:(NSInteger)section {

}

- (UILabel *)createLable {
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment=NSTextAlignmentLeft;
    lab.textColor=LTTitleColor;
    lab.font=fontSiz(15.f);
    lab.backgroundColor=[UIColor clearColor];
    return lab;
}

- (UIButton *)createBtnWithTag:(NSInteger)tag {
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(Screen_width-16-100, 0, 100, kHeaderH);
    [btn setTitle:@"全选" forState:UIControlStateNormal];
    [btn setTitle:@"取消全选" forState:UIControlStateSelected];
    btn.titleLabel.font=fontSiz(midFontSize);
    btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [btn setTitleColor:BlueFont forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(chooseAllAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    return btn;
}

- (UILabel *)lab:(CGFloat)y text:(NSString *)text {
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(LTAutoW(kLeftMar), y, LTAutoW(200), LTAutoW(17))];
    lab.font = autoFontSiz(15);
    lab.textColor = LTSubTitleColor;
    lab.text = text;
    return lab;
}

- (UIButton *)footBtn:(NSInteger)idx {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clickFootBtn:) forControlEvents:UIControlEventTouchUpInside];

    NSString *name = nil;
    UIColor *bgNorColor = nil;
    UIColor *bgSelColor = nil;
    UIColor *txtNorColor = nil;
    UIColor *txtSelColor = nil;
    if (idx == 0) {
        name = @"取消";
        txtNorColor = LTSubTitleColor;
        bgNorColor = LTBgColor;
        
        txtSelColor = LTSubTitleColor;
        bgSelColor = LTBgColor;
    } else {
        name = @"快速平仓";
        txtNorColor = LTWhiteColor;
        bgNorColor = LTSubTitleRGB;
        
        txtSelColor = LTWhiteColor;
        bgSelColor = LTSureFontBlue;
    }
    
    [btn setBackgroundImage:[UIImage imageWithColor:bgNorColor size:CGSizeMake(20, 20)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:bgSelColor size:CGSizeMake(20, 20)] forState:UIControlStateSelected];

    [btn setTitleColor:txtNorColor forState:UIControlStateNormal];
    [btn setTitleColor:txtSelColor forState:UIControlStateSelected];

    btn.titleLabel.font = autoFontSiz(17);
    btn.tag = footBtnTag + idx;
    [btn setTitle:name forState:UIControlStateNormal];
    btn.frame = CGRectMake(idx*ScreenW_Lit*0.5, 0, ScreenW_Lit*0.5, LTAutoW(kFootViewH));

    
    return btn;
}

- (UIButton *)btnFrame:(CGRect)r sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = r;
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:LTSureFontBlue forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontOfSize:15.f];
    [self addSubview:btn];
    return btn;
}


//修改快速平仓按钮的状态
- (void)changeFooterBtnEnable {
    
    NSEnumerator * enumeratorValue = [_slectDic objectEnumerator];
    BOOL flag = NO;
    for (NSNumber *object in enumeratorValue) {
        flag = [object boolValue];
        
        if (flag) {
            break;
        }
    }
    
    _sellBtn.selected = flag;
    _sellBtn.userInteractionEnabled = flag;
}


- (void)showHoldListEmptyView {
    BOOL show = (self.holdList.count > 0);
    _emptyView.hidden = show;
    _tableView.hidden = !show;
}

#pragma mark - action

//关闭view
- (void)shutThisView {
    _shutView ? _shutView() : nil;
    [self showView:NO];
}

//取消 / 快速平仓
- (void)clickFootBtn:(UIButton *)sender {
    BOOL isCancle = (sender.tag == footBtnTag);
    if (isCancle) {//取消
        [self shutThisView];
    } else {//快速平仓
        if ([self.fromClassString isEqualToString:@"WeiPanMarketViewController"]) {
            UMengEvent(UM_MarketDetail_Sell);
        }
        [self closeOutRecursion];
    }
}

//全选、反选
- (void)chooseAllAction:(UIButton *)sender {

}



- (void)chooseAllActionWithSelectFlag:(BOOL)select {

}



- (void)closeOutRecursion {
    BOOL flag = NO;
    _canUpdate = NO;
    NSArray *allkey = [_slectDic allKeys];
    for (NSString *key in allkey) {
        if ([_slectDic boolFoKey:key]) {
            flag=YES;
            [self closePositionWithOrderId:key];
            break;
        }
    }
    if (!flag) {
        NSLog(@"平仓完毕");
        _canUpdate = YES;
        [_tableView reloadData];
        
        [self shutThisView];
        
        [self sellOver:@"平仓成功" code:@""];
    }
}


- (void)sellOver:(NSString *)msg code:(NSString *)code {
    _sellFinish ? _sellFinish(msg ,code) : nil ;
}

- (void)closePositionWithOrderId:(NSString *)orderId {
    [self showLoadingView];
    WS(ws);
    [RequestCenter reqEXOrderCloseWithOrderId:orderId finish:^(LTResponse *res) {
        [ws hideLoadingView];
        if (res.success) {
            [ws configDatasWithOrderId:orderId];
        } else {
            [ws showTip:res.message];
        }
        
    }];
    
}

- (void)configDatasWithOrderId:(NSString *)orderId {

}

#pragma mark 动画显示隐藏

static CGFloat animateDuration = 0.3;
- (void)showView:(BOOL)show {
    WS(ws);
    if (show) {
        NFCPost_FloatingPlayHide;
        [self.superview bringSubviewToFront:self];
        self.alpha = 0.3;
        [self changeContentViewUp:NO];
        self.hidden = NO;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:animateDuration animations:^{
            ws.alpha = 1;
            [ws changeContentViewUp:YES];
        } completion:^(BOOL finished) {
            ws.userInteractionEnabled = YES;
        }];
        
    } else {
        NFCPost_FloatingPlayShow;
        self.alpha = 1;
        self.userInteractionEnabled = NO;
        [self changeContentViewUp:YES];
        [UIView animateWithDuration:animateDuration animations:^{
            ws.alpha = 0.3;
            [ws changeContentViewUp:NO];
        } completion:^(BOOL finished) {
            ws.userInteractionEnabled = YES;
            ws.hidden = YES;
        }];
    }
    
}

- (void)changeContentViewUp:(BOOL)up {
    CGFloat y = up ? self.contentViewY : self.h_;
    [_contentView setOY:y];
}


#pragma mark - 外部

- (void)refDatas:(NSArray *)holdList {
    if (_canUpdate) {
        [_holdList removeAllObjects];
        [_holdList addObjectsFromArray:holdList];
        [_holdListTwo removeAllObjects];
        
        [_tableView reloadData];
    }
    [self showHoldListEmptyView];
}



@end
