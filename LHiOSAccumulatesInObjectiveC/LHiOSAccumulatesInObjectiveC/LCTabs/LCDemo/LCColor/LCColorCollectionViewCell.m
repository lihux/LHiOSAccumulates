//
//  LCColorCollectionViewCell.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/6.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCColorCollectionViewCell.h"

#import "UIColor+helper.h"

@interface LCColorCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation LCColorCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorView.layer.cornerRadius = 4;
    self.colorView.clipsToBounds = YES;
}

- (void)setColorIndex:(NSUInteger)colorIndex {
    _colorIndex = colorIndex & 0xFFFFFF;
    NSUInteger complementColorIndex = 0xFFFFFF - _colorIndex;
    self.colorView.backgroundColor = [UIColor colorWithHex:_colorIndex];
    self.textLabel.textColor = [UIColor colorWithHex:complementColorIndex];
    self.textLabel.font = [UIFont boldSystemFontOfSize:12];
    NSString *firstPart = [NSString stringWithFormat:@"%03lx", (unsigned long)((_colorIndex >> 12) & 0xfff000)];
    NSString *lastPart = [NSString stringWithFormat:@"%03lx", (unsigned long)(_colorIndex & 0x000fff)];
    self.textLabel.text = [NSString stringWithFormat:@"%@\n%@", firstPart, lastPart];
}

@end

