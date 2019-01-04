//
//  HomeTableViewCell.m
//  FMStock
//
//  Created by dangfm on 15/4/30.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "HomeTableViewCell.h"
#import "AsSocket.h"
@implementation HomeTableViewCell

-(instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initViews];

    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)initViews{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor whiteColor];
    
    float x = 16;
    float w = (Screen_width)/4.0;
    float y = 10;
    float h = kCellFontSize;
    // 名称
    if (!_name) {
        _name = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w-x, h)];
        _name.font = fontSiz(midFontSize);
        _name.textColor = LTTitleRGB;
        _name.backgroundColor = LTClearColor;
        _name.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_name];
    }
    // 编码
    if (!_code) {
        _code = [[UILabel alloc] initWithFrame:CGRectMake(x, y+h+3, w-x, h)];
        _code.font = autoFontSiz(kCellCodeFontSize);
        _code.textColor = LTSubTitleRGB;
        _code.backgroundColor = LTClearColor;
        _code.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_code];
        
    }
    
    // 买入价
    if (!_price) {
        _price = [[UILabel alloc] initWithFrame:CGRectMake(w, y+6, 0.26*Screen_width, h)];
        _price.font = autoFontSiz(kCellPriceFontSize);
        _price.textColor = LTTitleRGB;
        _price.backgroundColor = LTClearColor;
        _price.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_price];
    }

    // 卖出价
    if (!_weipanId) {
        _weipanId = [[UILabel alloc] initWithFrame:CGRectMake(w *2, y+6, w, h)];
        _weipanId.font = autoFontSiz(kCellPriceFontSize);
        _weipanId.textColor = LTTitleRGB;
        _weipanId.backgroundColor = LTClearColor;
        _weipanId.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_weipanId];
    
    }
    
    if (!_change) {
        CGFloat h = 28;
        CGFloat bt_w = 70;
        _change = [[UIButton alloc] initWithFrame:CGRectMake(Screen_width-x-bt_w,10, bt_w, h)];
        _change.layer.cornerRadius = 3;
        _change.layer.masksToBounds = YES;
        _change.backgroundColor = LTHEX(0x999999);
        [_change setBackgroundImage:[UIImage imageWithColor:LTHEX(0x999999) size:CGSizeMake(_change.frame.size.width, _change.frame.size.height)] forState:UIControlStateNormal];
        [_change setBackgroundImage:[UIImage imageWithColor:LTHEX(0x999999) size:CGSizeMake(_change.frame.size.width, _change.frame.size.height)] forState:UIControlStateSelected];
        [self.contentView addSubview:_change];
        [_change setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _change.titleLabel.font = [UIFont boldSystemFontOfSize:13];

    }
}
-(void)updateCellContent:(MarketModel *)model
{
    if ( self && model)
    {
        if (notemptyStr(model.symbol )&& notemptyStr(model.buy_out) && notemptyStr(model.buy_in)) {
        NSUInteger decimals =[model digit];
        NSString * percentage =[NSString stringWithFormat:@"%@%@%@",@"%0.",[NSString stringWithFormat:@"%ld",decimals],@"f"];
        _price.text =[NSString stringWithFormat:percentage,model.buy_in.doubleValue];
        _weipanId.text = [NSString stringWithFormat:percentage,model.buy_out.doubleValue];
            //如果是1就是非选中状态
            if (model.isAllSelect == 1) {
                [self changeBgColorWithOldPrice:model.buy_in code:model.symbol yesClosePrice:model.close];
            }else
            {
                [self calculate_Spread:model.buy_in and:model.buy_out isSelect:model.isAllSelect digit:model.digit];
            }
    }
    }
}
//计算点差
-(void)calculate_Spread:(NSString*)buyIN and:(NSString *)buyOut isSelect:(NSInteger)isSelect digit:(NSInteger )digit
{
    
    float spread = buyOut.floatValue - buyIN.floatValue;
    if (spread < 0) {
        [self.change setTitle:[NSString stringWithFormat:@" %.5f ",spread] forState:0];
    }else
    {
        [self.change setTitle:[NSString stringWithFormat:@"%@%@",@"+",[NSString stringWithFormat:@" %.5f ",spread]]forState:0];
    }
    [self changeChangColorWithOldChang:@" " spread:[NSString stringWithFormat:@" %.5f ",spread] isSelect:isSelect];
}
//改变颜色和计算涨跌幅
-(void)changeBgColorWithOldPrice:(NSString*)price code:(NSString *)code yesClosePrice:(NSString *)closePrice{
    
    NSString *oldPrice = closePrice;
    NSString *newPrice =price;
    if ([newPrice floatValue]!=[oldPrice floatValue] && [oldPrice floatValue]>0) {
        if ([_code.text isEqualToString:code]) {
         _changerate = [newPrice floatValue] - [oldPrice floatValue];
        float  gains =_changerate/[oldPrice floatValue] * 100;
            if (gains < 0) {
                [self.change setTitle:[NSString stringWithFormat:@"%@%%",[NSString stringWithFormat:@" %.2f ",gains]] forState:UIControlStateNormal];
            }else
            {
                [self.change setTitle:[NSString stringWithFormat:@"%@%%",[NSString stringWithFormat:@"%@ %@",@"+",[NSString stringWithFormat:@"%.2f",gains]]] forState:UIControlStateNormal];
            }
            [self changeChangColorWithOldChang:[NSString stringWithFormat:@"%.2f",gains] spread:@" " isSelect:1];

        }
    }
}

