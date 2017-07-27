//
//  LCUtilities.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCUtilities.h"

#import "LCAccumulate.h"
#import "LCTableViewController.h"
#import "LCConstantDefines.h"

#import <UIKit/UIKit.h>

@implementation LCUtilities

+ (NSArray *)loadAccumulatesFromPlistWithPlistFileName:(NSString *)fileName {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray *accumulates = [NSArray array];
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:plistPath];
    NSNumber *showUnfinishedTag = [[NSUserDefaults standardUserDefaults] objectForKey:KLCSettingShowUnfinishedPageKey];
    BOOL showUnfinished = showUnfinishedTag ? showUnfinishedTag.boolValue : NO;
    if (tempArray.count > 0) {
        NSMutableArray *tempAccumulates = [NSMutableArray array];
        for (NSDictionary* dic in tempArray) {
            LCAccumulate *accumulate = [[LCAccumulate alloc] initWithDictionary:dic];
            if (showUnfinished) {
                [tempAccumulates addObject:accumulate];
            } else if ((accumulate.plistName.length > 0 || accumulate.storyboardID.length > 0)) {
                [tempAccumulates addObject:accumulate];
            }
        }
        accumulates = [NSArray arrayWithArray:tempAccumulates];
    }
    return accumulates;
}

+ (UIViewController *)viewControllerForAccumulate:(LCAccumulate *)accumulate
{
    if (accumulate.plistName.length > 0) {
        LCTableViewController *vc = [[LCTableViewController alloc] init];
        [vc configWithTitle:accumulate.viewControllerTitle plistFileName:accumulate.plistName];
        return vc;
    } else if (accumulate.storyboardID.length > 0) {
        return [[UIStoryboard storyboardWithName:accumulate.storyboardName bundle:nil] instantiateViewControllerWithIdentifier:accumulate.storyboardID];
    }
    return nil;
}

@end
