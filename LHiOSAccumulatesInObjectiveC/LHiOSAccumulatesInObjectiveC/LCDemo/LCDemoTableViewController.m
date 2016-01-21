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
    [self configTableViewWithPlistFileName:@"LCDemoAccumulates" storyBoardName:@"Main"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LCTableViewCellSmallSize" forIndexPath:indexPath];
    LCAccumulate *accumulate = self.accumulatesManager.accumulates[indexPath.row];
    [cell configCellWithAccumulate:accumulate withIndexPatch:indexPath];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - LCTableViewCellDelegate
- (void)tableViewCell:(LCTableViewCell *)cell tappedWithIndex:(NSIndexPath *)indexPath
{
    
}
@end
