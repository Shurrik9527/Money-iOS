//
//  NewPositionCell.m
//  Canary
//
//  Created by jihaokeji on 2018/5/7.
//  Copyright © 2018年 litong. All rights reserved.
//

#import "NewPositionCell.h"
#import "PosinionView.h"
#import "DataHundel.h"
#import "MarketModel.h"

#define kNewsBlackColor  LTColorHex(0x373637)
#define kNewsGrayColor  LTSubTitleColor
#define kNewsGrayBgColor  LTBgColor

@interface NewPositionCell ()

@property (nonatomic, assign) NSInteger width1;
@property (nonatomic, assign) NSInteger highly;
@property (nonatomic, strong) UIView * lineView;
/**
 止盈
 */
@property (nonatomic, strong) PosinionView * viewOne;
/**
 止损
 */
@property (nonatomic, strong) PosinionView * viewTwo;
/**
 手数
 */
@property (nonatomic, strong) PosinionView * viewThree;
/**
 订单号
 */
@property (nonatomic, strong) PosinionView * viewFour;
@end

@implementation NewPositionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self UI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (void)UI{
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.increaseImage];
    [self.contentView addSubview:self.timeLadel];
    [self.contentView addSubview:self.priceLadel];
    [self.contentView addSubview:self.unwindButton];
    [self.contentView addSubview:self.lineView];
    NSMutableArray * arr = [self PosinionView];
    self.viewOne = arr[0];
    [self.contentView addSubview:self.viewOne];
    self.viewTwo = arr[1];
    [self.contentView addSubview:self.viewTwo];
    self.viewThree = arr[2];
    [self.contentView addSubview:self.viewThree];
    self.viewFour = arr[3];
    [self.contentView addSubview:self.viewFour];
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 47)];
        _topView.backgroundColor = LTBgColor;
        [_topView addSubview: self.lineImage];
        [_topView addSubview:self.nameLadel];
        [_topView addSubview:self.typeLadel];
        [_topView addSubview:self.zhangFuLadel];
        [_topView addSubview:self.arrowImage];
    }
    return _topView;
}

- (UIImageView *)lineImage{
    if (!_lineImage) {
        _lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 2.5, 17)];
        _lineImage.image = [UIImage imageNamed:@"smallElement"];
        _width1 = 10 + _lineImage.frame.size.width + 5;
        _highly = 20;
    }
    return _lineImage;
}

- (UILabel *)nameLadel{
    if (!_nameLadel) {
        _nameLadel = [[UILabel alloc] initWithFrame:CGRectMake(_width1, _highly, 80, 17)];
        _nameLadel.text = @"英镑/美元";
        _nameLadel.font = [UIFont systemFontOfSize:17.0];
        _nameLadel.textColor = [UIColor blackColor];
        _width1 += _nameLadel.frame.size.width + 5;
    }
    return _nameLadel;
}

- (UILabel *)typeLadel{
    if (!_typeLadel) {
        _typeLadel = [[UILabel alloc] initWithFrame:CGRectMake(_width1, _highly, 40, 17)];
        _typeLadel.backgroundColor =  LTRGBA(42, 101, 234, 1);
        _typeLadel.text = @"市价单";
        _typeLadel.font = [UIFont systemFontOfSize:10.0];
        _typeLadel.textAlignment = NSTextAlignmentCenter;
        _typeLadel.layer.masksToBounds = YES;
        [_typeLadel.layer setCornerRadius:4.0f];
        _typeLadel.textColor = [UIColor whiteColor];
        _width1 += _typeLadel.frame.size.width + 5;
    }
    return _typeLadel;
}

- (UILabel *)zhangFuLadel{
    if (!_zhangFuLadel) {
        _zhangFuLadel = [[UILabel alloc] initWithFrame:CGRectMake(_width1, _highly, 30, 17)];
        _zhangFuLadel.backgroundColor =   LTRGBA(42, 101, 234, 1);
        _zhangFuLadel.text = @"买涨";
        _zhangFuLadel.font = [UIFont systemFontOfSize:10.0];
        _zhangFuLadel.textAlignment = NSTextAlignmentCenter;
        _zhangFuLadel.layer.masksToBounds = YES;
        [_zhangFuLadel.layer setCornerRadius:4.0f];
        _zhangFuLadel.textColor = [UIColor whiteColor];
    }
    return _zhangFuLadel;
}

