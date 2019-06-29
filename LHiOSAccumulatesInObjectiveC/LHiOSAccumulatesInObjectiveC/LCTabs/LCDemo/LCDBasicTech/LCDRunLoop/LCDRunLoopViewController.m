//
//  LCDRunLoopViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2018/9/7.
//  Copyright © 2018年 Lihux. All rights reserved.
//

#import "LCDRunLoopViewController.h"

#import <os/lock.h>

@interface LCDRunLoopViewController ()

@end

@implementation LCDRunLoopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testLock];
}

- (void)testLock {
    int i;
    os_unfair_lock_t lock = &OS_UNFAIR_LOCK_INIT;
    os_unfair_lock_lock(lock);
    i = 10;
    os_unfair_lock_unlock(lock);
    //如果在异步线程unlock这把锁，它会crash！
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        os_unfair_lock_unlock(lock);
//    });
}

- (IBAction)didTapOnNoToleranceTimerButton:(id)sender {
    //添加断点来测试：
    //(lldb) breakpoint set -r dispatch_source_set_timer
    NSLog(@"没有设置tolerance,直接使用mk_timer");
    CFAbsoluteTime refTime = CFAbsoluteTimeGetCurrent();
    NSTimer *timer = [NSTimer timerWithTimeInterval:3.0 repeats:NO block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer fire %f",CFAbsoluteTimeGetCurrent() - refTime);
    }];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (IBAction)didTapOnToleranceTimerButton:(id)sender {
    NSLog(@"设置了tolerance，使用dispatch timer");
    CFAbsoluteTime refTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"start time 0.000000");
    NSTimer *timer = [NSTimer timerWithTimeInterval:7.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer fire %f",CFAbsoluteTimeGetCurrent() - refTime);
    }];
    timer.tolerance = 0.5;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
//    NSTimer *timer2 = [NSTimer timerWithTimeInterval:53.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        NSLog(@"timer fire %f",CFAbsoluteTimeGetCurrent() - refTime);
//    }];
//    [[NSRunLoop mainRunLoop] addTimer:timer2 forMode:NSRunLoopCommonModes];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"before busy %f", CFAbsoluteTimeGetCurrent() - refTime);
//        NSInteger j;
//        for (long  i = 0; i< 1000000000; i++) {
//            j = i*3;
//        }
//        NSLog(@"after busy %f", CFAbsoluteTimeGetCurrent() - refTime);
//    });
    
}


@end
