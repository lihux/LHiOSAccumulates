//
//  LCDBRuntimeViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/7/14.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDBRuntimeViewController.h"

@interface LCDBRuntimeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *testDic;
@property (nonatomic, strong) NSArray *keys;

@end

@implementation LCDBRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self log:[NSString stringWithFormat:@"%@", self.testDic]];
    NSLog(@"%@", self.testDic);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = self.keys[indexPath.row];
    NSString *selectorString = self.testDic[key];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(selectorString)];
#pragma clang diagnostic pop
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"runtimeTestCaseCell"];
    cell.textLabel.text = self.keys[indexPath.row];
    [LCLihuxHelper makeLihuxStyleOfView:cell];
    return cell;
}

#pragma mark - test cases
- (void)testTaggedPointer {
    [self log:@"现在开始测试tagged pointer:苹果在OC2 & 64位CPU系统中引入了 tagged Poniter的概念，目的是为了缩减加载小尺寸类（NSNumber...)的加载速度和存储空间"];
}

#pragma mark - getter & setters
- (NSDictionary *)testDic {
    if (_testDic) {
        return _testDic;
    }
    _testDic = @{@"1.测试taggedPointer": @"testTaggedPointer"};
    self.keys = [_testDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2];
    }];
    return _testDic;
}
@end
