//
//  popMoreView.m
//  ixit
//
//  Created by Brain on 2017/2/17.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "PopMoreView.h"

#define ExchangeLabFrame CGRectMake((Screen_width-140)/2.0, 20, 140, 44)

@interface popMoreView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
//currentExchangeView
@property(strong,nonatomic)UIImageView * triangleIcon;//三角形
@property(strong,nonatomic)UITableView * table;
@property(assign,nonatomic)NSInteger selectIndex;

@property(strong,nonatomic)NSMutableArray * titles;//标题
@property(strong,nonatomic)NSMutableArray * icons;//图标

@end

@implementation popMoreView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self==[super initWithFrame:frame])
    {
        self.backgroundColor=LTClearColor;
        [self tapGesture];
        [self initData];
        [self initExchangeView];
    }
    return self;
}
-(void)dealloc {
    [_titles removeAllObjects];
    _titles=nil;
    [_icons removeAllObjects];
    _icons=nil;
    _table=nil;
    _triangleIcon=nil;
}

- (void)initData {
    _titles=nil;
    _titles=[[NSMutableArray alloc]initWithObjects:@"行情提醒",@"全屏",@"关闭辅助线",@"功能说明", nil];
    _icons=nil;
    _icons=[[NSMutableArray alloc]initWithObjects:@"bellIcon",@"transFull",@"closeLine",@"moreNote", nil];
}

-(void)reloadExchangeDataWithCurrentExchange:(NSString *)selectExchange
{
    [self initData];
    [_table reloadData];
}
-(void)tapGesture
{
    UIView *bgview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height)];
    bgview.backgroundColor=[UIColor clearColor];
    [self addSubview:bgview];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPop)];
    tap.delegate = self;
    [bgview addGestureRecognizer:tap];
}
#pragma mark - initCustomView
-(void)initTable {
    if (!_table) {
        _table=[[UITableView alloc]init];
        _table.frame=CGRectMake(0,6, self.w_, _titles.count*44);
        _table.delegate=self;
        _table.dataSource=self;
        _table.backgroundColor=LTWhiteColor;
        _table.layer.masksToBounds=YES;
        _table.layer.cornerRadius=3;
        _table.bounces=NO;
        _table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_table];
    }
}

-(void)initExchangeView
{
    //三角形
    _triangleIcon=[[UIImageView alloc]init];
    _triangleIcon.frame=CGRectMake((self.w_-78)/2.0, -18, 78, 72);
    UIImage *image = [UIImage imageNamed:@"triangleIcon"];
    _triangleIcon.image=image;
    [ self addSubview:_triangleIcon];
    [self initTable];
}
#pragma mark - table Delegate and DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles?_titles.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier =[NSString stringWithFormat:@"porductCell%li",indexPath.row];
    UITableViewCell *cell =
    (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[UIFont systemFontOfSize:17];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        if (indexPath.row < _titles.count-1) {
            UIView *line=[[UIView alloc]init];
            line.frame=CGRectMake(0, cell.contentView.h_-1, Screen_width,0.5);
            line.backgroundColor=LTLineColor;
            [cell.contentView addSubview:line];
        }
    }
    cell.textLabel.text=_titles[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = _titles[indexPath.row];
    [self reloadExchangeDataWithCurrentExchange:identifier];
    [self hiddenPop];
}

-(void)showPop {
    self.frame=CGRectMake(0, self.frame.origin.y, Screen_width, Screen_height);
}
-(void)hiddenPop {
  
}

@end
