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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *god;

@end

@implementation LCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self adjustLayoutConstraints];
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
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
