//
//  LCBCreateRecordViewController.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/2.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCViewController.h"

@class LCBookReadingPlan;

@interface LCBCreateRecordViewController : LCViewController

+ (instancetype)createRecordViewControllerForReadingPlan:(LCBookReadingPlan *)plan;

@end
