//
//  LCLockViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/6/29.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCLockViewController.h"

#import <os/lock.h>

@interface LCLockViewController ()

@end

@implementation LCLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testLock];
}

- (void)testLock {
    [self testUnfairLock];
    [self testNSLock];
}

- (void)testUnfairLock {
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

- (void)testNSLock {
    NSLock *lock = [NSLock new];
    int i = 0;
    [lock lock];
    i++;
    [lock unlock];

    //异步unlock这把锁，貌似也是有问题的
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [lock unlock];
//    });
}

@end
