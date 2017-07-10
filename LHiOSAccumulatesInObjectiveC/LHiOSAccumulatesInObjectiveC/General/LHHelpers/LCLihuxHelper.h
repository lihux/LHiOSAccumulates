//
//  LCLihuxHelper.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIColor+helper.h"

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LCLihuxStyleColorType) {
    LCLihuxStyleColorTypeBackground = 0,
    LCLihuxStyleColorTypeContent,
    LCLihuxStyleColorTypeHighlight,
};

#define LihuxStyleColor [UIColor colorWithHex:0x188242]
#define LihuxContentBackgroundColor [UIColor colorWithHex:0x3b955e]

//如果不需要渲染lihux Style将View的tag设置为 -9999
static const NSInteger kLCNonLihuxStyleViewTag = -9999;

//LCViewController的子View，如何需要添加日志显示View，将其tag设置为 9999
static const NSInteger kLCNeedShowDebugLogViewTag = 9999;
static const NSInteger kLDontAdjustConstraintsTag = 9998;

@interface LCLihuxHelper : NSObject

+ (void)makeLihuxStyleOfView:(UIView *)view;

+ (UIColor *)colorOfType:(LCLihuxStyleColorType)type;
+ (void)resetColorByValue:(NSInteger)colorValue ofType:(LCLihuxStyleColorType)type;

@end
