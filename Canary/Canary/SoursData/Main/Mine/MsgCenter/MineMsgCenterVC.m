//
//  MineMsgCenterVC.m
//  ixit
//
//  Created by litong on 2017/3/10.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MineMsgCenterVC.h"
#import "MineMsgCenterCell.h"
#import "SelDateView.h"
#import "SelTypeView.h"

#define selViewH 45
#define tempH     8

#define onlyUseTime         1

#if onlyUseTime
#define MsgTypeList @[@"全部"]
#else
#define MsgTypeList @[@"全部",@"官",@"券",@"仓"]
#endif

@interface MineMsgCenterVC ()
{
    BOOL showDatePicker;
    BOOL showTypePicker;
}

@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,strong) UIView *selView;//选择

//选择日期
@property (nonatomic,strong) UIButton *selDateBtn;
@property (nonatomic,strong) UILabel *dateLab;
@property (nonatomic,strong) UIImageView *dateIV;
@property (nonatomic,strong) SelDateView *selDateView;
@property (nonatomic,copy) NSString *ym;

//选择类型
@property (nonatomic,strong) UIButton *selTypeBtn;
@property (nonatomic,strong) UILabel *typeLab;
@property (nonatomic,strong) UIImageView *typeIV;
@property (nonatomic,strong) SelTypeView *selTypeView;
@property (nonatomic,copy) NSString *typeStr;
//selType : MsgTypeList
@property (nonatomic,assign) NSInteger selType;

@end

@implementation MineMsgCenterVC

