//
//  LCNSURLSession.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/3.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCNSURLSession.h"

@interface LCNSURLSession () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *completeQueue;

@end

@implementation LCNSURLSession

- (void)connect {
    NSString *baidu = @"https://www.baidu.com";
//    [self connectTo:douban];
    [self connectTo:baidu];
}

- (void)connectTo:(NSString *)urlStr {
    if (_session) {
        [self.session invalidateAndCancel];
        self.session = nil;
        return;
    }
    
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:[NSURL URLWithString:urlStr]];
    [task resume];
}

- (NSURLSession *)session {
    if (_session) {
        return _session;
    }
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:self.completeQueue];
    return _session;
}

- (NSOperationQueue *)completeQueue {
    if (_completeQueue) {
        return _completeQueue;
    }
    _completeQueue = [NSOperationQueue new];
    _completeQueue.maxConcurrentOperationCount = 1;
    return _completeQueue;
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"收到数据：%@", str);
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSLog(@"收到证书验证事件%@", challenge.sender);
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (completionHandler) {
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    NSLog(@"怎么就编程了一个下载的task了呢？");
}

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    NSLog(@"连接失效：%@", error.localizedDescription);
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    NSLog(@"session通话结束:%@", error.localizedDescription);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"收到响应：%@", response);
}

@end
