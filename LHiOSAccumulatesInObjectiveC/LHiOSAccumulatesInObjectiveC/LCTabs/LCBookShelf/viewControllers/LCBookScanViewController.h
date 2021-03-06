//
//  LCBookScanViewController.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/24.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCViewController.h"

typedef void(^LCBookScanCompletionBlock)(NSString *ISBN);

@interface LCBookScanViewController : LCViewController

+ (instancetype)scanWithCompletionBlock:(LCBookScanCompletionBlock)block;

@end