- (instancetype)init {
    self = [super init];
    if (self) {
        showDatePicker = NO;
        showTypePicker = NO;
        self.selType = 0;
        self.ym = [[NSDate date] chinaFmt:@"yyyy-MM"];
        
        self.pageSize = kPageSize;
        self.list = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navTitle:@"消息中心" backType:BackType_PopVC];
    
    [self createSelView];
    
    [self createTableViewWithHeaderAndFooter];
    CGFloat tabViewY = NavBarTop_Lit+selViewH+tempH;
    CGRect rect = CGRectMake(0, tabViewY, ScreenW_Lit, ScreenH_Lit - tabViewY);
    self.tableView.frame = rect;
    self.tableView.backgroundColor = LTWhiteColor;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configDatas:(NSString *)messageDetailId {
    NSInteger i = 0;
    NSInteger count = _list.count;
//    MineMsgCenterMO *mo = nil;
    NSInteger curI = -1;
    for (i = 0 ; i < count; i++) {
        MineMsgCenterMO *item = _list[i];
        if ([item.messageDetailId isEqualToString:messageDetailId]) {
            curI = i;
            break;
        }
    }
    
    if (curI >= 0) {
        MineMsgCenterMO *item = _list[i];
        [item setStatus:2];
        [_list replaceObjectAtIndex:curI withObject:item];
        [self.tableView reloadData];
    }
}

#pragma mark - request


- (void)reqMsgList {
#warning 暂时注释
//    WS(ws);
//    
//    if (self.pageNo != kStartPageNum) {
//        [self showLoadingView];
//    }
//    [RequestCenter reqMsgList:self.pageNo pageSize:self.pageSize yearMonth:_ym messageTypes:self.selMessageTypes finish:^(LTResponse *res) {
//        [ws hideLoadingView];
//        if (res.success) {
//            
//            if (ws.pageNo == kStartPageNum) {
//                [ws.list removeAllObjects];
//            }
//            
//            NSArray *arr = [MineMsgCenterMO objsWithList:res.resArr];
////            NSArray *arr = [MineMsgCenterMO testDatas];
//            
//            if (arr.count < ws.pageSize) {
//                [ws.tableView.footer noticeNoMoreData];
//            } else {
//                [ws.tableView.footer resetNoMoreData];
//            }
//            
//            [ws.list addObjectsFromArray:arr];
//            
//            if (_list.count == 0) {
//                [ws showEmptySubView:ws.tableView];
//            } else {
//                [ws hideEmptyView];
//            }
//            
//            [ws endHeadOrFootRef];
//            [ws.tableView reloadData];
//            
//        } else {
//            [LTAlertView alertMessage:res.message];
//        }
//    }];
    
}


- (void)reqMsgRead:(NSString *)messageDetailId {
    
#warning 暂时注释
    
//    WS(ws);
//    [RequestCenter reqMsgReadWithMessageDetailId:messageDetailId finish:^(LTResponse *res) {
//        if (res.success) {
//            [ws configDatas:messageDetailId];
//        } else {
//            
//        }
//    }];
    
}



#pragma mark - 父类重写

//下拉上提刷新调用
- (void)loadData {
    [self reqMsgList];
}

- (void)returnBack {
    _allMessageReadedBlock ? _allMessageReadedBlock() : nil;
    
    [self.navigationController popVC];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"MineMsgCenterCell";
    MineMsgCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MineMsgCenterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSInteger row = indexPath.row;
    MineMsgCenterMO *mo = _list[row];
    [cell bindData:mo];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    MineMsgCenterMO *mo = _list[row];
    return [MineMsgCenterCell viewH:mo];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    MineMsgCenterMO *mo = _list[row];
    
    if (mo.showRed) {
        [self reqMsgRead:mo.messageDetailId];
    }
    
    if (notemptyStr(mo.url)) {
        [self presentWeb:mo.url title:mo.messageTitle];
    }
    
}



#pragma mark - head

- (void)createSelView {

    self.selView = [[UIView alloc] init];
    _selView.frame = CGRectMake(0, NavBarTop_Lit, ScreenW_Lit, selViewH);
    _selView.backgroundColor = LTWhiteColor;
    [self.view addSubview:_selView];
    
    [self createSelDateBtn];
    [self createSelDatePicker];
    
    [self createSelTypeBtn];
    [self createSelTypePicker];
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, selViewH-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [_selView addSubview:lineView];
    
}


#pragma mark 选择日期

- (void)createSelDateBtn {
    CGFloat selBtnW = ScreenW_Lit*0.5;
    CGFloat ivw = 11;
    CGFloat ivh = 7;
    
    self.selDateBtn = [UIButton btnWithTarget:self action:@selector(selDateAction) frame:CGRectMake(0, 0, selBtnW, selViewH)];
    _selDateBtn.backgroundColor = LTWhiteColor;
    [_selView addSubview:_selDateBtn];
    [_selDateBtn addLineRight:LTLineColor];
    
    self.dateLab = [[UILabel alloc] init];
    _dateLab.frame = CGRectMake(0, 0, ScreenW_Lit*0.4, selViewH);
    _dateLab.text = [self ymFmt];
    _dateLab.font = [UIFont fontOfSize:15];
    _dateLab.textColor = LTTitleColor;
    _dateLab.textAlignment = NSTextAlignmentCenter;
    [_selView addSubview:_dateLab];
    
    
    self.dateIV = [[UIImageView alloc] init];
    _dateIV.frame = CGRectMake(selBtnW - LTAutoW(44) - ivw, (selViewH - ivh)*0.5, ivw, ivh);
    _dateIV.image = [UIImage imageNamed:@"Shop_btn_close"];
    [_selView addSubview:_dateIV];
}

- (void)createSelDatePicker {
    CGFloat selDateViewY = _selView.y_;
    CGRect sr = CGRectMake(0, selDateViewY, ScreenW_Lit, ScreenH_Lit - selDateViewY);
    self.selDateView = [[SelDateView alloc] initWithFrame:sr ym:_ym];
    [self.view addSubview:_selDateView];
    
    WS(ws);
    _selDateView.selDateBlock = ^(NSString *ym) {
        ws.ym = ym;
        ws.dateLab.text = [ws ymFmt];
        ws.pageNo = kStartPageNum;
        [ws reqMsgList];
    };
    _selDateView.selDateViewShowBlock = ^(BOOL show) {
        [ws configDateIV:show];
    };
}

- (void)selDateAction {
    showDatePicker = !showDatePicker;
    
    //yes 显示日期
    [_selDateView showView:showDatePicker];
    [self.view bringSubviewToFront:_selDateView];
    [self configDateIV:showDatePicker];
    
}

- (void)configDateIV:(BOOL)show {
    showDatePicker = show;
    NSString *str = showDatePicker ? @"Shop_btn_open" : @"Shop_btn_close";
    _dateIV.image = [UIImage imageNamed:str];
}

- (NSString *)ymFmt {
    NSString *str = [_ym replacStr:@"-" withStr:@"年"];
    NSString *ym = [NSString stringWithFormat:@"%@月",str];
    return ym;
}

#pragma mark 选择类型

- (void)createSelTypeBtn {
    CGFloat selBtnW = ScreenW_Lit*0.5;
    CGFloat ivw = 11;
    CGFloat ivh = 7;
    
    self.selTypeBtn = [UIButton btnWithTarget:self action:@selector(selTypeAction) frame:CGRectMake(selBtnW, 0, selBtnW, selViewH)];
    _selTypeBtn.backgroundColor = LTWhiteColor;
    [_selView addSubview:_selTypeBtn];
    
    self.typeLab = [[UILabel alloc] init];
    _typeLab.frame = CGRectMake(0, 0, ScreenW_Lit*0.4, selViewH);
    _typeLab.text = @"全部";
    _typeLab.font = [UIFont fontOfSize:15];
    _typeLab.textColor = LTTitleColor;
    _typeLab.textAlignment = NSTextAlignmentCenter;
    [_selTypeBtn addSubview:_typeLab];
    
    self.typeIV = [[UIImageView alloc] init];
    _typeIV.frame = CGRectMake(selBtnW - 44 - ivw, (selViewH - ivh)*0.5, ivw, ivh);
    _typeIV.image = [UIImage imageNamed:@"Shop_btn_close"];
    [_selTypeBtn addSubview:_typeIV];
    _typeIV.hidden = (MsgTypeList.count <= 1);
}

- (void)configureTypeUI:(NSString *)str {
    if (ScreenW_Lit <= 320) {
        CGFloat selBtnW = ScreenW_Lit*0.5;
        CGFloat ivw = 11;
        CGFloat ivh = 7;
        if (str.length > 2) {
            _typeLab.frame = CGRectMake(0, 0, ScreenW_Lit*0.4, selViewH);
            _typeIV.frame = CGRectMake(selBtnW - 20 - ivw, (selViewH - ivh)*0.5, ivw, ivh);
        } else {
            _typeLab.frame = CGRectMake(0, 0, ScreenW_Lit*0.4, selViewH);
            _typeIV.frame = CGRectMake(selBtnW - 44 - ivw, (selViewH - ivh)*0.5, ivw, ivh);
        }
    }
}

- (void)createSelTypePicker {
    CGFloat selDateViewY = _selView.y_;
    CGRect sr = CGRectMake(0, selDateViewY, ScreenW_Lit, ScreenH_Lit - selDateViewY);
    self.selTypeView = [[SelTypeView alloc] initWithFrame:sr selRow:_selType typeList:MsgTypeList];
    [self.view addSubview:_selTypeView];
    
    WS(ws);
    _selTypeView.selTypeBlock = ^(NSString *typeStr,NSInteger row) {
        ws.typeStr = typeStr;
        ws.selType = row;
        ws.typeLab.text = typeStr;
        ws.pageNo = kStartPageNum;
        [ws reqMsgList];
        [ws configureTypeUI:typeStr];
    };
    _selTypeView.selTypeViewShowBlock = ^(BOOL show) {
        [ws configTypeIV:show];
    };
}

- (void)selTypeAction {
    if (MsgTypeList.count <= 1) {
        return;
    }
    showTypePicker = !showTypePicker;
    
    //yes 显示日期
    [_selTypeView showView:showTypePicker];
    [self.view bringSubviewToFront:_selTypeView];
    [self configTypeIV:showTypePicker];
    
}

- (void)configTypeIV:(BOOL)show {
    showTypePicker = show;
    NSString *str = showTypePicker ? @"Shop_btn_open" : @"Shop_btn_close";
    _typeIV.image = [UIImage imageNamed:str];
}

#pragma mark - utils

- (NSString *)selMessageTypes {
/*    #define MsgTypeList @[@"全部",@"官方",@"优惠券",@"仓"]
    2,行情提醒;（不处理）
 */
    
    if (self.selType == 0) {//@"全部"
        return nil;
    }
    else if (self.selType == 1) {
        //官 -- 1：系统消息; 8：交易风险-系统提示;
        return @"1,8";
    }
    else if (self.selType == 2) {
        //券 --  4,代金券-到账提醒;5,代金券-到期提现;6,代金券-即将到期;
        return @"4,5,6";
    }
    else if (self.selType == 3) {
        //仓 -- 3,系统平仓-爆仓提醒;7,系统平仓-止盈止损;
        return @"3,7";
    } else {
        return nil;
    }
}


@end
