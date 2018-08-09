//
//  LCTableViewCell.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/6/6.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCAccumulate;
@class LCTableViewCell;
@protocol LCTableViewCellDelegate <NSObject>

- (void)tableViewCell:(LCTableViewCell *)cell tappedWithIndex:(NSIndexPath *)indexPath;

@end

@interface LCTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) id<LCTableViewCellDelegate> delegate;
@property (nonatomic, strong) LCAccumulate *accumulate;

- (void)configCellWithAccumulate:(LCAccumulate *)accumulate withIndexPatch:(NSIndexPath *)indexPath;

@end

