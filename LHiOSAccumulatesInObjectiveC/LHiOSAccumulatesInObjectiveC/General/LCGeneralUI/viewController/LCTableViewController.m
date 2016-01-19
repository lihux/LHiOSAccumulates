//
//  LCTableViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCTableViewController.h"

#import "LCAccumulate.h"
#import "LCUtilities.h"
#import "LCTableViewCell.h"

@interface LCTableViewController ()

@property (nonatomic, strong) NSString *plistFileName;
@property (nonatomic, strong) NSString *storyBoardName;

@end

@implementation LCTableViewController

- (void)configTableViewWithPlistFileName:(NSString *)plistName storyBoardName:(NSString *)storyBoardName
{
    self.plistFileName = plistName;
    self.storyBoardName = storyBoardName;
    [self loadAccumulatesFromPlist];
}

- (void)loadAccumulatesFromPlist
{
    self.accumulatesManager = [[LCAccumulateManager alloc] initWithPlistFileName:self.plistFileName];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accumulatesManager.accumulates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellReuseIdentifier] forIndexPath:indexPath];
    LCAccumulate *accumulate = self.accumulatesManager.accumulates[indexPath.row];
    [cell configCellWithAccumulate:accumulate withIndexPatch:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LCAccumulate *accumulate = self.accumulatesManager.accumulates[indexPath.row];
    [self.navigationController pushViewController:[LCUtilities viewControllerForAccumulate:accumulate storyboardName:self.storyBoardName] animated:YES];
}

#pragma mark - LCTableViewCellDelegate
- (void)tableViewCell:(LCTableViewCell *)cell tappedWithIndex:(NSIndexPath *)indexPath
{
}

#pragma mark - method that may be override
- (NSString *)cellReuseIdentifier
{
    return @"LCAccumulateTableViewCell";
}

@end
