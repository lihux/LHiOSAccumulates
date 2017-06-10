//
//  LCLightBorderButton.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/10.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCLightBorderButton.h"

#import "UIColor+helper.h"

@implementation LCLightBorderButton

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configButton];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self configButton];
    }
    return self;
}

- (void)configButton
{
    self.layer.borderWidth = 2.0 / [UIScreen mainScreen].scale;
    [self setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor colorWithHex:0xFFFFFF alpha:0.2] forState:UIControlStateSelected];

    [self setBorderCorder:[UIColor colorWithHex:0xFFFFFF alpha:0.4] forState:UIControlStateNormal];
    [self setBorderCorder:[UIColor clearColor] forState:UIControlStateSelected];
    [self setBorderCorder:[UIColor clearColor] forState:UIControlStateHighlighted];

    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor colorWithHex:0xFFFFFF alpha:0.4] forState:UIControlStateNormal];
}

@end
