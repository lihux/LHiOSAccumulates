//
//  LCTableViewCell.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/6.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCTableViewCell.h"

#import "LCAccumulate.h"
#import "UIColor+helper.h"
#import "LCButton.h"

@interface LCTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation LCTableViewCell

- (void)configCellWithAccumulate:(LCAccumulate *)accumulate withIndexPatch:(NSIndexPath *)indexPath
{
    self.titleLabel.text = [NSString stringWithFormat:@"%zd. %@", self.tag, accumulate.title];
    self.contentLabel.text = accumulate.content;
    self.indexPath = indexPath;
    self.accumulate = accumulate;
}

- (void)awakeFromNib {
    [super awakeFromNib];
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

- (void)didTapOnButton:(UIButton *)button{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCell:tappedWithIndex:)]) {
        [self.delegate tableViewCell:self tappedWithIndex:self.indexPath];
    }
}

@end
