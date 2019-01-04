//
//  GiftSingleView.m
//  ixit
//
//  Created by litong on 2017/3/29.
//  Copyright © 2017年 litong. All rights reserved.
//

#import "GiftSingleView.h"
#import "UIImageView+WebCache.h"

#define kGiftIVWH   LTAutoW(70)

#define kSelIVWH    LTAutoW(17)
#define kSelIVMar    LTAutoW(8)

@interface GiftSingleView ()

@property (nonatomic,strong) UIButton *fullBtn;
@property (nonatomic,strong) UIImageView *selIV;
@property (nonatomic,strong) UIImageView *giftIV;
@property (nonatomic,strong) UILabel *pointLab;

@property (nonatomic,assign) NSInteger idx;

@end

@implementation GiftSingleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = LTClearColor;
        [self createView];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"GiftSingleView dealloc");
}

- (void)createView {
    
    self.selIV = [[UIImageView alloc] init];
    self.selIV.frame = CGRectMake(self.w_ - kSelIVMar - kSelIVWH, kSelIVMar, kSelIVWH, kSelIVWH);
    self.selIV.image = [UIImage imageNamed:@"live_gift_active"];
    self.selIV.userInteractionEnabled = YES;
    [self addSubview:self.selIV];
    self.selIV.hidden = YES;
    
    self.giftIV = [[UIImageView alloc] init];
    self.giftIV.frame = CGRectMake((self.w_ - kGiftIVWH)*0.5, LTAutoW(13.5), kGiftIVWH, kGiftIVWH);
    self.giftIV.userInteractionEnabled = YES;
    [self addSubview:self.giftIV];
    
    self.pointLab = [[UILabel alloc] init];
    self.pointLab.frame = CGRectMake(0, self.giftIV.yh_, self.w_, LTAutoW(15));
    self.pointLab.textColor = LTColorHex(0xB4B9CB);
    self.pointLab.font = autoFontSiz(11);
    self.pointLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.pointLab];
    
    self.fullBtn = [UIButton btnWithTarget:self action:@selector(clickFullBtn) frame:CGRectMake(0, 0, self.w_, self.h_)];
    [self addSubview:self.fullBtn];
}


#pragma mark - action

- (void)clickFullBtn {
    _selectIdxBlock ? _selectIdxBlock(_idx) : nil;
}

#pragma mark - 外部

- (void)configData:(LiveGiftMO *)mo idx:(NSInteger)idx {
    self.idx = idx;

    [self.giftIV sd_setImageWithURL:[mo.giftPic toURL] placeholderImage:nil options:SDWebImageProgressiveDownload];
    self.pointLab.attributedText = [mo poins_absfmt];
}

- (void)selectedView:(BOOL)selected {
    UIColor *color = selected ? GiftSingleBgColorSel : LTClearColor;
    self.backgroundColor = color;
    
    self.selIV.hidden = !selected;
}

@end
