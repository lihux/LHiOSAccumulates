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

@interface LCTableViewController : UITableViewController

@property (nonatomic, assign) BOOL dontRestoring;

- (void)configWithTitle:(NSString *)title plistFileName:(NSString *)plistName;

@end
