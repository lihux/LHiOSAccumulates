//
//  LCC100BeautifulColorViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/7.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCC100BeautifulColorViewController.h"

#import "LCC100BeautifulColorTableViewCell.h"
#import "LCColorCombinationManger.h"

@interface LCC100BeautifulColorViewController () <UITableViewDataSource, UITableViewDelegate, LCC100BeautifulColorTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation LCC100BeautifulColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LCC100BeautifulColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LCC100BeautifulColorTableViewCell class])];
    cell.photoIndex = indexPath.row;
    cell.delegate = self;
    return cell;
}

#pragma mark - LCC100BeautifulColorTableViewCellDelegate
-(void)colorTableViewCell:(LCC100BeautifulColorTableViewCell *)cell didChoseNamedColor:(LCNamedColor *)namedColor {
    NSLog(@"点击色彩：%@：%zd", namedColor.name, namedColor.rgb);
}

@end
