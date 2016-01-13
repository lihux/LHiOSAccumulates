//
//  LCHomeViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/10.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCHomeViewController.h"

#import "LCLightBorderButton.h"

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

@property (nonatomic, strong) NSArray *flyConstraintArray;
@property (nonatomic, assign) NSInteger flyingViewIndex;

@end

@implementation LCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustLayoutConstraints];
    self.flyConstraintArray = @[self.flyView1SizeConstraints, self.flyView2SizeConstraints, self.flyView3SizeConstraints, self.flyView4SizeConstraints];
    self.flyingViewIndex = -1;
    self.maskLabel.alpha = 0;
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

- (void)animatingButton:(BOOL)isZoom
{
    CGFloat width = isZoom ? [UIScreen mainScreen].bounds.size.width * 2 : 50;
    CGFloat scale = width / 50;
    CGFloat alpha = isZoom ? 0 : 1;
    [UIView animateWithDuration:0.8 animations:^{
        self.maskView.transform = CGAffineTransformMakeScale(scale, scale);
        self.maskLabel.alpha = alpha;
    }];
}

- (IBAction)didTapOnHomeButton:(LCLightBorderButton *)sender {
    NSInteger index = sender.tag;
    if (index == self.flyingViewIndex) {
        return;
    }
    CGFloat kAnimationDuration = 0.5;
    NSArray *constraintsToBeDeactive = self.flyConstraintArray[index - 1];
    NSArray *constraintsToBeActive = nil;
    if (self.flyingViewIndex > 0) {
        constraintsToBeActive = self.flyConstraintArray[self.flyingViewIndex - 1];
        [constraintsToBeActive enumerateObjectsUsingBlock:^(NSLayoutConstraint *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.active = YES;
        }];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [constraintsToBeDeactive enumerateObjectsUsingBlock:^(NSLayoutConstraint *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.active = NO;
            }];
            [UIView animateWithDuration:kAnimationDuration animations:^{
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.flyingViewIndex = index;
            }];
        }];
    } else {
        [constraintsToBeDeactive enumerateObjectsUsingBlock:^(NSLayoutConstraint *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.active = NO;
        }];
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.maskLabel.alpha = 1;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.flyingViewIndex = index;
            [self animatingButton:YES];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
