//
//  LCBCreateReadingPlanViewController.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/27.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCViewController.h"

@class LCBook;

@interface LCBCreateReadingPlanViewController : LCViewController

+ (instancetype)createReadingPlanViewControllerForBook:(LCBook *)book;

@end
