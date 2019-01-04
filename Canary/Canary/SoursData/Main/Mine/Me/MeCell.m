//
//  MeCell.m
//  ixit
//
//  Created by litong on 2016/12/9.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "MeCell.h"

@interface MeCell ()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UILabel *detailLab;
@property (nonatomic,strong) UIImageView *nextIV;

@property (nonatomic,strong) UIImageView *redMarkIV;

@property (nonatomic,strong) UILabel *countLab;

@end

@implementation MeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = LTWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createCell];
    }
    return self;
}
- (void)createCell {
    self.titleLab = [[UILabel alloc] init];
    _titleLab.frame = CGRectMake(LTAutoW(kLeftMar), 0, ScreenW_Lit*0.5, LTAutoW(kMeCellH));
    _titleLab.font = autoFontSiz(15);
    _titleLab.textColor = LTTitleColor;
    [self addSubview:_titleLab];
    
    
    CGFloat mar = LTAutoW(32);
    CGFloat detailLabW = ScreenW_Lit*0.3;
    self.detailLab = [[UILabel alloc] init];
    _detailLab.frame = CGRectMake(ScreenW_Lit - mar - detailLabW, 0, detailLabW, LTAutoW(kMeCellH));
    _detailLab.font = autoFontSiz(15);
    _detailLab.textColor = LTSubTitleColor;
    _detailLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:_detailLab];
    
    CGFloat countLabW = LTAutoW(26);
    CGFloat countLabH = LTAutoW(16);
    self.countLab = [[UILabel alloc] init];
    _countLab.frame = CGRectMake(ScreenW_Lit - mar - countLabW, (LTAutoW(kMeCellH)-countLabH)*0.5, countLabW, countLabH);
    _countLab.font = autoFontSiz(12);
    _countLab.textColor = LTWhiteColor;
    _countLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_countLab];
    [_countLab layerRadius:3 bgColor:LTColorHex(0xF54A40)];
    _countLab.hidden = YES;
    
    CGFloat nextIVW = LTAutoW(7);
    CGFloat nextIVH = LTAutoW(11);
    self.nextIV = [[UIImageView alloc] init];
    _nextIV.frame = CGRectMake(ScreenW_Lit - LTAutoW(kLeftMar) - nextIVW, (LTAutoW(kMeCellH) - nextIVH)/2.0, nextIVW, nextIVH);
    _nextIV.image = [UIImage imageNamed:@"next"];
    [self addSubview:_nextIV];
    
    self.redMarkIV = [[UIImageView alloc] init];
    _redMarkIV.image = [UIImage imageNamed:@"redPointIcon"];
    [self addSubview:_redMarkIV];
    _redMarkIV.hidden = YES;
    
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, LTAutoW(kMeCellH)-0.5, ScreenW_Lit, 0.5);
    lineView.backgroundColor = LTLineColor;
    [self addSubview:lineView];
    
}


NSInteger shortVersionInt() {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    NSString *verStr = [dict objectForKey:@"CFBundleShortVersionString"];
    NSString *ver = [verStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSInteger version = [ver integerValue];
    return version;
}

NSString *shortVersionString() {
    NSDictionary *dict = [[NSBundle mainBundle] infoDictionary];
    return [dict objectForKey:@"CFBundleShortVersionString"];
}



- (void)bindData:(NSString *)data {
    _titleLab.text = data;
    
    NSString *detail = nil;
    BOOL showRedPoint = NO;

    if ([data isEqualToString:@"版本检测"]) {
        NSInteger curVer = shortVersionInt();
        detail = [NSString stringWithFormat:@"v%@",shortVersionString()];
        
        NSString *newestVersionStr0 = [UserDefaults stringForKey:newestVersionKey];
        NSString *newestVersionStr = [newestVersionStr0 stringByReplacingOccurrencesOfString:@"." withString:@""];
        NSInteger newestVersion = [newestVersionStr integerValue];
        
        BOOL bl = newestVersion > curVer;
        if (bl) {
            detail = [NSString stringWithFormat:@"v%@",newestVersionStr0];
            showRedPoint = YES;
            CGFloat redPointIVWH = LTAutoW(7);
            CGSize size = [data boundingSize:CGSizeMake(MAXFLOAT, LTAutoW(20)) font:autoFontSiz(15) ];
            CGFloat w = size.width;
            _redMarkIV.frame = CGRectMake(_titleLab.x_ + w + LTAutoW(4), LTAutoW(12.5), redPointIVWH, redPointIVWH);
        }
    }
    
    if ([data isEqualToString:@"消息中心"]) {
        NSInteger messageCount = UD_UnReadMessageCount;
        if (messageCount > 0) {
            _countLab.hidden = NO;
            if (messageCount > 99) {
                _countLab.text = @"99+";
            } else {
                _countLab.text = [NSString stringWithInteger:messageCount];
            }
        } else {
            _countLab.hidden = YES;
        }
    } else {
        _countLab.hidden = YES;
    }
    
    _detailLab.text = detail;
    _redMarkIV.hidden = !showRedPoint;
}



@end
