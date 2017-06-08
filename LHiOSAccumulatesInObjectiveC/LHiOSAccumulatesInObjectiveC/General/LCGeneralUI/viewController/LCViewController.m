//
//  LCViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/4/26.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCViewController.h"

#import "UIColor+helper.h"
#import "UIView+LHAutoLayout.h"
#import "LCSectionHeaderView.h"

@interface LCViewController () <LCSectionHeaderViewDelegate>

@end

@implementation LCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0x3b955e];
    LCSectionHeaderView *headerView = [LCSectionHeaderView sectionHeaderViewWithDelegate:self title:self.title leftText:@"返回" rightText:@""];
    [self.view addSubview:headerView withLayoutInfo:LHLayoutInfoMake(0, 0, LHLayoutNone, 0, LHLayoutNone, 44)];
}

#pragma mark - LCSectionHeaderViewDelegate
- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnLeftButton:(UIButton *)leftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeLihuxStyleOfSubviewsFromParent:(UIView *)parentView {
    for (UIView *subView in parentView.subviews) {
        subView.backgroundColor = [UIColor clearColor];
        UIColor *textColor = [UIColor whiteColor];
        UIFont *font = [UIFont systemFontOfSize:14];
        if ([subView isKindOfClass:[UILabel class]]) {
            [(UILabel *)subView setTextColor:textColor];
            [(UILabel *)subView setFont:font];
        } else if ([subView isKindOfClass:[UIButton class]]) {
            [(UIButton *)subView setTitleColor:textColor forState:UIControlStateNormal];
        } else if ([subView isKindOfClass:[UITextField class]]) {
            [(UITextField *)subView setTextColor:textColor];
            [(UITextField *)subView setFont:font];
        } else if ([subView isKindOfClass:[UITextView class]]) {
            [(UITextView *)subView setTextColor:textColor];
            [(UITextView *)subView setFont:font];
        }
        [self makeLihuxStyleOfSubviewsFromParent:subView];
    }
}

@end
