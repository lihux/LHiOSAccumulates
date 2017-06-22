//
//  LCBShelfViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCBShelfViewController.h"

#import "LCBookCoreDataManager.h"
#import "LCBShelfTableViewCell.h"

@interface LCBShelfViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LCBookCoreDataManager *manager;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation LCBShelfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeLihuxStyleOfView:self.containerView];
}

#pragma mark - UITableViewDelegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.manager numberOfBooksInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCBShelfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCBShelfTableViewCell class])];
    cell.book = [self.manager bookForRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark - lazy load
- (LCBookCoreDataManager *)manager {
    if (_manager) {
        return _manager;
    }
    _manager = [[LCBookCoreDataManager alloc] init];
    return _manager;
}

@end
