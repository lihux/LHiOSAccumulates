//
//  LCNetworkViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2019/7/2.
//  Copyright © 2019 Lihux. All rights reserved.
//

//NOTE:
//服务端使用node.js简单写了个，直接运行当前文件夹下的 `node tcp_server.js`即可
//参考blog：https://blog.csdn.net/lockey23/article/details/76408891

#import "LCNetworkViewController.h"

#import "LCBSDSocket.h"
#import "LCCFSocket.h"

@interface LCNetworkViewController ()

@property (nonatomic, strong) LCBSDSocket *bsdSocket;
@property (nonatomic, strong) LCCFSocket *cfSocket;

@end

@implementation LCNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)didTapOnBSDSocketButton:(id)sender {
    [self.bsdSocket connect];
}
- (IBAction)didTapOnCFSocketButton:(id)sender {
    [self.cfSocket connect];
}

- (IBAction)didTapOnCFNetworkButton:(id)sender {
}
- (IBAction)didTapOnNSURLConnectionButton:(id)sender {
}
- (IBAction)didTapOnNSURLSessionButton:(id)sender {
}

#pragma mark - lazy loads
-(LCBSDSocket *)bsdSocket {
    if (_bsdSocket) {
        return _bsdSocket;
    }
    _bsdSocket = [LCBSDSocket new];
    return _bsdSocket;
}

- (LCCFSocket *)cfSocket {
    if (_cfSocket) {
        return _cfSocket;
    }
    _cfSocket = [LCCFSocket new];
    return _cfSocket;
}

@end
