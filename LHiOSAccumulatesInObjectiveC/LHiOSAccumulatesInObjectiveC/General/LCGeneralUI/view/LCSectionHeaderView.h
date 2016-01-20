//
//  LCSectionHeaderView.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/20.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCSectionHeaderView;

@protocol LCSectionHeaderViewDelegate <NSObject>

- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnLeftButton:(UIButton *)leftButton;
- (void)sectionHeaderView:(LCSectionHeaderView *)sectionHeaderView tappedOnRightButton:(UIButton *)rightButton;

@end

@interface LCSectionHeaderView : UIView

@property (nonatomic, weak) id<LCSectionHeaderViewDelegate> delegate;

- (void)configSectionHeaderViewWithTitle:(NSString *)title leftText:(NSString *)leftText rightText:(NSString *)rightText;

@end
