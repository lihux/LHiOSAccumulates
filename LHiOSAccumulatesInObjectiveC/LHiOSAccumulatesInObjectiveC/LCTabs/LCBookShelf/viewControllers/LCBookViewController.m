//
//  LCBookViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/24.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBookViewController.h"

@interface LCBookViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation LCBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super makeLihuxStyleOfView:self.containerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
