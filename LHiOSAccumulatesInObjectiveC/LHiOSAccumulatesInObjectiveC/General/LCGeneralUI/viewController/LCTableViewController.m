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
#import "UIColor+helper.h"
#import "LCSectionHeaderView.h"
#import "LCLihuxHelper.h"
#import "UIView+LHAutoLayout.h"
#import "LCLihuxStyleView.h"

@interface LCTableViewController () <LCSectionHeaderViewDelegate, LCTableViewCellDelegate>

@property (nonatomic, strong) NSString *plistFileName;
@property (nonatomic, strong) UIButton *leftNavigatorButton;
@property (nonatomic, strong) UIButton *rightNavigatorButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) LCAccumulateManager *accumulatesManager;

@end

@implementation LCTableViewController

- (void)configWithTitle:(NSString *)title plistFileName:(NSString *)plistName {
    self.title = title;
    self.plistFileName = plistName;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *reuseID = [self tableViewCellResueIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:reuseID bundle:nil] forCellReuseIdentifier:reuseID];
    [self loadAccumulatesFromPlist];
}

- (void)loadAccumulatesFromPlist {
    self.accumulatesManager = [[LCAccumulateManager alloc] initWithPlistFileName:self.plistFileName];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)customUI {
    self.tableView.tableFooterView = [UIView new];
    UIView *backgroundView = [LCLihuxStyleView styleViewWithCOlorType:LCLihuxStyleColorTypeContent];
    self.tableView.backgroundView = backgroundView;
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
    cell.tag = indexPath.row + 1;
    LCAccumulate *accumulate = self.accumulatesManager.accumulates[indexPath.row];
    [cell configCellWithAccumulate:accumulate withIndexPatch:indexPath];
    cell.delegate = self;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    if (section == 0) {
        NSString *leftText = [self leftNavigatorItemText];
        NSString *rightText = [self rightNavigatorItemText];
        return [LCSectionHeaderView sectionHeaderViewWithDelegate:self title:self.title leftText:leftText rightText:rightText];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

#pragma mark - LCTableViewCellDelegate
- (void)tableViewCell:(LCTableViewCell *)cell tappedWithIndex:(NSIndexPath *)indexPath
{
    LCAccumulate *accumulate = cell.accumulate;
    UIViewController *detailViewController = [LCUtilities viewControllerForAccumulate:accumulate];
    if (!detailViewController) {
        NSString *message = [NSString stringWithFormat:@"%@ \n暂时还未开发完成，稍安勿躁，静候佳音", accumulate.title];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"该子项尚未完成，请再等等" message:message preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        __weak typeof(alertController) weakAlertController = alertController;
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf dismissViewControllerAnimated:weakAlertController completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        if (accumulate.viewControllerTitle && accumulate.viewControllerTitle.length > 0) {
            detailViewController.title = accumulate.viewControllerTitle;
        }
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}

#pragma mark - LCSectionHeaderViewDelegate
- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnLeftButton:(UIButton *)leftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - method that may be override
- (NSString *)leftNavigatorItemText
{
    BOOL isRoot = [self.navigationController.viewControllers objectAtIndex:0] == self;
    return isRoot ? @"" : @"返回";
}

- (NSString *)rightNavigatorItemText
{
    return @"";
}

- (NSString *) tableViewCellResueIdentifier
{
    return NSStringFromClass([LCTableViewCell class]);
}

@end
