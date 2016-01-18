//
//  LCButton.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by lihui on 16/1/12.
//  Copyright © 2016年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCButton : UIButton

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;
- (UIColor *)backgroundColorForState:(UIControlState)state;

- (void)setBorderCorder:(UIColor *)borderColor forState:(UIControlState)state;
- (UIColor *)borderColorForState:(UIControlState)state;

@end
