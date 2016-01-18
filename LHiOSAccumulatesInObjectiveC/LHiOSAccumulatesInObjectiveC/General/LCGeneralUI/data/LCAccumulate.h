//
//  LCAccumulate.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCAccumulate : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* storyboardID;

- (instancetype)initWith:(NSString *)title content:(NSString *)content storyboardID:(NSString *)storyboardID;

@end
