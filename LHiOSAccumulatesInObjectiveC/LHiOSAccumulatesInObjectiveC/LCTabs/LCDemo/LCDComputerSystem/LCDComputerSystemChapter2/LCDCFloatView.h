//
//  LCDCFloatView.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/21.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCDCFloatView : UIView

@property (nonatomic, assign) BOOL isFloatDot;
@property (nonatomic, assign) NSInteger bitCount;

@property (nonatomic, assign) NSInteger ePart;
@property (nonatomic, assign) NSInteger mPart;

@end
