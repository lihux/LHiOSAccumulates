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
#import "LCCFNetwork.h"
#import "LCNSURLConnection.h"
#import "LCNSURLSession.h"

@interface LCNetworkViewController ()

@property (nonatomic, strong) LCBSDSocket *bsdSocket;
@property (nonatomic, strong) LCCFSocket *cfSocket;
@property (nonatomic, strong) LCCFNetwork *cfnetwork;
@property (nonatomic, strong) LCNSURLConnection *connection;
@property (nonatomic, strong) LCNSURLSession *session;

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
    [self.cfnetwork connect];
}
- (IBAction)didTapOnNSURLConnectionButton:(id)sender {
    [self.connection connect];
}

- (IBAction)didTapOnNSURLSessionButton:(id)sender {
    [self.session connect];
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

- (LCCFNetwork *)cfnetwork {
    if (_cfnetwork) {
        return _cfnetwork;
    }
    _cfnetwork = [LCCFNetwork new];
    return _cfnetwork;
}

- (LCNSURLConnection *)connection {
    if (_connection) {
        return _connection;
    }
    _connection = [LCNSURLConnection new];
    return _connection;
}

- (LCNSURLSession *)session {
    if (_session) {
        return _session;
    }
    _session = [LCNSURLSession new];
    return _session;
}

@end
