//
//  ChatVC.m
//  ixit
//
//  Created by Brain on 16/10/26.
//  Copyright © 2016年 ixit. All rights reserved.
//

#import "ChatVC.h"
#import "DataProvider.h"
#import "NTESSessionViewController.h"
#import "Masonry.h"
//#import "NIMMessageMaker.h"

@interface ChatVC ()

@property (nonatomic,strong) UIButton *rightBt;
@property(strong,nonatomic)NTESSessionViewController * chat;

@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    kPublicData.isCustomer=YES;
    [self initChatV];
    // Do any additional setup after loading the view.
    NFC_AddObserver(NFC_IMPushURL, @selector(IMPushURL:));

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.frame=CGRectMake(0, 64, Screen_width, Screen_height-64);
}

#pragma mark - initview
-(void)initViews
{
    _titleName=_titleName?_titleName:@"";
    NSString *title =[NSString stringWithFormat:@"%@",_titleName];

    [self navTitle:title backType:BackType_PopVC];
    
    [self setupRightBt];
    _rightBt.hidden = ![LTUtils noHide];

    
}

-(void)initChatV
{
    if (!_chat)
    {
//        _chat=[[NTESSessionViewController alloc]initWithSession:[NIMSession session:_sessionId type:NIMSessionTypeP2P]];
//        [self.view addSubview:_chat.view];
        //注入 NIMKit 内容提供者
        DataProvider *dataProvider = [DataProvider new];
//        [[NIMKit sharedKit] setProvider:dataProvider];
    }
    _chat.view.frame=CGRectMake(0, 64, Screen_width, Screen_height-64);
}


#pragma mark - 右按钮

- (void)setupRightBt {
    //隐藏
    if(!_rightBt) {
        _rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBt.hidden = YES;
        [self.header addSubview:_rightBt];
        [_rightBt setTitle:@"版本信息" forState:UIControlStateNormal];
        UIColor *color = NavBarSubCoror;
        [_rightBt setTitleColor:color forState:UIControlStateNormal];
        _rightBt.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBt addTarget:self action:@selector(clickRightBt) forControlEvents:UIControlEventTouchUpInside];
        [_rightBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@(-3));
            make.width.equalTo(@80);
            make.height.equalTo(@25);
            make.centerY.equalTo(@0);
        }];
    }
}

- (void)clickRightBt {
    NSString *res = [LTUtils debugInfo];
    
//    [LTAlertView alertTitle:res];
    
//    NIMMessage *message = [NIMMessageMaker msgWithText:res];
//    message.apnsPayload=@{@"sessionId":_chat.session.sessionId};
//    [_chat sendMessage:message];
    
}


#pragma mark - action
-(void)returnBack
{
    kPublicData.isCustomer=NO;
    [self popVC];
}
#pragma mark -notification
-(void)IMPushURL:(NSNotification *)obj{
    NSString *title = [obj.userInfo objectForKey:@"title"];
    NSString *url = [obj.userInfo objectForKey:@"url"];
    NSLog(@"url=%@ ,title=%@",url,title);
    [self.navigationController pushWeb:url title:title];
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
