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