- (UIImageView *)arrowImage{
    if (!_arrowImage) {
        _arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 15, 22.5, 5, 10)];
        _arrowImage.image = [UIImage imageNamed:@"arrow"];
    }
    return _arrowImage;
}

-(UIImageView *)increaseImage{
    if (!_increaseImage) {
        _increaseImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.topView.frame.size.height+10, 27.5, 27.5)];
        _increaseImage.image = [UIImage imageNamed:@""];
    }
    return _increaseImage;
}

- (UILabel *)timeLadel{
    if (!_timeLadel) {
        _timeLadel = [[UILabel alloc] initWithFrame:CGRectMake(15+_increaseImage.frame.size.width, self.topView.frame.size.height + 12, [UIScreen mainScreen].bounds.size.width /2, 10)];
        _timeLadel.text = @"2018-04-18 14:42:22";
        _timeLadel.font = [UIFont systemFontOfSize:10.0];
        _timeLadel.textColor = kNewsGrayColor;
    }
    return _timeLadel;
}

- (UILabel *)priceLadel{
    if (!_priceLadel) {
        _priceLadel = [[UILabel alloc] initWithFrame:CGRectMake(15+_increaseImage.frame.size.width, self.topView.frame.size.height + 12 + _timeLadel.frame.size.height + 3.5, [UIScreen mainScreen].bounds.size.width /2, 14)];
        _priceLadel.text = @"建仓价1.43015(-0.23$)";
        _priceLadel.textColor = kNewsGrayColor;
        _priceLadel.font = [UIFont systemFontOfSize:14.0];
    }
    return _priceLadel;
}

- (UIButton *)unwindButton{
    if (!_unwindButton) {
        _unwindButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _unwindButton .frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, _topView.frame.size.height + 9.5, 50, 27.5 );
        [_unwindButton setTitle:@"平仓" forState:UIControlStateNormal];
        [_unwindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_unwindButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_unwindButton.layer setCornerRadius:_unwindButton.frame.size.height/2];
        _unwindButton.backgroundColor =  LTRGBA(42, 101, 234, 1);
    }
    return _unwindButton;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topView.frame.size.height + 20 + _increaseImage.frame.size.height, [UIScreen mainScreen].bounds.size.width, 0.5)];
        _lineView.backgroundColor = LTBgColor;
    }
    return _lineView;
}

-(NSMutableArray *)PosinionView{
    NSMutableArray * viewArr = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 2; j++) {
            PosinionView * view = [[PosinionView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 * j, self.topView.frame.size.height + 30.5 + _increaseImage.frame.size.height + 22 * (i%2), [UIScreen mainScreen].bounds.size.width * 0.5, 12)];
            [viewArr addObject:view];
        }
    }
    return viewArr;
}

#pragma mark 数据赋值
- (void)setModel:(postionModel *)model{
    
    // 获取本地的行情数据
//     NSMutableArray  * markArray = [NSMutableArray arrayWithArray:[DataHundel shareDataHundle].marketArrat];
//    NSInteger numder = 0;
//    if (markArray.count > 0 ) {
//        for (MarketModel * marketModel in markArray) {
//            if ([marketModel.symbol isEqualToString:model.symbol]) {
//                 self.nameLadel.text = marketModel.symbol_cn;
//                numder = marketModel.digit;
//            }
//        }
//    }
   
    self.nameLadel.text = model.symbolName;
    NSDecimalNumber *unitPrice = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%lf", model.unitPrice]];

    NSString * string = @"建仓价";
    NSString * string1= [NSString stringWithFormat:@"%@",unitPrice];
    CGFloat  profit = model.profit;
   
    NSString *string2 = [NSString stringWithFormat:@"(%@$)",[self formatNumber:profit withPointDigits:2]];
    NSString *string4 = [NSString stringWithFormat:@"%@%@%@",string,string1,string2];
    // 创建Attributed
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:string4];
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc = [[noteStr string] rangeOfString:string].location+string.length;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc = [[noteStr string] rangeOfString:string1].location+string1.length;
    // 需要改变的区间
    NSRange range = NSMakeRange(firstLoc, secondLoc - firstLoc);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:range];
    
    
    // 需要改变的第一个文字的位置
    NSUInteger firstLoc1 = [[noteStr string] rangeOfString:string].location+string.length+string1.length;
    // 需要改变的最后一个文字的位置
    NSUInteger secondLoc1 = [[noteStr string] rangeOfString:string2].location+string2.length;
    // 需要改变的区间
    NSRange range1 = NSMakeRange(firstLoc1, secondLoc1 - firstLoc1);
    // 改变颜色
    [noteStr addAttribute:NSForegroundColorAttributeName value:LTRGBA(25, 171, 0, 1) range:range1];
    // 改变字体大小及类型
    [noteStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.f] range:range1];
    
    // 为label添加Attributed
    [self.priceLadel setAttributedText:noteStr];
