//
//  LCMethodFordingViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/13.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCMethodFordingViewController.h"

#import "LCMethodForward.h"

@interface LCMethodFordingViewController ()

@property (nonatomic, strong) LCMethodForward *natural;

@end

@implementation LCMethodFordingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.natural = [LCMethodForward new];
    [self test];
}

- (void)test {
    [self.natural performSelector:@selector(dog) withObject:nil];
    [self.natural performSelector:@selector(cat) withObject:nil];
}

@end
