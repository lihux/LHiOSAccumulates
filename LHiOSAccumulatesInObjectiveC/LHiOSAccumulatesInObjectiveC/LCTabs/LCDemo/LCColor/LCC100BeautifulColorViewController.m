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
#import "LCConstantDefines.h"
#import "LCLihuxHelper.h"

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

- (void)updateColor:(NSInteger)colorValue type:(LCLihuxStyleColorType)type {
    [LCLihuxHelper resetColorByValue:colorValue ofType:LCLihuxStyleColorTypeBackground];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLCLihuxStyleViewChangeColorNotification object:@(type)];
}

#pragma mark - override
-(NSString *)rightItemText {
    return @"默认颜色";
}

-(void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnRightButton:(UIButton *)rightButton {
    [self updateColor:0x188242 type:LCLihuxStyleColorTypeBackground];
}

#pragma mark - LCC100BeautifulColorTableViewCellDelegate
-(void)colorTableViewCell:(LCC100BeautifulColorTableViewCell *)cell didChoseNamedColor:(LCNamedColor *)namedColor {
    [self updateColor:namedColor.rgb type:LCLihuxStyleColorTypeBackground];
    NSLog(@"点击色彩：%@：%zd", namedColor.name, namedColor.rgb);
}

@end
