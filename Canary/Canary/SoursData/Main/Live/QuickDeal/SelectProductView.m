//
//  SelectProductView.m
//  ixit
//
//  Created by litong on 2017/3/13.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "SelectProductView.h"
#import "ProductCell.h"

#define kHeadH           40

@interface SelectProductView ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat addSubBgW;
    CGFloat contentW;
    CGFloat contentH;
}

@property(strong,nonatomic)NSMutableArray * datas;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SelectProductView

- (instancetype)initWithContentH:(CGFloat)h {
    self = [super init];
    if (self) {
        self.datas = [NSMutableArray array];
        contentH = h;
        [self configContentH:contentH];
        [self initView];
    }
    return self;
}


- (void)initView {
    
    UILabel *headLab = [UILabel labRect:CGRectMake(0, 0, ScreenW_Lit, kHeadH) font:fontSiz(15) textColor:LTTitleColor text:@"请选择交易产品"];
    headLab.backgroundColor = LTBgColor;
    headLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:headLab];

    CGRect rect = CGRectMake(0, kHeadH, ScreenW_Lit, contentH - kHeadH);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = LTWhiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
    
    self.hidden = YES;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ProductCellID";
    ProductCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSInteger row = indexPath.row;
    ProductMO *mo = _datas[row];
    [cell bindData:mo];
    
    WS(ws);
    cell.buyProductBlock = ^(ProductMO *item, BOOL buyUp){
        if (ws.delegate && [ws.delegate respondsToSelector:@selector(showBuyView:buyUp:)]) {
            [ws.delegate buyUp:buyUp];
        }
    };
    
    return cell;
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ProductCell cellH];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}



#pragma mark 

- (void)configDatas:(NSArray *)datas {
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:datas];
    
    [self.tableView reloadData];
}


@end
