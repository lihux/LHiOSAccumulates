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

@interface LCTableViewController () <LCSectionHeaderViewDelegate, LCTableViewCellDelegate>

@property (nonatomic, strong) NSString *plistFileName;
@property (nonatomic, strong) UIButton *leftNavigatorButton;
@property (nonatomic, strong) UIButton *rightNavigatorButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation LCTableViewController

- (void)configTableViewWithPlistFileName:(NSString *)plistName
{
    self.plistFileName = plistName;
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
    LCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self tableViewCellResueIdentifier] forIndexPath:indexPath];
    LCAccumulate *accumulate = self.accumulatesManager.accumulates[indexPath.row];
    [cell configCellWithAccumulate:accumulate withIndexPatch:indexPath];
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    if (section == 0) {
        LCSectionHeaderView *sectionHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LCSectionHeaderView" owner:nil options:nil] objectAtIndex:0];
        sectionHeaderView.delegate = self;
        NSString *leftText = [self leftNavigatorItemText];
        NSString *rightText = [self rightNavigatorItemText];
        [sectionHeaderView configSectionHeaderViewWithTitle:self.title leftText:leftText rightText:rightText];
        return sectionHeaderView;
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

#pragma mark - LCTableViewCellDelegate
- (void)tableViewCell:(LCTableViewCell *)cell tappedWithIndex:(NSIndexPath *)indexPath
{
    LCAccumulate *accumulate = cell.accumulate;
    UIViewController *detailViewController = [LCUtilities viewControllerForAccumulate:accumulate];
    if (!detailViewController) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"该子项尚未完成，请再等等" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        __weak typeof(alertController) weakAlertController = alertController;
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf dismissViewControllerAnimated:weakAlertController completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self presentViewController:detailViewController animated:YES completion:nil];
    }
}

#pragma mark - LCSectionHeaderViewDelegate
- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnLeftButton:(UIButton *)leftButton
{
}

- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnRightButton:(UIButton *)rightButton
{
}

#pragma mark - method that may be override
- (NSString *)leftNavigatorItemText
{
    return @"";
}

- (NSString *)rightNavigatorItemText
{
    return @"";
}

- (void)didTapOnLeftNavigatorButton:(UIButton *)leftButton
{
}

- (void)didTapOnRightNavigatorButton:(UIButton *)rightButton
{
}

- (NSString *) tableViewCellResueIdentifier
{
    return @"LCTableViewCellSmallSize";
}

@end
