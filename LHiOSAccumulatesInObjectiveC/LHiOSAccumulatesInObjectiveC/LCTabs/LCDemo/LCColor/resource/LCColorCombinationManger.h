//
//  LCColorCombinationManger.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/9.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LCColorCombination.h"

@interface LCColorCombinationManger : NSObject

@property (nonatomic, copy) NSArray <LCColorCombination *>*colorCombinations;

+ (instancetype)sharedInstance;

- (NSArray <LCNamedColor *>*)namedColors;

@end
