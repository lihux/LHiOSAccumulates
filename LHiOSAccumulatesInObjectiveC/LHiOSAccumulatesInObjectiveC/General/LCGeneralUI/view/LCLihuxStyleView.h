//
//  LCLihuxStyleView.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/8.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LCLihuxHelper.h"

@interface LCLihuxStyleView : UIView

@property (nonatomic, assign) LCLihuxStyleColorType colorType;

+ (instancetype)styleViewWithCOlorType:(LCLihuxStyleColorType)colorType;

@end
