//
//  LCC100BeautifulColorTableViewCell.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 2017/7/7.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCC100BeautifulColorTableViewCell;
@class LCNamedColor;

@protocol LCC100BeautifulColorTableViewCellDelegate <NSObject>

- (void)colorTableViewCell:(LCC100BeautifulColorTableViewCell *)cell didChoseNamedColor:(LCNamedColor *)namedColor;

@end

@interface LCC100BeautifulColorTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, weak) id<LCC100BeautifulColorTableViewCellDelegate> delegate;

@end
