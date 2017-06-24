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
#import "UIColor+helper.h"
#import "LCLihuxHelper.h"

@interface LCViewController ()

@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) UIView *logBorderLineView;
@property (nonatomic, strong) UIView *logContainerView;

@end

@implementation LCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0x3b955e];
    [LCLihuxHelper makeLihuxStyleOfView:[self lihuxStyleView]];
    NSString *rightText = [self rightItemText];
    LCSectionHeaderView *headerView = [LCSectionHeaderView sectionHeaderViewWithDelegate:self title:self.title leftText:@"返回" rightText:rightText];
    [self.view addSubview:headerView withLayoutInfo:LHLayoutInfoMake(0, 0, LHLayoutNone, 0, LHLayoutNone, 44)];
}

- (void)log:(NSString *)log {
    if ([self logAnchorView]) {
        if ([NSThread isMainThread]) {
            [self appendLogTextFieldWith:log];
        } else {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf appendLogTextFieldWith:log];
            });
        }
        return;
    }
    NSLog(@"%@", log);
}

- (void)appendLogTextFieldWith:(NSString *)log {
    NSString *oldLog = self.logTextView.text;
    
    NSString *gapString = (oldLog.length > 0 && log.length > 0) ? @"\n==========lihux.me==========\n" : @"";
    if ([self isShowLogReverse]) {
        self.logTextView.text = [NSString stringWithFormat:@"%@\n%@\n%@", log, gapString, oldLog];
        [self.logTextView scrollsToTop];
    } else {
        self.logTextView.text = [NSString stringWithFormat:@"%@\n%@\n%@", oldLog, gapString, log];
        NSInteger textLength = self.logTextView.text.length;
        if (textLength > 5) {
            [self.logTextView scrollRangeToVisible:NSMakeRange(textLength - 2, 1)];
        }
    }
}

+ (instancetype)loadViewControllerFromStoryboard:(NSString *)storyboardName {
    Class cls = [self class];
    LCViewController *vc = [[UIStoryboard storyboardWithName:storyboardName bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(cls)];
    return vc;
}

#pragma mark - 子类按需继承
- (UIView *)logAnchorView {
    return nil;
}

- (UIView *)lihuxStyleView {
    return nil;
}

- (BOOL)needReLayoutAnchorView {
    return YES;
}

- (void)cleanLog {
    self.logTextView.text = @"";
}

- (BOOL)isShowLogReverse {
    return NO;
}

- (NSString *)rightItemText {
    return [self logAnchorView] ? @"清理日志" : @"";
}

#pragma mark - 高蛋白
#pragma mark - UITraitEnvironment
- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    UIView *anchorView = [self logAnchorView];
    if (!anchorView) {
        return;
    }
    [self relayoutAnchorView];
    [self relayoutLogTextView];
//    NSLog(@"\n影响布局的环境发生了变化，变化前是酱紫的：\n%@\n\n变化后是酱紫的：%@\n\n\n", previousTraitCollection, self.traitCollection);
}

- (void)relayoutAnchorView {
    if ([self needReLayoutAnchorView]) {
        BOOL isVerticalSizeCompact = self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact;//YES:横屏
        UIView *anchorView = [self logAnchorView];
        [anchorView removeFromSuperview];
        CGFloat defaultGap = 8;
        CGFloat headerHeight = 44;
        LHLayoutInfo layoutInfo = isVerticalSizeCompact ? LHLayoutInfoMake(headerHeight + defaultGap, defaultGap, defaultGap, LHLayoutNone, LHLayoutNone, LHLayoutNone) : LHLayoutInfoMake(headerHeight + defaultGap, defaultGap, LHLayoutNone, defaultGap, LHLayoutNone, LHLayoutNone);
        [self.view addSubview:anchorView withLayoutInfo:layoutInfo];
        NSLayoutAttribute attribute = isVerticalSizeCompact ? NSLayoutAttributeWidth : NSLayoutAttributeHeight;
        [[NSLayoutConstraint constraintWithItem:anchorView
                                      attribute:attribute
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.view
                                      attribute:attribute
                                     multiplier:0.5
                                       constant:0] setActive:YES];
    }
}

- (void)relayoutLogTextView {
    CGFloat defaultGap = 10;
    CGFloat headerHeight = 44;
    UIView *anchorView = [self logAnchorView];
    UIView *textView = self.logContainerView;
    [textView removeFromSuperview];
    BOOL isVerticalSizeCompact = self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact;
    [self.logBorderLineView removeFromSuperview];
    [self.logBorderLineView removeConstraints:self.logBorderLineView.constraints];
    if (isVerticalSizeCompact) {
        [textView addSubview:self.logBorderLineView withLayoutInfo:LHLayoutInfoMake(0, 0, 0, LHLayoutNone, 1, LHLayoutNone)];
        [self.view addSubview:textView withLayoutInfo:LHLayoutInfoMake(headerHeight + defaultGap, LHLayoutNone, defaultGap, defaultGap, LHLayoutNone, LHLayoutNone)];
    } else {
        [textView addSubview:self.logBorderLineView withLayoutInfo:LHLayoutInfoMake(0, 0, LHLayoutNone, 0, LHLayoutNone, 1)];
        [self.view addSubview:textView withLayoutInfo:LHLayoutInfoMake(LHLayoutNone, defaultGap, defaultGap, defaultGap, LHLayoutNone, LHLayoutNone)];
    }
    NSLayoutAttribute anchorViewAttribute = isVerticalSizeCompact ? NSLayoutAttributeRight : NSLayoutAttributeBottom;
    NSLayoutAttribute textViewAttribute = isVerticalSizeCompact ? NSLayoutAttributeLeft : NSLayoutAttributeTop;
    [[NSLayoutConstraint constraintWithItem:anchorView
                                  attribute:anchorViewAttribute
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:textView
                                  attribute:textViewAttribute
                                 multiplier:1 constant:-12] setActive:YES];
}

#pragma mark - LCSectionHeaderViewDelegate
- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnLeftButton:(UIButton *)leftButton {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnRightButton:(UIButton *)rightButton {
    [self cleanLog];
}

#pragma mark - lazy loads
- (UITextView *)logTextView {
    if (!_logTextView) {
        _logTextView = [[UITextView alloc] init];
        _logTextView.font = [UIFont systemFontOfSize:14];
        [LCLihuxHelper makeLihuxStyleOfView:_logTextView];
    }
    return _logTextView;
}

- (UIView *)logBorderLineView {
    if (!_logBorderLineView) {
        _logBorderLineView = [[UIView alloc] init];
        _logBorderLineView.backgroundColor = [UIColor colorWithHex:0x188242];
        _logBorderLineView.tag = -1;//不需要对其背景色做统一配置
    }
    return _logBorderLineView;
}

-(UIView *)logContainerView {
    if (!_logContainerView) {
        _logContainerView = [[UIView alloc] init];
        [_logContainerView addSubviewUsingDefaultLayoutConstraints:self.logTextView];
    }
    return _logContainerView;
}

@end
