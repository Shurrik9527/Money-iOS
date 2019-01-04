//
//  MoneyRecordDeatilVCtrl.m
//  Canary
//
//  Created by litong on 2017/6/2.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "MoneyRecordDeatilVCtrl.h"
#import "MoneyRecordDetailCell.h"

@interface MoneyRecordDeatilVCtrl ()

@property (nonatomic,strong) NSArray *list;

@end

@implementation MoneyRecordDeatilVCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = nil;
    
    if (_typ == MoneyRecordType_in) {
        str = @"入金详情";
        self.list = @[
                          @{key_MRDC_Title : @"流水号", key_MRDC_Content : _mo.mid },
                          @{key_MRDC_Title : @"金额", key_MRDC_Content : _mo.amount },
                          
                          @{key_MRDC_Title : @"处理时间", key_MRDC_Content : _mo.time },
                          @{key_MRDC_Title : @"处理状态", key_MRDC_Content : _mo.state },
                       ];
    } else {
        str = @"出金详情";
        NSString *mark = @"";
        if (notemptyStr(_mo.mark)) {
            mark = [NSString stringWithFormat:@"(%@)",_mo.mark];
        }
        NSString *stateStr = [NSString stringWithFormat:@"%@%@",_mo.state,mark];
        
        NSString *bankNoStr = [self strMidChangeToStar:_mo.bankNo];
        self.list = @[
                          @{key_MRDC_Title : @"流水号", key_MRDC_Content : _mo.mid },
                          @{key_MRDC_Title : @"银行", key_MRDC_Content : _mo.bankName },
                          
                          @{key_MRDC_Title : @"卡号", key_MRDC_Content : bankNoStr },
                          @{key_MRDC_Title : @"出金额", key_MRDC_Content : _mo.amount },
                          
                          @{key_MRDC_Title : @"处理时间", key_MRDC_Content : _mo.time },
                          @{key_MRDC_Title : @"处理状态", key_MRDC_Content : stateStr },
                      ];
    }
    [self navPopBackTitle:str];
    
    [self createTableView];
    CGRect rect = CGRectMake(0, NavBarTop_Lit, self.w_, self.h_ - NavBarTop_Lit);
    self.tableView.backgroundColor = LTBgColor;
    self.tableView.frame = rect;
    [self.tableView reloadData];
}

- (NSString *)strMidChangeToStar:(NSString *)str {
    NSInteger len = str.length;
    if (len <= 8) {
        return str;
    }
    
    NSString *midStr = [str substringWithRange:NSMakeRange(4, len-8)];
    NSString *res = [str replacStr:midStr withStr:@"********"];
    return res;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"MoneyRecordDetailCellID";
    MoneyRecordDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MoneyRecordDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSInteger row = indexPath.row;
    NSDictionary *dict = _list[row];
    [cell bindData:dict];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMoneyRecordDetailCellH;
}



@end
