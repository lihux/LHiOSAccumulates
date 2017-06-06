//
//  LHBorderLineView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/13.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LHBorderLineView.h"

@implementation LHBorderLineView

- (void)awakeFromNib {
    [super awakeFromNib];
    for (NSLayoutConstraint *constraint in self.constraints) {
        NSLog(@"%@", constraint);
        if (constraint.firstItem == self && (constraint.firstAttribute == NSLayoutAttributeWidth || constraint.firstAttribute == NSLayoutAttributeHeight)) {
            constraint.constant = 1 / [UIScreen mainScreen].scale;
            [self layoutIfNeeded];
        }
    }
}

@end
