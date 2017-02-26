//
//  LCFlyingView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCFlyingView.h"

@interface LCFlyingView ()

@end

@implementation LCFlyingView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            self.maskLabel = (UILabel *)view;
            self.maskLabel.backgroundColor = [UIColor clearColor];
        } else {
            self.maskView = view;
        }
    }
}

- (void)setAlpha:(CGFloat)alpha
{
    if (self.maskView && self.maskLabel) {
        self.maskLabel.alpha = alpha == 1.0 ? 1.0 : 0.4;
        self.maskView.alpha = alpha == 1.0 ? 0.2 : 0;
    } else {
        [super setAlpha:alpha];
    }
}

@end
