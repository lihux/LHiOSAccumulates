//
//  UILabel+LCLihuxStyle.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/8/2.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "UILabel+LCLihuxStyle.h"

@implementation UILabel (LCLihuxStyle)

- (void)setAdjustLineHeight:(BOOL)adjustLineHeight {
    if (adjustLineHeight) {
        NSLog(@"调用了分类set方法");
    }
}

@end
