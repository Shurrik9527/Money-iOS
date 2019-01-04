//
//  UIView+Tip.m
//  ixit
//
//  Created by litong on 16/10/26.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "UIView+Tip.h"
#import "UIView+Toast.h"
#import "LitTipsView.h"
#import "UIFont+LT.h"


@implementation UIView (Tip)


+ (UIView *)viewWithMsg:(NSString *)msg doYes:(BOOL)doYes {
    
//    NSString *imgName = doYes ? @"doYes" : @"doYes";
    
    UIView *BGView=[[UIView alloc]init];
    BGView.frame=CGRectMake(0, 0, ScreenW_Lit,ScreenH_Lit);
    BGView.backgroundColor=LTRGBA(1, 1, 1, 0.5);
    
    CGFloat sviewW = 160;
    CGFloat sviewH = 60;
    UIView * successView=[[UIView alloc]initWithFrame:CGRectMake((ScreenW_Lit - sviewW)*0.5, (ScreenH_Lit-sviewH)*0.5, sviewW, sviewH)];
    successView.backgroundColor=[UIColor whiteColor];
    successView.layer.masksToBounds=YES;
    successView.layer.cornerRadius=4;
    [BGView addSubview:successView];
    
    CGFloat ivWH = 25.f;
    UIImageView *img=[[UIImageView alloc]init];
    img.frame=CGRectMake(24, (sviewH-ivWH)/2, ivWH,ivWH);
    img.image= [UIImage imageNamed:@"success_green"];
    [successView addSubview:img];
    
    UILabel *label=[[UILabel alloc]init];
    label.frame=CGRectMake(img.xw_+12, img.y_, sviewW, img.h_);
    label.text=msg;
    label.textAlignment=NSTextAlignmentLeft;
    label.textColor=LTTitleColor;
    label.font=fontSiz(17);
    [successView addSubview:label];
    
    return BGView;
}

static NSInteger kSuccessViewTag = 20008;

- (void)showSuccessWithTitle:(NSString *)msg {
    UIView *msgView = [UIView viewWithMsg:msg doYes:YES];
    msgView.tag = kSuccessViewTag;
    msgView.center=self.center;
    [self addSubview:msgView];
    [self bringSubviewToFront:msgView];

    [self performSelector:@selector(hideSuccessView) withObject:nil afterDelay:autoHideTimeInterval];
}
- (void)hideSuccessView {
    UIView *msgView = [self viewWithTag:kSuccessViewTag];
    [msgView removeFromSuperview];
}

#pragma mark - tip

//- (void)showTip:(NSString *)message {
//    [self makeToast:message duration:autoHideTimeInterval position:CSToastPositionCenter];
//}
//
//- (void)showTip:(NSString *)message imageName:(NSString *)imageName {
//    [self makeToast:message duration:autoHideTimeInterval position:CSToastPositionCenter image:[UIImage imageNamed:imageName]];
//}
//
//- (void)showTip:(NSString *)message title:(NSString *)title {
//    [self makeToast:message duration:autoHideTimeInterval position:CSToastPositionCenter title:title];
//}
//- (void)showTip:(NSString *)message title:(NSString *)title imageName:(NSString *)imageName {
//    [self makeToast:message duration:autoHideTimeInterval position:CSToastPositionCenter title:title image:[UIImage imageNamed:imageName]];
//}

- (void)showTip:(NSString *)tip afterHide:(NSInteger)afterHide {
    LitTipsView *tipView = [UIView showTips:tip];
    tipView.center = self.center;
    [self addSubview:tipView];
    [self bringSubviewToFront:tipView];
    
    [self performSelector:@selector(hideTip) withObject:nil afterDelay:afterHide];
}

- (void)showTip:(NSString *)tip {
     [self showTip:tip afterHide:autoHideTimeInterval];
}

- (void)hideTip {
    LitTipsView *tipView = [LitTipsView sharedInstance];
    tipView.showed = NO;
    [tipView removeFromSuperview];
}


#pragma mark - utils

+ (LitTipsView *)showTips:(NSString *)tip {
    if (notemptyStr(tip)) {
        
        LitTipsView *tipView = [LitTipsView sharedInstance];
        
        if (tipView.showed) {
            [LitTipsView hideTips];
        }
        
        tipView.showed = YES;
        
        UIFont *font = [UIFont fontOfSize:fontSize];
        
        CGFloat maxW = ScreenW_Lit * 0.7;
        CGSize size = [tip boundingSize:CGSizeMake(maxW, MAXFLOAT) font:font];
        tipView.frame = CGRectMake(0, 0, size.width + leftMar*2, size.height + topMar*2);
        tipView.msgLable.frame = CGRectMake(leftMar, topMar, size.width, size.height);
        tipView.msgLable.text = tip;
//        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//        [window addSubview:tipView];
//        
//        tipView.center = window.center;
        return tipView;
    }
    return nil;
}

+ (void)hideTips {
    LitTipsView *tipView = [LitTipsView sharedInstance];
    if (tipView.showed) {
        tipView.showed = NO;
        [tipView removeFromSuperview];
    }
}




@end
