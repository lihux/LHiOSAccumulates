//
//  LCLihuxMeViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/4.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCLihuxMeViewController.h"

@interface LCLihuxMeViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LCLihuxMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.lihux.me"]]];
    [self logProcessInfo];
}

- (void)logProcessInfo {
    @autoreleasepool {
        //创建一个NSProcessInfo对象，表示当前进程
        NSProcessInfo *processInfo = [NSProcessInfo processInfo];
        
        //获取运行该进程的参数
        NSArray *arr = [processInfo arguments];
        NSLog(@"运行该程序的参数为：%@", arr);
        //获取该进程的进程标示符
        NSLog(@"该程序的进程标示符(PID)为：%d", [processInfo processIdentifier]);
        //获取该进程的进程名
        NSLog(@"该程序的进程名为：%@", [processInfo processName]);
        //设置该进程的新进程名
        [processInfo setProcessName:@"test"];
        NSLog(@"该程序的新进程名为：%@", [processInfo processName]);
        
        //获取运行该进程的系统的环境变量
        NSLog(@"运行该进程的系统的所有环境变量为：%@", [processInfo environment]);
        //获取运行该进程的主机名
        NSLog(@"运行该进程的主机名为：%@", [processInfo hostName]);
        //获取运行该进程的操作系统
        NSLog(@"运行该进程所在的操作系统为：%ld", [processInfo operatingSystem]);
        //获取运行该进程的操作系统的版本
        NSLog(@"运行该进程所在的操作系统名为：%@", [processInfo operatingSystemName]);
        //获取运行该进程的操作系统的版本
        NSLog(@"运行该进程所在的操作系统的版本为：%@", [processInfo operatingSystemVersionString]);
        
        //获取运行该进程的系统的物理内存
        NSLog(@"运行该进程的系统的物理内存为：%lld", [processInfo physicalMemory]);
        //获取运行该进程的系统的处理器数量
        NSLog(@"运行该进程的系统的处理器数量为：%ld", [processInfo processorCount]);
        //获取运行该进程的系统的处于激活状态的处理器数量
        NSLog(@"运行该进程的系统的处于激活状态的处理器数量为：%ld", [processInfo activeProcessorCount]);
        //获取运行该进程的系统已运行的时间
        NSLog(@"运行该进程的系统的已运行时间为：%f", [processInfo systemUptime]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"%@: request:%@\n\n", NSStringFromSelector(_cmd), request);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"...%@", NSStringFromSelector(_cmd));
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"...%@", NSStringFromSelector(_cmd));
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"...%@:failed:%@", NSStringFromSelector(_cmd), error);
}

@end
