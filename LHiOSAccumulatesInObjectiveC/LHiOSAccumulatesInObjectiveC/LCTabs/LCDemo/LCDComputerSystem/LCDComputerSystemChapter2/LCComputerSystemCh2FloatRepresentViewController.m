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

@property (weak, nonatomic) IBOutlet UILabel *floatInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *fixedInfoLabel;
@property (weak, nonatomic) IBOutlet LCDCFloatView *fixedDotView;
@property (weak, nonatomic) IBOutlet LCDCFloatView *floatDotView;

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic, assign) NSInteger oldValue;

@end

@implementation LCComputerSystemCh2FloatRepresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.floatDotView.isFloatDot = YES;
    self.fixedDotView.isFloatDot = NO;
    [self updateUI];
}

- (void)updateUI {
    NSInteger bits = (NSInteger)self.slider.value;
    self.fixedDotView.bitCount = bits;
    self.floatDotView.bitCount = bits;
    self.fixedInfoLabel.text = [NSString stringWithFormat:@"一、定点表示实数：%zd位,其中整数部分%zd位，小数部分%zd位", bits, bits / 2, bits - (NSInteger)(bits / 2)];
    if (bits > 3) {
        self.floatInfoLabel.text = [NSString stringWithFormat:@"二、浮点表示实数：%zd位阶码，%zd位尾数(黄色区域为非规格化部分)", self.floatDotView.ePart, self.floatDotView.mPart];
    } else {
        self.floatInfoLabel.text = @"二、位数不足4位，浮点数无法表示，无法绘制坐标轴！！";
    }
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
