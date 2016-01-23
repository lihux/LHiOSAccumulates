//
//  LCDocumentViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/18.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCDocumentViewController.h"

#import "LCTableViewCell.h"

@interface LCDocumentViewController ()

@end

@implementation LCDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好看";
    self.tableView.tableFooterView = [UIView new];
    [self configTableViewWithPlistFileName:@"LCDocumentAccumulates" storyBoardName:@"Main"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)tableViewCellResueIdentifier
{
    return @"LCTableViewCellSmallSize";
}

- (void)tableViewCell:(LCTableViewCell *)cell tappedWithIndex:(NSIndexPath *)indexPath
{
    
}

@end
