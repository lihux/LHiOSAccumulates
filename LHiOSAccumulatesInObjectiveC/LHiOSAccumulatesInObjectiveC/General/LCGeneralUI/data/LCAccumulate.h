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
@property (nonatomic, strong) NSString* viewControllerTitle;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* storyboardID;
@property (nonatomic, strong) NSString* storyboardName;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
