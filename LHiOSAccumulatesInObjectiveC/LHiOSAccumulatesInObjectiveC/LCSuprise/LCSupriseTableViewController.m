//
//  LCSupriseTableViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/18.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCSupriseTableViewController.h"

#import "LCTableViewCell.h"

@interface LCSupriseTableViewController ()

@end

@implementation LCSupriseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self configTableViewWithPlistFileName:@"LCSupriseAccumulates" storyBoardName:@"Main"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)cellReuseIdentifier
{
    return @"LCTableViewCellSmallSize";
}

- (void)tableViewCell:(LCTableViewCell *)cell tappedWithIndex:(NSIndexPath *)indexPath
{
    
}

@end
