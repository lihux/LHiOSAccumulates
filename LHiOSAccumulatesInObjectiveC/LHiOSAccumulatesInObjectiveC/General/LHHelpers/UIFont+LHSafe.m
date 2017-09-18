//
//  UIFont+LHSafe.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/9/18.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "UIFont+LHSafe.h"

@implementation UIFont (LHSafe)

+ (instancetype)lh_safeFontWithName:(NSString *)name size:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:name size:size];
    return font ? font : [UIFont systemFontOfSize:size];
}

@end
