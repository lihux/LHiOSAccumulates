//
//  LCTableViewCell.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/18.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCAccumulate;
@class LCTableViewCell;
@protocol LCTableViewCellDelegate <NSObject>

- (void)tableViewCell:(LCTableViewCell *)cell tappedWithIndex:(NSIndexPath *)indexPath;

@end

@interface LCTableViewCell : UITableViewCell

@property (nonatomic, weak) id<LCTableViewCellDelegate> delegate;

- (void)configCellWithAccumulate:(LCAccumulate *)accumulate withIndexPatch:(NSIndexPath *)indexPath;

@end
