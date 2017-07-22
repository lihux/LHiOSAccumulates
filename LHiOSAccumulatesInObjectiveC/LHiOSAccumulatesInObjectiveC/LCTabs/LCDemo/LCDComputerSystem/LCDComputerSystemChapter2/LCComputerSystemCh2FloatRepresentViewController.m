//
//  LCComputerSystemCh2FloatRepresentViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/29.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCComputerSystemCh2FloatRepresentViewController.h"

#import <math.h>

#import "UIView+LHAutoLayout.h"
#import "LCDCFloatView.h"

@interface LCComputerSystemCh2FloatRepresentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet LCDCFloatView *xAxisLineView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, assign) NSInteger oldValue;

@end

@implementation LCComputerSystemCh2FloatRepresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateUI];
}

- (void)updateUI {
    self.xAxisLineView.bitCount = (NSInteger)self.slider.value;
    NSInteger bits = (NSInteger)self.slider.value;
    self.infoLabel.text = [NSString stringWithFormat:@"选择的基数是：%zd,整数部分%zd位，小数部分%zd位", bits, bits / 2, bits - (NSInteger)(bits / 2)];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    NSInteger current = (NSInteger)sender.value;
    if (current != self.oldValue) {
        [self updateUI];
        self.oldValue = current;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [self updateUI];
}

@end
