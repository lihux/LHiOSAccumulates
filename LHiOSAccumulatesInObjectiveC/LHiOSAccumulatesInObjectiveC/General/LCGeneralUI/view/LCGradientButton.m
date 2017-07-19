//
//  LCGradientButton.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/7/19.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCGradientButton.h"
#import "UIColor+helper.h"

@interface LCGradientButton ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation LCGradientButton

-(void)layoutSubviews {
    [super layoutSubviews];
    NSLog(@"渐变button：layoutSubviews ：\n%@", self);
    self.gradientLayer.frame = self.bounds;
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer) {
        return _gradientLayer;
    }
    _gradientLayer = [[CAGradientLayer alloc] init];
    UIColor *start = self.gradientStartColor ? self.gradientStartColor : [UIColor colorWithHex:0x00E0E5];
    UIColor *end = self.gradientEndColor ? self.gradientEndColor : [UIColor colorWithHex:0x0086FA];
    _gradientLayer.colors = @[(__bridge id)start.CGColor, (__bridge id)end.CGColor];
    _gradientLayer.startPoint = CGPointMake(0, 0);
    _gradientLayer.endPoint = CGPointMake(1.0, 0);
    _gradientLayer.frame = self.bounds;
    [self.layer addSublayer:_gradientLayer];
    return _gradientLayer;
}

@end
