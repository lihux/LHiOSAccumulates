//
//  LCNetworkViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2019/7/2.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCNetworkViewController.h"

#import "LCBSDSocket.h"

@interface LCNetworkViewController ()

@property (nonatomic, strong) LCBSDSocket *bsdSocket;

@end

@implementation LCNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)didTapOnBSDSocketButton:(id)sender {
    [self.bsdSocket connect];
}
- (IBAction)didTapOnCFSocketButton:(id)sender {
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
@end
