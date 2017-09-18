//
//  UIFont+LHSafe.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/9/18.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (LHSafe)

+ (instancetype)lh_safeFontWithName:(NSString *)name size:(CGFloat)size;

@end
