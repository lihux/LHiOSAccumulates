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
//    [self testNSCondition];
//    [self testNSConditionLock];
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
    //NSLock是由pthread_mutex_lock来实现的
    NSLock *lock = [NSLock new];
    int i = 0;
    [lock lock];
//    [lock lock];//这里打开会死锁：在同一个线程里
    i++;
    [lock unlock];

    //异步unlock这把锁，貌似也是有问题的
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [lock unlock];
//    });
}

//NSCondition可以wait/signal，wait的时候会卡住当前线程，但是这两个操作之前都要lock/unlock
//NSCondition可以用来协同典型的读者写者问题
//经测试发现它也是封装pthread_mutex_lock来实现的，擦
- (void)testNSCondition {
    NSCondition *condition = [NSCondition new];
    [condition lock];
//    [condition lock];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [condition lock];
        [condition signal];
        printf("走这里");
        [condition unlock];
    });
    __block int i = 0;
    [condition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    i = 4;
    printf("卡死了%d", i);
    [condition unlock];
}

//lockWhenCondition:10，当condition为10的时候才能成功获取锁，进而进入核心区代码，否则就卡住当前线程，这个方法使用了NSCondition waitUntilDate:方法
//其实现使用了pthread_cond_wait，封装而成
- (void)testNSConditionLock {
    NSConditionLock *conditionLock = [[NSConditionLock alloc] initWithCondition:3];
    [conditionLock lockWhenCondition:2];//这时候会卡死
//    [conditionLock lockWhenCondition:3];
}

- (void)testMutextLock {
//    pthread_mutex_t mutex = pthmri
}

@end
