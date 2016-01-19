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
@property (nonatomic, strong) UIButton *leftNavigatorButton;
@property (nonatomic, strong) UIButton *rightNavigatorButton;
@property (nonatomic, strong) UILabel *titleLabel;

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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    if (section == 0) {
        headerView.backgroundColor = [UIColor clearColor];
        [headerView addSubview:self.leftNavigatorButton];
        [headerView addSubview:self.rightNavigatorButton];
        [headerView addSubview:self.titleLabel];
        NSDictionary *dic = @{@"leftButton": self.leftNavigatorButton, @"rightButton": self.rightNavigatorButton, @"titleLabel": self.titleLabel};
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-80-[titleLabel]-80-|" options:0 metrics:nil views:dic]];
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-10-[leftButton]" options:0 metrics:nil views:dic]];
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[rightButton]-10-|" options:0 metrics:nil views:dic]];
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-14-[titleLabel]" options:0 metrics:nil views:dic]];
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[leftButton]-0-|" options:0 metrics:nil views:dic]];
        [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[rightButton]-0-|" options:0 metrics:nil views:dic]];
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
}

#pragma mark - method that may be override
- (NSString *)cellReuseIdentifier
{
    return @"LCAccumulateTableViewCell";
}

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

- (UIButton *)leftNavigatorButton
{
    if (!_leftNavigatorButton) {
        _leftNavigatorButton = [self customNavigatorButton];
        _leftNavigatorButton.titleLabel.text = [self leftNavigatorItemText];
        _leftNavigatorButton.hidden = _leftNavigatorButton.titleLabel.text.length > 0 ? NO : YES;
    }
    return _leftNavigatorButton;
}

- (UIButton *)rightNavigatorButton
{
    if (!_rightNavigatorButton) {
        _rightNavigatorButton = [self customNavigatorButton];
        _rightNavigatorButton.titleLabel.text = [self rightNavigatorItemText];
        _rightNavigatorButton.hidden = _rightNavigatorButton.titleLabel.text.length > 0 ? NO : YES;
    }
    return _rightNavigatorButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@" STHeitiSC-Medium" size:14];
        label.textColor = [UIColor whiteColor];
        [label addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(==16)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
        label.text = self.title;
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIButton *)customNavigatorButton
{
    UIButton *button = [[UIButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.titleLabel.font = [UIFont fontWithName:@" STHeitiSC-Medium" size:14];
    button.titleLabel.textColor = [UIColor whiteColor];
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70]];

    button.hidden = YES;
    return button;
}



@end
