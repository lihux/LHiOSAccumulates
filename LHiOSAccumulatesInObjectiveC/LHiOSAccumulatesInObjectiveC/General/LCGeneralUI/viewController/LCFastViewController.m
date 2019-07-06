//
//  LCFastViewController.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2019/7/6.
//  Copyright © 2019 Lihux. All rights reserved.
//

#import "LCFastViewController.h"

@interface LCFastViewController ()

@end

@implementation LCFastViewController

- (void)loadView {
    self.view = [UIView new];
    UIView *anchorView = [UIView new];
    anchorView.tag = kLCNeedShowDebugLogViewTag;
    [self.view addSubview:anchorView];
}

- (CGFloat)logViewProportion {
    return 1;
}

@end
