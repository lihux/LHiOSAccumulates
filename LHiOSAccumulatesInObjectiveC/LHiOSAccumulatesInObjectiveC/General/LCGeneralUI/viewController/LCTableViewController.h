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
#import "LCSectionHeaderView.h"

@interface LCTableViewController : UITableViewController  <LCTableViewCellDelegate, LCSectionHeaderViewDelegate>

@property (nonatomic, strong) LCAccumulateManager *accumulatesManager;

- (void)configWithTitle:(NSString *)title plistFileName:(NSString *)plistName;

- (NSString *) tableViewCellResueIdentifier;
- (NSString *)leftNavigatorItemText;
- (NSString *)rightNavigatorItemText;

@end
