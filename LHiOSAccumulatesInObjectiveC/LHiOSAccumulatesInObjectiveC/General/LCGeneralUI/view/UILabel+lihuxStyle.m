//
//  UILabel+lihuxStyle.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/30.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "UILabel+lihuxStyle.h"

#import "LCLihuxHelper.h"

@implementation UILabel (lihuxStyle)

+ (instancetype)lihuxStyleLabelWithTag:(NSInteger)tag {
    UILabel *label = [[UILabel alloc] init];
    label.tag = tag;
    label.textAlignment = NSTextAlignmentCenter;
    [LCLihuxHelper makeLihuxStyleOfView:label];
    return label;
}

@end
