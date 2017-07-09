//
//  LCLihuxStyleView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/8.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCLihuxStyleView.h"

#import "LCConstantDefines.h"

@implementation LCLihuxStyleView

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(application:didReceiveLocalNotification:) name:kLCLihuxStyleViewChangeColorNotification object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)setColorType:(LCLihuxStyleColorType)colorType {
    switch (colorType) {
        case LCLihuxStyleColorTypeBackground:
            self.backgroundColor = [UIColor redColor];
            break;
        case LCLihuxStyleColorTypeContent:
            self.backgroundColor = [UIColor yellowColor];
            break;
        case LCLihuxStyleColorTypeHighlight:
            self.backgroundColor = [UIColor blueColor];
            break;
        default:
            break;
    }
}

- (void)didReceiveChangeColorNotification:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[NSNumber class]]) {
        NSNumber *temp = (NSNumber *)notification.object;
        self.colorType = temp.integerValue;
    }
}

@end
