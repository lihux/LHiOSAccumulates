//
//  LCHomeViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/10.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCHomeViewController.h"

#import "LCLightBorderButton.h"
#import "UIColor+helper.h"
#import "LCTableViewController.h"

static const CGFloat kDefaultFlyingAnimationDuration = 0.6;
static const CGFloat kDefaultZoomingAnimationDuration = 0.4;

@interface LCHomeViewController ()

@property (strong, nonatomic) IBOutletCollection(LCLightBorderButton) NSArray *homeButtons;


@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *homeButtonACVerticalSpaceConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *homeButtonCRHorizontalSpaceConstraints;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *maskLabel;
@property (weak, nonatomic) IBOutlet UIView *controllerContrainerView;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *flyView1SizeConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *flyView2SizeConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *flyView3SizeConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *flyView4SizeConstraints;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *flyingViews;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *subViewControllerContainerViews;


@property (nonatomic, strong) NSArray *flyConstraintArray;
@property (nonatomic, assign) NSInteger flyingViewIndex;
@property (nonatomic, assign) BOOL firstLaunch;
@property (nonatomic, strong) NSArray *homeButtonTitles;
@property (nonatomic, assign) BOOL isFlying;
@property (nonatomic, assign) CGFloat controllerContainerViewZoomingMin;

@end

@implementation LCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustLayoutConstraints];
    [self prepareDatas];
}

- (void)prepareDatas {
    self.flyingViewIndex = -1;
    self.homeButtonTitles = @[@"好玩", @"好看", @"你猜", @"设置"];
    self.flyConstraintArray = @[self.flyView1SizeConstraints, self.flyView2SizeConstraints, self.flyView3SizeConstraints, self.flyView4SizeConstraints];
    self.flyingViews = [self.flyingViews sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = NSOrderedAscending;
        if ([(UIView *)obj1 tag] > [(UIView *)obj1 tag]) {
            result = NSOrderedDescending;
        }
        return result;
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateControllerControllerContrainerViewWithZoomingState:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.firstLaunch) {
        self.firstLaunch = YES;
        self.flyingViewIndex = 0;
        [(UIButton *)self.homeButtons[0] setSelected:YES];
        [self homeButtonAnimateWithButtonIndex:0 isFlyingAway:YES completion:^{
            self.maskLabel.text = self.homeButtonTitles[0];
            [self centerCircleAnimateWithIsZooming:YES completion:nil];
        }];
    }
}

- (void)setFlyingViewIndex:(NSInteger)flyingViewIndex {
    if (flyingViewIndex >= 0) {
        for (UIView *view in self.subViewControllerContainerViews) {
            view.hidden = flyingViewIndex == view.tag ? NO : YES;
        }
    }
    _flyingViewIndex = flyingViewIndex;
}

- (void)adjustLayoutConstraints {
    CGFloat buttonWidth = [(UIButton *)self.homeButtons[0] bounds].size.width;
    CGFloat borderGap = 22;
    NSInteger buttonCount = self.homeButtons.count;
    CGFloat widthConstant = ([UIScreen mainScreen].bounds.size.width  - borderGap - (buttonWidth * buttonCount))/ (buttonCount - 1);
    for (NSLayoutConstraint *constraint in self.homeButtonACVerticalSpaceConstraints) {
        constraint.constant = widthConstant;
    }
    for (NSLayoutConstraint *constraint in self.homeButtonCRHorizontalSpaceConstraints) {
        constraint.constant = widthConstant;
    }
    [self.view layoutIfNeeded];
}

- (void)updateControllerControllerContrainerViewWithZoomingState:(BOOL)isZooming {
    CGFloat controllerContainerViewScale = isZooming ? 1 : self.controllerContainerViewZoomingMin;
    CGFloat controllerContainerViewAlpha = isZooming ? 1 : 0;
    self.controllerContrainerView.transform = CGAffineTransformMakeScale(controllerContainerViewScale, controllerContainerViewScale);
    self.controllerContrainerView.alpha = controllerContainerViewAlpha;
}

