//
//  LCMemoryManageViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/6.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCMemoryManageViewController.h"

@interface LCMemoryManageViewController ()


@end

@implementation LCMemoryManageViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self log:@"ARC原理、autoreleasepool的原理以及NSObject内部布局是怎样的？"];
}

@end
