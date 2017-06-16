//
//  LCAccumulate.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import "LCAccumulate.h"

@implementation LCAccumulate

- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    if (self = [super init]) {
        self.title = dic[@"title"];
        self.viewControllerTitle = dic[@"viewControllerTitle"];
        self.plistName = dic[@"plistName"];
        self.content = dic[@"content"];
        self.storyboardID = dic[@"storyboardID"];
        self.storyboardName = dic[@"storyboardName"];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"LCAccumulate:\ntitle = %@\nviewControllerTitle = %@\ncontent = %@\nplistName = %@\nstoryboardID = %@\nstoryboardName = %@", self.title, self.viewControllerTitle, self.content, self.plistName, self.storyboardID, self.storyboardName];
}

@end
