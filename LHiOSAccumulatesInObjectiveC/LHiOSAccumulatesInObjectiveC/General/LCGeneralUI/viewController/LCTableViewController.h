//
//  LCTableViewController.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/16.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LCAccumulateManager.h"
#import "LCTableViewCell.h"

@interface LCTableViewController : UITableViewController  <LCTableViewCellDelegate>

@property (nonatomic, strong) LCAccumulateManager *accumulatesManager;

- (void)configTableViewWithPlistFileName:(NSString *)plistName storyBoardName:(NSString *)storyBoardName;
- (NSString *)cellReuseIdentifier;

@end
