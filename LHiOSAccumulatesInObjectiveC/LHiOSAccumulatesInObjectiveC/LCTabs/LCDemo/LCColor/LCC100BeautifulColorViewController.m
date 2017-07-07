//
//  LCC100BeautifulColorViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/7.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCC100BeautifulColorViewController.h"

#import "LCC100BeautifulColorTableViewCell.h"

@interface LCC100BeautifulColorViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation LCC100BeautifulColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat imageHeightWidthRatio = 0.631;
    self.cellHeight = ([UIScreen mainScreen].bounds.size.width - 24) * imageHeightWidthRatio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCC100BeautifulColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCC100BeautifulColorTableViewCell class])];
    cell.photoIndex = indexPath.row;
    return cell;
}

@end
