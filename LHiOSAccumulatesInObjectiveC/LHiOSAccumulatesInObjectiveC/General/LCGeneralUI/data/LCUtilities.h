//
//  LCUtilities.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <Foundation/Foundation.h>

#define mcc_stringify(v) mcc_stringify_(v)
#define mcc_concat(a, b) mcc_concat_(a, b)

#if DEBUG
#define mcc_ext_keywordify autoreleasepool {}
#else
#define mcc_ext_keywordify try {} @catch (...) {}
#endif

#define mcc_stringify_(v) # v
#define mcc_concat_(a, b) a ## b

#define weakify(VAR)        mcc_weakify_(VAR)
#define mcc_weakify_(VAR)    mcc_ext_keywordify __weak __typeof__(VAR) mcc_concat(VAR, _weak_) = (VAR)
#define strongify(VAR)      mcc_strongify_(VAR)
#define mcc_strongify_(VAR)  mcc_ext_keywordify __strong __typeof__(VAR) VAR = mcc_concat(VAR, _weak_)

@class UIViewController;
@class LCAccumulate;

@interface LCUtilities : NSObject

+ (NSArray *)loadAccumulatesFromPlistWithPlistFileName:(NSString *)fileName;
+ (UIViewController *)viewControllerForAccumulate:(LCAccumulate *)accumulate;

@end
