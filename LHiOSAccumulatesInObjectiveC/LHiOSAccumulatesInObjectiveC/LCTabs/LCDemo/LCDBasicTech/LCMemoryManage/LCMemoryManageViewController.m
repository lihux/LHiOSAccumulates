//
//  LCMemoryManageViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/6.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCMemoryManageViewController.h"

#import "DummyObject.h"

#import <malloc/malloc.h>
#import <objc/runtime.h>

@interface LCMemoryManageViewController ()


@end

@implementation LCMemoryManageViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self log:@"ARC原理、autoreleasepool的原理以及NSObject内部布局是怎样的？"];
    [self testNSobject];
}

- (void)testNSobject {
    NSArray *classes = [DummyObject testClasses];
    id temp;
    size_t instanceSize, memeorySize;
    for (Class cls in classes) {
        temp = [cls new];
        instanceSize = class_getInstanceSize(cls);
        memeorySize = malloc_size((__bridge const void *)temp);
        [self log:[NSString stringWithFormat:@"类%@实例对象的实例大小是：%zd，但实际占用内存大小是:%zd", NSStringFromClass(cls), instanceSize, memeorySize]];
    }
}

@end
