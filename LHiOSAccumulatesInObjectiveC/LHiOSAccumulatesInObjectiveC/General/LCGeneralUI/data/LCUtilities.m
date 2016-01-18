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
            NSString *title = dic[@"title"];
            NSString *content = dic[@"content"];
            NSString *storyboardID = dic[@"storyboardID"];
            [tempAccumulates addObject:[[LCAccumulate alloc] initWith:title content:content storyboardID:storyboardID]];
        }
        accumulates = [NSArray arrayWithArray:tempAccumulates];
    }
    return accumulates;
}

+ (UIViewController *)viewControllerForAccumulate:(LCAccumulate *)accumulate storyboardName:(NSString *)storyboardName
{
    UIViewController *accumulateViewController = [[UIStoryboard storyboardWithName:storyboardName bundle: nil] instantiateViewControllerWithIdentifier:accumulate.storyboardID];
    accumulateViewController.title = accumulate.title;
    return accumulateViewController;
}

@end