-(void)changeChangColorWithOldChang:(NSString*)chang spread:(NSString *)spread  isSelect:(NSInteger )isSelect {
    if (isSelect == 2) {
        [_change setBackgroundColor:[UIColor clearColor]];
        [_change setBackgroundImage:[UIImage imageWithColor:LTHEX(0x999999) size:CGSizeMake(_change.frame.size.width, _change.frame.size.height)] forState:UIControlStateNormal];

        if ([chang floatValue]>0) {
            _price.textColor = LTKLineRed;
            _weipanId.textColor = LTKLineRed;
        }
        if ([chang floatValue]<0) {
            _price.textColor = LTKLineGreen;
            _weipanId.textColor = LTKLineGreen;
        }
    }else if (isSelect == 1)
    {
    if ([chang floatValue]>0) {
        [_change setBackgroundImage:[UIImage imageWithColor:LTKLineRed size:CGSizeMake(_change.frame.size.width, _change.frame.size.height)] forState:UIControlStateNormal];
        _price.textColor = LTKLineRed;
        _weipanId.textColor = LTKLineRed;
    }

    if ([chang floatValue]==0) {
        [_change setBackgroundImage:[UIImage imageWithColor:LTHEX(0x999999) size:CGSizeMake(_change.frame.size.width, _change.frame.size.height)] forState:UIControlStateNormal];
    }
    
    if ([chang floatValue]<0) {
        [_change setBackgroundImage:[UIImage imageWithColor:LTKLineGreen size:CGSizeMake(_change.frame.size.width, _change.frame.size.height)] forState:UIControlStateNormal];
        _price.textColor = LTKLineGreen;
        _weipanId.textColor = LTKLineGreen;
    }
    }
}


//#pragma mark 闪动视图
//-(void)createBgWithPrice:(NSString*)price{
//    CGFloat w = 90;
//    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(_price.center.x-w/2.0, 10, w, 28)];
//    bg.layer.cornerRadius = 3;
//    bg.layer.masksToBounds = YES;
//    [self insertSubview:bg belowSubview:_price];
//    bg.layer.backgroundColor = LTKLineGreen.CGColor;
//    NSString *oldPrice = _price.text;
//    if ([price floatValue]>=[oldPrice floatValue] && [oldPrice floatValue]>0) {
//        bg.layer.backgroundColor = LTKLineRed.CGColor;
//    }
//    bg.layer.opacity = 0.1;
//    [UIView animateWithDuration:0.1 animations:^{
//        bg.layer.opacity = 0.2;
//    } completion:^(BOOL isfinish){
//        [UIView animateWithDuration:0.1 animations:^{
//            bg.layer.opacity = 0;
//        } completion:^(BOOL isfinish){
//            [bg removeFromSuperview];
//        }];
//    }];
//    bg = nil;
//    bg.backgroundColor = nil;
//}


@end
