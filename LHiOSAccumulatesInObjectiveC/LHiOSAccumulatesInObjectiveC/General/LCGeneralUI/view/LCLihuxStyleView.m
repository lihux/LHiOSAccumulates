//
//  LCLihuxStyleView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/8.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCLihuxStyleView.h"

@implementation LCLihuxStyleView

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

@end
