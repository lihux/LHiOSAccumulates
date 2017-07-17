//
//  LCDBRuntimeViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/7/14.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDBRuntimeViewController.h"

#import <objc/objc.h>
#import <objc/runtime.h>

#define ADDRESS_OF(object) [NSString stringWithFormat:@"%p", object]

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
    [self log:@"现在开始测试tagged pointer:苹果在OC2 & 64位CPU系统中引入了 tagged Poniter的概念，目的是为了缩减加载小尺寸类（NSNumber/NSData...)的加载速度和存储空间"];
    NSNumber *a = @1, *b = @2, *c = @3, *d = @(0xffff), *e = @(0xEFFFFFFFFFFFFFFF);
    NSNumber *f = [[NSNumber alloc] initWithInt:4];
    NSString *output = [NSString stringWithFormat:@"NSNumber对象\na=%@  address =%p\nb=%@  address =%p\nc=%@  address =%p\nd=%@  address =%p,\ne=%@  address =%p, \nf=%@  address =%p", a, a, b, b, c, c, d, d, e, e, f, f];
    [self log:output];
    [self log:@"可以看出当数比较小的时候，都将作为tagged pointer来存储的，也就是将值整合到地址中去"];
    [self log:[NSString stringWithFormat:@"再来看看他们的尺寸：sizeof a = %zd, sizeof e = %zd", sizeof(a), sizeof(e)]];
    BOOL r11 = [NSObject isKindOfClass:[NSObject class]];
    BOOL r12 = [[NSObject class] isKindOfClass:[NSObject class]];
    BOOL r13 = [[NSObject new] isKindOfClass:[NSObject class]];
    BOOL r14 = [[[NSObject new] class] isKindOfClass:[NSObject class]];
    BOOL r15 = [[NSObject class] isKindOfClass:[[NSObject new] class]];
    BOOL r16 = [object_getClass([NSObject class]) isKindOfClass:[NSObject class]];
    NSLog(@"1=%d, 2=%d, 3=%d, 4=%d, 5=%d, 6=%d", r11, r12, r13, r14, r15, r16);
//    a.objCType
//    NSString *isa = [NSString stringWithFormat:@"%@", a->ISA()];
    [self addressOf:nil];
}

- (void)addressOf:(id)object {
    BOOL r21 = [NSObject isMemberOfClass:[NSObject class]];
    BOOL r22 = [[NSObject class] isMemberOfClass:[NSObject class]];
    BOOL r23 = [[NSObject new] isMemberOfClass:[NSObject class]];
    BOOL r24 = [[[NSObject new] class] isMemberOfClass:[NSObject class]];
    BOOL r25 = [[NSObject class] isMemberOfClass:[[NSObject new] class]];
    BOOL r26 = [object_getClass([NSObject class]) isMemberOfClass:[NSObject class]];
    BOOL r27 = [[NSObject class] isMemberOfClass:object_getClass([NSObject class])];
    NSLog(@"1=%d, 2=%d, 3=%d, 4=%d, 5=%d, 6=%d, 7=%d", r21, r22, r23, r24, r25, r26, r27);
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
