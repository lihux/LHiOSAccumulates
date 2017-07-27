//
//  LCAnimationKeyPathPathView.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/7/27.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCAnimationKeyPathPathViewDelegate <NSObject>

- (NSArray *)pointsForCount:(NSInteger)count;

@end

@interface LCAnimationKeyPathPathView : UIView

@property (nonatomic, copy) NSArray *points;

@property (nonatomic, weak) id<LCAnimationKeyPathPathViewDelegate> delegate;

@end
