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

/**

 */

/**
 里面含有跳转到目的ViewController的三种用法：
 1.如果plistName不为空，则跳转到由plistName加载出来的数据源的目录页面，否则进入到2；
 2.如果storyboardName，则通过storyboard加载viewController(当然storyboardID也需要有值)，否则进入到3；
 3.如果storyboardID，则假定storyboardID就是viewController的类名，直接生成Class，进而调用new方法生成，否则进入到4；
 4.加载失败，返回空;

 @param accumulate 含有跳转信息的对象
 @return 返回跳转过去的viewController，或者nil
 */
+ (UIViewController *)viewControllerForAccumulate:(LCAccumulate *)accumulate
{
    if (accumulate.plistName.length > 0) {
        LCTableViewController *vc = [[LCTableViewController alloc] init];
        [vc configWithTitle:accumulate.viewControllerTitle plistFileName:accumulate.plistName];
        return vc;
    } else if (accumulate.storyboardID.length > 0) {
        if (accumulate.storyboardName.length > 0) {
            return [[UIStoryboard storyboardWithName:accumulate.storyboardName bundle:nil] instantiateViewControllerWithIdentifier:accumulate.storyboardID];
        }
        
        Class cls = NSClassFromString(accumulate.storyboardID);
        return [cls new];//这里假设storyboardID是你要初始化的viewController的类的名字
    }
    return nil;
}

@end
