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

- (void)setColorType:(LCLihuxStyleColorType)colorType {
    self.backgroundColor = [LCLihuxHelper colorOfType:colorType];
}

- (void)didReceiveChangeColorNotification:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[NSNumber class]]) {
        NSNumber *temp = (NSNumber *)notification.object;
        self.colorType = temp.integerValue;
    }
}

@end
