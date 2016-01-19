//
//  UIColor+helper.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/12.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "UIColor+helper.h"

@implementation UIColor (helper)

+ (UIColor *) r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a
{
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a];
}

+ (UIColor *) r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b
{
    return [self r:r g:g b:b a:1.0];
}

+ (UIColor *) colorWithHex:(long)value
{
    return [self colorWithHex:value alpha:1.0];
}

+ (UIColor *) colorWithHex:(long)value alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((value & 0xFF0000) >> 16) / 255.0 green:((value & 0x00FF00) >> 8) / 255.0 blue:(value & 0x0000FF) / 255.0 alpha:alpha];
}

@end
