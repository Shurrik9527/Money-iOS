//
//  MyRemind.m
//  ixit
//
//  Created by litong on 2017/2/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MyRemind.h"
#import "RemindCell.h"


static CGFloat kHeadH = 48;
static CGFloat kHeadBtnW = 62;

static CGFloat kFootH = 116;

@interface MyRemind ()<UITableViewDelegate,UITableViewDataSource>
{
    CGFloat tempH;
    CGFloat contentViewH;
}

@property (nonatomic,strong) NSString *excode;
@property (nonatomic,strong) NSString *code;
@property (nonatomic,copy) NSString *pName;

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,assign) CGRect contentViewUpRect;
@property (nonatomic,assign) CGRect contentViewDownRect;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,assign) BOOL showEdit;//YES:左边按钮(编辑) ,NO:取消

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIImageView *tempIV;

@property (nonatomic,strong) UIView *footView;

@property (nonatomic,strong) NSMutableArray *list;



@end

@implementation MyRemind

- (instancetype)initWithTempH:(CGFloat)h excode:(NSString *)excode code:(NSString *)code pName:(NSString *)pName {
    self = [super initWithFrame:CGRectMake(0, 0, ScreenW_Lit, ScreenH_Lit)];
    if (self) {
        tempH = h;
        self.excode = excode;
        self.code = code;
        self.pName = pName;
        contentViewH = self.h_ - tempH;
        self.backgroundColor = LTMaskColor;
        self.list = [NSMutableArray array];
        [self createView];
    }
    return self;
}



#pragma mark - action

- (void)clickRightBtn {
    [self showView:NO];
}

- (void)cancleAction {
    [self showView:NO];
}

- (void)clickLeftBtn {
    [self intoEditing:_showEdit];
}

- (void)intoEditing:(BOOL)bl {
    if (bl) {//进入编辑状态
        self.tableView.editing = NO;
        [self.tableView setEditing:YES animated:YES];
        self.showEdit = NO;
    } else {//取消编辑状态
        [self.tableView setEditing:NO animated:YES];
        self.showEdit = YES;
    }
}

- (void)addRemind {
    
    if (![LTUser hasLogin]) {
        _goLoginBlock ? _goLoginBlock() : nil;
        return;
    }
    
    [self intoEditing:NO];
    
    if (_list.count >= _remindConfigModel.limitSize.integerValue) {
        [LTAlertView alertTitle:@"最多添加4条提醒" message:@"您可以编辑已有提醒，或者删除\n旧提醒后添加" sureTitle:@"我知道了" sureAction:^{
        }];
        return;
    }
//    [self showView:NO];
    _addRemindBlock ? _addRemindBlock() : nil;
}


