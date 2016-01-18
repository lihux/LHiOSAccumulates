//
//  LCTableViewCell.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/18.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCAccumulate;

@interface LCTableViewCell : UITableViewCell

- (void)configCellWithAccumulate:(LCAccumulate *)accumulate;

@end
