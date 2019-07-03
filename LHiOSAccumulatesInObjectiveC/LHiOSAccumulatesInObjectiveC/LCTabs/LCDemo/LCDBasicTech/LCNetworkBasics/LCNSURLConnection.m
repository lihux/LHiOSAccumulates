//
//  LCNSURLConnection.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/3.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCNSURLConnection.h"

@interface LCNSURLConnection ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation LCNSURLConnection

- (void)connect {
    [self connect:@"https://www.github.com"];
}

- (void)connect:(NSString *)urlStr {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    if (!request) {
        return;
    }
    if (self.connection) {
        [self.connection cancel];
        self.connection = nil;
    }
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"连接建立失败：%@", error.localizedDescription);
}

//- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection;
//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    NSLog(@"是否认证：%@", protectionSpace);
    return YES;
}

//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    NSLog(@"服务端来问我的身份了，挑战一把：%@", challenge);
//}

//- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    NSLog(@"挑战发生了改变了%@", challenge);
//}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSError *error;
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (str) {
        NSLog(@"收到数据啦：\n%@\n", str);
    } else if (error) {
        NSLog(@"解析数据发生错误：%@", error.localizedDescription);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"收到网络请求的Response，里面包含了此次请求的元数据，但不包含正在的数据：%@", response);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"请求加载完成");
}


@end
