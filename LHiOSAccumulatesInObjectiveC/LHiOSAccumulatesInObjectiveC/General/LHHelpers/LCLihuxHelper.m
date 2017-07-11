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

+ (void)makeLihuxStyleOfView:(UIView *)view {
    if ((!view) || view.tag == kLCNonLihuxStyleViewTag) {
        return;
    }
    view.backgroundColor = [UIColor clearColor];
    UIColor *textColor = [UIColor whiteColor];
    if ([view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)view;
        [label setTextColor:textColor];
        if (label.tag >9 && label.tag < 20) {
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:label.tag];
        }
    } else if ([view isKindOfClass:[UIButton class]]) {
        [(UIButton *)view setTitleColor:textColor forState:UIControlStateNormal];
    } else if ([view isKindOfClass:[UITextField class]]) {
        [(UITextField *)view setTextColor:textColor];
    } else if ([view isKindOfClass:[UITextView class]]) {
        [(UITextView *)view setTextColor:textColor];
    }
    
    for (UIView *subView in view.subviews) {
        [self makeLihuxStyleOfView:subView];
    }
}

+ (UIColor *)colorOfType:(LCLihuxStyleColorType)type {
    UIColor *color = [UIColor clearColor];
    switch (type) {
        case LCLihuxStyleColorTypeBackground:
        case LCLihuxStyleColorTypeContent:
            color = [UIColor colorWithHex:0x188242 alpha:1.0];
        default:
            break;
    }
    //目前其他类型的颜色是从背景色衍生出来的，所以不需要储存
    NSString *key = [self lihuxStyleColorStoreKeyFromType:LCLihuxStyleColorTypeBackground];
    NSNumber *colorValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (colorValue) {
        color = [UIColor colorWithHex:colorValue.integerValue];
    }
    if (type == LCLihuxStyleColorTypeContent) {
        color = [color blendWithColor:[UIColor whiteColor] alpha:0.1];
    }
    return color;
}

+ (void)resetColorByValue:(NSInteger)colorValue ofType:(LCLihuxStyleColorType)type {
    NSString *key = [self lihuxStyleColorStoreKeyFromType:type];
    if (colorValue > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:@(colorValue) forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

+ (NSString *)lihuxStyleColorStoreKeyFromType:(LCLihuxStyleColorType)type {
    return [NSString stringWithFormat:@"LCLihuxStyleColorType_%zd", type];
}

@end
