//
//  LCBShelfTableViewCell.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCBook;
@class LCBShelfTableViewCell;

@protocol LCBShelfTableViewCellDelegate <NSObject>

- (void)planButtonDidTappedOnCell:(LCBShelfTableViewCell *)cell;

@end

@interface LCBShelfTableViewCell : UITableViewCell

@property (nonatomic, strong) LCBook *book;
@property (nonatomic, weak) id<LCBShelfTableViewCellDelegate> delegate;

@end
