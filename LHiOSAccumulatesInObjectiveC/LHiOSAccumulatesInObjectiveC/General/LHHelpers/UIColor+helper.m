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

//UIColor* blend( UIColor* c1, UIColor* c2, float alpha )
//{
//    alpha = MIN( 1.f, MAX( 0.f, alpha ) );
//    float beta = 1.f - alpha;
//    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
//    [c1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
//    [c2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
//    CGFloat r = r1 * beta + r2 * alpha;
//    CGFloat g = g1 * beta + g2 * alpha;
//    CGFloat b = b1 * beta + b2 * alpha;
//    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
//}
@end
