//
//  LCColorCombination.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/9.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface LCNamedColor : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger rgb;
@property (nonatomic, readonly) UIColor *color;

- (instancetype)initWithName:(NSString *)name rgb:(NSString *)rgb;

@end

@interface LCColorCombination : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSArray <LCNamedColor *> *colors;

+ (NSArray *)colorCombinations;

@end
