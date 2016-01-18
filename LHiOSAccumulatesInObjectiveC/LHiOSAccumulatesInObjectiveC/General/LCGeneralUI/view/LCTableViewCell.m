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

@interface LCTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

@implementation LCTableViewCell

- (void)configCellWithAccumulate:(LCAccumulate *)accumulate
{
    self.titleLabel.text = accumulate.title;
    self.contentLabel.text = accumulate.content;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.1];
    [self setSelectedBackgroundView:backgroundView];
}

@end
