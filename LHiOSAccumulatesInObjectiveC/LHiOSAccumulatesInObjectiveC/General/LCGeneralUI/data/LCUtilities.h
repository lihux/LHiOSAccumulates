//
//  LCUtilities.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@class LCAccumulate;

@interface LCUtilities : NSObject

+ (NSArray *)loadAccumulatesFromPlistWithPlistFileName:(NSString *)fileName;
+ (UIViewController *)viewControllerForAccumulate:(LCAccumulate *)accumulate;

@end
