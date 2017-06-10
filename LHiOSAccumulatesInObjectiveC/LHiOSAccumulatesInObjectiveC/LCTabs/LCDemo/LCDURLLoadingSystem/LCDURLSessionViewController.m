//
//  LCDURLSessionViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/10.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDURLSessionViewController.h"

#import "LCDURLHelper.h"

@interface LCDURLSessionViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentContainerView;

@end

@implementation LCDURLSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - override
- (UIView *)logAnchorView {
    return self.contentContainerView;
}

#pragma mark - test cases
- (IBAction)testDefaultDelegateSession:(id)sender {
    [self log:@"下面开始测试使用default delegate的session进行简单的网络请求"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", kLCDURLHost, @"/hello/lihux"];
    NSURL *url = [NSURL URLWithString:urlString];
    [self log:[NSString stringWithFormat:@"请求的URL是\n%@", url]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *threadInfo = [NSString stringWithFormat:@"请求完毕，当前的completionHandler执行的具体线程信息是\n%@", [NSThread currentThread]];
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *responseInfo = [NSString stringWithFormat:@"请求回来的数据是：\ndata:\n%@\nresponse:\n%@\nerror:\n%@", dataString, response, error];
        [self log:threadInfo];
        [self log:responseInfo];
    }];
    [dataTask resume];
}

- (IBAction)testCustomizedDelegateSession:(id)sender {
}
- (IBAction)testPostRequest:(id)sender {
}

- (IBAction)test302Redirect:(id)sender {
}

@end
