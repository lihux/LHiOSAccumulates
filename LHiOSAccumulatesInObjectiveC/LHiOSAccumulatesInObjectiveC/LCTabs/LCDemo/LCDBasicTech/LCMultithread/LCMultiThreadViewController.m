//
//  LCMultiThreadViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/13.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCMultiThreadViewController.h"

#import "LCMyOperation.h"

@interface LCMultiThreadViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end
@implementation LCMultiThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

- (void)test {
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"我在那条线程里面干活呢？");
    }];
    [self.queue addOperation:operation];
    LCMyOperation *myOperation = [LCMyOperation new];
    [self.queue addOperation:myOperation];
}

#pragma mark -
- (NSOperationQueue *)queue {
    if (_queue) {
        return _queue;
    }
    _queue = [[NSOperationQueue alloc] init];
    _queue.maxConcurrentOperationCount = 1;
    return _queue;
}

@end
