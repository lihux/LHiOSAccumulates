//
//  LCLabel.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/8/2.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCLabel.h"

@implementation LCLabel

- (void)awakeFromNib {
    [super awakeFromNib];
    self.text = self.text;
}

- (void)setText:(NSString *)text {
    if (self.numberOfLines == 1) {
        [super setText:text];
    } else {
        UIColor *textColor = self.textColor ? self.textColor : [UIColor blackColor];
        UIFont *font = self.font ? self.font : [UIFont systemFontOfSize:14];
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineSpacing = font.pointSize * .875;
        NSDictionary *dic = @{NSForegroundColorAttributeName : textColor,
                              NSFontAttributeName: font,
                              NSParagraphStyleAttributeName: style};
        self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:dic];
    }
}

- (CGSize)intrinsicContentSize {
    CGSize size = [super intrinsicContentSize];
    NSLog(@"固有尺寸是：%lf, %lf", size.width, size.width);
    return size;
}

@end
