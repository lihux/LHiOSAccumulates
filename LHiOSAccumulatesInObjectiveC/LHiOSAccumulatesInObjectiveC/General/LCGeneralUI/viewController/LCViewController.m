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

@property (nonatomic, strong) UITextView *logTextView;

@end

@implementation LCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0x3b955e];
    LCSectionHeaderView *headerView = [LCSectionHeaderView sectionHeaderViewWithDelegate:self title:self.title leftText:@"返回" rightText:@"log"];
    [self.view addSubview:headerView withLayoutInfo:LHLayoutInfoMake(0, 0, LHLayoutNone, 0, LHLayoutNone, 44)];
}

- (void)makeLihuxStyleOfSubviewsFromParent:(UIView *)parentView {
    if (parentView.tag < 0) {
        return;
    }
    for (UIView *subView in parentView.subviews) {
        if (subView.tag < 0) {
            continue;
        }
        [self makeLihuxStyleOfView:subView];
        [self makeLihuxStyleOfSubviewsFromParent:subView];
    }
}

- (void)makeLihuxStyleOfView:(UIView *)view {
    view.backgroundColor = [UIColor clearColor];
    UIColor *textColor = [UIColor whiteColor];
    if ([view isKindOfClass:[UILabel class]]) {
        [(UILabel *)view setTextColor:textColor];
    } else if ([view isKindOfClass:[UIButton class]]) {
        [(UIButton *)view setTitleColor:textColor forState:UIControlStateNormal];
    } else if ([view isKindOfClass:[UITextField class]]) {
        [(UITextField *)view setTextColor:textColor];
    } else if ([view isKindOfClass:[UITextView class]]) {
        [(UITextView *)view setTextColor:textColor];
    }
\
}

- (UIView *)logAnchorView {
    return nil;
}

- (void)log:(NSString *)log {
    if ([NSThread isMainThread]) {
        [self appendLogTextFieldWith:log];
    } else {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf appendLogTextFieldWith:log];
        });
    }
}

- (void)appendLogTextFieldWith:(NSString *)log {
    NSString *oldLog = self.logTextView.text;
    self.logTextView.text = [NSString stringWithFormat:@"%@\n%@", log, oldLog];
}

#pragma mark - 高蛋白
#pragma mark - UITraitEnvironment
- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    UIView *anchorView = [self logAnchorView];
    if (!anchorView) {
        return;
    }
    BOOL isVerticalSizeCompact = self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact;
    UITextView *textView = self.logTextView;
    [textView removeFromSuperview];
    CGFloat defaultGap = 10;
    LHLayoutInfo layoutInfo = isVerticalSizeCompact ? LHLayoutInfoMake(49, LHLayoutNone, defaultGap, defaultGap, LHLayoutNone, LHLayoutNone) : LHLayoutInfoMake(LHLayoutNone, defaultGap, defaultGap, defaultGap, LHLayoutNone, LHLayoutNone);
    NSLayoutAttribute anchorViewAttribute = isVerticalSizeCompact ? NSLayoutAttributeRight : NSLayoutAttributeBottom;
    NSLayoutAttribute textViewAttribute = isVerticalSizeCompact ? NSLayoutAttributeLeft : NSLayoutAttributeTop;
    [self.view addSubview:textView withLayoutInfo:layoutInfo];
    [[NSLayoutConstraint constraintWithItem:anchorView
                                  attribute:anchorViewAttribute
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:textView
                                  attribute:textViewAttribute
                                 multiplier:1 constant:10] setActive:YES];
    NSLog(@"\n影响布局的环境发生了变化，变化前是酱紫的：\n%@\n\n变化后是酱紫的：%@\n\n\n", previousTraitCollection, self.traitCollection);
}

#pragma mark - LCSectionHeaderViewDelegate
- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnLeftButton:(UIButton *)leftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnRightButton:(UIButton *)rightButton {
    rightButton.tag = rightButton.tag ? 0 : 1;
    [rightButton setTitle:(rightButton.tag ? @"show log": @"hide log") forState:UIControlStateNormal];
}

#pragma mark - lazy loads
- (UITextView *)logTextView {
    if (!_logTextView) {
        _logTextView = [[UITextView alloc] init];
        _logTextView.font = [UIFont systemFontOfSize:14];
        [self makeLihuxStyleOfView:_logTextView];
    }
    return _logTextView;
}

@end
