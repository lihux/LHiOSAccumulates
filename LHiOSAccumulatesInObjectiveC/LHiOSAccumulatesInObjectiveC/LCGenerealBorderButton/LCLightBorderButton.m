//
//  LCLightBorderButton.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/10.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCLightBorderButton.h"

@implementation LCLightBorderButton

- (void)awakeFromNib
{
    self.layer.borderColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8].CGColor;
    self.layer.borderWidth = 2.0 / [UIScreen mainScreen].scale;
}

@end
