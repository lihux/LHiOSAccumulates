//
//  LCDPushTestViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/10/11.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDPushTestViewController.h"

@interface LCDPushTestViewController ()

@end

@implementation LCDPushTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)didTapOnPushButton:(id)sender {
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.title = @"第一个页面";
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.title = @"第二个页面";
    [self.navigationController pushViewController:vc1 animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:vc2 animated:YES];
    });
}

@end
