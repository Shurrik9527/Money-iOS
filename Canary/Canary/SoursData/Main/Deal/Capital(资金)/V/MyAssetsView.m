//
//  MyAssetsView.m
//  Canary
//
//  Created by 孙武东 on 2019/2/18.
//  Copyright © 2019 litong. All rights reserved.
//

#import "MyAssetsView.h"

@implementation MyAssetsView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (IBAction)assetsAction:(UIButton *)sender {
    if (self.assetsBlock) {
        self.assetsBlock();
    }
}

- (IBAction)withdrawal:(UIButton *)sender {
    if (self.withdrawalBlock) {
        self.withdrawalBlock();
    }
}


@end
