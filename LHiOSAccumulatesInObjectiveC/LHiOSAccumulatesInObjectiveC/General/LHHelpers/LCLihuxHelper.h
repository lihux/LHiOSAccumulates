//
//  LCLihuxHelper.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

//如果不需要渲染lihux Style将View的tag设置为 -9999
static const NSInteger kLCNonLihuxStyleViewTag = -9999;

//LCViewController的子View，如何需要添加日志显示View，将其tag设置为 9999
static const NSInteger kLCNeedShowDebugLogViewTag = 9999;

@interface LCLihuxHelper : NSObject

+ (void)makeLihuxStyleOfView:(UIView *)view;
    
@end
