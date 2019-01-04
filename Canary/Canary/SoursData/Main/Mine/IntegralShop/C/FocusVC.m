//
//  FocusVC.m
//  ixit
//
//  Created by Brain on 2017/4/18.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "FocusVC.h"

@interface FocusVC ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView * table;
@property(strong,nonatomic)NSMutableArray * focusList;//关注列表
@end

@implementation FocusVC
#define FocusCellH 88
#pragma mark - system
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated {
    [self requestFocusData];
}
#pragma mark - init

-(void)initViews{
    [self navTitle:@"我的关注" backType:BackType_PopVC];
    
}
-(void)initTable {
    _table=[[UITableView alloc]init];
    _table.frame=CGRectMake(0, 64, ScreenW_Lit,ScreenH_Lit-64);
    _table.delegate=self;
    _table.dataSource=self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
}
#pragma mark - utils
-(UIView *)contentViewWithData:(NSDictionary *)dic tag:(NSInteger)tag {
    UIView *contentView=[[UIView alloc]init];
    return contentView;
}
#pragma mark - request
//获取关注列表数据
-(void)requestFocusData {
//    WS(ws);
//    [RequestCenter requestFocusListCompletion:^(LTResponse *res) {
//        if (res.success) {
//            NSLog(@"focus list ");
//            if (!ws.focusList) {
//                ws.focusList=[[NSMutableArray alloc]init];
//            }else{
//                if (ws.focusList.count>0) {
//                    [ws.focusList removeAllObjects];
//                }
//            }
//            if (res.resArr.count>0) {
//                [ws.focusList addObjectsFromArray:res.resArr];
//            }
//            [ws.table reloadData];
//        }
//    }];
}
//关注 or 取消关注请求
-(void)requestFocusActionWithAuthorId:(NSString *)authorId isFocus:(BOOL)isFocus index:(NSIndexPath *)index {
//    WS(ws);
//    [RequestCenter reqAttentionAnalyst:isFocus authorId:authorId finish:^(LTResponse *res) {
//        [ws.table reloadRow:index.row inSection:index.section];
//    }];
}
#pragma mark - delegate
#pragma mark - table Delegate and DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return FocusCellH;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _focusList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier =[NSString stringWithFormat:@"foucsCell"];
    UITableViewCell *cell =
    (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%li",indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
