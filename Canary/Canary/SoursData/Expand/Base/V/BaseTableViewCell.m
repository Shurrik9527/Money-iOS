//
//  BaseTableViewCell.m
//  FMStock
//
//  Created by dangfm on 15/4/12.
//  Copyright (c) 2015年 dangfm. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Masonry.h"

@interface BaseTableViewCell(){
    UIButton *_detailIco;
}

@end
@implementation BaseTableViewCell

-(void)dealloc{
    _detailIco = nil;
}
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
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




-(void)initViews{
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    UIView *_selectbg = [[UIView alloc]initWithFrame:self.frame];
    self.selectedBackgroundView = _selectbg;
    _selectbg = nil;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.imageView.image) {
        CGFloat w = self.imageWidth;
        if (w<=0) w = 50;
        CGRect f = self.imageView.frame;
        [self.imageView setFrame:CGRectMake(5+(w-f.size.width)/2, f.origin.y,f.size.width, f.size.height)];
        //self.imageView.clipsToBounds = YES;
        //self.imageView.contentMode = UIViewContentModeCenter;
        //self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.textLabel.frame = CGRectMake(w+10,
                                          self.textLabel.frame.origin.y,
                                          self.frame.size.width-w,
                                          self.textLabel.frame.size.height);
    }
    _detailIco.frame = CGRectMake(self.frame.size.width-_detailIco.frame.size.width-10, (self.frame.size.height-_detailIco.frame.size.height)/2, _detailIco.frame.size.width, _detailIco.frame.size.height);
}


-(void)showArrow{
    // 箭头
    if (!_detailIco) {
//        UIImage *img = [UIImage imageNamed:@"ms_in"];
//        _detailIco = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-img.size.width-10, (self.frame.size.height-img.size.height)/2, img.size.width, img.size.height)];
//        [_detailIco setBackgroundImage:img forState:UIControlStateNormal];
//        img = nil;
//        [self.contentView addSubview:_detailIco];
    }
    
}


@end
