//
//  LCDBLoadInitializeLearningViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2019/5/16.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCDBLoadInitializeLearningViewController.h"

#import "LHFather.h"

@implementation LCDBLoadInitializeLearningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testInitalize];
    
}

- (void)testInitalize {
    LHFather *father = [LHFather new];//会导致父类的initialize被调用了两次！！！
}

@end
