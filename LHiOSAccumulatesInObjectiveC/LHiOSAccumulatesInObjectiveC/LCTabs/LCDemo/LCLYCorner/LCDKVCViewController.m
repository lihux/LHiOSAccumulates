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
    return @{@"KVC🐂啊": @"testKVCSearchPath:",
             @"KVC🐂啊s": @"testKVCSearchPath:",
             @"KVC🐂啊f": @"testKVCSearchPath:",
             @"KVC🐂啊e": @"testKVCSearchPath:",
             @"KVC🐂啊d": @"testKVCSearchPath:",
             @"KVC🐂啊ds": @"testKVCSearchPath:",
             @"KVC🐂啊dsada": @"testKVCSearchPath:",
             @"KVC🐂啊fff": @"testKVCSearchPath:",
             @"KVC🐂啊fd": @"testKVCSearchPath:",
             @"KVC🐂啊fdsfds": @"testKVCSearchPath:",
             };
}

#pragma mark - test functions
- (void)testKVCSearchPath:(NSNumber *)row {
    [self log:@"啊哈哈哈，看到希望了"];
}

@end
