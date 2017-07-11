//
//  LCLihuxStyleView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/8.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCLihuxStyleView.h"

#import "LCConstantDefines.h"
#import "LCLihuxHelper.h"

@implementation LCLihuxStyleView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveChangeColorNotification:) name:kLCLihuxStyleViewChangeColorNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

+ (instancetype)styleViewWithColorType:(LCLihuxStyleColorType)colorType {
    LCLihuxStyleView *view = [[LCLihuxStyleView alloc] init];
    view.colorType = colorType;
    return view;
}

- (void)setColorType:(LCLihuxStyleColorType)colorType {
    _colorType = colorType;
    self.backgroundColor = [LCLihuxHelper colorOfType:colorType];
}

- (void)didReceiveChangeColorNotification:(NSNotification *)notification {
    self.backgroundColor = [LCLihuxHelper colorOfType:self.colorType];
}

@end
