//
//  LCSectionHeaderView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/20.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCSectionHeaderView.h"

#import "LCLihuxHelper.h"

@interface LCSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (nonatomic, weak) id<LCSectionHeaderViewDelegate> delegate;

@end

@implementation LCSectionHeaderView

+ (LCSectionHeaderView *)sectionHeaderViewWithDelegate:(id<LCSectionHeaderViewDelegate>)delegate
                                                 title:(NSString *)title
                                              leftText:(NSString *)leftText
                                             rightText:(NSString *)rightText {
    LCSectionHeaderView *sectionHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LCSectionHeaderView" owner:nil options:nil] objectAtIndex:0];
    sectionHeaderView.delegate = delegate;
    [sectionHeaderView configSectionHeaderViewWithTitle:title leftText:leftText rightText:rightText];
    sectionHeaderView.backgroundColor = LihuxStyleColor;
    return sectionHeaderView;
}

- (void)configSectionHeaderViewWithTitle:(NSString *)title leftText:(NSString *)leftText rightText:(NSString *)rightText {
    self.titleLabel.text = title;
    [self.leftButton setTitle:leftText forState:UIControlStateNormal];
    self.leftButton.titleLabel.text = leftText;
    self.leftButton.hidden = leftText.length > 0 ? NO : YES;
    [self.rightButton setTitle:rightText forState:UIControlStateNormal];
    self.rightButton.hidden = rightText.length > 0 ? NO : YES;
}

- (void)updateTitle:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma mark - LCSectionHeaderViewDelegate
- (IBAction)didTapOnLeftButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:tappedOnLeftButton:)]) {
        [self.delegate sectionHeaderView:self tappedOnLeftButton:self.leftButton];
    }
}

- (IBAction)didTapOnRightButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionHeaderView:tappedOnRightButton:)]) {
        [self.delegate sectionHeaderView:self tappedOnRightButton:self.rightButton];
    }
}

@end
