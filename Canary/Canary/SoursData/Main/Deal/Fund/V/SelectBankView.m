//
//  SelectBankView.m
//  Canary
//
//  Created by litong on 2017/6/3.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "SelectBankView.h"


#define kHeadH   44
#define kTableViewH   210
#define kContentH   (kHeadH + kTableViewH)
#define kBankCardCellID  @"kBankCardCellID"

@interface SelectBankView ()<BankCardCellDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *list;

@property (nonatomic,strong) UILabel *headLab;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSString *bid;

@end

@implementation SelectBankView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configContentH:kContentH];
        [self initView];
    }
    return self;
}

- (void)initView {
    [self createHeadView];
    [self createTableView];
}

- (void)createHeadView {
    self.headLab = [UILabel labRect:CGRectMake(0, 0, ScreenW_Lit, kHeadH) font:boldFontSiz(15) textColor:LTTitleColor text:@"选择银行卡"];
    _headLab.textAlignment = NSTextAlignmentCenter;
    _headLab.backgroundColor = LTBgColor;
    [self.contentView addSubview:_headLab];
}

- (void)createTableView {
    self.list = [NSMutableArray array];
    CGRect rect = CGRectMake(0, self.headLab.yh_, ScreenW_Lit, kTableViewH);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = LTWhiteColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
    
    [self.tableView registerClass:[BankCardCell class] forCellReuseIdentifier:kBankCardCellID];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger count = _list.count;
    BankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kBankCardCellID];
    if (row < count && count != 0) {
        cell.delegate = self;
        cell.typ = BankCardCellType_Select;
        BankCarkMO *mo = _list[row];
        [cell bindData:mo];
    }
    else {//添加银行卡
        cell.typ = BankCardCellType_AddCard;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kBankCardCellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    NSInteger count = _list.count;
    if (row < count && count != 0) {
        BankCarkMO *mo = _list[row];
        _bid = mo.bankId;
        [self configCellSelect];
        if (_delegate && [_delegate respondsToSelector:@selector(selectedBank:)]) {
            [_delegate selectedBank:mo];
        }
    }
    else {//添加银行卡
        if (_delegate && [_delegate respondsToSelector:@selector(pushBindCard)]) {
            [_delegate pushBindCard];
        }
    }
}

#pragma mark - 选卡

- (void)configCellSelect {
    
    NSInteger i = 0;
    for (BankCarkMO *item in _list) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        BankCardCell *cell = (BankCardCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        NSString *bid = item.bankId;
        BOOL sel = [bid isEqualToString:_bid];
        [cell selectCell:sel];
        
        i ++;
    }
}

#pragma mark - 外部

- (void)configBanks:(NSArray *)banks {
    [self.list removeAllObjects];
    [self.list addObjectsFromArray:banks];
    if (_list.count > 0) {
        if (emptyStr(_bid)) {
            BankCarkMO *mo = _list[0];
            _bid = mo.bankId;
            [self configCellSelect];
        }
    }
    [self.tableView reloadData];
}


@end
