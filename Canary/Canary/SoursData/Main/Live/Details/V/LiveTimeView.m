//
//  LiveTimeView.m
//  ixit
//
//  Created by litong on 2016/12/29.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "LiveTimeView.h"



@interface LiveTimeView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation LiveTimeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTMaskColor;
        [self createView];
    }
    return self;
}

- (void)createView {
    
    [self addSingeTap:@selector(singeTap) target:self];
    [self addRightSwipeAction:@selector(singeTap) target:self];
    
    CGRect rect = CGRectMake(self.w_ - LTAutoW(LiveTimeCellW), 0, LTAutoW(LiveTimeCellW), self.h_);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = LTWhiteColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self.tableView addSingeTap:@selector(tmepTap) target:self];
    
    self.hidden = YES;
}

- (void)setList:(NSArray *)list {
    _list = list;
    [self.tableView reloadData];
}



#pragma mark - action

- (void)singeTap {
    [self showView:NO];
}

- (void)tmepTap{}


#pragma mark 显示隐藏

static CGFloat animateDuration = 0.3;
- (void)showView:(BOOL)show {
    WS(ws);
    if (show) {
        NFCPost_FloatingPlayHide;
        [self.superview bringSubviewToFront:self];
        self.alpha = 0.3;
        [self changeContentViewShow:NO];
        self.hidden = NO;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:animateDuration animations:^{
            ws.alpha = 1;
            [ws changeContentViewShow:YES];
        } completion:^(BOOL finished) {
            ws.userInteractionEnabled = YES;
        }];
        
    } else {
        NFCPost_FloatingPlayShow;
        self.alpha = 1;
        self.userInteractionEnabled = NO;
        [self changeContentViewShow:YES];
        [UIView animateWithDuration:animateDuration animations:^{
            ws.alpha = 0.3;
            [ws changeContentViewShow:NO];
        } completion:^(BOOL finished) {
            ws.userInteractionEnabled = YES;
            ws.hidden = YES;
        }];
    }
    
}

- (void)changeContentViewShow:(BOOL)show {
    if (show) {
        CGRect rectShow = CGRectMake(self.w_ - LTAutoW(LiveTimeCellW), 0, LTAutoW(LiveTimeCellW), self.h_);
        _tableView.frame = rectShow;
    } else {
        CGRect rectHide = CGRectMake(self.w_, 0, LTAutoW(LiveTimeCellW), self.h_);
        _tableView.frame = rectHide;
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier=@"LiveTimeCell";
    LiveTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LiveTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    LiveTimeMo *mo = _list[indexPath.row];
    [cell bindData:mo];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return LTAutoW(LiveTimeCellH);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



@end
