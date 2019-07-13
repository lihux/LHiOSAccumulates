//
//  LCJSCViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/13.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCJSCViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface LCJSCViewController ()

@property (nonatomic, strong) JSContext *context;

@end

@implementation LCJSCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test];
}

- (void)test {
    JSValue *value = [self.context evaluateScript:@"f(2, 3)"];
    JSValue *value2 = [self.context evaluateScript:@"add(2, 3)"];
    NSLog(@"哈哈哈哈哈哈哈哈哈哈：%@, %@", [value toString], value2);
}

#pragma mark - lazy load
- (JSContext *)context {
    if (_context) {
        return _context;
    }
    _context = [[JSContext alloc] init];
    [_context evaluateScript:@"function add(x, y) {return x + y}"];
//    _context[@"add"] = @"function add(x, y) { return x + y;}";
    _context.exceptionHandler = ^(JSContext *context, JSValue *value) {
        NSLog(@"JS执行发生了异常，快来看看有什么问题：%@, %@", context, value);
    };
    return _context;
}

@end