- (void)centerCircleAnimateWithIsZooming:(BOOL)isZooming completion:(void(^)())completion {
    self.maskLabel.hidden = NO;
    self.maskView.hidden = NO;
    self.maskLabel.text = self.homeButtonTitles[self.flyingViewIndex];
    CGFloat scale = isZooming ? self.view.bounds.size.width * 2 / 50 : 1;
    CGFloat labelAlpha = isZooming ? 0 : 1;
    [UIView animateWithDuration:kDefaultZoomingAnimationDuration animations:^{
        self.maskView.transform = CGAffineTransformMakeScale(scale, scale);
        self.maskLabel.alpha = labelAlpha;
        [self updateControllerControllerContrainerViewWithZoomingState:isZooming];
    } completion:^(BOOL finished) {
        if (finished && completion) {
            self.maskLabel.hidden = YES;
            self.maskView.hidden = !isZooming;
            completion();
        }
    }];
}

- (void)homeButtonAnimateWithButtonIndex:(NSInteger)index isFlyingAway:(BOOL)isFlyingAway completion:(void(^)())completion {
    UIView *flyingView = self.flyingViews[index];
    flyingView.hidden = NO;
    BOOL stopHomeButtonFlyAwayConstraintActive = !isFlyingAway;
    NSArray *constraints = self.flyConstraintArray[index];
    for (NSLayoutConstraint *constraint in constraints) {
        constraint.active = stopHomeButtonFlyAwayConstraintActive;
    }
    [UIView animateWithDuration:kDefaultFlyingAnimationDuration animations:^{
        flyingView.alpha = isFlyingAway ? 1.0 : 0.4;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished && completion) {
            [(UIView *)self.flyingViews[index] setHidden:YES];
            completion();
        }
    }];
}

- (IBAction)didTapOnHomeButton:(LCLightBorderButton *)sender {
    NSInteger index = sender.tag;
    if (index == self.flyingViewIndex || self.isFlying) {
        return;
    }
    NSInteger currentIndex = self.flyingViewIndex;
    sender.selected = YES;
    [(UIButton *)self.homeButtons[currentIndex] setSelected:NO];
    self.isFlying = YES;
    [self centerCircleAnimateWithIsZooming:NO completion:^{
        [self homeButtonAnimateWithButtonIndex:currentIndex isFlyingAway:NO completion:^{
        }];
    }];
    [self homeButtonAnimateWithButtonIndex:index isFlyingAway:YES completion:^{
        self.flyingViewIndex = index;
        [self centerCircleAnimateWithIsZooming:YES completion:^{
            self.isFlying = NO;
        }];
    }];
}

- (CGFloat)controllerContainerViewZoomingMin {
    if (_controllerContainerViewZoomingMin == 0) {
        CGFloat length = self.controllerContrainerView.frame.size.height > self.controllerContrainerView.frame.size.width ? self.controllerContrainerView.frame.size.height : self.controllerContrainerView.frame.size.width;
        _controllerContainerViewZoomingMin = 50 / length;
    }
    return _controllerContainerViewZoomingMin;
}

#pragma mark - handle segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSInteger tag = [segue.identifier integerValue];
    NSString *title = [self.homeButtonTitles objectAtIndex:tag];
    NSString *plistName;
    switch (tag) {
        case 0: {
            title = @"好玩";
            plistName = @"LCDemo";
        }
            break;
        case 1: {
            title = @"好看";
            plistName = @"LCDocument";
        }
            break;
        case 2: {
            title = @"你猜";
            plistName = @"LCSuprise";
        }
            break;
        case 3: {
            title = @"设置";
            plistName = @"LCSetting";
        }
            break;

        default:
            break;
    }
    LCTableViewController *vc = (LCTableViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
    [vc configWithTitle:title plistFileName:plistName];
}

@end
