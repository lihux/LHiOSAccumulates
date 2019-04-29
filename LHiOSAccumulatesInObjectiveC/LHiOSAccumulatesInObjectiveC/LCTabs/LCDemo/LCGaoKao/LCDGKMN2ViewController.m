//
//  LCDGKMN2ViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/4/29.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCDGKMN2ViewController.h"

@implementation LCDGKMN2ViewController

#pragma mark - override
- (NSDictionary *)buildDictionaryData {
    return @{@"检查GCD主-子-主线程切换的执行顺序": @"checkGCDFlow1",
             @"检查GCD子-主-子线程切换的执行顺序": @"checkGCDFlow2"
             };
}

#pragma mark - 具体调用
- (void)checkGCDFlow1 {
    [self cleanLog];
    printf("1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        printf("2");
    });
    printf("3");
    [self log:@"主(1)-子(2)-主(3)的执行顺序一定是：132，原因是：dispatch_async(global)，子线程的执行是在...的时候才进行"];
}

- (void)checkGCDFlow2 {
    [self cleanLog];
    printf("1");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        printf("2");
        dispatch_async(dispatch_get_main_queue(), ^{
            printf("3");
        });
        printf("4");
    });
    printf("5");
    [self log:@"主(1)-子(2)-主(3)的执行顺序一定是：15243，原因是：dispatch_async(global)，子线程的执行是在...的时候才进行"];
}

@end
