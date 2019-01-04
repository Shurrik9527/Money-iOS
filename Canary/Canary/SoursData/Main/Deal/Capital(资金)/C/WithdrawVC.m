//
//  WithdrawVC.m
//  Canary
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "WithdrawVC.h"
#import "DataHundel.h"
#import "DesTableViewCell.h"
@interface WithdrawVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArray1;
@property(nonatomic,strong)NSArray * dataArray2;
@property(nonatomic,strong)NSArray * desArray;

@end

@implementation WithdrawVC
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.dataArray1 = [NSArray array];
        self.dataArray2 = [NSArray array];
        self.desArray =[NSArray array];
        self.dataArray1 = @[@"提现金额",@"提现时间",@"处理状态",@"备注"];
        self.dataArray2 = @[@"卡号",@"户名",@"银行名称",@"银行支行"];
    }
    return self;
}- (void)viewDidLoad {
    [super viewDidLoad];
    [self navTitle:@"提现详情" backType:BackType_PopVC];
    [self creatTableView];
}
-(void)creatTableView
{
    self.tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 74, Screen_width, self.h_) style:(UITableViewStyleGrouped)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.sectionHeaderHeight = 5;
    _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,_tableView.bounds.size.width,0.01f)];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray1.count;
    }else if (section == 1)
    {
        return self.dataArray2.count;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * string  = @"iden";
    DesTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell =[[DesTableViewCell alloc]initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:string];
    }
    if (indexPath.section == 0) {
        cell.nameLabel.text = [self.dataArray1 objectAtIndex:indexPath.row];
        if (indexPath.row == 0) {
            cell.desLabel.text = [NSString stringWithFormat:@"%@%@",@"$",self.model.amount];
        }else if (indexPath.row ==1)
        {
            cell.desLabel.text =  [DataHundel convertime:self.model.date];
        }else if (indexPath.row ==2)
        {
            if ([self.model.status isEqualToString:@"FAILD"]) {
                if (notemptyStr(self.model.commit)) {
                    cell.desLabel.text = self.model.commit;
                }else
                {
                    cell.desLabel.text = @"提现失败";
                }
            }else if ([self.model.status isEqualToString:@"WAIT"])
            {
                cell.desLabel.text = @"等待处理";
            }
            else if ([self.model.status isEqualToString:@"DONE"])
            {
                cell.desLabel.text = @"已转账";
            }
        }else if ( indexPath.row ==3)
        {
            if (notemptyStr(self.model.commit)) {
            cell.desLabel.text = self.model.commit;
            }else
            {
            cell.desLabel.text = @"无";
            }
        }
    }else if (indexPath.section == 1)
    {
        cell.nameLabel.text = [self.dataArray2 objectAtIndex:indexPath.row];
        if (indexPath.row ==0) {
            cell.desLabel.text = self.model.accountNumber;
        }else if (indexPath.row ==1)
        {
            cell.desLabel.text = self.model.accountName;

        }else if (indexPath.row ==2)
        {
            cell.desLabel.text = self.model.bankName;

        }else if (indexPath.row ==3)
        {
            cell.desLabel.text = self.model.bankAddress;
            if (self.model.bankAddress.length > 15) {
                cell.desLabel.font =[UIFont systemFontOfSize:12.5];
            }
        }
    }
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