- (void)setShowEdit:(BOOL)showEdit {
    _showEdit = showEdit;
    
    if (_showEdit) {
        [_leftBtn setTitle:@"编辑" forState:UIControlStateNormal];
    } else {
        [_leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    }
}

- (void)deleteRow:(NSIndexPath *)indexPath {
    
    [self showLoadingView];
    PushRemindModel *mo = _list[indexPath.row];
    WS(ws);
    [RequestCenter reqReminderDeleteWithId:mo.pid finsh:^(LTResponse *res) {
        [ws hideLoadingView];
        if (res.success) {
            [ws deleteSuccess:indexPath];
        } else {
            [ws showTip:res.message];
        }
    }];
}

- (void)deleteSuccess:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    [self.list removeObjectAtIndex:row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    BOOL listIsEmpty = self.list.count == 0;
    self.tempIV.hidden = !listIsEmpty;
    [self intoEditing:NO];
    
    _reqRemindListBlock ? _reqRemindListBlock() : nil;

}


#pragma mark - 外部

- (void)reload:(NSArray *)list {
    [self.list removeAllObjects];
    [self.list addObjectsFromArray:list];
    NSInteger listCount = _list.count;
    BOOL tempList = (listCount == 0);
    _leftBtn.hidden = tempList;
    _tempIV.hidden = !tempList;

    
//    CGFloat cth = _list.count *LTAutoW(kRemindCellH);
//    self.tableView.contentSize = CGSizeMake(self.w_, cth);
    
    [self.tableView reloadData];
}

#pragma mark 显示关闭
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
        [self intoEditing:NO];
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

- (void)showView:(BOOL)show animate:(BOOL)animate {
    if (animate) {
        [self showView:show];
    } else {
        if (show) {
            NFCPost_FloatingPlayHide;
        } else {
            NFCPost_FloatingPlayShow;
        }
        self.hidden = !show;
        [self changeContentViewUp:show];
        
        if (!show) {
            [self intoEditing:NO];
        }
    }

}

- (void)changeContentViewUp:(BOOL)bl {
    self.contentView.frame = bl ? _contentViewUpRect : _contentViewDownRect;
}


#pragma mark - init

- (void)createView {
    
    UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.backgroundColor = self.backgroundColor;
    bgBtn.frame = CGRectMake(0, 0, self.w_, tempH);
    [bgBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    
    self.contentViewUpRect = CGRectMake(0, tempH, self.w_, contentViewH);
    self.contentViewDownRect = CGRectMake(0, self.h_, self.w_, contentViewH);
    self.contentView = [[UIView alloc] init];
    _contentView.backgroundColor = LTWhiteColor;
    _contentView.frame = _contentViewDownRect;
    [self addSubview:_contentView];
    
    [self createHeadView];
    [self createTableView];
    [self createFootView];
    
}

//头部
- (void)createHeadView {
    self.headView = [[UIView alloc] init];
    _headView.frame = CGRectMake(0, 0, self.w_, LTAutoW(kHeadH));
    _headView.backgroundColor = LTBgColor;
    [_contentView addSubview:_headView];
    
    CGFloat labw = 160;
    UILabel *lab = [[UILabel alloc] init];
    lab.frame = CGRectMake((self.w_ - labw)*0.5, 0, labw, LTAutoW(kHeadH));
    lab.font = autoBoldFontSiz(17);
    lab.textColor = LTTitleColor;
    lab.text = @"我的提醒";
    lab.textAlignment = NSTextAlignmentCenter;
    [_headView addSubview:lab];
    
    self.leftBtn = [self btnX:0 sel:@selector(clickLeftBtn)];
    [_headView addSubview:_leftBtn];
    self.showEdit = YES;
    _leftBtn.hidden = YES;
    
    UIButton *rightBtn = [self btnX:self.w_ - LTAutoW(kHeadBtnW) sel:@selector(clickRightBtn)];
    [rightBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [_headView addSubview:rightBtn];
    
}

//tableView
- (void)createTableView {
    CGFloat tableViewH = contentViewH - LTAutoW(kHeadH) - LTAutoW(kFootH);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _headView.yh_, self.w_, tableViewH) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setAllowsSelectionDuringEditing:YES];
    [_contentView addSubview:_tableView];
    
    CGFloat tempIVW = LTAutoW(74);
    CGFloat tempIVH = LTAutoW(97);
    _tempIV = [[UIImageView alloc] init];
    _tempIV.frame = CGRectMake((_tableView.w_ - tempIVW)/2, (_tableView.h_ - tempIVH)/2, tempIVW, tempIVH);
    _tempIV.image = [UIImage imageNamed:@"market_notReminder"];
    [_tableView addSubview:_tempIV];
}

//footer
- (void)createFootView {
    self.footView = [[UIView alloc] init];
    _footView.frame = CGRectMake(0, contentViewH - LTAutoW(kFootH), self.w_, LTAutoW(kFootH));
    [_contentView addSubview:_footView];
    
    CGFloat btnW = LTAutoW(160);
    CGFloat btnH = LTAutoW(36);
    UIColor *footBtnTextColor = LTColorHex(0x4877E6);
    UIButton *footBtn = [UIButton btnWithTarget:self action:@selector(addRemind) frame:CGRectMake((self.w_ - btnW)/2, (_footView.h_ - btnH)/2, btnW, btnH)];
    footBtn.titleLabel.font = autoFontSiz(15);
    [footBtn setTitle:@"+ 添加提醒" forState:UIControlStateNormal];
    [footBtn setTitleColor:footBtnTextColor forState:UIControlStateNormal];
    [footBtn layerRadius:3 borderColor:footBtnTextColor borderWidth:0.5];
    [_footView addSubview:footBtn];
}

#pragma mark - utils

- (UIButton *)btnX:(CGFloat)x sel:(SEL)sel {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(x, 0,  LTAutoW(kHeadBtnW), LTAutoW(kHeadH));
    btn.titleLabel.font = autoFontSiz(15);
    [btn setTitleColor:LTTitleColor forState:UIControlStateNormal];
    [btn addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    return btn;
}





#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"RemindCell";
    RemindCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[RemindCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PushRemindModel *mo = _list[indexPath.row];
    [cell bindData:mo];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LTAutoW(kRemindCellH);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.editing) {
        if (![LTUser hasLogin]) {
            _goLoginBlock ? _goLoginBlock() : nil;
            return;
        }
        _editRemindBlock ? _editRemindBlock(indexPath.row) : nil;
    } else {

    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteRow:indexPath];
    }
}


@end
