//
//  LCHomeViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/10.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCHomeViewController.h"

#import "LCLightBorderButton.h"

static const CGFloat kDefaultFlyingAnimationDuration = 1.0;
static const CGFloat kDefaultZoomingAnimationDuration = 0.5;

@interface LCHomeViewController ()

@property (strong, nonatomic) IBOutletCollection(LCLightBorderButton) NSArray *homeButtons;


@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *homeButtonACVerticalSpaceConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *homeButtonCRHorizontalSpaceConstraints;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (weak, nonatomic) IBOutlet UILabel *maskLabel;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *flyView1SizeConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *flyView2SizeConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *flyView3SizeConstraints;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *flyView4SizeConstraints;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *flyingViews;


@property (nonatomic, strong) NSArray *flyConstraintArray;
@property (nonatomic, assign) NSInteger flyingViewIndex;
@property (nonatomic, assign) BOOL firstLaunch;
@property (nonatomic, strong) NSArray *homeButtonTitles;
@property (nonatomic, assign) BOOL isFlying;

@end

@implementation LCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustLayoutConstraints];
    [self prepareDatas];
    self.flyingViewIndex = -1;
    self.homeButtonTitles = @[@"好玩", @"好看", @"你猜", @"设置"];
}

- (void)prepareDatas
{
    self.flyConstraintArray = @[self.flyView1SizeConstraints, self.flyView2SizeConstraints, self.flyView3SizeConstraints, self.flyView4SizeConstraints];
    self.flyingViews = [self.flyingViews sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = NSOrderedAscending;
        if ([(UIView *)obj1 tag] > [(UIView *)obj1 tag]) {
            result = NSOrderedDescending;
        }
        return result;
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.firstLaunch) {
        self.firstLaunch = YES;
        [self homeButtonAnimateWithButtonIndex:0 isFlyingAway:YES completion:^{
            self.maskLabel.text = self.homeButtonTitles[0];
            [self centerCircleAnimateWithIsZooming:YES completion:^{
                self.flyingViewIndex = 0;
            }];
        }];
    }
}

#pragma mark - AutoLayout Concerns
- (void)adjustLayoutConstraints
{
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

- (void)centerCircleAnimateWithIsZooming:(BOOL)isZooming completion:(void(^)())completion
{
    self.maskLabel.hidden = NO;
    self.maskView.hidden = NO;
    if (!isZooming) {
        self.maskLabel.text = self.homeButtonTitles[self.flyingViewIndex];
    }
    CGFloat scale = isZooming ? self.view.bounds.size.width * 2 / 50 : 1;
    CGFloat labelAlpha = isZooming ? 0 : 1;
    [UIView animateWithDuration:kDefaultZoomingAnimationDuration animations:^{
        self.maskView.transform = CGAffineTransformMakeScale(scale, scale);
        self.maskLabel.alpha = labelAlpha;
    } completion:^(BOOL finished) {
        if (finished && completion) {
            self.maskLabel.hidden = YES;
            self.maskView.hidden = !isZooming;
            completion();
        }
    }];
}

- (void)homeButtonAnimateWithButtonIndex:(NSInteger)index isFlyingAway:(BOOL)isFlyingAway completion:(void(^)())completion
{
    [(UIView *)self.flyingViews[index] setHidden:NO];
    BOOL stopHomeButtonFlyAwayConstraintActive = !isFlyingAway;
    NSArray *constraints = self.flyConstraintArray[index];
    for (NSLayoutConstraint *constraint in constraints) {
        constraint.active = stopHomeButtonFlyAwayConstraintActive;
    }
//    CGFloat animationTime = isFlyingAway ? 0.6 : 1.0;
    [UIView animateWithDuration:kDefaultFlyingAnimationDuration animations:^{
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
    self.isFlying = YES;
    [self centerCircleAnimateWithIsZooming:NO completion:^{
        [self homeButtonAnimateWithButtonIndex:currentIndex isFlyingAway:NO completion:^{
        }];
    }];
    [self homeButtonAnimateWithButtonIndex:index isFlyingAway:YES completion:^{
        [self centerCircleAnimateWithIsZooming:YES completion:^{
            self.flyingViewIndex = index;
            self.isFlying = NO;
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
