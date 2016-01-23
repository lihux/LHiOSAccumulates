//
//  LCDemoTableViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/17.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCDemoTableViewController.h"

#import "LCTableViewCell.h"

@interface LCDemoTableViewController ()

@end

@implementation LCDemoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"好玩";
    [self configTableViewWithPlistFileName:@"LCDemoAccumulates"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self currentDeviceIsIpad] ? 90 : 44;
}

- (NSString *)tableViewCellResueIdentifier
{
    return [self currentDeviceIsIpad] ? @"LCTableViewCellFullSize" : @"LCTableViewCellSmallSize";
}

- (BOOL)currentDeviceIsIpad
{
    return [[[UIDevice currentDevice].model substringToIndex:4] isEqualToString:@"iPad"];
}

#pragma mark - LCTableViewCellDelegate
- (void)tableViewCell:(LCTableViewCell *)cell tappedWithIndex:(NSIndexPath *)indexPath
{
    
}
@end
