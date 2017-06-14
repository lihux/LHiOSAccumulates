//
//  LCDURLSessionViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/10.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDURLSessionViewController.h"

#import "LCDURLHelper.h"

@interface LCDURLSessionViewController () <NSURLSessionDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentContainerView;
@property (nonatomic, strong) NSURLSession *defaultSeesion;

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
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[LCDURLHelper urlWithPath:@"/create/topic"]];
    postRequest.HTTPMethod = @"POST";
    postRequest.HTTPBody = [@"来自星星✨的你，来自月亮🌛的我" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionDataTask *dataTask = [self.defaultSeesion dataTaskWithRequest:postRequest];
    [dataTask resume];
    [self.defaultSeesion finishTasksAndInvalidate];
}

- (IBAction)test302Redirect:(id)sender {
}

- (IBAction)didTapOnUpdateServerButton:(id)sender {
    [[[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]] dataTaskWithURL:[LCDURLHelper urlWithPath:@"/updateServer"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *threadInfo = [NSString stringWithFormat:@"请求完毕，当前的completionHandler执行的具体线程信息是\n%@", [NSThread currentThread]];
        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *responseInfo = [NSString stringWithFormat:@"请求回来的数据是：\ndata:\n%@\nresponse:\n%@\nerror:\n%@", dataString, response, error];
        [self log:threadInfo];
        [self log:responseInfo];
    }] resume];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    [self log:[NSString stringWithFormat:@"会话：%@:\n状态变为了无效，错误原因是：%@", session, error]];
}

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    [self log:[NSString stringWithFormat:@"会话：%@收到了challenge:\n%@", session, challenge]];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [self log:[NSString stringWithFormat:@"NSURLSessionDataDelegate-didReceiveResponse\n收到响应%@", response]];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    [self log:[NSString stringWithFormat:@"NSURLSessionDataDelegate-didBecomeDownloadTask\n收到响应%@", downloadTask]];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [self log:[NSString stringWithFormat:@"NSURLSessionDataDelegate-didReceiveData\n收到响应%@", data]];
}

#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    for (NSURLSessionTaskTransactionMetrics *TaskMetric in metrics.transactionMetrics) {
        [self log:@""];
        [self log:[NSString stringWithFormat:@"路由信息：%@", TaskMetric]];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    [self log:[NSString stringWithFormat:@"NSURLSessionTaskDelegate-didCompleteWithError\n%@%@%@", session, task, error]];
}

#pragma mark - lazy loads
-(NSURLSession *)defaultSeesion {
    if (!_defaultSeesion) {
        _defaultSeesion = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _defaultSeesion;
}
@end
