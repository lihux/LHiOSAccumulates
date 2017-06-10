//
//  LCDURLMetricsViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/6.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDURLMetricsViewController.h"

@interface LCDURLMetricsViewController ()

@end

@implementation LCDURLMetricsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url = @"http://13.58.220.233:8080/hello/roy";
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"收到网络请求：%@, %@, %@", data, response, error);
    }] resume];
}

@end
