//
//  PopTableView.m
//  ixit
//
//  Created by Brain on 2017/2/15.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "PopTableView.h"
@interface PopTableView()<UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>{
    CGFloat container_width;
}

@property(strong,nonatomic)UIImageView * triangleIcon;//三角形
@property(strong,nonatomic)UIView * listView;//container vire
@property(strong,nonatomic)UITableView * table;//列表
@property(assign,nonatomic)CGRect showFrame;//显示时的frame

//selectIndex
@property(assign,nonatomic)NSInteger selectIndex;


@end

@implementation PopTableView
//CGRectMake(ScreenW_Lit-12-144, 64, 144, 166)
-(instancetype)initWithFrame:(CGRect)frame {
    if (self==[super initWithFrame:frame]) {
        self.backgroundColor=LTClearColor;
        [self tapGesture];
        [self setDefaultMorePop];
        [self initContainerView];
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
    _listView=nil;
}

-(void)tapGesture {
    UIView *line=[[UIView alloc]init];
    line.frame=self.frame;
    line.backgroundColor=LTClearColor;
    [self addSubview:line];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPop)];
    tap.delegate = self;
    [line addGestureRecognizer:tap];
    
    tap=nil;
    line=nil;
}
#pragma mark - initCustomView
-(void)initContainerView {
    _listView=[[UIView alloc]init];
    _listView.frame=CGRectMake(ScreenW_Lit-12-144, 64, 144, 166);
    _listView.backgroundColor=LTClearColor;
    [self addSubview:_listView];
    container_width=_listView.w_;
    
    //三角形
    _triangleIcon=[[UIImageView alloc]init];
    _triangleIcon.frame=CGRectMake((self.listView.w_-13)/2.0, 0, 13, 6);
    UIImage *image = [UIImage imageNamed:@"triangleIcon"];
    _triangleIcon.image=image;
    [_listView addSubview:_triangleIcon];
    //表
    [self initTable];
}

-(void)initTable {
    if (!_table) {
        _table=[[UITableView alloc]init];
        _table.frame=CGRectMake(0,6, container_width, _titles.count*44);
        _table.delegate=self;
        _table.dataSource=self;
        _table.backgroundColor=LTWhiteColor;
        _table.layer.masksToBounds=YES;
        _table.layer.cornerRadius=3;
        _table.bounces=NO;
        _table.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_listView addSubview:_table];
    }
    _table.frame=CGRectMake(0,6, self.listView.w_, _titles.count*44);
}
#pragma mark - table Delegate and DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles?_titles.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier =[NSString stringWithFormat:@"porductCell%li",indexPath.row];
    UITableViewCell *cell =
    (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIImageView *imageView;
    UILabel *textLabel;
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row < _titles.count-1) {
            UIView *line=[[UIView alloc]init];
            line.frame=CGRectMake(0, cell.contentView.h_-1, Screen_width,0.5);
            line.backgroundColor=LTLineColor;
            [cell.contentView addSubview:line];
        }
        imageView=[[UIImageView alloc]init];
        imageView.frame=CGRectMake(16, cell.contentView.center.y-10, 20, 20);
        imageView.tag=100;
        [cell.contentView addSubview:imageView];
        
        textLabel=[self createLabWithFrame:CGRectMake(imageView.xw_+8, 0, container_width-44, 44) text:@""];
        textLabel.tag=101;
        textLabel.font=[UIFont systemFontOfSize:15];
        textLabel.textAlignment=NSTextAlignmentLeft;
        [cell.contentView addSubview:textLabel];
    }
    imageView=[cell.contentView viewWithTag:100];
    textLabel=[cell.contentView viewWithTag:101];
    if (_icons.count>indexPath.row) {
        NSString *imgName = _icons[indexPath.row];
        imageView.image=[UIImage imageNamed:imgName];
    }
    if (indexPath.row==0) {
        NSString *subStr=[NSString stringWithFormat:@"(%li)",_count];
        NSString *countStr=[NSString stringWithFormat:@"%@ %@",_titles[indexPath.row],subStr];
        NSAttributedString *attr=[self attrStrWithStr:countStr subStr:subStr color:LTSubTitleColor];
        textLabel.attributedText=attr;
        attr=nil;
    }else {
        textLabel.text=_titles[indexPath.row];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _selectIndex=indexPath.row;
    _clickCell?_clickCell(indexPath.row):nil;
    [self hiddenPop];
}

#pragma mark - 外部方法
-(void)setDefaultMorePop{
    _titles=nil;
    _icons=nil;
    _titles=[[NSMutableArray alloc]initWithObjects:@"行情提醒",@"全屏",@"关闭辅助线",@"功能说明", nil];
    _icons=[[NSMutableArray alloc]initWithObjects:@"bellIcon",@"transFull",@"closeLine",@"moreNote", nil];
     [self configData];
}
//设置三角形定点位置
-(void)setTriangleCenterX:(CGFloat)x{
    CGPoint point = _triangleIcon.center;
    point.x=x;
    _triangleIcon.center=point;
}
-(void)showPop {
    [self configData];
    [_table reloadData];
    self.hidden=NO;
}
-(void)hiddenPop {
    self.hidden=YES;
}
#pragma mark - Method
-(void)configData{
//    NSString *key = [NSString stringWithFormat:@"%@_%@_line",self.excode,self.code];
    BOOL flag = YES;//辅助线开启状态
    if (![LTUser hideDeal]) {
        if (!flag) {
            [self.titles replaceObjectAtIndex:2 withObject:@"开启辅助线"];
            [self.icons replaceObjectAtIndex:2 withObject:@"openLine"];
        }else{
            [self.titles replaceObjectAtIndex:2 withObject:@"关闭辅助线"];
            [self.icons replaceObjectAtIndex:2 withObject:@"closeLine"];
        }
    }
}
#pragma mark - Utils
-(UILabel *)createLabWithFrame:(CGRect)frame
                          text:(NSString *)text
{
    UILabel *label=[[UILabel alloc]init];
    label.frame=frame;
    label.backgroundColor=[UIColor clearColor];
    label.text=text;
    label.textAlignment=NSTextAlignmentLeft;
    return label;
}
-(NSAttributedString *)attrStrWithStr:(NSString *)str subStr:(NSString *)subStr color:(UIColor *)color{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range = [str rangeOfString:subStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attrStr;
}
@end
