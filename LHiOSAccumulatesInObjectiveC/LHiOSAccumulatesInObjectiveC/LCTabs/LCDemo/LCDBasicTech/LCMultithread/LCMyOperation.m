//
//  LCMyOperation.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/13.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCMyOperation.h"

//源码参考：http://blog.leichunfeng.com/blog/2015/07/29/ios-concurrency-programming-operation-queues/

@interface LCMyOperation ()
@end
@implementation LCMyOperation

@synthesize executing = _executing;
@synthesize finished = _finished;

- (instancetype)init {
    if (self = [super init]) {
        _executing = NO;
        _finished = NO;
    }
    return self;
}

- (void)start {
    NSLog(@"我开始干活了");
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
}

- (void)main {
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        _finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }

    sleep(3);
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _finished  = YES;
    [self didChangeValueForKey:@"isFinished"];
    NSLog(@"Finish executing %@", NSStringFromSelector(_cmd));
}

- (BOOL)isExecuting {
    return _executing;
}

- (BOOL)isFinished {
    return _finished;
}

- (BOOL)isAsynchronous {
    return YES;
}

@end
