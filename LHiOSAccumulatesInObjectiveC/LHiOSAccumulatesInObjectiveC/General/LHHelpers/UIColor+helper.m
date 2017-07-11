//
//  UIColor+helper.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/12.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "UIColor+helper.h"

@implementation UIColor (helper)

+ (UIColor *) r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a {
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a];
}

+ (UIColor *) r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b {
    return [self r:r g:g b:b a:1.0];
}

+ (UIColor *) colorWithHex:(long)value {
    return [self colorWithHex:value alpha:1.0];
}

+ (UIColor *) colorWithHex:(long)value alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((value & 0xFF0000) >> 16) / 255.0 green:((value & 0x00FF00) >> 8) / 255.0 blue:(value & 0x0000FF) / 255.0 alpha:alpha];
}

- (UIColor*)blendWithColor:(UIColor*)color2 alpha:(CGFloat)alpha2 {
    alpha2 = MIN( 1.0, MAX( 0.0, alpha2 ) );
    CGFloat beta = 1.0 - alpha2;
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [self getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    CGFloat red     = r1 * beta + r2 * alpha2;
    CGFloat green   = g1 * beta + g2 * alpha2;
    CGFloat blue    = b1 * beta + b2 * alpha2;
    CGFloat alpha   = a1 * beta + a2 * alpha2;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
