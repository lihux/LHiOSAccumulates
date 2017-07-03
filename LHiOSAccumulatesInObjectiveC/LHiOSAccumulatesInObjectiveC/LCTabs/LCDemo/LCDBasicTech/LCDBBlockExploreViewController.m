//
//  LCDBBlockExploreViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/17.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDBBlockExploreViewController.h"

typedef void(^LCDBCompletionBlock)(BOOL);

@implementation LCDBBlockExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger aa = 1;
    NSInteger *bb = &aa;
    NSString *cc = @"hello";
    __block NSString *dd = [NSString stringWithFormat:@"%@", cc];
    NSArray *ee = @[@1, @2];
    NSMutableArray *ff = [NSMutableArray arrayWithArray:ee];
    [self log:[NSString stringWithFormat:@"地址信息是：aa: %ld, bb: %ld, cc: %ld, dd: %ld, ee: %ld, ff: %ld", (long)&aa, (long)&bb, (long)&cc, (long)&dd, (long)&ee, (long)&ff]];
    [self testBlock:^(BOOL finished) {        
        NSString *ddd = dd;
        dd = @"周杰伦";
        NSLog(@"ddd:%@,dd:%@,&ddd:%ld,&dd:%ld", ddd, dd , (long)&ddd, (long)&dd);
        if (finished) {
            [self log:@"block被调用"];
        }
    }];
}

- (void)testBlock:(LCDBCompletionBlock)block {
    if (block) {
        block(YES);
    }
}

@end
