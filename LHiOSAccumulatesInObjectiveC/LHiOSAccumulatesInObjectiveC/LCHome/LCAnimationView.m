//
//  LCAnimationView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/14.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCAnimationView.h"

#import "LCAnimationLayer.h"

@implementation LCAnimationView

+ (Class)layerClass
{
    return [LCAnimationLayer class];
}

@end