//    self.timeLadel.text = [DataHundel convertime:model.createTime];
    self.timeLadel.text = model.createTime;
//    self.priceLadel.text = [NSString stringWithFormat:@"%@%@(%@)",@"建仓价",model.open_price,model.profit];
    // 判断建仓类型
    self.typeStr = model.cmd;
    
    NSInteger transactionStatus = model.transactionStatus;
    
    if (transactionStatus == 1) {
        // 市价单赋值预留
        self.typeLadel.text = @"市价单";
        self.String = @"CLOSE";
        [self.unwindButton setTitle:@"平仓" forState:UIControlStateNormal];
        
        // 判断是否买涨还是买跌Ladel 赋值预留
        if (model.ransactionType == 1) {
            self.zhangFuLadel.text =[NSString stringWithFormat:@"%@", @"买涨"];
            self.increaseImage.image = [UIImage imageNamed:@"rose"];
//            self.rangLabel.textColor = LTRedColor;
        }else
        {
            self.zhangFuLadel.text =[NSString stringWithFormat:@"%@", @"买跌"];
            self.increaseImage.image = [UIImage imageNamed:@"fall"];
//            self.rangLabel.textColor = LTGreenColor;
        }
    }else{
        //市价单赋值预留
        self.String = @"DELETE";
        self.typeLadel.text = @"挂  单";
        [self.unwindButton setTitle:@"撤销" forState:UIControlStateNormal];

        // 判断是否买涨还是买跌Ladel 赋值预留
        if (model.ransactionType == 1) {
            self.zhangFuLadel.text =[NSString stringWithFormat:@"%@", @"买涨"];
            self.increaseImage.image = [UIImage imageNamed:@"rose"];
//            self.rangLabel.textColor = LTRedColor;
        }else
        {
            self.zhangFuLadel.text =[NSString stringWithFormat:@"%@", @"买跌"];
            self.increaseImage.image = [UIImage imageNamed:@"fall"];
//            self.rangLabel.textColor = LTGreenColor;
        }
    }
    
    self.viewOne.titleString = @"止盈";
    self.viewOne.parameterString = model.stopProfitExponent;
    self.viewTwo.titleString = @"止损";
    self.viewTwo.parameterString = model.stopLossExponent;
    self.viewThree.titleString = @"手数";
    self.viewThree.parameterString = [NSString stringWithFormat:@"%ld",model.lot];
    self.viewFour.titleString = @"订单号";
    self.viewFour.parameterString = @"";
    
}

- (void)setIndex:(NSInteger)index{
    _unwindButton.tag = index;
}

#pragma mark - 平仓按钮点击事件
-(void)clickAction:(UIButton *)sender
{
    NSLog(@"点击了%ld号按钮",_unwindButton.tag);
    // 之前声明好的代理
//    [self.delegate didQueRenBtn:sender atIndex:sender.tag type:self.String];
//    if ([self.delegate respondsToSelector:@selector(didQueRenBtn:)]) {
//
//    }
    if (self.goodsViewTouchBlock) {
        self.goodsViewTouchBlock(sender, sender.tag, self.String);
    }
}

- (NSString *)formatNumber:(CGFloat)number withPointDigits:(int)digits {
    NSString *formatStr = [NSString stringWithFormat:@"%%0.%df", digits];
    return [NSString stringWithFormat:formatStr, number];
}
@end
