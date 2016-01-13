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

- (void)awakeFromNib
{
    [self configButton];
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"]) {
        NSLog(@"我擦：%lf", self.bounds.size.width);
        self.layer.cornerRadius = self.bounds.size.width / 2;
    }
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
    [self setBackgroundColor:[UIColor colorWithHex:0xFFFFFF alpha:0.1] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.2] forState:UIControlStateHighlighted];
    [self setBorderCorder:[UIColor colorWithHex:0xFFFFFF alpha:0.8] forState:UIControlStateNormal];
    [self setBorderCorder:[UIColor colorWithHex:0x000000 alpha:0.1] forState:UIControlStateHighlighted];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"bounds"];
}

@end
