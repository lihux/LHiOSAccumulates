//
//  LCDatePickerView.m
//  LHiOSAccumulatesInObjectiveC
//
//  Created by 李辉 on 2017/6/28.
//  Copyright © 2017年 Lihux. All rights reserved.
//

#import "LCDatePickerView.h"

#import "UIView+LHAutoLayout.h"
#import "UIColor+helper.h"
#import "LCLihuxHelper.h"

@interface LCDatePickerView ()

@property (nonatomic, copy) LCDatePickerCompletionBlock completionBlock;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSLayoutConstraint *datePickerBottomConstraint;
@property (nonatomic, assign) CGFloat datePickerViewHeight;

@end

@implementation LCDatePickerView

+ (void)showPickerViewWithCompletionBlock:(LCDatePickerCompletionBlock) completionBlock {
    LCDatePickerView *pickerView = [[LCDatePickerView alloc] init];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubviewUsingDefaultLayoutConstraints:pickerView];
    pickerView.datePickerBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.35 animations:^{
        [pickerView setNeedsLayout];
        pickerView.backgroundColor = [UIColor colorWithHex:0xFFFFFF alpha:0.4];
    }];
}

- (instancetype)init {
    if (self = [super init]) {
        [self customUI];
    }
    return self;
}

- (void)customUI {
    self.backgroundColor = [UIColor colorWithHex:0xFFFFFF alpha:0.3];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelSelectDate)];
    [self addGestureRecognizer:tap];
    self.datePickerViewHeight = 190;
    [self addSubview:self.datePicker withLayoutInfo:LHLayoutInfoMake(LHLayoutNone, 0, -self.datePickerViewHeight, 0, LHLayoutNone, self.datePickerViewHeight)];
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.constant == -self.datePickerViewHeight) {
            self.datePickerBottomConstraint = constraint;
            break;
        }
    }
}

#pragma mark - actions
- (void)cancelSelectDate {
    if (self.completionBlock) {
        self.completionBlock(nil);
        self.completionBlock = nil;
    }
    [self dismiss];
}

- (void)doneSelectDate {
    if (self.completionBlock) {
        NSDate *date = self.datePicker.date;
        self.completionBlock(date);
        self.completionBlock = nil;
    }
    [self dismiss];
}

- (void)dismiss {
    self.datePickerBottomConstraint.constant = -self.datePickerViewHeight;
    [UIView animateWithDuration:0.35 animations:^{
        [self setNeedsLayout];
        self.backgroundColor = [UIColor colorWithHex:0xFFFFFF alpha:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - lazy load
- (UIDatePicker *)datePicker {
    if (_datePicker) {
        return _datePicker;
    }
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.tag = kLCNonLihuxStyleViewTag;
    _datePicker.backgroundColor = [UIColor whiteColor];
    return _datePicker;
}

@end
