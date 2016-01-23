//
//  LCTableViewCell.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/18.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCTableViewCell.h"

#import "LCAccumulate.h"
#import "UIColor+helper.h"
#import "LCButton.h"

@interface LCTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation LCTableViewCell

- (void)configCellWithAccumulate:(LCAccumulate *)accumulate withIndexPatch:(NSIndexPath *)indexPath
{
    self.titleLabel.text = accumulate.title;
    self.contentLabel.text = accumulate.content;
    self.indexPath = indexPath;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    LCButton *button = [[LCButton alloc] init];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button setBackgroundColor:[UIColor clearColor] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor colorWithHex:0x188242] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(didTapOnButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:button];
    [self.contentView sendSubviewToBack:button];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)]];
}

- (void)didTapOnButton:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:tappedWithIndex:)]) {
        [self.delegate tableViewCell:self tappedWithIndex:self.indexPath];
    }
}

@end
