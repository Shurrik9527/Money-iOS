//
//  GiftMO.m
//  ixit
//
//  Created by litong on 2016/12/19.
//  Copyright © 2016年 litong. All rights reserved.
//

#import "GiftMO.h"

@implementation GiftMO

- (UIColor *)btnColor {
    NSString *str = _btnTextColor;
    if (notemptyStr(str)) {
        return LTColorHexString(str);
    }
    return LTSureFontBlue;
}

- (UIColor *)subTextColor {
    NSString *str = _subTextColorOpacity;
    if (notemptyStr(str)) {
        return LTColorHexString(str);
    }
    return LTColorHexA(0xFFFFFF, 0.3);;
}


- (NSString *)giftLimitNum_fmt {
    NSString *str = [NSString stringWithFormat:@"仅剩%@份",_giftLimitNum];
    return str;
}

- (NSString *)points_fmt {
    NSString *str = [NSString stringWithFormat:@"%@积分",[_poins numberDecimalFmt]];
    return str;
}


- (NSString *)takeNum_fmt {
    NSString *str = [NSString stringWithFormat:@"%@人已兑换",[_takeNum numberDecimalFmt]];
    return str;
}

- (NSString *)giftSmallPic {
    if (_giftSmallPic) {
        return _giftSmallPic;
    }
    return _giftPic;
}


-(void)setPoins:(NSNumber *)poins{
    NSInteger pN=[poins integerValue];
    NSNumber *poinsN=[NSNumber numberWithInteger:labs(pN)];
    _poins=poinsN;
}


@end
