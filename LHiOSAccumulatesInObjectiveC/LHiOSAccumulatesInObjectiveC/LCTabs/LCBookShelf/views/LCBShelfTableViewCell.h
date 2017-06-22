//
//  LCBShelfTableViewCell.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/22.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCBook;

@interface LCBShelfTableViewCell : UITableViewCell

@property (nonatomic, weak) LCBook *book;

@end
