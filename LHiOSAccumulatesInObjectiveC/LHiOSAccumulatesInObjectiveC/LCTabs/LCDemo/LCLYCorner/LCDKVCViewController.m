//
//  LCDKVCViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2018/8/9.
//  Copyright © 2018年 Lihux. All rights reserved.
//

#import "LCDKVCViewController.h"


@interface LCDKVCPerson: NSObject

@property (nonatomic, strong) NSString *name;

@end

@implementation LCDKVCPerson

@end

@interface LCDKVCViewController () {
    NSInteger _age;
}

@end

@implementation LCDKVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark override
- (NSDictionary *)buildData {
    return @{@"KVC🐂啊": @"testKVCSearchPath:"};
}

#pragma mark - test functions
- (void)testKVCSearchPath:(NSNumber *)row {
    [self log:@"啊哈哈哈，看到希望了"];
}

@end
