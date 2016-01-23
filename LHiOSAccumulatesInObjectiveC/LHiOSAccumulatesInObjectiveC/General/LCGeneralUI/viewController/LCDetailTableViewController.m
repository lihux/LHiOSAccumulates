//
//  LCDetailTableViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/23.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCDetailTableViewController.h"

#import "UIColor+helper.h"

@interface LCDetailTableViewController ()

@end

@implementation LCDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:58.0 / 255 green:148.0 /255 blue:94.0 / 255 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)leftNavigatorItemText
{
    return @"返回";
}

- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnLeftButton:(UIButton *)leftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
