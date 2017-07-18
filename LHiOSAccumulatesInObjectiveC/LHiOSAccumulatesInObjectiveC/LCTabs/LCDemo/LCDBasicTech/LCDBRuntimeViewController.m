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
//test case 2
@property (nonatomic, assign) NSString *assignedString;
@property (nonatomic, strong) NSString *strongedString;
@property (nonatomic, assign) NSNumber *assignedNumber;
@property (nonatomic, strong) NSNumber *strongedNumber;

@end

static void setExpressionFormula(id self, SEL cmd, id value) {
    NSLog(@"LCDBRuntimeDog: call setExpressionFormula");
}

static void getExpressionFormula(id self, SEL cmd) {
    NSLog(@"LCDBRuntimeDog: call getExpressionFormula");
}

@implementation LCDBRuntimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self log:[NSString stringWithFormat:@"%@", self.testDic]];
    NSLog(@"%@", self.testDic);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self customTestCase2];
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
//1.测试taggedPointer
- (void)testTaggedPointer {
    [self cleanLog];
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

//2.测试assign的持有NSNumber & NSString，会不会crash，以及为什么
- (void) testAssignNSNumberAndNSString {
    [self cleanLog];
    [self log:@"下面开始测试assign的持有NSNumber & NSString，会不会crash，以及为什么"];
    self.assignedNumber = @21;
    self.assignedString = [NSString stringWithFormat:@"xxooxx:%@", self.strongedString];
    [self log:[NSString stringWithFormat:@"assignedString:%@, 地址：%p,\nstrongedString:%@,地址：%p,\nassignedNumber:%@, 地址：%p,\nstrongedNumber:%@,地址：%p", self.assignedString, self.assignedString, self.strongedString, self.strongedString, self.assignedNumber, self.assignedNumber, self.strongedNumber, self.strongedNumber]];
}

-(void)customTestCase2 {
    self.assignedNumber = @1;
    self.strongedNumber = @23;
    self.assignedString = @"helo, I'm assigned";
    self.strongedString = @"hello, I'm stronged";
    [self log:[NSString stringWithFormat:@"assignedString:%@, 地址：%p,\nstrongedString:%@,地址：%p,\nassignedNumber:%@, 地址：%p,\nstrongedNumber:%@,地址：%p", self.assignedString, self.assignedString, self.strongedString, self.strongedString, self.assignedNumber, self.assignedNumber, self.strongedNumber, self.strongedNumber]];
}

//3.测试self类方法和对象方法的不同之处
- (void)testSelf {
    [self cleanLog];
    [self log:@"下面开始测试到底什么是self"];
    BOOL b1 = [NSObject class] == [NSObject self];
    [self log:[NSString stringWithFormat:@"[NSObject class]:%@ ==? [NSObject self]:%@，答案是：%zd", [NSObject class], [NSObject self], b1]];
    BOOL b2 = [NSObject class] == [[NSObject new] class];
    [self log:[NSString stringWithFormat:@"[NSObject class]:%@ ==? [[NSObject new] class]:%@，答案是：%zd", [NSObject class], [[NSObject new] class], b2]];
}

//4.测试运行时动态创建类、添加成员变量和方法、以及调用
- (void)testCreateClassAtRuntime {
    [self cleanLog];
    [self log:@"下面开始动态创建一个类：LCDBRuntimeDog"];
    const char *className = "LCDBRuntimeDog";
    Class cls = objc_getClass(className);
    if (!cls) {
        [self log:@"类LCDBRuntimeDog在运行时环境中不存在"];
        Class superClass = [NSObject class];
        cls = objc_allocateClassPair(superClass, className, 0);
    }
    NSUInteger size;
    NSUInteger alignment;
    NSGetSizeAndAlignment("*", &size, &alignment);
    class_addIvar(cls, "expression", size, alignment, "*");
    
    class_addMethod(cls, @selector(setExpressionFormula:), (IMP)setExpressionFormula, "v@:@");
    class_addMethod(cls, @selector(getExpressionFormula), (IMP)getExpressionFormula, "@@:");
    
    objc_registerClassPair(cls);
    
    [self log:@"类LCDBRuntimeDog运行时创建并注册完成，下面开始创建一个他的实例："];
    id aRuntimeDog = [[cls alloc] init];
//    object_setInstanceVariable(aRuntimeDog, "expression", "1+1"); //BAD in ARC
    Ivar var = class_getInstanceVariable(cls, "expression");
    object_setIvar(aRuntimeDog, var, @"1+1");
    [aRuntimeDog performSelector:@selector(getExpressionFormula)];
}

#pragma mark - getter & setters
- (NSDictionary *)testDic {
    if (_testDic) {
        return _testDic;
    }
    _testDic = @{@"1.测试taggedPointer": @"testTaggedPointer",
                 @"2.测试assign的持有NSNumber & NSString，会不会crash，以及为什么": @"testAssignNSNumberAndNSString",
                 @"3.测试self类方法和对象方法的不同之处": @"testSelf",
                 @"4.测试运行时动态创建类、添加成员变量和方法、以及调用": @"testCreateClassAtRuntime",
                 };
    self.keys = [_testDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2];
    }];
    return _testDic;
}
@end
