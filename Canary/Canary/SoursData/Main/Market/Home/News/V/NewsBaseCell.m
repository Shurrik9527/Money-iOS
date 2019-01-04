//
//  NewsBaseCell.m
//  ixit
//
//  Created by litong on 2016/11/10.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "NewsBaseCell.h"



@interface NewsBaseCell ()

@end


@implementation NewsBaseCell

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
    
}

- (void)bindData:(NewsModel *)model { }
+ (CGFloat)cellHWithContent:(NewsModel *)mo {
    return 0;
}

+ (NSAttributedString *)ABStr:(NSString *)title content:(NSString *)content {
    CGSize titleSize = [title boundingSize:CGSizeMake(MAXFLOAT, titleFontSize) font:[UIFont autoFontSize:titleFontSize]];
    CGFloat w = titleSize.width;
    
    NSString *str = [NSString stringWithFormat:@"  %@",content];
    NSMutableAttributedString *ABStr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange range = NSMakeRange(0, str.length);
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5.f;
    paragraphStyle.firstLineHeadIndent = w;
    [ABStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
//    [ABStr addAttribute:NSForegroundColorAttributeName value:kNewsBlackColor range:range];
    [ABStr addAttribute:NSFontAttributeName value:[UIFont autoBoldFontSize:15.f] range:range];
    
    return ABStr;
}

+ (CGSize)ABStrH:(NSString *)title content:(NSString *)content {
    NSAttributedString *ABStr = [NewsBaseCell ABStr:title content:content];
    CGFloat w = [NewsBaseCell contectLabW];
    CGSize size = [ABStr boundingRectWithSize:CGSizeMake(w, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return size;
}




+ (CGFloat)contectLabW {
    return ScreenW_Lit - 2*LTAutoW(kLeftMar);
}


- (void)addTopLine {
    UIView *lineView = [[UIView alloc] init] ;
    lineView.frame = CGRectMake(0, 0, ScreenW_Lit, LTAutoW(kNewsTempLineH));
    lineView.backgroundColor = LTBgColor;
    [self addSubview:lineView];
}

@end
