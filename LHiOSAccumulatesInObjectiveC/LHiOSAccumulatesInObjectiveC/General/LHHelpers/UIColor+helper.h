//
//  UIColor+helper.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/12.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (helper)

+ (UIColor *) r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b;
+ (UIColor *) r:(CGFloat)r g:(CGFloat)g b:(CGFloat)b a:(CGFloat)a;
+ (UIColor *) colorWithHex:(NSInteger)value;
+ (UIColor *) colorWithHex:(NSInteger)value alpha:(CGFloat)alpha;
- (UIColor*)blendWithColor:(UIColor*)color2 alpha:(CGFloat)alpha2;

@end
