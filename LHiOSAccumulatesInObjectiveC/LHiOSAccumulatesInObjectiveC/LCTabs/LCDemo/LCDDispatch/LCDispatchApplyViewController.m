//
//  LCDispatchApplyViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/4/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDispatchApplyViewController.h"
#import "LCUtilities.h"

#import <objc/runtime.h>

@interface LCDispatchApplyViewController ()

@property (nonatomic, strong) NSMutableString *outputString;
@property (weak, nonatomic) IBOutlet UIButton *trigglerButton;

@end

@implementation LCDispatchApplyViewController

//定义的__weak_lihux是为了学习autoreleasepool的实现原理而新增的，参考文章：
//http://www.cocoachina.com/ios/20150610/12093.html
__weak NSString *__weak_lihux = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.outputString = [NSMutableString string];
//    [self sceen1];
//    [self sceen1b];
//    [self sceen2];
//    [self sceen3];
//    [self testDeayLock];
    [self testSemaphore];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear:%@", __weak_lihux);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear:%@", __weak_lihux);
//    [self printAllClass];
}

#pragma mark -
- (void)sceen1 {
    NSString *lihux = [NSString stringWithFormat:@"大王派我来巡山"];
    __weak_lihux = lihux;
    //运行的时候在此处设置lldb的断点：watchpoint set variable __weak_lihux 观察__weak_lihux的值的变化情况
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), __weak_lihux);
}

- (void)sceen1b {
    NSString *lihux = @"大王派我来巡山";
    __weak_lihux = lihux;
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), __weak_lihux);
}

- (void)sceen2 {
    @autoreleasepool {
        NSString *lihux = [NSString stringWithFormat:@"大王派我来巡山"];
        __weak_lihux = lihux;
    }
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), __weak_lihux);
}

- (void)sceen3 {
    NSString *lihux;
    @autoreleasepool {
         lihux = [NSString stringWithFormat:@"大王派我来巡山"];
        __weak_lihux = lihux;
    }
    NSLog(@"%@:%@", NSStringFromSelector(_cmd), __weak_lihux);
}

#pragma -
- (IBAction)didTapOnButton:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    button.tag = tag + 1;
    [self updateOutPutStringWithTag:tag];
    [button setTitle:[NSString stringWithFormat:@"点击触发dispatch_apply(%d)次", tag + 1] forState:UIControlStateNormal];
}

- (void)updateOutPutStringWithTag:(NSInteger)tag {
    [self.outputString appendString:[NSString stringWithFormat:@"\n点击触发dispatch_apply(%zd)次", tag]];
    [self log:self.outputString];
    @weakify(self);
    dispatch_apply(tag, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        @strongify(self);
        NSString *content = [NSString stringWithFormat:@"\n并发%zd个中的第%zd个：\n此计算在线程%@上进行\n", tag, index, [NSThread currentThread]];
        [self.outputString appendString:content];//多线程同时写，可能会有问题
        NSLog(@"%@", content);
    });
}

#pragma mark -
- (void)testDeayLock {
    NSLog(@"测试GCD是否会死锁1");
    dispatch_queue_t queue1 = dispatch_queue_create(NULL, DISPATCH_QUEUE_CONCURRENT);//这样不会产生死锁
    //https://blog.csdn.net/u013378438/article/details/81076116
//    dispatch_queue_t queue1 = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL); //这样会产生死锁（最新的已经能检测出死锁直接挂掉)
    dispatch_async(queue1, ^{
        NSLog(@"测试GCD是否会死锁2");
        dispatch_sync(queue1, ^{
            NSLog(@"测试GCD是否会死锁3");
        });
    });
    NSLog(@"测试GCD是否会死锁4");
}

#pragma mark - Test Semphore
- (void)testSemaphore {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    if (!semaphore) {
        NSLog(@"怎么回事！！！！！");
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"爷爷来解救你！");
        dispatch_semaphore_signal(semaphore);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSLog(@"爸爸来解救你！");
//            dispatch_semaphore_signal(semaphore);
//        });
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"终于等到你！");
}

#pragma mark - 打印出所有的类
- (void)printAllClass {
    @autoreleasepool {
        unsigned int count;
        Class *cls = objc_copyClassList(&count);
        for (NSUInteger i = 0; i < count; i ++) {
            Class currentClass = cls[i];
            NSLog(@"打印第%zd个类address%p：%@", i+1, currentClass, NSStringFromClass(currentClass));
        }
    }
}

- (void)dealloc {
    NSLog(@"我释放了");
}

@end
