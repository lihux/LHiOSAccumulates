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

@property (weak, nonatomic) IBOutlet UIView *xAxisLineView;

@end

static NSInteger kBitCount = 8;

@implementation LCComputerSystemCh2FloatRepresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addDots];
}

- (void)addDots {
    NSInteger leftPart = kBitCount / 2;
//    NSInteger rightPart = kBitCount - leftPart;
    NSInteger maxInteger = powf(2, leftPart - 1) - 1;
    NSInteger minInteger = - maxInteger - 1;
    CGFloat axisLength = maxInteger - minInteger;
    CGFloat lineWidth = self.xAxisLineView.bounds.size.width;
    for (NSInteger i = minInteger; i <= maxInteger; i ++) {
        
        CGFloat ratio = (axisLength - maxInteger + i) / axisLength;
        UIView *dotView = [[UIView alloc] init];
        dotView.backgroundColor = [UIColor whiteColor];
        LHLayoutInfo info = LHLayoutInfoMake(0, lineWidth * ratio, 0, LHLayoutNone, 2, LHLayoutNone);
        [self.xAxisLineView addSubview:dotView withLayoutInfo:info];
    }
}

@end
