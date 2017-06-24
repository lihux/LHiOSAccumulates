//
//  LCLihuxHelper.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

static const NSInteger kLCNonLihuxStyleViewTag = -9999;

@interface LCLihuxHelper : NSObject

+ (void)makeLihuxStyleOfView:(UIView *)view;
    
@end
