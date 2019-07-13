//
//  LCJSCViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/13.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCJSCViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@protocol LCJSExpoer <JSExport>

- (NSInteger)add:(NSInteger)a to:(NSInteger)b;

@end

@interface LCJSObject : NSObject <LCJSExpoer>

@property (nonatomic, assign) NSInteger result;

@end

@implementation LCJSObject

- (NSInteger) add:(NSInteger)a to:(NSInteger)b {
    return a + b;
}

@end

@interface LCJSCViewController ()

@property (nonatomic, strong) JSContext *context;
@property (nonatomic, strong) LCJSObject *bridgeObject;

@end

@implementation LCJSCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

- (void)test {
    [self.context evaluateScript:@"f(2, 3)"];//f没有定义，所以抛出异常
    JSValue *addValue = [self.context evaluateScript:@"add(2, 3)"];//js执行的是oc添加的js函数
    JSValue *subValue = [self.context evaluateScript:@"sub(4, 1)"];//js执行的是oc 添加的oc函数
    JSValue *anotherAddValue = [self.context evaluateScript:@"ocobj.result = ocobj.addTo(43, 2)"];
    NSString *str = [NSString stringWithFormat:@"哈哈哈哈哈哈哈哈哈哈：加法：%@, 减法：%@, i调用另外一个加法：%@", [addValue toString], subValue, anotherAddValue];
    [self log:str];
}

#pragma mark - lazy load
- (JSContext *)context {
    if (_context) {
        return _context;
    }
    _context = [[JSContext alloc] init];
    [_context evaluateScript:@"function add(x, y) {return x + y}"];
//    _context[@"add"] = @"function add(x, y) { return x + y;}";
    _context[@"sub"] = ^(NSInteger a, NSInteger b) {
        return a - b;
    };
    _context.exceptionHandler = ^(JSContext *context, JSValue *value) {
        NSLog(@"JS执行发生了异常，快来看看有什么问题：%@, %@", context, value);
    };
    
    _context[@"ocobj"] = self.bridgeObject;
    return _context;
}

- (LCJSObject *)bridgeObject {
    if (_bridgeObject) {
        return _bridgeObject;
    }
    _bridgeObject = [LCJSObject new];
    return _bridgeObject;
}

@end
