//
//  LCUtilities.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCUtilities.h"

#import "LCAccumulate.h"
#import <UIKit/UIKit.h>

@implementation LCUtilities

+ (NSArray *)loadAccumulatesFromPlistWithPlistFileName:(NSString *)fileName
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray *accumulates = [NSArray array];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:plistPath];
    if (tempArray.count > 0) {
        NSMutableArray *tempAccumulates = [NSMutableArray array];
        for (NSDictionary* dic in tempArray) {
            [tempAccumulates addObject:[[LCAccumulate alloc] initWithDictionary:dic]];
        }
        accumulates = [NSArray arrayWithArray:tempAccumulates];
    }
    return accumulates;
}

+ (UIViewController *)viewControllerForAccumulate:(LCAccumulate *)accumulate
{
    if (accumulate.storyboardID.length > 0) {
        return [[UIStoryboard storyboardWithName:accumulate.storyboardName bundle:nil] instantiateViewControllerWithIdentifier:accumulate.storyboardID];
    }
    return nil;
}

@end
