//
//  FMBaseView.m
//  golden_iphone
//
//  Created by dangfm on 15/6/11.
//  Copyright (c) 2015年 golden. All rights reserved.
//

#import "FMBaseView.h"

@implementation FMBaseView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        self.isClear = NO;
        //self.userInteractionEnabled = NO;
    }
    return self;
}

-(void)updateWithModel:(FMKLineModel*)model{

}


@end
