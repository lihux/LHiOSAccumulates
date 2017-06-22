//
//  LCLihuxHelper.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCLihuxHelper.h"

#import <UIKit/UIKit.h>

@implementation LCLihuxHelper

- (void)makeLihuxStyleOfView:(UIView *)view {
    if (view && view.tag != -9999) {
        view.backgroundColor = [UIColor clearColor];
        UIColor *textColor = [UIColor whiteColor];
        if ([view isKindOfClass:[UILabel class]]) {
            [(UILabel *)view setTextColor:textColor];
        } else if ([view isKindOfClass:[UIButton class]]) {
            [(UIButton *)view setTitleColor:textColor forState:UIControlStateNormal];
        } else if ([view isKindOfClass:[UITextField class]]) {
            [(UITextField *)view setTextColor:textColor];
        } else if ([view isKindOfClass:[UITextView class]]) {
            [(UITextView *)view setTextColor:textColor];
        }
    }
    
    for (UIView *subView in view.subviews) {
        [self makeLihuxStyleOfView:subView];
    }
}

@end
