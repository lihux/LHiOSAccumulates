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
#import "LCConstantDefines.h"

@interface LCViewController ()

@property (nonatomic, strong) UITextView *logTextView;
@property (nonatomic, strong) UIView *logBorderLineView;
@property (nonatomic, strong) UIView *logContainerView;
@property (nonatomic, strong) UIView *lcViewController_ContainerView;
@property (nonatomic, strong) UIView *logAnchorView;
@property (nonatomic, strong) LCSectionHeaderView *headerView;

@end

@implementation LCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customLCViewControllerBaseUI];
    [self addKVOForTitle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveChangeColorNotification:) name:kLCLihuxStyleViewChangeColorNotification object:nil];
}

- (void)didReceiveChangeColorNotification:(NSNotification *)notification {
    self.view.backgroundColor = [LCLihuxHelper colorOfType:LCLihuxStyleColorTypeContent];
}

- (void)customLCViewControllerBaseUI {
    self.view.backgroundColor = [LCLihuxHelper colorOfType:LCLihuxStyleColorTypeContent];
    [LCLihuxHelper makeLihuxStyleOfView:self.lcViewController_ContainerView];
    if (self.lcViewController_ContainerView.tag != kLDontAdjustConstraintsTag) {
        [self.lcViewController_ContainerView removeFromSuperview];
        [self.view addSubview:self.lcViewController_ContainerView withLayoutInfo:LHLayoutInfoMake(44, 0, 0, 0, LHLayoutNone, LHLayoutNone)];
    }
    NSString *rightText = [self rightItemText];
    LCSectionHeaderView *headerView = [LCSectionHeaderView sectionHeaderViewWithDelegate:self title:self.title leftText:[self leftItemText] rightText:rightText];
    [self.view addSubview:headerView withLayoutInfo:LHLayoutInfoMake(0, 0, LHLayoutNone, 0, LHLayoutNone, 44)];
    self.headerView = headerView;
}

- (void)addKVOForTitle {
    [self addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)log:(NSString *)log {
    if (self.logAnchorView) {
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        [self.headerView updateTitle:self.title];
    }
}

#pragma mark - 子类按需继承
- (void)cleanLog {
    self.logTextView.text = @"";
}

- (BOOL)isShowLogReverse {
    return NO;
}

- (NSString *)leftItemText {
    return @"返回";
}

- (NSString *)rightItemText {
    return self.logAnchorView ? @"清理日志" : @"";
}

#pragma mark - 高蛋白
#pragma mark - UITraitEnvironment
- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    UIView *anchorView = self.logAnchorView;
    if (!anchorView) {
        return;
    }
    [self relayoutAnchorView];
    [self relayoutLogTextView];
}

- (void)relayoutAnchorView {
    UIView *anchorView = self.logAnchorView;
    if (anchorView) {
        BOOL isVerticalSizeCompact = self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact;//YES:横屏
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
    UIView *anchorView = self.logAnchorView;
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

- (UIView *)lcViewController_ContainerView {
    if (_lcViewController_ContainerView) {
        return _lcViewController_ContainerView;
    }
    for (id object in self.view.subviews) {
        if ([object isKindOfClass:[UIView class]]) {
            if (![object isKindOfClass:[LCSectionHeaderView class]]) {
                _lcViewController_ContainerView = (UIView *)object;
                _logAnchorView = _lcViewController_ContainerView.tag == kLCNeedShowDebugLogViewTag ? _lcViewController_ContainerView : nil;
                break;
            }
        }
    }
    return _lcViewController_ContainerView;
}

#pragma mark -
-(void)dealloc {
    [self removeObserver:self forKeyPath:@"title"];
}

@end
