//
//  LCSimpleTableViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2018/8/9.
//  Copyright © 2018年 Lihux. All rights reserved.
//

#import "LCSimpleTableViewController.h"

#import "LCTableViewCell.h"

@interface LCSimpleTableViewController () <UITableViewDelegate, UITableViewDataSource, LCTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, strong) NSArray *keys;

@end

@implementation LCSimpleTableViewController

- (instancetype)init {
    if (self = [super init]) {
        self.dataDic = [self buildData];
        self.keys = self.dataDic.allKeys;
    }
    return self;
}

- (NSDictionary *)buildData {
    return nil;
}

- (void)viewDidLoad {
    [self.view addSubview:self.tableView];
    [super viewDidLoad];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataDic.allValues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCTableViewCell class]) forIndexPath:indexPath];
    cell.tag = indexPath.row + 1;
    cell.delegate = self;
    cell.titleLabel.text = self.keys[indexPath.row];
    return cell;
}

#pragma mark - LCTableViewCellDelegate
-(void)tableViewCell:(LCTableViewCell *)cell tappedWithIndex:(NSIndexPath *)indexPath {
    NSString *key = [self.keys objectAtIndex:indexPath.row];
    NSString *value = [self.dataDic objectForKey:key];
    SEL action = NSSelectorFromString(value);
    if ([self respondsToSelector:action]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:action withObject:@(indexPath.row)];
        #pragma clang diagnostic pop
    }
}

#pragma mark - lazy load
- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tag = kLCNeedShowDebugLogViewTag;
    NSString *reuseID = NSStringFromClass([LCTableViewCell class]);
    [_tableView registerNib:[UINib nibWithNibName:reuseID bundle:nil] forCellReuseIdentifier:reuseID];
    return _tableView;
}

@end
