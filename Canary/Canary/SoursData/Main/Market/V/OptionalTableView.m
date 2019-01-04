//
//  OptionalTableView.m
//  FMStock
//
//  Created by dangfm on 15/4/12.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "OptionalTableView.h"


@interface OptionalTableView(){
    
}
@property (nonatomic,retain) UIView *sectionView;
@property (strong, nonatomic) UINavigationController *navigationController;
@end



@implementation OptionalTableView



-(instancetype)init{
    if(self=[super init]){
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self=[super initWithFrame:frame style:style]) {
        [self initViews];
        [self changeSectionBackgroundColor];
    }
    return self;
}

-(void)dealloc{
    _sectionView = nil;
}

-(void)initViews{
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self createAddButton];
}

-(void)createAddButton{
    CGFloat boxH = 60;
    CGFloat w = 110;
    CGFloat h = 20;
    CGFloat x = (self.frame.size.width-w)/2;
    CGFloat y = (boxH-h)/3;
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, boxH)];
    footerview.backgroundColor = [UIColor clearColor];
    self.tableFooterView = footerview;
    
    UIImageView *addIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add"]];
    addIcon.frame=CGRectMake(x+2, y, h, h);
    [footerview addSubview:addIcon];
    addIcon=nil;
    
    UIButton *addbutton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [addbutton setTitle:@"  添加自选" forState:UIControlStateNormal];
    addbutton.titleLabel.font = [UIFont fontWithName:kFontName size:15];
    [addbutton setTitleColor:BlueFont forState:UIControlStateNormal];
    [footerview addSubview:addbutton];
    [addbutton addTarget:self action:@selector(clickAddButton) forControlEvents:UIControlEventTouchUpInside];
    addbutton = nil;
    footerview = nil;
}



-(void)clickAddButton{
    if (self.clickAddButtonBlock) {
        self.clickAddButtonBlock(self);
    }
}

-(UIView *)SectionView:(int)height{

    int fontsize = 15;
    float w = (Screen_width-20)/5+3;
    _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
    _sectionView.backgroundColor = LTBgRGB;
    // 名称
    UIButton *name = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 2*w, height)];
    name.titleLabel.textAlignment = NSTextAlignmentLeft;
    [name setTitle:@"品种代码" forState:UIControlStateNormal];
    name.titleLabel.font = [UIFont fontWithName:kFontName size:fontsize];
    name.titleEdgeInsets = UIEdgeInsetsMake(5, -45, 0, 0);
    name.titleLabel.textColor = LTSubTitleRGB;
    [name setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
    [_sectionView addSubview:name];
    name = nil;
    // 最新价
    UIButton *price = [[UIButton alloc] initWithFrame:CGRectMake(w*2, 0, w, height)];
    [price setTitle:@"买入价" forState:UIControlStateNormal];
    price.titleLabel.textAlignment = NSTextAlignmentLeft;
    price.titleLabel.font = [UIFont fontWithName:kFontName size:fontsize];
    price.titleLabel.textColor = LTSubTitleRGB;
    [price setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
    [_sectionView addSubview:price];
    price = nil;
    // 卖出价
    UIButton *outPrice = [[UIButton alloc] initWithFrame:CGRectMake(w*3, 0, w, height)];
    [outPrice setTitle:@"卖出价" forState:UIControlStateNormal];
    outPrice.titleLabel.textAlignment = NSTextAlignmentLeft;
    outPrice.titleLabel.font = [UIFont fontWithName:kFontName size:fontsize];
    outPrice.titleLabel.textColor = LTSubTitleRGB;
    [outPrice setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
    [_sectionView addSubview:outPrice];
    outPrice = nil;
    // 涨跌幅
    UIButton *change = [[UIButton alloc] initWithFrame:CGRectMake(w*4, 0, w, height)];
    [change setTitle:@"涨跌幅" forState:UIControlStateNormal];
    change.titleLabel.textAlignment = NSTextAlignmentLeft;
    [change addTarget:self action:@selector(changeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    change.titleLabel.font = [UIFont fontWithName:kFontName size:fontsize];
    change.titleLabel.textColor = LTSubTitleRGB;
    [change setTitleColor:LTSubTitleRGB forState:UIControlStateNormal];
    [_sectionView addSubview:change];
    change = nil;
    
    return _sectionView;
}

#pragma mark 改变组视图背景
-(void)changeSectionBackgroundColor
{
    _sectionView.backgroundColor = LTBgRGB;
    self.backgroundColor = LTBgRGB;
}

@end
