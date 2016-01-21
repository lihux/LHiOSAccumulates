//
//  LCSettingTableViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/18.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCSettingTableViewController.h"

#import "LCTableViewCell.h"

@interface LCSettingTableViewController ()

@end

@implementation LCSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    self.tableView.tableFooterView = [UIView new];
    [self configTableViewWithPlistFileName:@"LCSettingAccumulates" storyBoardName:@"Main"];
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
