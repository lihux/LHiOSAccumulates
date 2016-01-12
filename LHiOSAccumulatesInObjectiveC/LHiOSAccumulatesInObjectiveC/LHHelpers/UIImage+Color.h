//
//  UIImage+Color.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/12.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color rect:(CGRect)rect;

@end
