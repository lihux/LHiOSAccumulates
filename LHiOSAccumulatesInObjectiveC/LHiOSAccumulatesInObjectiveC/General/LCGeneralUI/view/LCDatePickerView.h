//
//  LCDatePickerView.h
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/28.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LCDatePickerCompletionBlock)(NSDate *selectedDate);

@interface LCDatePickerView : UIView

+ (void)showPickerViewWithTitle:(NSString *)title completionBlock:(LCDatePickerCompletionBlock) completionBlock;
    
@end
