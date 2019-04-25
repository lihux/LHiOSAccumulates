//
//  LHTinyDog.m
//  virtualMemearyLearning
//
//  Created by 李辉 on 2019/4/25.
//  Copyright © 2019 LH. All rights reserved.
//

#import "LHTinyDog.h"

#define kCount 300000
@interface LHTinyDog () {
    long a[kCount];
}


@end

@implementation LHTinyDog

static int i = 0;

- (instancetype)init
{
    self = [super init];
    if (self) {
        a[(i) % kCount] = i++;
    }
    return self;
}

@end
